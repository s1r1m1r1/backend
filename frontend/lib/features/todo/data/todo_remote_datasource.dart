import 'package:injectable/injectable.dart';

import '../domain/models/create_todo_dto.dart';
import '../domain/models/todo.dart';
import '../domain/models/update_todo_dto.dart';
import 'todos_http_client.dart';

abstract class TodoDataSource {
  /// Returns a list of all todo items in the data source
  Future<List<Todo>> getAllTodo();

  /// Returns a todo item with the given [id] from the data source
  /// If no todo item with the given [id] exists, returns `null`
  Future<Todo> getTodoById(int todoId);

  /// Creates a new todo item in the data source
  Future<Todo> createTodo(CreateTodoDto todo);

  /// Updates an existing todo item in the data source
  Future<Todo> updateTodo({required int todoId, required UpdateTodoDto todo});

  /// Deletes a todo item with the given [id] from the data source
  Future<void> deleteTodoById(int todoId);
}

@LazySingleton(as: TodoDataSource)
class TodosRemoteDataSource implements TodoDataSource {
  const TodosRemoteDataSource(this.httpClient);

  final TodosHttpClient httpClient;

  @override
  Future<Todo> createTodo(CreateTodoDto todo) => httpClient.createTodo(todo);

  @override
  Future<void> deleteTodoById(int todoId) => httpClient.deleteTodoById(todoId);

  @override
  Future<List<Todo>> getAllTodo() => httpClient.getAllTodo();

  @override
  Future<Todo> getTodoById(int todoId) => httpClient.getTodoById(todoId);

  @override
  Future<Todo> updateTodo({required int todoId, required UpdateTodoDto todo}) => httpClient.updateTodo(todoId, todo);
}
