import 'package:drift/drift.dart';

import '../../models/enums.dart';

@DataClassName('RoomEntry')
class RoomTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  TextColumn get type => textEnum<RoomType>()();
}
