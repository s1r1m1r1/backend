import 'package:backend/core/debug_log.dart';
import 'package:backend/core/new_api_exceptions.dart';
import 'package:backend/db_client/dao/todo_dao.dart';
import 'package:backend/db_client/db_client.dart';
import 'package:backend/todo/todo.datasource.dart';
import 'package:drift/drift.dart';
import 'package:sha_red/sha_red.dart';

class TodoDataSourceImpl implements TodoDataSource {
  const TodoDataSourceImpl(this._dao);
  final TodoDao _dao;
  // final User _user;
  @override
  Future<TodoDto> createTodo(CreateTodoDto createTodo, int userId) async {
    try {
      // _dao.doWhenOpened();
      final result = await _dao.insertTodo(
        TodoTableCompanion(
          title: Value(createTodo.title),
          description: Value.absentIfNull(createTodo.description),
          completed: Value(false),
          createdAt: Value(DateTime.now()),
          userId: Value(userId),
        ),
      );

      final todo = TodoDto(
        id: result.id,
        title: result.title,
        description: result.description,
        createdAt: result.createdAt,
      );
      debugLog('has result $todo');
      return todo;
    } on Exception catch (e) {
      debugLog('exception create todo ${e.runtimeType}');
      throw ApiException.badRequest(message: 'Unexpected error');
    } finally {
      // await _databaseConnection.close();
    }
  }

  @override
  Future<int> deleteTodoById({required int todoId, required int userId}) async {
    return await _dao.deleteTodoById(todoId: todoId, userId: userId);
  }

  @override
  Future<List<TodoDto>> getAllTodo(int userId) async {
    final result = await _dao.getAllTodo(userId);
    return result
        .map(
          (i) => TodoDto(
            id: i.id,
            title: i.title,
            description: i.description,
            completed: i.completed,
            createdAt: i.createdAt,
          ),
        )
        .toList();
  }

  @override
  Future<TodoDto> getTodoById({
    required int todoId,
    required int userId,
  }) async {
    // await _databaseConnection.connect();
    final result = await _dao.getTodoById(todoId: todoId, userId: userId);
    return TodoDto(
      id: result.id,
      title: result.title,
      createdAt: result.createdAt,
    );
  }

  @override
  Future<TodoDto> updateTodo({
    required int todoId,
    required UpdateTodoDto todo,
    required int userId,
  }) async {
    debugLog('datasource update ${todo.id} ${todo.completed} $userId');
    // this should be in repository
    final hasPermission = await _dao.hasPermission(
      todoId: todoId,
      userId: userId,
    );
    if (!hasPermission) {
      throw ApiException.unauthorized(message: 'Operation denied');
    }
    final amount = await _dao.updateTodo(
      TodoTableCompanion(
        id: Value(todo.id),
        title: Value.absentIfNull(todo.title),
        description: Value.absentIfNull(todo.description),
        completed: Value.absentIfNull(todo.completed),
        updatedAt: Value(DateTime.now()),
      ),
    );
    debugLog('datasource update  --- { $amount }');
    if (amount == 0) {
      debugLog('datasource update  ok todo  $amount');
      throw ApiException.notFound(message: 'Todo not found');
    }

    final updated = await _dao.getTodoById(todoId: todoId, userId: userId);

    debugLog('update ok $updated');
    return TodoDto(
      id: updated.id,
      title: updated.title,
      description: updated.description,
      createdAt: updated.createdAt,
    );
  }
}
