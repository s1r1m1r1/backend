import 'package:drift/drift.dart';

@DataClassName('ChatRoomEntry')
class ChatRoomTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  DateTimeColumn get deletedAt => dateTime().nullable()();
}
