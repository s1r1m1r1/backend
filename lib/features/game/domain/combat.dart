import 'package:types/types.dart';

import 'combatant.dart';

enum CombatStatus { initial, ready, started, stopped, failure }

enum TurnStatus { none, available, completed }

class Combat {
  Combat({
    required this.round,
    required this.currentCombatant,
    required this.unitOrder,
    required this.combatants,
  });
  factory Combat.initial() => Combat(
    round: const Round(0),
    currentCombatant: UnitId.none,
    unitOrder: [],
    combatants: [],
  );
  CombatStatus status = CombatStatus.initial;
  Round round;
  UnitId currentCombatant;
  List<UnitId> unitOrder;
  List<Combatant> combatants;

  void nextCombatant() {
    if (unitOrder.length <= 1) {
      nextRound();
      return;
    }
    unitOrder.removeAt(0);
    currentCombatant = unitOrder.first;
  }

  void initTurn() {
    if (round == 0) {
      unitOrder = combatants
          .where((e) => e.mutableUnit.hp > 0)
          .map((e) => e.unitId)
          .toList();
      currentCombatant = unitOrder.isNotEmpty ? unitOrder.first : UnitId.none;
      status = CombatStatus.ready;
    }
  }

  void nextRound() {
    round = Round(round.value + 1);
    unitOrder = combatants
        .where((e) => e.mutableUnit.hp > 0)
        .map((e) => e.unitId)
        .toList();
    currentCombatant = unitOrder.isNotEmpty ? unitOrder.first : UnitId.none;
  }
}
