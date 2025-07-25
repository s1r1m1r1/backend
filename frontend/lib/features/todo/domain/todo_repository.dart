import 'package:injectable/injectable.dart';

import '../../../core/exceptions/network_exception.dart';
import '../../../core/failures/failure.dart';
import '../../../core/failures/network_failure.dart';
import '../../../core/utils/result.dart';
import '../data/todo_remote_datasource.dart';
import 'models/create_todo_dto.dart';
import 'models/todo.dart';
import 'models/update_todo_dto.dart';

abstract class TodoRepository {
  Future<Result<Failure, List<Todo>>> getTodos();

  Future<Result<Failure, Todo>> getTodoById(int todoId);

  Future<Result<Failure, Todo>> createTodo(CreateTodoDto createTodoDto);

  Future<Result<Failure, Todo>> updateTodo({required int todoId, required UpdateTodoDto updateTodoDto});

  Future<Result<Failure, void>> deleteTodo(int todoId);
}

@LazySingleton(as: TodoRepository)
class TodoRepositoryImpl implements TodoRepository {
  const TodoRepositoryImpl(this._todoDataSource);
  final TodoDataSource _todoDataSource;

  @override
  Future<Result<Failure, Todo>> createTodo(CreateTodoDto createTodoDto) =>
      handleError(() => _todoDataSource.createTodo(createTodoDto));

  @override
  Future<Result<Failure, void>> deleteTodo(int todoId) => handleError(() => _todoDataSource.deleteTodoById(todoId));

  @override
  Future<Result<Failure, Todo>> getTodoById(int todoId) => handleError(() => _todoDataSource.getTodoById(todoId));

  @override
  Future<Result<Failure, List<Todo>>> getTodos() => handleError(_todoDataSource.getAllTodo);

  @override
  Future<Result<Failure, Todo>> updateTodo({required int todoId, required UpdateTodoDto updateTodoDto}) =>
      handleError(() => _todoDataSource.updateTodo(todoId: todoId, todo: updateTodoDto));

  Future<Result<Failure, T>> handleError<T>(Future<T> Function() callback) async {
    try {
      final res = await callback();
      return Result.success(res);
    } on NetworkException catch (e) {
      return Result.fail(NetworkFailure(message: e.message, statusCode: e.statusCode, errors: e.errors));
    }
  }
}
