import 'package:backend/db_client/db_client.dart';
import 'package:backend/db_client/tables/selected_unit_table.dart';
import 'package:backend/db_client/tables/unit_table.dart';
import 'package:drift/drift.dart';

part 'unit_dao.g.dart';

@DriftAccessor(tables: [UnitTable, SelectedUnitTable])
class UnitDao extends DatabaseAccessor<DbClient> with _$UnitDaoMixin {
  // this constructor is required so that the main database can create an instance
  // of this object.
  UnitDao(super.db);

  //------------------------------------------------------------------------------- --

  Future<UnitEntry> insertUnit(UnitTableCompanion companion) {
    return into(unitTable).insertReturning(companion);
  }

  Future<UnitEntry?> getUnit(int unitId) {
    final query = unitTable.select();
    query.where((t) => t.id.equals(unitId));
    return query.getSingleOrNull();
  }

  Future<List<UnitEntry>> getListUnit({required int userId}) {
    final query = unitTable.select();
    query.where((t) => t.userId.equals(userId));
    return query.get();
  }

  Future<UnitEntry?> updateUnit(UnitTableCompanion companion) async {
    final isOk = await update(unitTable).replace(companion);
    if (isOk) {
      return getUnit(companion.id.value);
    }
    return null;
  }

  Future<int> deleteUnit(int characterId) async {
    final query = delete(unitTable);
    query.where((t) => t.id.equals(characterId));
    return query.go();
  }

  Future<SelectedUnitEntry> setSelectedUnit(SelectedUnitTableCompanion companion) {
    return selectedUnitTable.insertReturning(companion, mode: InsertMode.insertOrReplace);
  }

  Future<SelectedUnitEntry?> getSelectedUnit(int userId) {
    final query = selectedUnitTable.select();
    query.where((t) => t.userId.equals(userId));
    return query.getSingleOrNull();
  }
}
