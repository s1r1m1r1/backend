import 'package:failures/failures.dart';
import 'package:models/models.dart';
import 'package:typedefs/typedefs.dart';

abstract class TodoRepository {
  Future<List<Todo>> getTodos();

  Future<Todo> getTodoById(TodoId id);

  Future<Todo> createTodo(CreateTodoDto createTodoDto);

  Future<Todo> updateTodo({
    required TodoId id,
    required UpdateTodoDto updateTodoDto,
  });

  Future<void> deleteTodo(TodoId id);
}
