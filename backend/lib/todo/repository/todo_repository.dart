import 'dart:developer';
import 'dart:io';

import 'package:backend/exceptions/api_exceptions.dart';
import 'package:backend/failures/server_failure.dart';
import 'package:either_dart/either.dart';

import '../../failures/failure.dart';
import '../../models/create_todo_dto.dart';
import '../../models/todo.dart';
import '../../models/update_todo_dto.dart';
import '../../models/user.dart';
import '../../utils/typedefs.dart';
import '../datasource/todo_datasource.dart';

abstract class TodoRepository {
  Future<List<Todo>> getTodos();

  Future<Either<Failure, Todo>> getTodoById(TodoId id);

  Future<Either<Failure, Todo>> createTodo(CreateTodoDto createTodoDto);

  Future<Either<Failure, Todo>> updateTodo({required TodoId id, required UpdateTodoDto updateTodoDto});

  Future<Either<Failure, void>> deleteTodo(TodoId id);
}

class TodoRepositoryImpl implements TodoRepository {
  TodoRepositoryImpl(this._datasource, this.user);
  final TodoDataSource _datasource;
  final User user;

  @override
  Future<Either<Failure, Todo>> createTodo(CreateTodoDto createTodoDto) async {
    try {
      stdout.writeln('create todo');
      final todo = await _datasource.createTodo(createTodoDto, user.userId);
      stdout.writeln('create todo ready ${todo.toJson()}');
      return Right(todo);
    } on Exception catch (e) {
      stdout.writeln('exception create todo ${e.runtimeType}');
      log(e.toString());
      return Left(ServerFailure(message: e.toString(), statusCode: 100));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTodo(TodoId id) async {
    try {
      final result = await getTodoById(id);
      switch (result) {
        case Right():
          await _datasource.deleteTodoById(id, user.userId);
          return Right(null);
        case Left():
          return Left(ServerFailure(message: 'user not found'));
      }
    } on ServerException catch (e) {
      log(e.message);
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, Todo>> getTodoById(TodoId id) async {
    try {
      final res = await _datasource.getTodoById(id, user.userId);
      return Right(res);
    } on ApiException catch (e) {
      // log(e.message);
      return Left(ServerFailure(message: e.toString(), statusCode: e.statusCode));
    } on ServerException catch (e) {
      log(e.message);
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<List<Todo>> getTodos() async {
    try {
      final res = await _datasource.getAllTodo(user.userId);
      return res;
    } on ServerException catch (e) {
      rethrow;
    } on Object catch (e, stackTrace) {
      Error.throwWithStackTrace(ApiException.internalServerError(), stackTrace);
    }
  }

  @override
  Future<Either<Failure, Todo>> updateTodo({required TodoId id, required UpdateTodoDto updateTodoDto}) async {
    try {
      final r = await _datasource.updateTodo(id: id, todo: updateTodoDto, userId: user.userId);
      return Right(r);
    } on ApiException catch (e) {
      return Left(ServerFailure(message: e.message ?? '', statusCode: e.statusCode));
    } on ServerException catch (e) {
      log(e.message);
      return Left(ServerFailure(message: e.message));
    }
  }
}
