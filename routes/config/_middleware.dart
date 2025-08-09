import '../../lib/config/ws_config_datasource.dart';
import '../../lib/config/ws_config_repository.dart';
import '../../lib/db_client/db_client.dart';
import '../../lib/middlewares/session_middleware_.dart';
import '../../lib/models/user.dart';
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
