import 'package:backend/db_client/tables/user_table.dart';
import 'package:drift/drift.dart';

@DataClassName('SessionEntry')
class SessionTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get token => text()();

  TextColumn get userId => text().references(UserTable, #id)(); // foreign key userId

  DateTimeColumn get expiryDate => dateTime()();

  DateTimeColumn get createdAt => dateTime()();
  //soft delete
  DateTimeColumn get deletedAt => dateTime().nullable()();
}
