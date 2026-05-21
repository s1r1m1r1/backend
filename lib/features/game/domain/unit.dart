import 'package:game_dto/game_dto.dart';

class Unit {
  Unit({
    required this.hp,
    required this.atk,
    required this.def,
    required this.name,
    required this.unitId,
    this.level = 1,
    this.statPoints = 0,
    this.wins = 0,
    this.losses = 0,
    this.coins = 0,
    this.exp = 0,
  });

  factory Unit.fromDto(UnitDto dto) {
    return Unit(
      unitId: dto.id,
      name: dto.name,
      hp: dto.hp,
      atk: dto.atk,
      def: dto.def,
      level: dto.level,
      statPoints: dto.statPoints,
    );
  }
  final UnitId unitId;
  final String name;
  int hp, atk, def;
  int level, statPoints;
  int wins, losses, coins, exp;

  UnitDto toDto() {
    return UnitDto(
      id: unitId,
      name: name,
      hp: hp,
      atk: atk,
      def: def,
      level: level,
      statPoints: statPoints,
    );
  }
}
