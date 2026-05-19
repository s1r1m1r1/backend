// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_dao.dart';

// ignore_for_file: type=lint
mixin _$UserDaoMixin on DatabaseAccessor<DbClient> {
  $UserTableTable get userTable => attachedDatabase.userTable;
  UserDaoManager get managers => UserDaoManager(this);
}

class UserDaoManager {
  final _$UserDaoMixin _db;
  UserDaoManager(this._db);
  $$UserTableTableTableManager get userTable =>
      $$UserTableTableTableManager(_db.attachedDatabase, _db.userTable);
}
