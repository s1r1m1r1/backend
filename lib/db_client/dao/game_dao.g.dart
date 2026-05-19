// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_dao.dart';

// ignore_for_file: type=lint
mixin _$GameDaoMixin on DatabaseAccessor<DbClient> {
  $UserTableTable get userTable => attachedDatabase.userTable;
  $CharacterTableTable get characterTable => attachedDatabase.characterTable;
  GameDaoManager get managers => GameDaoManager(this);
}

class GameDaoManager {
  final _$GameDaoMixin _db;
  GameDaoManager(this._db);
  $$UserTableTableTableManager get userTable =>
      $$UserTableTableTableManager(_db.attachedDatabase, _db.userTable);
  $$CharacterTableTableTableManager get characterTable =>
      $$CharacterTableTableTableManager(
        _db.attachedDatabase,
        _db.characterTable,
      );
}
