import 'package:drift/native.dart';

import 'db_client.dart';
import 'package:injectable/injectable.dart';

@module
abstract class DbClientModule {
  @lazySingleton
  DbClient get dbClient => DbClient(NativeDatabase.memory());
}
