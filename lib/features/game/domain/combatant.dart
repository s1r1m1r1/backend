import 'package:dto/dto.dart';
import 'package:game_dto/game_dto.dart';

import 'unit.dart';

class Combatant {
  Combatant({
    required this.unitId,
    required this.teamId,
    required this.userId,
    required this.isBot,
    required this.baseUnit,
    required this.stats,
  }) : mutableUnit = Unit.fromDto(baseUnit);
  final UnitId unitId;
  TeamId teamId;
  final UserId userId;
  bool isBot;
  //------------------
  final UnitDto baseUnit;
  final UnitStatsDto stats;
  Unit mutableUnit;

  bool ready = false;

  CombatantDto toDto({bool includeBase = true}) {
    return CombatantDto(
      unitId: unitId,
      teamId: teamId,
      userId: userId,
      isBot: isBot,
      baseUnit: includeBase ? baseUnit : null,
      unit: mutableUnit.toDto(),
    );
  }
}
