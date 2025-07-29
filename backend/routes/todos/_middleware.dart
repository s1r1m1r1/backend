import 'dart:io';

import 'package:backend/db_client/db_client.dart';
import 'package:backend/exceptions/new_api_exceptions.dart';
import 'package:backend/middlewares/session_middleware.dart';
import 'package:backend/models/user.dart';
import 'package:backend/session/session.dart';
import 'package:backend/session/session_datasource.dart';
import 'package:backend/session/session_repository.dart';
import 'package:backend/todo/controller/todo_controller.dart';
import 'package:backend/todo/datasource/todo_datasource.dart';
import 'package:backend/todo/repository/todo_repository.dart';
import 'package:backend/user/repository/user_repository.dart';
import 'package:dart_frog/dart_frog.dart';

Handler middleware(Handler handler) {
  final sessionRepository = SessionRepositoryImpl(sessionDatasource: SessionMemoryDatasource());
  return handler.use(provider<SessionRepository>((_) => sessionRepository)).use(sessionTodoMiddleware);
}

// Handler authorizationMiddleware(Handler handler) {
//   return (context) async {
//     try {
//       stdout.writeln('AuthorizationMiddleware start');
//       final request = context.request;
//       final authHeader = request.headers[HttpHeaders.authorizationHeader] ?? '';
//       final token = authHeader.replaceFirst('Bearer ', '');
//       if (token.isEmpty) throw ApiException.unauthorized(message: 'Token must not be empty');
//       final jwtService = context.read<JWTService>();
//       final decoded = jwtService.verify(token);
//       final decodedUser = User.fromJson(decoded);
//       final userRepo = context.read<UserRepository>();
//       final user = await userRepo.getUserById(decodedUser.userId);
//       if (user.isLeft) throw ApiException.unauthorized(message: "User doesn't exist");
//       context = _handleAuthDependencies(context, user.right);
//       return handler(context);
//     } on ApiException catch (e) {
//       stdout.writeln('AuthorizationMiddleware ${e.statusCode} ${e.message}');
//       return Response.json(body: {'message': e.message}, statusCode: e.statusCode);
//     } on Object catch (e, stack) {
//       stdout.writeln('AuthorizationMiddleware  ${stack}');
//       return Response.json(
//         body: {'message': 'An unexpected error occurred'},
//         statusCode: HttpStatus.internalServerError,
//       );
//     }
//   };
// }

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
    final session = await sessionRepository.getSession(token);
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
  final todoController = TodoController(todoRepo);
  late RequestContext updatedContext;
  updatedContext = context.provide<User>(() => user);
  updatedContext = updatedContext.provide<TodoController>(() => todoController);
  updatedContext = updatedContext.provide<TodoRepository>(() => todoRepo);
  updatedContext = updatedContext.provide<TodoDataSource>(() => todoDs);
  return updatedContext;
}
