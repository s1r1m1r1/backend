import 'package:drift/drift.dart';
import 'package:shared/shared.dart' show Role;

// import 'package:uuid/uuid.dart';

@DataClassName('UserEntry')
class UserTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  // primary key
  TextColumn get email => text()();
  TextColumn get password => text()();

  //  admin, user, tester
  TextColumn get role => textEnum<Role>().withDefault(const Constant('user'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn? get deletedAt => dateTime().nullable()();
}


  // TextColumn get id => text().clientDefault(() => const Uuid().v1())();