import 'package:equatable/equatable.dart';
import 'package:sha_red/sha_red.dart';

class Unit extends Equatable {
  const Unit({
    required this.vitality,
    required this.atk,
    required this.def,
    required this.name,
    required this.id,
  });
  final int id;
  final String name;
  final int vitality, atk, def;

  @override
  List<Object?> get props => [id, name, vitality, atk, def];

  factory Unit.fromDto(UnitDto dto) {
    return Unit(id: dto.id, name: dto.name, vitality: dto.vitality, atk: dto.atk, def: dto.def);
  }
}
