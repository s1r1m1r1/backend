import 'dart:developer';
import 'dart:io';

import 'package:backend/exceptions/not_found_exceptions.dart';
import 'package:backend/exceptions/server_exceptions.dart';
import 'package:backend/failures/server_failure.dart';

import '../../failures/failure.dart';
import '../../models/create_todo_dto.dart';
import '../../models/todo.dart';
import '../../models/update_todo_dto.dart';
import '../../models/user.dart';
import '../../utils/result.dart';
import '../../utils/typedefs.dart';
import '../datasource/todo_datasource.dart';

abstract class TodoRepository {
  Future<Result<Failure, List<Todo>>> getTodos();

  Future<Result<Failure, Todo>> getTodoById(TodoId id);

  Future<Result<Failure, Todo>> createTodo(CreateTodoDto createTodoDto);

  Future<Result<Failure, Todo>> updateTodo({required TodoId id, required UpdateTodoDto updateTodoDto});

  Future<Result<Failure, void>> deleteTodo(TodoId id);
}

class TodoRepositoryImpl implements TodoRepository {
  TodoRepositoryImpl(this._datasource, this.user);
  final TodoDataSource _datasource;
  final User user;

  @override
  Future<Result<Failure, Todo>> createTodo(CreateTodoDto createTodoDto) async {
    try {
      stdout.writeln('create todo');
      final todo = await _datasource.createTodo(createTodoDto, user.userId);
      stdout.writeln('create todo ready ${todo.toJson()}');
      return Success(todo);
    } on Exception catch (e) {
      stdout.writeln('exception create todo ${e.runtimeType}');
      log(e.toString());
      return Fail(ServerFailure(message: e.toString(), statusCode: 100));
    }
    ;
  }

  @override
  Future<Result<Failure, void>> deleteTodo(TodoId id) async {
    try {
      final result = await getTodoById(id);
      switch (result) {
        case Success():
          await _datasource.deleteTodoById(id, user.userId);
          return Success(null);
        case Fail(value: final f):
          return Fail(ServerFailure(message: 'user not found'));
      }
    } on ServerException catch (e) {
      log(e.message);
      return Fail(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Result<Failure, Todo>> getTodoById(TodoId id) async {
    try {
      final res = await _datasource.getTodoById(id, user.userId);
      return Success(res);
    } on NotFoundException catch (e) {
      // log(e.message);
      return Fail(ServerFailure(message: e.toString(), statusCode: e.statusCode));
    } on ServerException catch (e) {
      log(e.message);
      return Fail(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Result<Failure, List<Todo>>> getTodos() async {
    try {
      final res = await _datasource.getAllTodo(user.userId);
      return Success(res);
    } on ServerException catch (e) {
      return Fail(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Result<Failure, Todo>> updateTodo({required TodoId id, required UpdateTodoDto updateTodoDto}) async {
    try {
      final r = await _datasource.updateTodo(id: id, todo: updateTodoDto, userId: user.userId);
      return Success(r);
    } on NotFoundException catch (e) {
      log(e.message);
      return Fail(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on ServerException catch (e) {
      log(e.message);
      return Fail(ServerFailure(message: e.message));
    }
  }
}
