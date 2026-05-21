import 'dart:async';

import 'package:drift/drift.dart' show Value;
import 'package:dto/dto.dart';
import 'package:game_dto/game_dto.dart';
import 'package:injectable/injectable.dart';

import '../../../core/api_exceptions.dart';
import '../../../db_client/db_client.dart';
import '../../../db_client/extensions/entry_to_dto.dart';
import '../domain/unit_repository.dart';

@LazySingleton(as: UnitRepository)
class UnitRepositoryImpl implements UnitRepository {
  UnitRepositoryImpl(this._db);
  final DbClient _db;

  @override
  Future<UnitDto> createUnit(UserId userId, CreateUnitDto dto) async {
    final entry = await _db.unitDao.insertUnit(
      UnitTableCompanion.insert(
        name: dto.name,
        atk: dto.atk,
        def: dto.def,
        vitality: dto.vitality,
        userId: userId.value,
      ),
    );
    return entry.toDto();
  }

  @override
  FutureOr<UnitDto?> getUnit({
    required UserId userId,
    required UnitId characterId,
  }) async {
    final entry = await _db.unitDao.getUnitEntry(characterId.value);
    if (entry == null || entry.userId != userId.value) return null;
    return entry.toDto();
  }

  @override
  FutureOr<List<UnitDto>> getListUnit({required UserId userId}) async {
    final entries = await _db.unitDao.getListUnitEntries(userId: userId.value);
    return entries.map((e) => e.toDto()).toList();
  }

  @override
  Future<UnitDto?> updateUnit(UserId userId, UpdateUnitDto dto) async {
    final result = await _db.unitDao.updateUnit(
      UnitTableCompanion(
        id: Value(dto.id.value),
        name: Value.absentIfNull(dto.name),
        vitality: Value.absentIfNull(dto.vitality),
        atk: Value.absentIfNull(dto.atk),
        def: Value.absentIfNull(dto.def),
      ),
    );
    if (result == null) return null;
    return result.toDto();
  }

  @override
  Future<bool> deleteUnit({
    required UserId userId,
    required UnitId characterId,
  }) async {
    final entry = await _db.unitDao.getUnitEntry(characterId.value);
    if (entry == null || entry.userId != userId.value) return false;
    final result = await _db.unitDao.deleteUnit(characterId.value);
    return result == 1;
  }

  @override
  Future<UnitDto> setSelectedUnit({
    required UserId userid,
    required UnitId unitId,
  }) async {
    final entry = await _db.unitDao.setSelectedUnit(
      SelectedUnitTableCompanion(
        userId: Value(userid.value),
        unitId: Value(unitId.value),
      ),
    );
    if (entry == null) throw const ApiException.notFound();
    return entry.toDto();
  }

  @override
  Future<UnitDto?> getSelectedUnit(UserId userid) async {
    final entry = await _db.unitDao.getSelectedUnitEntry(userid.value);
    if (entry == null) return null;
    return entry.toDto();
  }

  @override
  Future<UnitStatsDto?> getUnitPublicInfo(UnitId unitId) {
    return _db.unitDao.getUnitPublicInfo(unitId.value);
  }

  @override
  Future<void> updateStats({
    required UnitId unitId,
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
    UnitId unitId,
    int addAtk,
    int addDef,
    int addVitality,
  ) {
    return _db.unitDao.allocateStats(unitId.value, addAtk, addDef, addVitality);
  }
}
