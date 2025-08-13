import 'package:backend/db_client/tables/character_table.dart';
import 'package:drift/drift.dart';

import 'package:backend/db_client/db_client.dart';

part 'game_dao.g.dart';

@DriftAccessor(tables: [CharacterTable])
class GameDao extends DatabaseAccessor<DbClient> with _$GameDaoMixin {
  // this constructor is required so that the main database can create an instance
  // of this object.
  GameDao(super.db);

  //--------------------------------------------------------------------------

  Future<CharacterEntry> insertCharacter(CharacterTableCompanion companion) {
    return into(characterTable).insertReturning(companion);
  }

  Future<CharacterEntry?> getCharacter(int characterId) {
    final query = characterTable.select();
    query.where((t) => t.id.equals(characterId));
    return query.getSingleOrNull();
  }

  Future<List<CharacterEntry>> getListCharacter({required int userId}) {
    final query = characterTable.select();
    query.where((t) => t.userId.equals(userId));
    return query.get();
  }

  Future<CharacterEntry?> updateCharacter(CharacterTableCompanion characterTableCompanion) async {
    final isOk = await update(characterTable).replace(characterTableCompanion);
    if (isOk) {
      return getCharacter(characterTableCompanion.id.value);
    }
    return null;
  }

  Future<int> deleteCharacter(int characterId) async {
    final query = delete(characterTable);
    query.where((t) => t.id.equals(characterId));
    return query.go();
  }
}
