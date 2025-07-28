// {@template todo_data_source_impl}
import 'dart:io';

import 'package:backend/db_client/dao/todo_dao.dart';
import 'package:backend/db_client/db_client.dart';
import 'package:backend/models/update_todo_dto.dart';
import 'package:drift/drift.dart' show Value;
import 'package:shared/shared.dart';

import '../../exceptions/new_api_exceptions.dart';

abstract class TodoDataSource {
  /// Returns a list of all todo items in the data source
  Future<List<TodoDto>> getAllTodo(String userId);

  /// Returns a todo item with the given [id] from the data source
  /// If no todo item with the given [id] exists, returns `null`
  Future<TodoDto> getTodoById(int todoId, String userId);

  /// Creates a new todo item in the data source
  Future<TodoDto> createTodo(CreateTodoDto todo, String userId);

  /// Updates an existing todo item in the data source
  Future<TodoDto> updateTodo({required int todoId, required UpdateTodoDto todo, required String userId});

  /// Deletes a todo item with the given [id] from the data source
  Future<void> deleteTodoById(int todoId, String userId);
}

class TodoDataSourceImpl implements TodoDataSource {
  const TodoDataSourceImpl(this._dao);
  final TodoDao _dao;
  // final User _user;
  @override
  Future<TodoDto> createTodo(CreateTodoDto createTodo, String userId) async {
    try {
      // _dao.doWhenOpened();
      final result = await _dao.insertTodo(
        TodoTableCompanion(
          title: Value(createTodo.title),
          description: Value.absentIfNull(createTodo.description),
          completed: Value(false),
          createdAt: Value(DateTime.now()),
          userId: Value(userId),
        ),
      );

      final todo = TodoDto(
        id: result.id,
        title: result.title,
        description: result.description,
        createdAt: result.createdAt,
      );
      stdout.writeln('has result $todo');
      return todo;
    } on Exception catch (e) {
      stdout.writeln('exception create todo ${e.runtimeType}');
      throw ApiException.badRequest(message: 'Unexpected error');
    } finally {
      // await _databaseConnection.close();
    }
  }

  @override
  Future<void> deleteTodoById(int todoId, String userId) async {
    try {
      final deletedRows = await _dao.deleteTodoById(todoId, userId);
    } on Exception catch (e) {
      throw ApiException.badRequest(message: 'Unexpected error');
    } finally {
      // await _databaseConnection.close();
    }
  }

  @override
  Future<List<TodoDto>> getAllTodo(String userId) async {
    final result = await _dao.getAllTodo(userId);
    return result
        .map((i) => TodoDto(id: i.id, title: i.title, description: i.description, createdAt: i.createdAt))
        .toList();
  }

  @override
  Future<TodoDto> getTodoById(int todoId, String userId) async {
    try {
      // await _databaseConnection.connect();
      final result = await _dao.getTodoById(todoId, userId);
      return TodoDto(id: result.id, title: result.title, createdAt: result.createdAt);
    } on ApiException {
      rethrow;
    } on Exception catch (e) {
      throw ApiException.badRequest(message: 'Unexpected error');
    } finally {
      // await _databaseConnection.close();
    }
  }

  @override
  Future<TodoDto> updateTodo({required int todoId, required UpdateTodoDto todo, required String userId}) async {
    try {
      stdout.writeln('datasource update $todo');
      final amount = await _dao.updateTodo(
        todoId,
        TodoTableCompanion(
          title: Value.absentIfNull(todo.title),
          description: Value.absentIfNull(todo.description),
          completed: Value.absentIfNull(todo.completed),
          updatedAt: Value(DateTime.now()),
        ),
      );
      if (amount == 0) {
        stdout.writeln('datasource update not ok todo 1');
        throw ApiException.notFound(message: 'Todo not found');
      }

      stdout.writeln('datasource update ready 1');
      final updated = await _dao.getTodoById(todoId, userId);

      stdout.writeln('datasource update ready $updated');
      stdout.writeln('update ok $updated');
      return TodoDto(
        id: updated.id,
        title: updated.title,
        description: updated.description,
        createdAt: updated.createdAt,
      );
    } on Exception catch (e) {
      stdout.writeln('update err $e ');
      throw ApiException.badRequest(message: 'Unexpected error');
    } finally {
      // await _databaseConnection.close();
    }
  }
}
