import 'package:drift/drift.dart';
import 'package:dto/dto.dart';

import '../../core/api_exceptions.dart';
import '../db_client.dart';
import '../tables/todo_table.dart';

part 'todo_dao.g.dart';

@DriftAccessor(tables: [TodoTable])
class TodoDao extends DatabaseAccessor<DbClient> with _$TodoDaoMixin {
  // this constructor is required so that the main database can create an instance
  // of this object.
  TodoDao(super.db);

  //------------------------------------------------------------------------------- --
  // Mapping methods
  //------------------------------------------------------------------------------- --

  TodoDto _toTodoDto(TodoEntry entry) {
    return TodoDto(
      id: entry.id,
      title: entry.title,
      description: entry.description,
      completed: entry.completed,
      createdAt: entry.createdAt,
    );
  }

  //------------------------------------------------------------------------------- --
  // CRUD operations returning TodoDto
  //------------------------------------------------------------------------------- --

  Future<TodoDto> insertTodo(TodoTableCompanion companion) async {
    final entry = await into(todoTable).insertReturning(companion);
    return _toTodoDto(entry);
  }

  Future<int> updateTodo(TodoTableCompanion companion) async {
    return (update(
      todoTable,
    )..where((t) => t.id.equals(companion.id.value))).write(companion);
  }

  Future<bool> hasPermission({
    required int todoId,
    required String userId,
  }) async {
    final query = select(todoTable);
    query.where((t) => t.id.equals(todoId) & t.userId.equals(userId));
    final exist = await query.getSingleOrNull();
    if (exist == null) return false;
    return true;
  }

  Future<int> deleteTodoById({
    required int todoId,
    required String userId,
  }) async {
    return (delete(
      todoTable,
    )..where((t) => t.id.equals(todoId) & t.userId.equals(userId))).go();
  }

  Future<List<TodoDto>> getAllTodo(String userId) async {
    final entries =
        await (select(todoTable)
              ..where((t) => t.userId.equals(userId))
              ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
            .get();
    return entries.map(_toTodoDto).toList();
  }

  Future<TodoDto> getTodoById({
    required int todoId,
    required String userId,
  }) async {
    try {
      final result =
          await (select(todoTable)
                ..where((t) => t.id.equals(todoId) & t.userId.equals(userId)))
              .getSingle();
      return _toTodoDto(result);
    } catch (e) {
      throw const ApiException.notFound(message: 'Todo not found');
    }
  }
}
