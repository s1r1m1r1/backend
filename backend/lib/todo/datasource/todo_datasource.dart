// {@template todo_data_source_impl}
import 'dart:io';

import 'package:backend/db_client/dao/todo_dao.dart';
import 'package:backend/db_client/db_client.dart';
import 'package:backend/exceptions/not_found_exceptions.dart';
import 'package:backend/exceptions/server_exceptions.dart';
import 'package:backend/models/create_todo_dto.dart';
import 'package:backend/models/todo.dart';
import 'package:backend/models/update_todo_dto.dart';
import 'package:backend/utils/typedefs.dart';
import 'package:drift/drift.dart' show Value;

abstract class TodoDataSource {
  /// Returns a list of all todo items in the data source
  Future<List<Todo>> getAllTodo(String userId);

  /// Returns a todo item with the given [id] from the data source
  /// If no todo item with the given [id] exists, returns `null`
  Future<Todo> getTodoById(TodoId id, String userId);

  /// Creates a new todo item in the data source
  Future<Todo> createTodo(CreateTodoDto todo, String userId);

  /// Updates an existing todo item in the data source
  Future<Todo> updateTodo({required TodoId id, required UpdateTodoDto todo, required String userId});

  /// Deletes a todo item with the given [id] from the data source
  Future<void> deleteTodoById(TodoId id, String userId);
}

class TodoDataSourceImpl implements TodoDataSource {
  const TodoDataSourceImpl(this._dao);
  final TodoDao _dao;
  // final User _user;
  @override
  Future<Todo> createTodo(CreateTodoDto createTodo, String userId) async {
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

      final todo = Todo(
        id: result.id,
        title: result.title,
        description: result.description,
        createdAt: result.createdAt,
      );
      stdout.writeln('has result $todo');
      return todo;
    } on Exception catch (e) {
      stdout.writeln('exception create todo ${e.runtimeType}');
      throw const ServerException('Unexpected error');
    } finally {
      // await _databaseConnection.close();
    }
  }

  @override
  Future<void> deleteTodoById(TodoId id, String userId) async {
    try {
      final deletedRows = await _dao.deleteTodoById(id, userId);
    } on Exception catch (e) {
      throw ServerException('Unexpected error');
    } finally {
      // await _databaseConnection.close();
    }
  }

  @override
  Future<List<Todo>> getAllTodo(String userId) async {
    try {
      final result = await _dao.getAllTodo(userId);
      return result
          .map((i) => Todo(id: i.id, title: i.title, description: i.description, createdAt: i.createdAt))
          .toList();
    } on Exception catch (e) {
      throw ServerException('Unexpected error');
    } finally {
      // await _databaseConnection.close();
    }
  }

  @override
  Future<Todo> getTodoById(TodoId id, String userId) async {
    try {
      // await _databaseConnection.connect();
      final result = await _dao.getTodoById(id, userId);
      return Todo(id: result.id, title: result.title, createdAt: result.createdAt);
    } on NotFoundException {
      rethrow;
    } on Exception catch (e) {
      throw ServerException('Unexpected error');
    } finally {
      // await _databaseConnection.close();
    }
  }

  @override
  Future<Todo> updateTodo({required TodoId id, required UpdateTodoDto todo, required String userId}) async {
    try {
      stdout.writeln('datasource update $todo');
      final amount = await _dao.updateTodo(
        id,
        TodoTableCompanion(
          title: Value.absentIfNull(todo.title),
          description: Value.absentIfNull(todo.description),
          completed: Value.absentIfNull(todo.completed),
          updatedAt: Value(DateTime.now()),
        ),
      );
      if (amount == 0) {
        stdout.writeln('datasource update not ok todo 1');
        throw const NotFoundException('Todo not found');
      }

      stdout.writeln('datasource update ready 1');
      final updated = await _dao.getTodoById(id, userId);

      stdout.writeln('datasource update ready $updated');
      stdout.writeln('update ok $updated');
      return Todo(id: updated.id, title: updated.title, description: updated.description, createdAt: updated.createdAt);
    } on Exception catch (e) {
      stdout.writeln('update err $e ');
      throw ServerException('Unexpected error');
    } finally {
      // await _databaseConnection.close();
    }
  }
}
