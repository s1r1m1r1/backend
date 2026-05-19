import 'package:drift/drift.dart';

import 'user_table.dart';

@DataClassName('UnitEntry')
class UnitTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 3, max: 12)();
  IntColumn get atk => integer()(); // атака
  IntColumn get def => integer()(); // защита
  IntColumn get vitality => integer()(); // жизненная сила
  IntColumn get wins => integer().withDefault(const Constant(0))();
  IntColumn get losses => integer().withDefault(const Constant(0))();
  IntColumn get coins => integer().withDefault(const Constant(0))();
  IntColumn get level => integer().withDefault(const Constant(1))();
  IntColumn get statPoints => integer().withDefault(const Constant(0))();
  IntColumn get exp => integer().withDefault(const Constant(0))();

  TextColumn get userId =>
      text().references(UserTable, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get updatedAt =>
      dateTime().clientDefault(() => DateTime.now())();
  // soft delete
  DateTimeColumn get deletedAt => dateTime().nullable()();
}
