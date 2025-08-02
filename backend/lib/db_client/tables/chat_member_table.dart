import 'package:drift/drift.dart';

import 'chat_room_table.dart';
import 'user_table.dart';

@DataClassName('ChatMemberEntry')
class ChatMemberTable extends Table {
  // Primary key combines the chat room and user IDs.
  IntColumn get chatRoomId => integer().references(ChatRoomTable, #id, onDelete: KeyAction.cascade)();
  IntColumn get userId => integer().references(UserTable, #id, onDelete: KeyAction.cascade)();

  // Each combination of chatRoomId and userId must be unique.
  @override
  Set<Column> get primaryKey => {chatRoomId, userId};
}
