import 'package:drift/drift.dart';
import 'user_table.dart';

@DataClassName('SessionEntry')
class SessionTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get token => text()();

  TextColumn get userId => text().references(
    UserTable,
    #id,
    onDelete: KeyAction.cascade,
  )(); // foreign key userId

  DateTimeColumn get expiryDate => dateTime()();

  DateTimeColumn get createdAt => dateTime()();

  TextColumn get refreshToken => text()();

  DateTimeColumn get refreshTokenExpiry => dateTime()();
  //soft delete
  DateTimeColumn get deletedAt => dateTime().nullable()();
}
