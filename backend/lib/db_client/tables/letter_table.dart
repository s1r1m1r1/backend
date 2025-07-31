import 'package:drift/drift.dart';

import 'chat_room_table.dart';

@DataClassName('LetterEntry')
class LetterTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get chatRoomId => integer().nullable().references(ChatRoomTable, #id)();
  IntColumn get senderId => integer()(); // Reference to user, if needed
  TextColumn get content => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
