import 'package:backend/db_client/db_client.dart';
import 'package:backend/inject/inject.dart';
import 'package:injectable/injectable.dart';

@module
abstract class DbClientModule {
  @LazySingleton(scope: BackendScope.name)
  DbClient get dbClient => DbClient(DbClient.openConnection());
}
