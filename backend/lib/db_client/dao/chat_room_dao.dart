import 'package:backend/db_client/tables/chat_room_table.dart';
import 'package:drift/drift.dart';

import '../db_client.dart';

part 'chat_room_dao.g.dart';

@DriftAccessor(tables: [ChatRoomTable])
class ChatRoomDao extends DatabaseAccessor<DbClient> with _$ChatRoomDaoMixin {
  // this constructor is required so that the main database can create an instance
  // of this object.
  ChatRoomDao(super.db);

  Future<List<ChatRoomEntry>> getChatRooms() {
    return select(chatRoomTable).get();
  }

  Future<ChatRoomEntry?> selectChatRoom(int chatRoomId) {
    return (select(chatRoomTable)..where((t) => t.id.equals(chatRoomId))).getSingleOrNull();
  }

  Future<ChatRoomEntry?> insertRow(ChatRoomTableCompanion toCompanion) {
    return into(chatRoomTable).insertReturningOrNull(toCompanion);
  }
}
