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
    updatedContext = _handleAuthDependencies(updatedContext);
    return handler(updatedContext);
  };
}

RequestContext _handleAuthDependencies(RequestContext context) {
  final db = context.read<DbClient>();
  final todoDao = db.todoDao;
  final todoDs = TodoDataSourceImpl(todoDao);
  final user = context.read<User>();
  final todoRepo = TodoRepositoryImpl(todoDs, user);
  late RequestContext updatedContext;
  updatedContext = context.provide<TodoRepository>(() => todoRepo);
  updatedContext = updatedContext.provide<TodoDataSource>(() => todoDs);

  return updatedContext;
}
