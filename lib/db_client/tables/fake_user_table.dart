import 'package:drift/drift.dart';

import 'user_table.dart';

@DataClassName('FakeUserEntry')
class FakeUserTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get email => text()();
  // true fake password , not salt
  TextColumn get password => text()();

  // link to user table
  IntColumn get userId =>
      integer().references(UserTable, #id, onDelete: KeyAction.cascade)();
}
