import 'dart:async';

import 'package:dto/dto.dart';

import '../../../core/debug_log.dart';
import '../../../models/user.dart';
import '../domain/todo.repository.dart';
import 'todo.datasource.impl.dart';

class TodoRepositoryImpl implements TodoRepository {
  TodoRepositoryImpl(this._datasource, this.user);
  final TodoDataSource _datasource;
  final User user;

  @override
  Future<TodoDto> createTodo(CreateTodoDto createTodoDto) async {
    debugLog('create todo');
    final todo = await _datasource.createTodo(createTodoDto, user.userId.id);
    debugLog('create todo ready ${todo.toJson()}');
    return todo;
  }

  @override
  Future<int> deleteTodo(int todoId) async {
    // final result = await getTodoById(todoId);
    return _datasource.deleteTodoById(todoId: todoId, userId: user.userId.id);
  }

  @override
  FutureOr<TodoDto> getTodoById(int todoId) async {
    final res = await _datasource.getTodoById(
      todoId: todoId,
      userId: user.userId.id,
    );
    return res;
  }

  @override
  Future<List<TodoDto>> getTodos() async {
    final res = await _datasource.getAllTodo(user.userId.id);
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
      userId: user.userId.id,
    );
    return r;
  }
}
