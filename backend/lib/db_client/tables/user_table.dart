import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

@DataClassName('UserEntry')
class UserTable extends Table {
  @override
  Set<Column> get primaryKey => {id};
  // primary key
  TextColumn get id => text().clientDefault(() => const Uuid().v1())();
  TextColumn get name => text()();
  TextColumn get email => text()();
  TextColumn get password => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn? get deletedAt => dateTime().nullable()();
}
