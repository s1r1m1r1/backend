import 'package:frontend/features/todo/data/todo_dto.dart';
import 'package:frontend/features/todo/data/update_todo_dto.dart';
import 'package:injectable/injectable.dart';

import '../../../core/network/protected_api_service.dart';
import '../data/create_todo_dto.dart';
import '../view/bloc/todo_bloc.dart';
import 'create_todo.dart';
import 'todo.dart';
import 'update_todo.dart';

abstract class TodoRepository {
  Future<List<Todo>> getTodos();
  Future<Todo> createTodo(CreateTodo todo);
  Future<Todo> updateTodo(UpdateTodo todo);
  Future<void> deleteTodo(int todoId);
}

@LazySingleton(as: TodoRepository)
class TodoRepositoryImpl implements TodoRepository {
  final ProtectedApiService _apiService;
  TodoRepositoryImpl(this._apiService);

  @override
  Future<List<Todo>> getTodos() async {
    final dto = await _apiService.fetchTodos();
    final todos = dto.map((dto) => dto.toModel()).toList();
    return todos;
  }

  @override
  Future<Todo> createTodo(CreateTodo todo) async {
    final dto = await _apiService.createTodo(todo.toDto());
    return dto.toModel();
  }

  @override
  Future<bool> deleteTodo(int todoId) async {
    return _apiService.deleteTodo(todoId);
  }

  @override
  Future<Todo> updateTodo(UpdateTodo todo) async {
    final dto = await _apiService.updateTodo(todo.toDto());
    return dto.toModel();
  }
}
