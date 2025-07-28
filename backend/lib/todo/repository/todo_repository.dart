import 'dart:developer';
import 'dart:io';

import 'package:backend/failures/server_failure.dart';
import 'package:either_dart/either.dart';
import 'package:shared/shared.dart';

import '../../exceptions/new_api_exceptions.dart';
import '../../failures/failure.dart';
import '../../models/update_todo_dto.dart';
import '../../models/user.dart';
import '../datasource/todo_datasource.dart';

abstract class TodoRepository {
  Future<List<TodoDto>> getTodos();

  Future<Either<Failure, TodoDto>> getTodoById(int todoId);

  Future<TodoDto> createTodo(CreateTodoDto createTodoDto);

  Future<Either<Failure, TodoDto>> updateTodo({required int todoId, required UpdateTodoDto updateTodoDto});

  Future<void> deleteTodo(int todoId);
}

class TodoRepositoryImpl implements TodoRepository {
  TodoRepositoryImpl(this._datasource, this.user);
  final TodoDataSource _datasource;
  final User user;

  @override
  Future<TodoDto> createTodo(CreateTodoDto createTodoDto) async {
    stdout.writeln('create todo');
    final todo = await _datasource.createTodo(createTodoDto, user.userId);
    stdout.writeln('create todo ready ${todo.toJson()}');
    return todo;
  }

  @override
  Future<void> deleteTodo(int todoId) async {
    try {
      final result = await getTodoById(todoId);
      await _datasource.deleteTodoById(todoId, user.userId);
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Future<Either<Failure, TodoDto>> getTodoById(int todoId) async {
    try {
      final res = await _datasource.getTodoById(todoId, user.userId);
      return Right(res);
    } on ApiException catch (e) {
      // log(e.message);
      return Left(ServerFailure(message: e.toString(), statusCode: e.statusCode));
    } on ApiException catch (e) {
      log(e.message);
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<List<TodoDto>> getTodos() async {
    final res = await _datasource.getAllTodo(user.userId);
    return res;
  }

  @override
  Future<Either<Failure, TodoDto>> updateTodo({required int todoId, required UpdateTodoDto updateTodoDto}) async {
    try {
      final r = await _datasource.updateTodo(todoId: todoId, todo: updateTodoDto, userId: user.userId);
      return Right(r);
    } on ApiException catch (e) {
      return Left(ServerFailure(message: e.message ?? '', statusCode: e.statusCode));
    } on ApiException catch (e) {
      log(e.message);
      return Left(ServerFailure(message: e.message));
    }
  }
}
