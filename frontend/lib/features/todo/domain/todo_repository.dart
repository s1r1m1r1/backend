import 'package:frontend/features/todo/data/todo_dto.dart';
import 'package:injectable/injectable.dart';

import '../../../core/network/protected_api_service.dart';
import '../data/create_todo_dto.dart';
import 'create_todo.dart';
import 'todo.dart';

abstract class TodoRepository {
  Future<List<Todo>> getTodos();
  Future<Todo> createTodo(CreateTodo todo);
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
    final dto = await _apiService.createTodo(CreateTodoDto.fromModel(todo));
    return dto.toModel();
  }
}
