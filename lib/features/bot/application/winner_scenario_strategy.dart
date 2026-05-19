import 'dart:async';
import 'package:dto/dto.dart';
import '../../../core/debug_log.dart';
import 'bot_strategy.dart';

/// Сценарий Сражение:
/// Два бота заходят в бой, по очереди атакуют друг друга до победы.
/// Проверяет начисление наград (exp, coins, wins/losses).
class WinnerScenarioStrategy extends BotStrategy {
  WinnerScenarioStrategy({required this.isCreator});

  final bool isCreator;
  final Completer<void> combatStarted = Completer<void>();
  final Completer<int> winnerTeamId = Completer<int>();
  final Completer<OnlineMemberDto> statsUpdated = Completer<OnlineMemberDto>();

  String? _combatRoomId;
  OnlineMemberDto? initialStats;

  /// Last known member list from StartBattleTc / CombatStateTc.
  List<CombatantDto> _lastMembs = [];

  @override
  FutureOr<void> onInit(ScenarioBot bot) {
    debugLog('[WinnerBot] Bot ${bot.userId} starting (creator: $isCreator)');
    bot.send(const WsRequest.joinArena(n: 'winner_join_arena'));
    bot.send(const WsRequest.syncOnlineUsers(n: 'winner_initial_stats'));
  }

  @override
  void onMessage(ScenarioBot bot, WsResponse message) {
    // Send ack for any RequiredAckTc message first
    if (message is RequiredAckTc) {
      bot.send(
        WsRequest.ack(n: message.n, ts: DateTime.now().millisecondsSinceEpoch),
      );
    }

    switch (message) {
      case OnlineUsersTc(:final members):
        final myUnitIdInt = bot.unitId.s;
        final me = members.cast<OnlineMemberDto?>().firstWhere(
          (m) => m?.unitId == myUnitIdInt,
          orElse: () => null,
        );

        if (me == null) {
          debugLog('[WinnerBot] Bot ${bot.userId} NOT FOUND in OnlineUsers');
          return;
        }

        if (initialStats == null) {
          initialStats = me;
          debugLog(
            '[WinnerBot] Bot ${bot.userId} initial stats: EXP=${me.exp}',
          );
        } else {
          if (me.exp != initialStats!.exp ||
              me.coins != initialStats!.coins ||
              me.wins != initialStats!.wins ||
              me.losses != initialStats!.losses) {
            debugLog(
              '[WinnerBot] Bot ${bot.userId} NEW stats: EXP=${me.exp} W=${me.wins} L=${me.losses}',
            );
            if (!statsUpdated.isCompleted) statsUpdated.complete(me);
          }
        }

      case ActiveEdictsTc(:final edicts):
        if (isCreator) {
          if (!edicts.any(
            (e) => e.members.any((m) => m.userId == (bot.userId as String)),
          )) {
            bot.send(const WsRequest.createNewEdict(n: 'winner_create'));
          }
        } else {
          if (edicts.isNotEmpty) {
            final target = edicts.first;
            if (!target.members.any(
              (m) => m.userId == (bot.userId as String),
            )) {
              bot.send(
                WsRequest.joinEdict(n: 'winner_join_edict', edictId: target.id),
              );
            }
          }
        }

      case CombatStartedTc():
        _combatRoomId = message.combatRoom;
        debugLog(
          '[WinnerBot] Bot ${bot.userId} CombatStartedTc room=$_combatRoomId',
        );
        if (!combatStarted.isCompleted) combatStarted.complete();
        bot.send(
          WsRequest.joinBattleRoom(
            n: 'winner_ready',
            combatRoomId: _combatRoomId!,
          ),
        );

      case StartBattleTc(:final currentTurn, :final membs):
        debugLog(
          '[WinnerBot] Bot ${bot.userId} StartBattleTc turn=$currentTurn myId=${bot.unitId.s}',
        );
        _lastMembs = membs.toList();
        _handleTurn(bot, currentTurn, membs);

      case CombatEventTc(:final events):
        // Update last known state from events, then check for our turn
        _updateStateFromEvents(events);
        final turnEvent = events.whereType<TurnEventDto>().firstOrNull;
        if (turnEvent != null) {
          debugLog(
            '[WinnerBot] Bot ${bot.userId} CombatEventTc turn=${turnEvent.currentTurn} myId=${bot.unitId.s}',
          );
          _handleTurn(bot, turnEvent.currentTurn, _lastMembs);
        }

      case CombatStateTc(:final currentTurn, :final membs):
        debugLog(
          '[WinnerBot] Bot ${bot.userId} CombatStateTc turn=$currentTurn myId=${bot.unitId.s}',
        );
        _lastMembs = membs.toList();
        _handleTurn(bot, currentTurn, membs);

      case CombatWinTc(:final winnerTeamId):
        debugLog(
          '[WinnerBot] Bot ${bot.userId} CombatWinTc winner=$winnerTeamId',
        );
        if (!this.winnerTeamId.isCompleted) {
          this.winnerTeamId.complete(winnerTeamId);
        }
        bot.send(const WsRequest.syncOnlineUsers(n: 'winner_final_sync'));

      case CombatErrorTc(:final error):
        debugLog('[WinnerBot] Bot ${bot.userId} CombatError: $error');

      default:
        break;
    }
  }

  /// Update _lastMembs HP values based on attack/death events.
  void _updateStateFromEvents(List<CombatEventDto> events) {
    for (final event in events) {
      switch (event) {
        case AttackEventDto(:final targetId, :final targetHp):
          final idx = _lastMembs.indexWhere((m) => m.unitId == targetId);
          if (idx != -1) {
            _lastMembs[idx] = _lastMembs[idx].copyWith(
              unit: _lastMembs[idx].unit.copyWith(hp: targetHp),
            );
          }
        case DeathEventDto(:final unitId):
          final idx = _lastMembs.indexWhere((m) => m.unitId == unitId);
          if (idx != -1) {
            _lastMembs[idx] = _lastMembs[idx].copyWith(
              unit: _lastMembs[idx].unit.copyWith(hp: 0),
            );
          }
        case RoundEventDto() || TurnEventDto():
          break;
      }
    }
  }

  void _handleTurn(ScenarioBot bot, int currentTurn, List<CombatantDto> membs) {
    final myUnitId = bot.unitId.s;
    debugLog(
      '[WinnerBot] Bot ${bot.userId} _handleTurn: turn=$currentTurn myId=$myUnitId',
    );
    if (currentTurn == myUnitId) {
      final enemies = membs
          .where((m) => m.unitId != myUnitId && m.unit.hp > 0)
          .toList();
      if (enemies.isEmpty) {
        debugLog('[WinnerBot] Bot ${bot.userId} no enemies to attack');
        return;
      }

      final enemy = enemies.first;
      debugLog(
        '[WinnerBot] Bot ${bot.userId} attacking enemy ${enemy.unitId} (HP: ${enemy.unit.hp})',
      );

      bot.send(
        WsRequest.gameAction(
          n: 'winner_attack',
          combatRoomId: _combatRoomId!,
          action: GameActionDto.attack(
            combatantId: myUnitId,
            enemyCombatantId: enemy.unitId,
          ),
        ),
      );
    }
  }

  @override
  void onDispose(ScenarioBot bot) {}
}
