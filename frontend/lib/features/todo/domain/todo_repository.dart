import 'package:frontend/core/network/api_service.dart';
import 'package:frontend/features/todo/data/response_todo_dto.dart';
import 'package:injectable/injectable.dart';

import '../../../models/todo.dart';

abstract class TodoRepository {
  Future getTodos() async {}
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
}
