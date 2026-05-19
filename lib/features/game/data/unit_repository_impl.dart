import 'dart:async';

import 'package:drift/drift.dart' show Value;
import 'package:dto/dto.dart';
import 'package:game_dto/game_dto.dart';
import 'package:injectable/injectable.dart';

import '../../../db_client/db_client.dart';
import '../domain/unit_repository.dart';

@LazySingleton(as: UnitRepository)
class UnitRepositoryImpl implements UnitRepository {
  UnitRepositoryImpl(this._db);
  final DbClient _db;

  @override
  Future<UnitDto> createUnit(UserId userId, CreateUnitDto dto) async {
    return _db.unitDao.insertUnit(
      UnitTableCompanion.insert(
        name: dto.name,
        atk: dto.atk,
        def: dto.def,
        vitality: dto.vitality,
        userId: userId.id,
      ),
    );
  }

  @override
  FutureOr<UnitDto?> getUnit({
    required UserId userId,
    required int characterId,
  }) async {
    return _db.unitDao.getUnitDto(userId: userId.id, unitId: characterId);
  }

  @override
  FutureOr<List<UnitDto>> getListUnit({required UserId userId}) {
    return _db.unitDao.getListUnitDto(userId: userId.id);
  }

  @override
  Future<UnitDto?> updateUnit(UserId userId, UpdateUnitDto dto) {
    return _db.unitDao.updateUnit(
      UnitTableCompanion(
        id: Value(dto.id),
        name: Value.absentIfNull(dto.name),
        vitality: Value.absentIfNull(dto.vitality),
        atk: Value.absentIfNull(dto.atk),
        def: Value.absentIfNull(dto.def),
      ),
    );
  }

  @override
  Future<bool> deleteUnit({
    required UserId userId,
    required int characterId,
  }) async {
    // Verify ownership before deleting
    final entry = await _db.unitDao.getUnitDto(
      userId: userId.id,
      unitId: characterId,
    );
    if (entry != null) {
      final result = await _db.unitDao.deleteUnit(characterId);
      return result == 1;
    }
    return false;
  }

  @override
  Future<UnitDto> setSelectedUnit({
    required UserId userid,
    required int unitId,
  }) {
    return _db.unitDao.setSelectedUnit(
      SelectedUnitTableCompanion(
        userId: Value(userid.id),
        unitId: Value(unitId),
      ),
    );
  }

  @override
  Future<UnitDto?> getSelectedUnit(UserId userid) {
    return _db.unitDao.getSelectedUnitDto(userid.id);
  }

  @override
  Future<UnitStatsDto?> getUnitPublicInfo(unitId) {
    return _db.unitDao.getUnitPublicInfo(unitId as int);
  }

  @override
  Future<void> updateStats({
    required int unitId,
    int winDelta = 0,
    int lossDelta = 0,
    int coinDelta = 0,
    int expDelta = 0,
    int? newLevel,
    int? newStatPoints,
  }) {
    return _db.unitDao.updateStats(
      unitId: unitId,
      winDelta: winDelta,
      lossDelta: lossDelta,
      coinDelta: coinDelta,
      expDelta: expDelta,
      newLevel: newLevel,
      newStatPoints: newStatPoints,
    );
  }

  @override
  Future<void> allocateStats(
    int unitId,
    int addAtk,
    int addDef,
    int addVitality,
  ) {
    return _db.unitDao.allocateStats(unitId, addAtk, addDef, addVitality);
  }
}
