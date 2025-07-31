import 'package:drift/drift.dart';

import 'channel_table.dart';

@DataClassName('MessageEntry')
class MessageTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get channelId => integer().nullable().references(ChannelTable, #id)();
  IntColumn get senderId => integer()(); // Reference to user, if needed
  TextColumn get content => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
