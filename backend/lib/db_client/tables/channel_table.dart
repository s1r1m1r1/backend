import 'package:drift/drift.dart';

@DataClassName('ChannelEntry')
class ChannelTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
}
