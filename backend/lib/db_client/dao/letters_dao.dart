import 'package:drift/drift.dart';

import '../db_client.dart';
import '../tables/letter_table.dart';

part 'letters_dao.g.dart';

@DriftAccessor(tables: [LetterTable])
class LettersDao extends DatabaseAccessor<DbClient> with _$LettersDaoMixin {
  // this constructor is required so that the main database can create an instance
  // of this object.
  LettersDao(super.db);

  Future<List<LetterEntry>> getLetters() {
    return select(letterTable).get();
  }

  Future<List<LetterEntry>> getLettersByChannel(int chatRoomId) {
    return (select(letterTable)..where((t) => t.chatRoomId.equals(chatRoomId))).get();
  }

  Future<LetterEntry?> insertRow(LetterTableCompanion toCompanion) {
    return into(letterTable).insertReturningOrNull(toCompanion);
  }

  Future<void> deleteLetter(int letterId) async {
    await (delete(letterTable)..where((t) => t.id.equals(letterId))).go();
  }
}
