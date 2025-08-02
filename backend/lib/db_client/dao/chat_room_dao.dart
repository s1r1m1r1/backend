import 'package:backend/db_client/tables/chat_room_table.dart';
import 'package:drift/drift.dart';

import '../db_client.dart';
import '../tables/chat_member_table.dart';

part 'chat_room_dao.g.dart';

@DriftAccessor(tables: [ChatRoomTable, ChatMemberTable])
class ChatRoomDao extends DatabaseAccessor<DbClient> with _$ChatRoomDaoMixin {
  // this constructor is required so that the main database can create an instance
  // of this object.
  ChatRoomDao(super.db);

  Future<List<ChatRoomEntry>> getListRoom() {
    return select(chatRoomTable).get();
  }

  Future<ChatRoomEntry?> selectRoom(int chatRoomId) {
    return (select(chatRoomTable)..where((t) => t.id.equals(chatRoomId))).getSingleOrNull();
  }

  Future<ChatRoomEntry?> insertRoom(ChatRoomTableCompanion companion) {
    return into(chatRoomTable).insertReturningOrNull(companion);
  }

  Future<void> deleteRoom(int chatRoomId) async {
    await (delete(chatRoomTable)..where((t) => t.id.equals(chatRoomId))).go();
  }
  //--------------------------------------------------------------------------

  Future<List<ChatMemberEntry>> getListMember(int chatRoomId) {
    return (select(chatMemberTable)..where((t) => t.chatRoomId.equals(chatRoomId))).get();
  }

  Future<void> insertMember(ChatMemberTableCompanion companion) {
    return into(chatMemberTable).insert(companion);
  }

  Future<void> deleteMember(int chatRoomId, int userId) {
    return (delete(chatMemberTable)..where((t) => t.chatRoomId.equals(chatRoomId) & t.userId.equals(userId))).go();
  }
}
