// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_dao.dart';

// ignore_for_file: type=lint
mixin _$GameDaoMixin on DatabaseAccessor<DbClient> {
  $CharacterTableTable get characterTable => attachedDatabase.characterTable;
  GameDaoManager get managers => GameDaoManager(this);
}

class GameDaoManager {
  final _$GameDaoMixin _db;
  GameDaoManager(this._db);
  $$CharacterTableTableTableManager get characterTable =>
      $$CharacterTableTableTableManager(
        _db.attachedDatabase,
        _db.characterTable,
      );
}
