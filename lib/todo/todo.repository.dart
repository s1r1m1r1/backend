import 'dart:async';

import 'package:sha_red/sha_red.dart';

abstract class TodoRepository {
  Future<List<TodoDto>> getTodos();

  FutureOr<TodoDto> getTodoById(int todoId);

  Future<TodoDto> createTodo(CreateTodoDto createTodoDto);

  FutureOr<TodoDto> updateTodo({
    required int todoId,
    required UpdateTodoDto updateTodoDto,
  });

  Future<int> deleteTodo(int todoId);
}
