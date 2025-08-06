import 'dart:async';
import 'dart:io';

import 'package:sha_red/sha_red.dart';

import '../models/user.dart';
import 'todo_datasource.dart';

abstract class TodoRepository {
  Future<List<TodoDto>> getTodos();

  FutureOr<TodoDto> getTodoById(int todoId);

  Future<TodoDto> createTodo(CreateTodoDto createTodoDto);

  FutureOr<TodoDto> updateTodo({required int todoId, required UpdateTodoDto updateTodoDto});

  Future<int> deleteTodo(int todoId);
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
  Future<int> deleteTodo(int todoId) async {
    // final result = await getTodoById(todoId);
    return _datasource.deleteTodoById(todoId: todoId, userId: user.userId);
  }

  @override
  FutureOr<TodoDto> getTodoById(int todoId) async {
    final res = await _datasource.getTodoById(todoId: todoId, userId: user.userId);
    return res;
  }

  @override
  Future<List<TodoDto>> getTodos() async {
    final res = await _datasource.getAllTodo(user.userId);
    return res;
  }

  @override
  FutureOr<TodoDto> updateTodo({required int todoId, required UpdateTodoDto updateTodoDto}) async {
    final r = await _datasource.updateTodo(todoId: todoId, todo: updateTodoDto, userId: user.userId);
    return r;
  }
}
