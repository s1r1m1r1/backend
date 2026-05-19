// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'log_dao.dart';

// ignore_for_file: type=lint
mixin _$LogDaoMixin on DatabaseAccessor<DbClient> {
  $LogEntriesTable get logEntries => attachedDatabase.logEntries;
  LogDaoManager get managers => LogDaoManager(this);
}

class LogDaoManager {
  final _$LogDaoMixin _db;
  LogDaoManager(this._db);
  $$LogEntriesTableTableManager get logEntries =>
      $$LogEntriesTableTableManager(_db.attachedDatabase, _db.logEntries);
}
