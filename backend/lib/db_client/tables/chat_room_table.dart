import 'package:drift/drift.dart';

@DataClassName('ChatRoomEntry')
class ChatRoomTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
}
