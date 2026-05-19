import 'package:drift/drift.dart';

import 'unit_table.dart';
import 'user_table.dart';

@DataClassName('SelectedUnitEntry')
class SelectedUnitTable extends Table {
  IntColumn get unitId =>
      integer().references(UnitTable, #id, onDelete: KeyAction.cascade)();
  TextColumn get userId =>
      text().references(UserTable, #id, onDelete: KeyAction.cascade)();

  @override
  Set<Column> get primaryKey => {userId};
}
