import 'package:drift/drift.dart';

@DataClassName('RoomEntry')
class RoomTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  DateTimeColumn get deletedAt => dateTime().nullable()();
}
