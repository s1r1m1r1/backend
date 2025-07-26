import 'package:drift/drift.dart';

import 'user_table.dart';

@DataClassName('TodoEntry')
class TodoTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  BoolColumn get completed => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  // soft delete
  DateTimeColumn get deletedAt => dateTime().nullable()();
  // foreign key
  TextColumn get userId => text().nullable().references(UserTable, #id)();
}
