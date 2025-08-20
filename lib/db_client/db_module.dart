import 'package:backend/db_client/db_client.dart';
// import 'package:drift/native.dart';
import 'package:injectable/injectable.dart';

@module
abstract class DbClientModule {
  @lazySingleton
  // DbClient get dbClient => DbClient(NativeDatabase.memory());
  DbClient get dbClient => DbClient(DbClient.openConnection());
}
