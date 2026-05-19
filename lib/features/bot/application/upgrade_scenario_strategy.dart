import 'dart:async';

import 'package:collection/collection.dart';
import 'package:dto/dto.dart';
import 'package:game_dto/game_dto.dart';

import '../../../core/debug_log.dart';
import 'bot_strategy.dart';

class UpgradeScenarioStrategy extends BotStrategy {
  UpgradeScenarioStrategy({required this.isCreator});

  final bool isCreator;
  final Completer<void> upgraded = Completer<void>();
  final Completer<int> winnerTeamId = Completer<int>();

  String? _combatRoomId;
  int lastAtk = 10;
  int lastDef = 5;
  int lastHp = 100;
  int upgradesDetected = 0;
  List<CombatantDto> lastMembs = [];

  @override
  FutureOr<void> onInit(ScenarioBot bot) {
    debugLog('[Bot ${bot.userId}] onInit: joining arena');
    bot.send(const WsRequest.joinArena(n: 'upgrade_join_arena'));
  }

  @override
  void onMessage(ScenarioBot bot, WsResponse message) {
    if (message is RequiredAckResponse) {
      bot.send(
        WsRequest.ack(n: message.n, ts: DateTime.now().millisecondsSinceEpoch),
      );
    }

    if (message is CombatWinResponse) {
      debugLog(
        '[Bot ${bot.userId}] CombatWinResponse MATCHED! team=${message.winnerTeamId}',
      );
      if (!winnerTeamId.isCompleted)
        winnerTeamId.complete(message.winnerTeamId);

      bot.send(const WsRequest.joinArena(n: 'upgrade_rejoin'));
      return;
    }

    if (message is UnitsUpdateResponse) {
      _onUnitsUpdate(bot, message.dto);
      return;
    }

    if (message is MenuResponse) {
      _onUnitsUpdate(bot, message.units);
      return;
    }

    if (message is CombatEventResponse) {
      for (final event in message.events) {
        switch (event) {
          case TurnEventDto(:final currentTurn):
            debugLog('[Bot ${bot.userId}] Turn event: $currentTurn');
            _handleTurn(bot, currentTurn, lastMembs);
          case AttackEventDto(:final targetId):
            final target = lastMembs.firstWhereOrNull(
              (m) => m.unitId == targetId,
            );
            if (target != null) {
              // target.unit.hp = targetHp; // if needed
            }
          case _:
            break;
        }
      }
    }

    switch (message) {
      case ActiveEdictsResponse(:final edicts):
        if (isCreator) {
          if (!edicts.any(
            (e) => e.members.any((m) => m.userId == bot.userId.id),
          )) {
            bot.send(const WsRequest.createNewEdict(n: 'upgrade_create'));
          }
        } else {
          if (edicts.isNotEmpty) {
            final target = edicts.first;
            if (!target.members.any((m) => m.userId == bot.userId.id)) {
              bot.send(
                WsRequest.joinEdict(
                  n: 'upgrade_join_edict',
                  edictId: target.id,
                ),
              );
            }
          }
        }

      case CombatStartedResponse():
        _combatRoomId = message.combatRoom;
        bot.send(
          WsRequest.joinBattleRoom(
            n: 'upgrade_ready',
            combatRoomId: _combatRoomId!,
          ),
        );

      case StartBattleResponse(:final currentTurn, :final membs):
        lastMembs = membs;
        _handleTurn(bot, currentTurn, membs);

      case CombatStateResponse(:final currentTurn, :final membs):
        lastMembs = membs;
        _handleTurn(bot, currentTurn, membs);

      case _:
        break;
    }
  }

  void _onUnitsUpdate(ScenarioBot bot, ListUnitDto units) {
    final currentUnit = units.list.firstWhereOrNull(
      (u) => u.id == units.selectedId,
    );
    if (currentUnit != null) {
      debugLog(
        '[Bot ${bot.userId}] data: ATK=${currentUnit.atk}, HP=${currentUnit.hp}, points=${currentUnit.statPoints}, level=${currentUnit.level}',
      );
      if (currentUnit.atk > lastAtk) {
        upgradesDetected++;
        debugLog(
          '[Bot ${bot.userId}] UPGRADE VERIFIED! ATK: $lastAtk -> ${currentUnit.atk}',
        );
        lastAtk = currentUnit.atk;
        if (!upgraded.isCompleted) upgraded.complete();
      }

      if (currentUnit.statPoints > 0) {
        debugLog(
          '[Bot ${bot.userId}] spending ${currentUnit.statPoints} statPoints',
        );
        _checkUpgrades(bot, currentUnit);
      }
    }
  }

  void _checkUpgrades(ScenarioBot bot, UnitDto unit) {
    final addAtk = unit.statPoints;
    bot.send(
      WsRequest.allocateStats(
        n: 'upgrade_alloc',
        unitId: unit.id,
        addAtk: addAtk,
        addDef: 0,
        addVitality: 0,
      ),
    );
    debugLog('[Bot ${bot.userId}] sent AllocateStats: +$addAtk ATK');
  }

  void _handleTurn(ScenarioBot bot, int currentTurn, List<CombatantDto> membs) {
    final myUnitId = bot.unitId.s;
    if (currentTurn == myUnitId) {
      final enemies = membs
          .where((m) => m.unitId != myUnitId && m.unit.hp > 0)
          .toList();
      if (enemies.isEmpty) {
        debugLog('[Bot ${bot.userId}] No enemies alive');
        return;
      }
      final enemy = enemies.first;
      debugLog('[Bot ${bot.userId}] attacking ${enemy.unitId}');
      bot.send(
        WsRequest.gameAction(
          n: 'upgrade_attack',
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
