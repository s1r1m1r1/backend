// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_dao.dart';

// ignore_for_file: type=lint
mixin _$TodoDaoMixin on DatabaseAccessor<DbClient> {
  $TodoTableTable get todoTable => attachedDatabase.todoTable;
  TodoDaoManager get managers => TodoDaoManager(this);
}

class TodoDaoManager {
  final _$TodoDaoMixin _db;
  TodoDaoManager(this._db);
  $$TodoTableTableTableManager get todoTable =>
      $$TodoTableTableTableManager(_db.attachedDatabase, _db.todoTable);
}
