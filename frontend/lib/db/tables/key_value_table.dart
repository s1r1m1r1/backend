import 'package:drift/drift.dart';

@DataClassName('KeyValueItem')
class KeyValueTable extends Table {
  TextColumn get key => text().withLength(min: 1, max: 255)();
  TextColumn get value => text()(); // Store value as text, you can parse it later
  @override
  Set<Column> get primaryKey => {key}; // Key is the primary key
}
