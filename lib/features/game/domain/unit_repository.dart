import 'dart:async';
import 'package:dto/dto.dart';
import 'package:game_dto/game_dto.dart';

abstract class UnitRepository {
  Future<UnitStatsDto?> getUnitPublicInfo(UnitId unitId);
  Future<UnitDto> createUnit(UserId userId, CreateUnitDto dto);
  Future<UnitDto?> updateUnit(UserId userId, UpdateUnitDto dto);
  FutureOr<UnitDto?> getUnit({
    required UserId userId,
    required int characterId,
  });
  FutureOr<List<UnitDto>> getListUnit({required UserId userId});
  Future<UnitDto> setSelectedUnit({
    required UserId userid,
    required int unitId,
  });
  Future<UnitDto?> getSelectedUnit(UserId userid);

  Future<bool> deleteUnit({required UserId userId, required int characterId});

  Future<void> updateStats({
    required int unitId,
    int winDelta = 0,
    int lossDelta = 0,
    int coinDelta = 0,
    int expDelta = 0,
    int? newLevel,
    int? newStatPoints,
  });

  Future<void> allocateStats(
    int unitId,
    int addAtk,
    int addDef,
    int addVitality,
  );
}
