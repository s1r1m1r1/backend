// Define a table for key-value pairs

import 'package:drift/drift.dart';
// import 'package:drift/native.dart';

import 'connection/native.dart';
import 'tables/key_value_table.dart';
part 'db_client.g.dart';

@DriftDatabase(tables: [KeyValueTable])
class DbClient extends _$DbClient {
  DbClient([QueryExecutor? executor]) : super(executor ?? openConnection());

  @override
  int get schemaVersion => 1; // Increment this if you change your schema

  // Method to save a key-value pair
  Future<void> saveKeyValue(String key, String value) {
    return into(keyValueTable).insertOnConflictUpdate(KeyValueTableCompanion.insert(key: key, value: value));
  }

  // Method to retrieve a value by key
  Future<String?> getKeyValue(String key) async {
    final result = await (select(keyValueTable)..where((t) => t.key.equals(key))).getSingleOrNull();
    return result?.value;
  }

  // Method to delete a key-value pair
  Future<void> deleteKeyValue(String key) {
    return (delete(keyValueTable)..where((t) => t.key.equals(key))).go();
  }
}
