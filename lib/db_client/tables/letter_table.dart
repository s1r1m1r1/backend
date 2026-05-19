import 'package:drift/drift.dart';

import 'room_table.dart';
import 'user_table.dart';

@DataClassName('LetterEntry')
class LetterTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get chatRoomId =>
      text().references(RoomTable, #id, onDelete: KeyAction.cascade)();
  TextColumn get senderId =>
      text().references(UserTable, #id, onDelete: KeyAction.cascade)();
  TextColumn get content => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
