import 'dart:io' show HttpHeaders;

import 'package:backend/db_client/db_client.dart';
import 'package:backend/exceptions/api_exceptions.dart';
import 'package:backend/services/jwt_service.dart';
import 'package:backend/todo/controller/todo_controller.dart';
import 'package:backend/todo/datasource/todo_datasource.dart';
import 'package:backend/todo/repository/todo_repository.dart';
import 'package:backend/user/repository/user_repository.dart';
import 'package:dart_frog/dart_frog.dart';

import '../models/user.dart';

Handler authorizationMiddleware(Handler handler) {
  return (context) async {
    try {
      final request = context.request;
      final authHeader = request.headers[HttpHeaders.authorizationHeader] ?? '';
      final token = authHeader.replaceFirst('Bearer ', '');
      if (token.isEmpty) throw ApiException.unauthorized(message: 'Token must not be empty');
      final jwtService = context.read<JWTService>();
      final decoded = jwtService.verify(token);
      final decodedUser = User.fromJson(decoded);
      final userRepo = context.read<UserRepository>();
      final user = await userRepo.getUserById(decodedUser.userId);
      if (user.isLeft) throw ApiException.unauthorized(message: "User doesn't exist");
      context = _handleAuthDependencies(context, user.right);
      return handler(context);
    } on ApiException catch (e) {
      return Response.json(body: {'message': e.message}, statusCode: e.statusCode);
    }
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
