import '../../lib/db_client/db_client.dart';
import '../../lib/middlewares/session_middleware_.dart';
import '../../lib/models/user.dart';
import '../../lib/todo/todo_datasource.dart';
import '../../lib/todo/todo_repository.dart';
import 'package:dart_frog/dart_frog.dart';

Handler middleware(Handler handler) {
  return sessionMiddleware(handler, addToContext: [_providerTodo]);
}

RequestContext _providerTodo(RequestContext context) {
  final db = context.read<DbClient>();
  final todoDao = db.todoDao;
  final todoDs = TodoDataSourceImpl(todoDao);
  final user = context.read<User>();
  final todoRepo = TodoRepositoryImpl(todoDs, user);
  var updatedContext = context.provide<TodoRepository>(() => todoRepo);
  updatedContext = updatedContext.provide<TodoDataSource>(() => todoDs);
  return updatedContext;
}
