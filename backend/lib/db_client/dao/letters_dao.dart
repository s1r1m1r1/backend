import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';

import '../../inject/inject.dart';
import '../db_client.dart';
import '../tables/letter_table.dart';

part 'letters_dao.g.dart';

@LazySingleton(scope: BackendScope.name)
@DriftAccessor(tables: [LetterTable])
class LettersDao extends DatabaseAccessor<DbClient> with _$LettersDaoMixin {
  // this constructor is required so that the main database can create an instance
  // of this object.
  LettersDao(super.db);

  Future<List<LetterEntry>> getListLetter({int? chatRoomId}) {
    final query = select(letterTable);
    if (chatRoomId != null) {
      query.where((t) => t.chatRoomId.equals(chatRoomId));
    }
    return query.get();
  }

  Future<LetterEntry?> insertRow(LetterTableCompanion toCompanion) {
    return into(letterTable).insertReturningOrNull(toCompanion);
  }

  Future<void> deleteLetter(int letterId) async {
    await (delete(letterTable)..where((t) => t.id.equals(letterId))).go();
  }

  Future<void> deleteLettersByChannel(int chatRoomId) async {
    await (delete(letterTable)..where((t) => t.chatRoomId.equals(chatRoomId))).go();
  }
}
