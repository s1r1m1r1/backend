import 'package:backend/db_client/db_client.dart';
import 'package:backend/db_client/tables/channel_table.dart';
import 'package:backend/db_client/tables/todo_table.dart';
import 'package:drift/drift.dart';
import '../../exceptions/not_found_exceptions.dart';
import '../../utils/typedefs.dart';

part 'todo_dao.g.dart';

@DriftAccessor(tables: [TodoTable])
class TodoDao extends DatabaseAccessor<DbClient> with _$TodoDaoMixin {
  // this constructor is required so that the main database can create an instance
  // of this object.
  TodoDao(super.db);

  insert() {}

  Future<TodoEntry> insertTodo(TodoTableCompanion companion) async {
    return into(todoTable).insertReturning(
      companion,
    );
  }

  Future<int> updateTodo(TodoId id, TodoTableCompanion companion) async {
    return (update(todoTable)..where((t) => t.id.equals(id))).write(
      companion,
    );
  }

  Future<int> deleteTodoById(TodoId id) async {
    return (delete(todoTable)..where((t) => t.id.equals(id))).go();
  }

  Future<List<TodoEntry>> getAllTodo() async {
    return (select(todoTable)..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).get();
  }

  Future<TodoEntry> getTodoById(TodoId id) async {
    try {
      final result = await (select(todoTable)..where((t) => t.id.equals(id))).getSingle();
      return result;
    } catch (e) {
      throw NotFoundException('Todo not found');
    }
  }
}
