// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unit_dao.dart';

// ignore_for_file: type=lint
mixin _$UnitDaoMixin on DatabaseAccessor<DbClient> {
  $UnitTableTable get unitTable => attachedDatabase.unitTable;
  $SelectedUnitTableTable get selectedUnitTable =>
      attachedDatabase.selectedUnitTable;
  UnitDaoManager get managers => UnitDaoManager(this);
}

class UnitDaoManager {
  final _$UnitDaoMixin _db;
  UnitDaoManager(this._db);
  $$UnitTableTableTableManager get unitTable =>
      $$UnitTableTableTableManager(_db.attachedDatabase, _db.unitTable);
  $$SelectedUnitTableTableTableManager get selectedUnitTable =>
      $$SelectedUnitTableTableTableManager(
        _db.attachedDatabase,
        _db.selectedUnitTable,
      );
}
