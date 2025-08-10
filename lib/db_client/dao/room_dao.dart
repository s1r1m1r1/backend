import 'package:backend/db_client/tables/room_table.dart';
import 'package:drift/drift.dart';

import 'package:backend/db_client/db_client.dart';
import 'package:backend/db_client/tables/room_member_table.dart';

part 'room_dao.g.dart';

@DriftAccessor(tables: [RoomTable, RoomMemberTable])
class RoomDao extends DatabaseAccessor<DbClient> with _$RoomDaoMixin {
  // this constructor is required so that the main database can create an instance
  // of this object.
  RoomDao(super.db);

  Future<List<RoomEntry>> getListRoom() {
    return select(roomTable).get();
  }

  Future<RoomEntry?> selectRoom(int roomId) {
    return (select(roomTable)..where((t) => t.id.equals(roomId))).getSingleOrNull();
  }

  Future<RoomEntry?> insertRoom(RoomTableCompanion companion) {
    return into(roomTable).insertReturningOrNull(companion);
  }

  Future<void> deleteRoom(int chatRoomId) async {
    await (delete(roomTable)..where((t) => t.id.equals(chatRoomId))).go();
  }
  //--------------------------------------------------------------------------

  Future<List<RoomMemberEntry>> getListMember(int chatRoomId) {
    return (select(roomMemberTable)..where((t) => t.chatRoomId.equals(chatRoomId))).get();
  }

  Future<RoomMemberEntry?> insertMember(RoomMemberTableCompanion companion) {
    return into(roomMemberTable).insertReturningOrNull(companion);
  }

  Future<void> deleteMember(int chatRoomId, int userId) {
    return (delete(
      roomMemberTable,
    )..where((t) => t.chatRoomId.equals(chatRoomId) & t.userId.equals(userId))).go();
  }
}
