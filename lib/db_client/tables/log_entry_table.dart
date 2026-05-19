import 'package:drift/drift.dart';

@DataClassName('LogEntry')
class LogEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get level => text()();
  TextColumn get loggerName => text()();
  TextColumn get message => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  // Optional: for errors
  TextColumn get error => text().nullable()();
  TextColumn get stackTrace => text().nullable()();
}
