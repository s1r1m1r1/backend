// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_dao.dart';

// ignore_for_file: type=lint
mixin _$RoomDaoMixin on DatabaseAccessor<DbClient> {
  $RoomTableTable get roomTable => attachedDatabase.roomTable;
  $UserTableTable get userTable => attachedDatabase.userTable;
  $RoomMemberTableTable get roomMemberTable => attachedDatabase.roomMemberTable;
  RoomDaoManager get managers => RoomDaoManager(this);
}

class RoomDaoManager {
  final _$RoomDaoMixin _db;
  RoomDaoManager(this._db);
  $$RoomTableTableTableManager get roomTable =>
      $$RoomTableTableTableManager(_db.attachedDatabase, _db.roomTable);
  $$UserTableTableTableManager get userTable =>
      $$UserTableTableTableManager(_db.attachedDatabase, _db.userTable);
  $$RoomMemberTableTableTableManager get roomMemberTable =>
      $$RoomMemberTableTableTableManager(
        _db.attachedDatabase,
        _db.roomMemberTable,
      );
}
