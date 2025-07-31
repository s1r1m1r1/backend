import 'package:drift/drift.dart';

import '../db_client.dart';
import '../tables/message_table.dart';

part 'messages_dao.g.dart';

@DriftAccessor(tables: [MessageTable])
class MessagesDao extends DatabaseAccessor<DbClient> with _$MessagesDaoMixin {
  // this constructor is required so that the main database can create an instance
  // of this object.
  MessagesDao(super.db);

  Future<List<MessageEntry>> getMessages() {
    return select(messageTable).get();
  }

  Future<List<MessageEntry>> getMessagesByChannel(int channelId) {
    return (select(messageTable)..where((t) => t.channelId.equals(channelId))).get();
  }

  Future<MessageEntry?> insertRow(MessageTableCompanion toCompanion) {
    return into(messageTable).insertReturningOrNull(toCompanion);
  }
}
