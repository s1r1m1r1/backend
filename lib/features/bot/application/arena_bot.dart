import 'dart:math';

import 'package:collection/collection.dart';
import 'package:dto/dto.dart';
import 'package:game_dto/game_dto.dart';

import '../../../core/app_config.dart';
import '../../../core/debug_log.dart';
import '../../../core/utils/next_noun.dart';
import 'bot_strategy.dart';

enum BotStatus { ready, joined, play, stopped, dead, failure }

/// Стратегия стандартного поведения бота в арене.
/// Бот заходит в арену, ищет свободные эдикты и вступает в них,
/// а затем участвует в бою, атакуя случайные цели.
class ArenaBotStrategy extends BotStrategy {
  bool joinedArena = false;
  BotStatus status = BotStatus.ready;
  final rnd = Random();

  Set<BroadcastId> setBroadcasts = {};

  EdictDto? joinedEdict;
  List<EdictDto> edicts = [];
  BroadcastId? combatRoom;

  List<CombatantDto> combatants = [];
  List<UnitId> unitOrder = [];
  int ready = 0;
  UnitId currentTurn = UnitId.none;

  @override
  Duration get actionDelay =>
      Duration(milliseconds: AppConfig.botActionDelaySec * 1000);

  void _reset(ScenarioBot bot) {
    status = BotStatus.ready;
    joinedEdict = null;
    combatRoom = null;
    combatants = [];
    unitOrder = [];
    ready = 0;
    currentTurn = UnitId.none;
    debugLog('[ArenaBot ${bot.userId}] reset → ready');
  }

  @override
  void onInit(ScenarioBot bot) {
    debugLog('[ArenaBot ${bot.userId}] onInit — joinedArena=$joinedArena');
    if (!joinedArena) {
      debugLog('[ArenaBot ${bot.userId}] Sending joinArena');
      bot.sendDelayed(.joinArena(n: nextNoun()));
      joinedArena = true;
    }
  }

