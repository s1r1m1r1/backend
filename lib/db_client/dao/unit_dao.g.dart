// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unit_dao.dart';

// ignore_for_file: type=lint
mixin _$UnitDaoMixin on DatabaseAccessor<DbClient> {
  $UserTableTable get userTable => attachedDatabase.userTable;
  $UnitTableTable get unitTable => attachedDatabase.unitTable;
  $SelectedUnitTableTable get selectedUnitTable =>
      attachedDatabase.selectedUnitTable;
  UnitDaoManager get managers => UnitDaoManager(this);
}

class UnitDaoManager {
  final _$UnitDaoMixin _db;
  UnitDaoManager(this._db);
  $$UserTableTableTableManager get userTable =>
      $$UserTableTableTableManager(_db.attachedDatabase, _db.userTable);
  $$UnitTableTableTableManager get unitTable =>
      $$UnitTableTableTableManager(_db.attachedDatabase, _db.unitTable);
  $$SelectedUnitTableTableTableManager get selectedUnitTable =>
      $$SelectedUnitTableTableTableManager(
        _db.attachedDatabase,
        _db.selectedUnitTable,
      );
}
