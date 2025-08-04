import 'package:backend/config/ws_config_datasource.dart';
import 'package:backend/config/ws_config_repository.dart';
import 'package:backend/db_client/db_client.dart';
import 'package:backend/middlewares/session_middleware_.dart';
import 'package:backend/models/user.dart';
import 'package:dart_frog/dart_frog.dart';

Handler middleware(Handler handler) {
  return sessionMiddleware(handler, addToContext: [_provideWsConfig]);
}

RequestContext _provideWsConfig(RequestContext context) {
  final user = context.read<User>();
  final db = context.read<DbClient>();
  final configDao = db.configDao;
  final datasource = WsConfigDatasourceImpl(configDao);
  final todoRepo = WsConfigRepositoryImpl(datasource);

  var updatedContext = context.provide<WsConfigRepository>(() => todoRepo);

  // return updatedContext;
  return updatedContext;
}
