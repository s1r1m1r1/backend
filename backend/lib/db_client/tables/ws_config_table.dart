import 'package:drift/drift.dart';
import 'package:sha_red/sha_red.dart';

@DataClassName('WsConfigEntry')
class WsConfigTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get role => textEnum<Role>().withDefault(const Constant('user'))();
  TextColumn get letterRoom => text()();
  TextColumn get counterRoom => text()();
  IntColumn get version => integer()();
}
