import 'dart:async';

import 'package:backend/core/debug_log.dart';
import 'package:backend/models/user.dart';
import 'package:backend/todo/todo.datasource.dart';
import 'package:backend/todo/todo.repository.dart';
import 'package:sha_red/sha_red.dart';

class TodoRepositoryImpl implements TodoRepository {
  TodoRepositoryImpl(this._datasource, this.user);
  final TodoDataSource _datasource;
  final User user;

  @override
  Future<TodoDto> createTodo(CreateTodoDto createTodoDto) async {
    debugLog('create todo');
    final todo = await _datasource.createTodo(createTodoDto, user.userId);
    debugLog('create todo ready ${todo.toJson()}');
    return todo;
  }

  @override
  Future<int> deleteTodo(int todoId) async {
    // final result = await getTodoById(todoId);
    return _datasource.deleteTodoById(todoId: todoId, userId: user.userId);
  }

  @override
  FutureOr<TodoDto> getTodoById(int todoId) async {
    final res = await _datasource.getTodoById(
      todoId: todoId,
      userId: user.userId,
    );
    return res;
  }

  @override
  Future<List<TodoDto>> getTodos() async {
    final res = await _datasource.getAllTodo(user.userId);
    return res;
  }

  @override
  FutureOr<TodoDto> updateTodo({
    required int todoId,
    required UpdateTodoDto updateTodoDto,
  }) async {
    final r = await _datasource.updateTodo(
      todoId: todoId,
      todo: updateTodoDto,
      userId: user.userId,
    );
    return r;
  }
}