  @override
  void onMessage(ScenarioBot bot, WsResponse message) {
    if (message is RequiredAckResponse) {
      bot.send(.ack(n: message.n, ts: DateTime.now().millisecondsSinceEpoch));
    }

    if (message is! WsResponseBot) return;

    switch (message) {
      case BroadcastInfoResponse(:final broadcasts):
        setBroadcasts.addAll(broadcasts.map((i) => BroadcastId(i.id)));
        debugLog(
          '[ArenaBot ${bot.userId}] BroadcastInfo: ${broadcasts.length} broadcasts',
        );

      case TerminatedBroadcastResponse(:final broad):
        setBroadcasts.remove(BroadcastId(broad));
        if (combatRoom?.id == broad || joinedEdict?.id == broad) {
          debugLog(
            '[ArenaBot ${bot.userId}] Terminated broadcast $broad — resetting',
          );
          _reset(bot);
        }

      case TerminatedAllBroadcastResponse():
        debugLog('[ArenaBot ${bot.userId}] TerminatedAllBroadcast — resetting');
        setBroadcasts.clear();
        joinedArena = false;
        _reset(bot);
        bot.sendDelayed(.joinArena(n: nextNoun()));
        joinedArena = true;

      case ArenaErrorResponse():
        debugLog('[ArenaBot ${bot.userId}] ArenaError: ${message.error}');

      case ActiveEdictsResponse(:final edicts):
        this.edicts = edicts;
        debugLog(
          '[ArenaBot ${bot.userId}] ActiveEdicts: ${edicts.length} edicts, status=$status',
        );
        if (status == BotStatus.play || status == BotStatus.joined) {
          joinedEdict = edicts.firstWhereOrNull(
            (i) => i.members.any((m) => m.userId == bot.userId),
          );
          debugLog(
            '[ArenaBot ${bot.userId}] Already in edict: ${joinedEdict?.id}',
          );
          return;
        }
        joinedEdict = edicts.firstWhereOrNull(
          (i) => i.members.any((m) => m.userId == bot.userId),
        );
        if (joinedEdict != null) {
          status = .joined;
          debugLog('[ArenaBot ${bot.userId}] Joined edict: ${joinedEdict!.id}');
          return;
        }
        if (edicts.isNotEmpty) {
          final available = edicts.firstWhereOrNull(
            (e) => e.maxMembers > e.members.length,
          );
          if (available != null) {
            debugLog('[ArenaBot ${bot.userId}] Joining edict: ${available.id}');
            bot.sendDelayed(.joinEdict(n: nextNoun(), edictId: available.id));
          } else {
            debugLog('[ArenaBot ${bot.userId}] No available edicts');
          }
        }

      case JoinedEdictResponse(:final edict):
        joinedEdict = edict;
        status = .joined;
        debugLog('[ArenaBot ${bot.userId}] JoinedEdictResponse: ${edict.id}');

      case CombatStartedResponse(:final combatRoom):
        this.combatRoom = BroadcastId(combatRoom);
        status = .play;
        debugLog('[ArenaBot ${bot.userId}] CombatStarted: $combatRoom');
        bot.sendDelayed(
          .joinBattleRoom(n: nextNoun(), combatRoomId: combatRoom),
        );

      case StartBattleResponse(
        :final broadcastId,
        :final membs,
        :final unitOrder,
        :final currentTurn,
        :final ready,
      ):
        if (broadcastId != combatRoom) {
          debugLog('[ArenaBot ${bot.userId}] StartBattleResponse WRONG ROOM');
          return;
        }
        combatants = List<CombatantDto>.from(membs);
        this.unitOrder = unitOrder.map((id) => UnitId(id.toString())).toList();
        this.currentTurn = UnitId(currentTurn.toString());
        this.ready = ready;
        this.unitOrder = combatants
            .where((c) => c.unit.hp > 0)
            .map((c) => c.unitId)
            .toList();
        final selfCombatant = combatants.firstWhereOrNull(
          (c) => c.unitId == bot.unitId,
        );
        if (selfCombatant != null && selfCombatant.unit.hp <= 0) {
          status = .dead;
          this.unitOrder.remove(bot.unitId);
          debugLog('[ArenaBot ${bot.userId}] Bot is dead on start');
          return;
        }
        if (this.currentTurn == bot.unitId) {
          _performAttack(bot, broadcastId);
        }

      case CombatStateResponse(
        :final broadcastId,
        :final currentTurn,
        :final membs,
      ):
        if (broadcastId != combatRoom?.id) {
          debugLog('[ArenaBot ${bot.userId}] CombatStateResponse WRONG ROOM');
          return;
        }
        this.currentTurn = UnitId(currentTurn.toString());
        combatants = List<CombatantDto>.from(membs);
        unitOrder = combatants
            .where((c) => c.unit.hp > 0)
            .map((c) => c.unitId)
            .toList();
        final selfCombatant = combatants.firstWhereOrNull(
          (c) => c.unitId == bot.unitId,
        );
        if (selfCombatant != null && selfCombatant.unit.hp <= 0) {
          status = BotStatus.dead;
          unitOrder.remove(bot.unitId);
          debugLog('[ArenaBot ${bot.userId}] Bot is dead, skipping turn.');
          return;
        }
        if (this.currentTurn == bot.unitId) {
          _performAttack(bot, broadcastId);
        }

      case CombatEventResponse(:final broadcastId, :final events):
        if (broadcastId != combatRoom?.id) return;
        for (final event in events) {
          switch (event) {
            case AttackEventDto(:final targetId, :final targetHp):
              final target = combatants.firstWhereOrNull(
                (c) => c.unitId == targetId,
              );
              if (target != null) {
                final updatedUnit = target.unit.copyWith(hp: targetHp);
                final idx = combatants.indexOf(target);
                combatants[idx] = target.copyWith(unit: updatedUnit);
              }
            case TurnEventDto(:final currentTurn, :final unitOrder):
              this.currentTurn = UnitId(currentTurn.toString());
              this.unitOrder = unitOrder
                  .map((id) => UnitId(id.toString()))
                  .toList();
            case RoundEventDto():
              break;
            case DeathEventDto(:final unitId):
              unitOrder.remove(unitId);
          }
        }
        final selfCombatant = combatants.firstWhereOrNull(
          (c) => c.unitId == bot.unitId,
        );
        if (selfCombatant != null && selfCombatant.unit.hp <= 0) {
          status = BotStatus.dead;
          unitOrder.remove(bot.unitId);
          return;
        }
        if (currentTurn == bot.unitId) {
          _performAttack(bot, broadcastId);
        }

      case CombatErrorResponse(:final broadcastId):
        if (broadcastId == combatRoom?.id) {
          debugLog('[ArenaBot ${bot.userId}] CombatError — resetting');
          _reset(bot);
          bot.sendDelayed(.joinArena(n: nextNoun()));
        }

      case CombatWinResponse(:final broadcastId):
        if (broadcastId == combatRoom?.id) {
          debugLog('[ArenaBot ${bot.userId}] CombatWin — resetting');
          _reset(bot);
          bot.sendDelayed(.joinArena(n: nextNoun()));
        }

      case CombatRoomsResponse():
        break;

      case MenuResponse(:final units):
        _onUnitsUpdate(bot, units);
        break;

      case UnitsUpdateResponse(:final dto):
        _onUnitsUpdate(bot, dto);
        break;

      case CombatClosedResponse(:final broadcastId):
        if (broadcastId == combatRoom?.id) {
          debugLog('[ArenaBot ${bot.userId}] CombatClosed — resetting');
          _reset(bot);
          bot.sendDelayed(WsRequest.joinArena(n: nextNoun()));
        }
    }
  }

