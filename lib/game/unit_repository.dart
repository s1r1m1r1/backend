import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:sha_red/sha_red.dart';

import 'unit_datasource.dart';

abstract class UnitRepository {
  Future<UnitDto> createUnit(int userid, CreateUnitDto dto);
  Future<UnitDto?> updateUnit(int userId, UpdateUnitDto dto);
  FutureOr<UnitDto?> getUnit({required int userId, required int characterId});
  FutureOr<List<UnitDto>> getListUnit({required int userId});
  Future<bool> setSelectedUnit({required int userid, required int unitId});
  Future<UnitDto?> getSelectedUnit(int userid);

  Future deleteUnit({required int userId, required int characterId});
}

@LazySingleton(as: UnitRepository)
class UnitRepositoryImpl implements UnitRepository {
  UnitRepositoryImpl(this._datasource);
  final UnitDatasource _datasource;

  @override
  Future<UnitDto> createUnit(int userId, CreateUnitDto dto) async {
    return _datasource.createUnit(userId, dto);
  }

  @override
  FutureOr<UnitDto?> getUnit({required int userId, required int characterId}) async {
    return await _datasource.getUnit(userId: userId, characterId: characterId);
  }

  @override
  FutureOr<List<UnitDto>> getListUnit({required int userId}) {
    return _datasource.getListUnit(userId);
  }

  @override
  Future<UnitDto?> updateUnit(int userId, UpdateUnitDto dto) {
    return _datasource.updateUnit(userId, dto);
  }

  @override
  Future<bool> deleteUnit({required int userId, required int characterId}) async {
    final entry = await _datasource.getUnit(userId: userId, characterId: characterId);
    if (entry != null) {
      final result = await _datasource.deleteUnit(characterId);
      return result == 1;
    }
    return false;
  }

  @override
  Future<bool> setSelectedUnit({required int userid, required int unitId}) {
    return _datasource.setSelectedUnit(userid: userid, unitId: unitId);
  }

  @override
  Future<UnitDto?> getSelectedUnit(int userid) {
    return _datasource.getSelectedUnit(userid);
  }
}
