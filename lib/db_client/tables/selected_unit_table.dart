import 'package:backend/db_client/tables/unit_table.dart';
import 'package:backend/db_client/tables/user_table.dart';
import 'package:drift/drift.dart';

@DataClassName('SelectedUnitEntry')
class SelectedUnitTable extends Table {
  IntColumn get unitId => integer().references(UnitTable, #id, onDelete: KeyAction.cascade)();
  IntColumn get userId => integer().references(UserTable, #id, onDelete: KeyAction.cascade)();

  @override
  Set<Column> get primaryKey => {userId};
}
