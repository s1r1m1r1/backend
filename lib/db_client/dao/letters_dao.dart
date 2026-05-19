import 'package:drift/drift.dart';

import '../db_client.dart';
import '../tables/letter_table.dart';

part 'letters_dao.g.dart';

@DriftAccessor(tables: [LetterTable])
class LettersDao extends DatabaseAccessor<DbClient> with _$LettersDaoMixin {
  // this constructor is required so that the main database can create an instance
  // of this object.
  LettersDao(super.db);

  Future<List<LetterEntry>> getListLetter({String? chatRoomId}) {
    final query = select(letterTable);
    if (chatRoomId != null) {
      query.where((t) => t.chatRoomId.equals(chatRoomId));
    }
    return query.get();
  }

  Future<LetterEntry?> insertRow(LetterTableCompanion toCompanion) {
    return into(letterTable).insertReturningOrNull(toCompanion);
  }

  Future<List<LetterEntry>> deleteLetter(int letterId) async {
    return (delete(
      letterTable,
    )..where((t) => t.id.equals(letterId))).goAndReturn();
  }

  Future<void> deleteLettersByChannel(String chatRoomId) async {
    await (delete(
      letterTable,
    )..where((t) => t.chatRoomId.equals(chatRoomId))).go();
  }

  Future<int> updateRow(int letterId, LetterTableCompanion toCompanion) {
    return (update(
      letterTable,
    )..where((t) => t.id.equals(letterId))).write(toCompanion);
  }

  Future<LetterEntry?> getLetterById(int id) {
    return (select(
      letterTable,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }
}
