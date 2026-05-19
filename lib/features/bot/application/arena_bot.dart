import 'dart:math';

import 'package:collection/collection.dart';
import 'package:dto/dto.dart';
import 'package:game_dto/game_dto.dart';

import '../../../core/app_config.dart';
import '../../../core/debug_log.dart';
import '../../../core/utils/noun_gen.dart';
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
  List<int> unitOrder = [];
  int ready = 0;
  int currentTurn = -1;

  /// Полный сброс состояния — бот возвращается в режим ожидания.
  void _reset(ScenarioBot bot) {
    status = BotStatus.ready;
    joinedEdict = null;
    combatRoom = null;
    combatants = [];
    unitOrder = [];
    ready = 0;
    currentTurn = -1;
    debugLog('[ArenaBot ${bot.userId}] reset → ready');
  }

  @override
  void onInit(ScenarioBot bot) {
    if (!joinedArena) {
      bot.send(.joinArena(n: NouN.next().v));
      joinedArena = true;
    }
  }

  @override
  void onMessage(ScenarioBot bot, WsResponse message) {
    if (message is RequiredAckResponse) {
      bot.send(.ack(n: message.n, ts: DateTime.now().millisecondsSinceEpoch));
    }

    if (message is! WsResponseBot) return;

    final toClient = message;

    switch (toClient) {
      case BroadcastInfoResponse(:final broadcasts):
        setBroadcasts.addAll(broadcasts.map((i) => BroadcastId(i.id)));

      case TerminatedBroadcastResponse(:final broad):
        setBroadcasts.remove(BroadcastId(broad));
        if (combatRoom?.id == broad || joinedEdict?.id == broad) {
          _reset(bot);
        }

      case TerminatedAllBroadcastResponse():
        // Полный сброс (ResetEdictsCMD или ResetCombatsCMD)
        setBroadcasts.clear();
        joinedArena = false;
        _reset(bot);
        bot.send(.joinArena(n: NouN.next().v));
        joinedArena = true;

      case ArenaErrorResponse():
        break;

      case ActiveEdictsResponse(:final edicts):
        this.edicts = edicts;
        // Если уже в бою или уже присоединились — не трогаем эдикты
        if (status == BotStatus.play || status == BotStatus.joined) {
          joinedEdict = edicts.firstWhereOrNull(
            (i) => i.members.any((m) => m.userId == bot.userId.id),
          );
          return;
        }
        joinedEdict = edicts.firstWhereOrNull(
          (i) => i.members.any((m) => m.userId == bot.userId.id),
        );
        if (joinedEdict != null) {
          status = .joined;
          return;
        }
        // Ищем первый доступный эдикт и вступаем
        if (edicts.isNotEmpty) {
          final available = edicts.firstWhereOrNull(
            (e) => e.maxMembers > e.members.length,
          );
          if (available != null) {
            bot.send(.joinEdict(n: NouN.next().v, edictId: available.id));
          }
        }

      case JoinedEdictResponse(:final edict):
        joinedEdict = edict;
        status = .joined;

      // TransitionResponse: подтверждаем переход в Combat через joinBattleRoom
      case CombatStartedResponse(:final combatRoom):
        this.combatRoom = BroadcastId(combatRoom);
        status = .play;
        bot.send(.joinBattleRoom(n: NouN.next().v, combatRoomId: combatRoom));

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
        this.unitOrder = List<int>.from(unitOrder);
        this.currentTurn = currentTurn;
        this.ready = ready;

        // Refresh unitOrder based on alive combatants
        this.unitOrder = combatants
            .where((c) => c.unit.hp > 0)
            .map((c) => c.unitId)
            .toList();

        // Check if bot is dead right after start
        final selfCombatant = combatants.firstWhereOrNull(
          (c) => c.unitId == (bot.unitId as int),
        );
        if (selfCombatant != null && selfCombatant.unit.hp <= 0) {
          status = .dead;
          this.unitOrder.remove(bot.unitId as int);
          debugLog(
            '[ArenaBot ${bot.userId}] Bot is dead on start, skipping actions.',
          );
          return;
        }

        if (currentTurn == (bot.unitId as int)) {
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
        this.currentTurn = currentTurn;
        combatants = List<CombatantDto>.from(membs);
        // Refresh unitOrder based on alive combatants
        unitOrder = combatants
            .where((c) => c.unit.hp > 0)
            .map((c) => c.unitId)
            .toList();

        // Check bot health before acting
        final selfCombatant = combatants.firstWhereOrNull(
          (c) => c.unitId == (bot.unitId as int),
        );
        if (selfCombatant != null && selfCombatant.unit.hp <= 0) {
          status = BotStatus.dead;
          unitOrder.remove(bot.unitId as int);
          debugLog('[ArenaBot ${bot.userId}] Bot is dead, skipping turn.');
          return;
        }
        if (currentTurn == (bot.unitId as int)) {
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
                // Update target HP in bot's local combatants list
                final updatedUnit = target.unit.copyWith(hp: targetHp);
                final idx = combatants.indexOf(target);
                combatants[idx] = target.copyWith(unit: updatedUnit);
              }
            case TurnEventDto(:final currentTurn, :final unitOrder):
              this.currentTurn = currentTurn;
              this.unitOrder = List<int>.from(unitOrder);
            case RoundEventDto():
              // Local round tracking not strictly needed for attack logic
              break;
            case DeathEventDto(:final unitId):
              unitOrder.remove(unitId);
          }
        }

        // Check if bot is dead after events
        final selfCombatant = combatants.firstWhereOrNull(
          (c) => c.unitId == (bot.unitId as int),
        );
        if (selfCombatant != null && selfCombatant.unit.hp <= 0) {
          status = BotStatus.dead;
          unitOrder.remove(bot.unitId as int);
          return;
        }

        if (currentTurn == (bot.unitId as int)) {
          _performAttack(bot, broadcastId);
        }

      case CombatErrorResponse(:final broadcastId):
        if (broadcastId == combatRoom?.id) {
          debugLog(
            '[ArenaBot ${bot.userId}] CombatError — resetting & rejoining Arena',
          );
          _reset(bot);
          bot.send(WsRequest.joinArena(n: NouN.next().v));
        }

      case CombatWinResponse(:final broadcastId):
        if (broadcastId == combatRoom?.id) {
          debugLog(
            '[ArenaBot ${bot.userId}] CombatWin — resetting & rejoining Arena',
          );
          _reset(bot);
          bot.send(WsRequest.joinArena(n: NouN.next().v));
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
          debugLog(
            '[ArenaBot ${bot.userId}] CombatClosed — resetting & rejoining Arena',
          );
          _reset(bot);
          bot.send(WsRequest.joinArena(n: NouN.next().v));
        }
    }
  }

  void _performAttack(ScenarioBot bot, String broadcastId) {
    debugLog(
      '[ArenaBot ${bot.userId}] _performAttack called for room: $broadcastId',
    );
    if (combatants.isEmpty) {
      debugLog('[ArenaBot ${bot.userId}] _performAttack failed: no combatants');
      return;
    }

    final selfCombatant = combatants.firstWhereOrNull(
      (c) => c.unitId == bot.unitId,
    );
    if (selfCombatant != null && selfCombatant.unit.hp <= 0) {
      debugLog('[ArenaBot ${bot.userId}] _performAttack failed: I am dead!');
      status = BotStatus.dead;
      return;
    }

    // Атакуем только живых противников
    final alive = combatants
        .where((c) => c.unit.hp > 0 && c.unitId != bot.unitId)
        .toList();
    if (alive.isEmpty) {
      debugLog(
        '[ArenaBot ${bot.userId}] _performAttack failed: no alive targets',
      );
      return;
    }

    final target = alive[rnd.nextInt(alive.length)];
    debugLog('[ArenaBot ${bot.userId}] Target selected: ${target.userId}');
    Future.delayed(AppConfig.botAttackTimeout, () {
      debugLog('[ArenaBot ${bot.userId}] Sending GameActionTs to $broadcastId');
      bot.send(
        WsRequest.gameAction(
          combatRoomId: broadcastId,
          n: NouN.next().v,
          action: GameActionDto.attack(
            combatantId: bot.unitId as int,
            enemyCombatantId: target.unitId,
          ),
        ),
      );
    });
  }

  void _onUnitsUpdate(ScenarioBot bot, ListUnitDto units) {
    // Проверяем наличие очков для улучшения
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

    // Сбалансированное распределение: 40% ATK, 30% DEF, 30% VIT
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

    bot.send(
      WsRequest.allocateStats(
        n: NouN.next().v,
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
