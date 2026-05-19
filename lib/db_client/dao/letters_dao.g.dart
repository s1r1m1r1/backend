// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'letters_dao.dart';

// ignore_for_file: type=lint
mixin _$LettersDaoMixin on DatabaseAccessor<DbClient> {
  $LetterTableTable get letterTable => attachedDatabase.letterTable;
  LettersDaoManager get managers => LettersDaoManager(this);
}

class LettersDaoManager {
  final _$LettersDaoMixin _db;
  LettersDaoManager(this._db);
  $$LetterTableTableTableManager get letterTable =>
      $$LetterTableTableTableManager(_db.attachedDatabase, _db.letterTable);
}
