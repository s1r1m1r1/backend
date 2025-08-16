// {@template todo_data_source_impl}

import 'package:sha_red/sha_red.dart';

abstract class TodoDataSource {
  /// Returns a list of all todo items in the data source
  Future<List<TodoDto>> getAllTodo(int userId);

  /// Returns a todo item with the given [id] from the data source
  /// If no todo item with the given [id] exists, returns `null`
  Future<TodoDto> getTodoById({required int todoId, required int userId});

  /// Creates a new todo item in the data source
  Future<TodoDto> createTodo(CreateTodoDto todo, int userId);

  /// Updates an existing todo item in the data source
  Future<TodoDto> updateTodo({
    required int todoId,
    required UpdateTodoDto todo,
    required int userId,
  });

  /// Deletes a todo item with the given [id] from the data source
  Future<int> deleteTodoById({required int todoId, required int userId});
}
