import 'package:drift/drift.dart';
import 'package:dto/dto.dart' show Role;
import 'package:uuid/uuid.dart';

@DataClassName('UserEntry')
class UserTable extends Table {
  @override
  Set<Column> get primaryKey => {id};
  // primary key
  // ignore: prefer_const_constructors
  TextColumn get id => text().clientDefault(() => const Uuid().v7())();

  // primary key
  TextColumn get email => text().withLength(min: 6, max: 254)();
  TextColumn get password => text().withLength(min: 28)();

  //  developer,user
  TextColumn get role => textEnum<Role>().withDefault(const Constant('user'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn? get deletedAt => dateTime().nullable()();

  BoolColumn get emailVerified =>
      boolean().withDefault(const Constant(false))();
  TextColumn get confirmationToken => text().nullable()();
}

// TextColumn get id => text().clientDefault(() => const Uuid().v1())();
