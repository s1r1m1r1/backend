import 'package:backend/db_client/db_client.dart';
import 'package:backend/db_client/tables/todo_table.dart';
import 'package:backend/exceptions/new_api_exceptions.dart';
import 'package:drift/drift.dart';
import '../../utils/typedefs.dart';

part 'todo_dao.g.dart';

@DriftAccessor(tables: [TodoTable])
class TodoDao extends DatabaseAccessor<DbClient> with _$TodoDaoMixin {
  // this constructor is required so that the main database can create an instance
  // of this object.
  TodoDao(super.db);

  Future<TodoEntry> insertTodo(TodoTableCompanion companion) async {
    return into(todoTable).insertReturning(companion);
  }

  Future<int> updateTodo(TodoId id, TodoTableCompanion companion) async {
    return (update(
      todoTable,
    )..where((t) => t.id.equals(id) & t.userId.equalsNullable(companion.userId.value))).write(companion);
  }

  Future<int> deleteTodoById(TodoId id, String userId) async {
    return (delete(todoTable)..where((t) => t.id.equals(id) & t.userId.equals(userId))).go();
  }

  Future<List<TodoEntry>> getAllTodo(String userId) async {
    return (select(todoTable)
          ..where((t) => t.userId.equals(userId))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  Future<TodoEntry> getTodoById(TodoId id, String userId) async {
    try {
      final result = await (select(todoTable)..where((t) => t.id.equals(id) & t.userId.equals(userId))).getSingle();
      return result;
    } catch (e) {
      throw ApiException.notFound(message: 'Todo not found');
    }
  }
}
