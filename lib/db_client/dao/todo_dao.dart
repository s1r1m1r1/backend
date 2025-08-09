import '../db_client.dart';
import '../tables/todo_table.dart';
import '../../core/new_api_exceptions.dart';
import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';

import '../../inject/inject.dart';

part 'todo_dao.g.dart';

@LazySingleton(scope: BackendScope.name)
@DriftAccessor(tables: [TodoTable])
class TodoDao extends DatabaseAccessor<DbClient> with _$TodoDaoMixin {
  // this constructor is required so that the main database can create an instance
  // of this object.
  TodoDao(super.db);

  Future<TodoEntry> insertTodo(TodoTableCompanion companion) async {
    return into(todoTable).insertReturning(companion);
  }

  Future<int> updateTodo(TodoTableCompanion companion) async {
    return (update(todoTable)..where((t) => t.id.equals(companion.id.value))).write(companion);
  }

  Future<bool> hasPermission({required int todoId, required int userId}) async {
    final query = select(todoTable);
    query.where((t) => t.id.equals(todoId) & t.userId.equals(userId));
    final exist = await query.getSingleOrNull();
    if (exist == null) return false;
    return true;
  }

  Future<int> deleteTodoById({required int todoId, required int userId}) async {
    return (delete(todoTable)..where((t) => t.id.equals(todoId) & t.userId.equals(userId))).go();
  }

  Future<List<TodoEntry>> getAllTodo(int userId) async {
    return (select(todoTable)
          ..where((t) => t.userId.equals(userId))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  Future<TodoEntry> getTodoById({required int todoId, required int userId}) async {
    try {
      final result = await (select(todoTable)..where((t) => t.id.equals(todoId) & t.userId.equals(userId))).getSingle();
      return result;
    } catch (e) {
      throw ApiException.notFound(message: 'Todo not found');
    }
  }
}
