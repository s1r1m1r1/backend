import 'dart:async';

import 'package:backend/core/new_api_exceptions.dart';
import 'package:backend/db_client/db_client.dart';
import 'package:drift/drift.dart' show Value;
import 'package:injectable/injectable.dart';
import 'package:sha_red/sha_red.dart';

abstract class UnitDatasource {
  Future<UnitDto> createUnit(int userId, CreateUnitDto dto);
  FutureOr<UnitDto?> getUnit({required int userId, required int characterId});

  FutureOr<List<UnitDto>> getListUnit(int userId);

  Future<UnitDto?> updateUnit(int userId, UpdateUnitDto dto);

  Future<int> deleteUnit(int characterId);

  Future<UnitDto> setSelectedUnit({required int userid, required int unitId});

  Future<UnitDto?> getSelectedUnit(int userid);
}

@LazySingleton(as: UnitDatasource)
class UnitDatasourceImpl implements UnitDatasource {
  UnitDatasourceImpl(this._db);
  final DbClient _db;

  @override
  Future<UnitDto> createUnit(int userId, CreateUnitDto dto) async {
    final entry = await _db.unitDao.insertUnit(
      UnitTableCompanion.insert(
        name: dto.name,
        atk: dto.atk,
        def: dto.def,
        vitality: dto.vitality,
        userId: userId,
      ),
    );
    return UnitDto(
      id: entry.id,
      name: entry.name,
      vitality: entry.vitality,
      atk: entry.atk,
      def: entry.def,
    );
  }

  @override
  FutureOr<UnitDto?> getUnit({
    required int userId,
    required int characterId,
  }) async {
    final entry = await _db.unitDao.getUnit(characterId);
    if (entry?.userId != userId) {
      return null;
    }
    if (entry != null) {
      return UnitDto(
        id: entry.id,
        name: entry.name,
        vitality: entry.vitality,
        atk: entry.atk,
        def: entry.def,
      );
    }
    return null;
  }

  @override
  FutureOr<List<UnitDto>> getListUnit(int userId) {
    return _db.unitDao
        .getListUnit(userId: userId)
        .then(
          (value) => value
              .map(
                (e) => UnitDto(
                  id: e.id,
                  name: e.name,
                  vitality: e.vitality,
                  atk: e.atk,
                  def: e.def,
                ),
              )
              .toList(),
        );
  }

  @override
  Future<UnitDto?> updateUnit(int userId, UpdateUnitDto dto) async {
    final entry = await _db.unitDao.updateUnit(
      UnitTableCompanion(
        id: Value(dto.id),
        name: Value.absentIfNull(dto.name),
        vitality: Value.absentIfNull(dto.vitality),
        atk: Value.absentIfNull(dto.atk),
        def: Value.absentIfNull(dto.def),
      ),
    );
    if (entry == null) return null;
    return UnitDto(
      id: entry.id,
      name: entry.name,
      vitality: entry.vitality,
      atk: entry.atk,
      def: entry.def,
    );
  }

  @override
  Future<int> deleteUnit(int characterId) {
    return _db.unitDao.deleteUnit(characterId);
  }

  @override
  Future<UnitDto> setSelectedUnit({
    required int userid,
    required int unitId,
  }) async {
    final selectedEntry = await _db.unitDao.setSelectedUnit(
      SelectedUnitTableCompanion(userId: Value(userid), unitId: Value(unitId)),
    );
    final unitEntry = await _db.unitDao.getUnit(selectedEntry.unitId);
    if (unitEntry == null) throw ApiException.notFound();
    return UnitDto(
      id: unitEntry.id,
      name: unitEntry.name,
      vitality: unitEntry.vitality,
      atk: unitEntry.atk,
      def: unitEntry.def,
    );
  }

  @override
  Future<UnitDto?> getSelectedUnit(int userid) async {
    final entry = await _db.unitDao.getSelectedUnit(userid);
    if (entry == null) return null;
    final getUnit = await _db.unitDao.getUnit(entry.unitId);
    if (getUnit == null) return null;
    return UnitDto(
      id: getUnit.id,
      name: getUnit.name,
      vitality: getUnit.vitality,
      atk: getUnit.atk,
      def: getUnit.def,
    );
  }
}
