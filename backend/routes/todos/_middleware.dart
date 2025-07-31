import 'dart:io';

import 'package:backend/db_client/db_client.dart';
import 'package:backend/models/user.dart';
import 'package:backend/session/session.dart';
import 'package:backend/session/session_repository.dart';
import 'package:backend/todo/todo_datasource.dart';
import 'package:backend/todo/todo_repository.dart';
import 'package:backend/user/user_repository.dart';
import 'package:dart_frog/dart_frog.dart';

Handler middleware(Handler handler) {
  return handler.use(sessionTodoMiddleware);
}

Handler sessionTodoMiddleware(Handler handler) {
  return (context) async {
    final request = context.request;
    final authHeader = request.headers[HttpHeaders.authorizationHeader] ?? '';
    final token = authHeader.replaceFirst('Bearer ', '');
    if (token.isEmpty) {
      stdout.writeln("token is null");
      return Response.json(body: {'message': 'Session token must not be empty'}, statusCode: HttpStatus.unauthorized);
    }
    final sessionRepository = context.read<SessionRepository>();
    final session = await sessionRepository.getSessionByToken(token);
    if (session == null) {
      stdout.writeln("session is null");
      return Response.json(body: {'message': 'Invalid or expired session token'}, statusCode: HttpStatus.unauthorized);
    }
    final user = await context.read<UserRepository>().getUserById(session.userId);
    // Attach userId to context for downstream handlers
    var updatedContext = context.provide<Session>(() => session);
    updatedContext = _handleAuthDependencies(context, user);
    return handler(updatedContext);
  };
}

RequestContext _handleAuthDependencies(RequestContext context, User user) {
  final db = context.read<DbClient>();
  final todoDao = db.todoDao;
  final todoDs = TodoDataSourceImpl(todoDao);
  final todoRepo = TodoRepositoryImpl(todoDs, user);
  late RequestContext updatedContext;
  updatedContext = context.provide<User>(() => user);
  updatedContext = updatedContext.provide<TodoRepository>(() => todoRepo);
  updatedContext = updatedContext.provide<TodoDataSource>(() => todoDs);

  return updatedContext;
}
