import 'package:drift/drift.dart';

import 'user_table.dart';

@DataClassName('RefreshTokenEntry')
class RefreshTokenTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get userId => text().references(UserTable, #id)();
  TextColumn get hashedToken => text().unique()();
  DateTimeColumn get expiresAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get revokedAt => dateTime().nullable()();
  TextColumn get deviceInfo => text().nullable()();
}