  void _performAttack(ScenarioBot bot, String broadcastId) {
    debugLog('[ArenaBot ${bot.userId}] _performAttack for room: $broadcastId');
    if (combatants.isEmpty) {
      debugLog('[ArenaBot ${bot.userId}] _performAttack: no combatants');
      return;
    }
    final selfCombatant = combatants.firstWhereOrNull(
      (c) => c.unitId == bot.unitId,
    );
    if (selfCombatant != null && selfCombatant.unit.hp <= 0) {
      debugLog('[ArenaBot ${bot.userId}] _performAttack: bot is dead');
      status = BotStatus.dead;
      return;
    }
    final alive = combatants
        .where((c) => c.unit.hp > 0 && c.unitId != bot.unitId)
        .toList();
    if (alive.isEmpty) {
      debugLog('[ArenaBot ${bot.userId}] _performAttack: no alive targets');
      return;
    }
    final target = alive[rnd.nextInt(alive.length)];
    debugLog('[ArenaBot ${bot.userId}] Target: ${target.userId}');
    Future.delayed(AppConfig.botAttackTimeout, () {
      bot.send(
        WsRequest.gameAction(
          combatRoomId: broadcastId,
          n: nextNoun(),
          action: GameActionDto.attack(
            combatantId: bot.unitId,
            enemyCombatantId: target.unitId,
          ),
        ),
      );
    });
  }

  void _onUnitsUpdate(ScenarioBot bot, ListUnitDto units) {
    final currentUnit = units.list.firstWhereOrNull(
      (u) => u.id == units.selectedId,
    );
    if (currentUnit != null && currentUnit.statPoints > 0) {
      _checkUpgrades(bot, currentUnit);
    }
  }

  void _checkUpgrades(ScenarioBot bot, UnitDto unit) {
    if (unit.statPoints <= 0) return;
    debugLog(
      '[ArenaBot ${bot.userId}] Upgrading unit ${unit.id} with ${unit.statPoints} points',
    );
    var remaining = unit.statPoints;
    var addAtk = 0;
    var addDef = 0;
    var addVit = 0;
    while (remaining > 0) {
      final r = rnd.nextDouble();
      if (r < 0.4) {
        addAtk++;
      } else if (r < 0.7) {
        addDef++;
      } else {
        addVit++;
      }
      remaining--;
    }
    bot.sendDelayed(
      WsRequest.allocateStats(
        n: nextNoun(),
        unitId: unit.id,
        addAtk: addAtk,
        addDef: addDef,
        addVitality: addVit,
      ),
    );
  }

  @override
  void onDispose(ScenarioBot bot) {
    _reset(bot);
    joinedArena = false;
  }
}

/// Арена-бот, теперь наследник ScenarioBot.
/// Использует ArenaBotStrategy по умолчанию.
class ArenaBot extends ScenarioBot {
  ArenaBot({
    required super.botRepository,
    required super.userId,
    required super.unitId,
    ArenaBotStrategy? strategy,
  }) : super(strategy: strategy ?? ArenaBotStrategy());
}
