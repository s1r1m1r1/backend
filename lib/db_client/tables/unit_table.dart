import 'package:drift/drift.dart';

import 'user_table.dart';

@DataClassName('UnitEntry')
class UnitTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get atk => integer()(); // атака
  IntColumn get def => integer()(); // защита
  IntColumn get vitality => integer()(); // жизненная сила

  IntColumn get userId => integer().references(UserTable, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get createdAt => dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get updatedAt => dateTime().clientDefault(() => DateTime.now())();
  // soft delete
  DateTimeColumn get deletedAt => dateTime().nullable()();
}
