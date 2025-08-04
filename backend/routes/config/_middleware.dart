import 'dart:io';

import 'package:backend/config/ws_config_datasource.dart';
import 'package:backend/config/ws_config_repository.dart';
import 'package:backend/db_client/db_client.dart';
import 'package:backend/models/user.dart';
import 'package:backend/session/session.dart';
import 'package:backend/session/session_repository.dart';
import 'package:backend/user/user_repository.dart';
import 'package:dart_frog/dart_frog.dart';

Handler middleware(Handler handler) {
  return handler.use(sessionConfigMiddleware);
}

Handler sessionConfigMiddleware(Handler handler) {
  return (context) async {
    final request = context.request;
    final authHeader = request.headers[HttpHeaders.authorizationHeader] ?? '';
    final token = authHeader.replaceFirst('Bearer ', '');
    if (token.isEmpty) {
      stdout.writeln("token is null");
      return Response.json(body: {'message': 'Session token must not be empty'}, statusCode: HttpStatus.unauthorized);
    }
    final sessionRepository = context.read<SessionRepository>();
    final session = await sessionRepository.getSession(token: token);
    if (session == null) {
      stdout.writeln("session is null");
      return Response.json(body: {'message': 'Invalid or expired session token'}, statusCode: HttpStatus.unauthorized);
    }
    final isTokenValid = sessionRepository.validateToken(session);
    if (!isTokenValid) {
      stdout.writeln("token is not valid");
      return Response.json(body: {'message': 'Invalid or expired session token'}, statusCode: HttpStatus.unauthorized);
    }

    final user = await context.read<UserRepository>().getUser(userId: session.userId);
    if (user == null) {
      stdout.writeln("user is null");
      return Response.json(body: {'message': 'User not found'}, statusCode: HttpStatus.unauthorized);
    }
    // Attach userId to context for downstream handlers
    var updatedContext = context.provide<Session>(() => session);
    updatedContext = updatedContext.provide<User>(() => user);
    updatedContext = _handleAuthDependencies(updatedContext, user);
    return handler(updatedContext);
  };
}

RequestContext _handleAuthDependencies(RequestContext context, User user) {
  final db = context.read<DbClient>();
  final configDao = db.configDao;
  final datasource = WsConfigDatasourceImpl(configDao);
  final todoRepo = WsConfigRepositoryImpl(datasource);

  var updatedContext = context.provide<WsConfigRepository>(() => todoRepo);

  // return updatedContext;
  return updatedContext;
}
