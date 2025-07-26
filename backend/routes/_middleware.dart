import 'package:backend/db_client/dao/todo_dao.dart';
import 'package:backend/db_client/db_client.dart';
import 'package:backend/services/jwt_service.dart';
import 'package:backend/services/password_hash_service.dart';
import 'package:backend/todo/controller/todo_controller.dart';
import 'package:backend/todo/datasource/todo_datasource.dart';
import 'package:backend/todo/repository/todo_repository.dart';
import 'package:backend/user/controller/user_controller.dart';
import 'package:backend/user/datasource/user_datasource.dart';
import 'package:backend/user/repository/user_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dotenv/dotenv.dart';

final env = DotEnv()..load();
// final _ds = TodoDataSourceImpl(DbClient.instance.todoDao);
// final _repo = TodoRepositoryImpl(_ds);
// final _todoController = TodoController(_repo);
final _userDs = UserDataSourceImpl(DbClient.instance.userDao);
const _passwordHasher = PasswordHasherService();
final _userRepo = UserRepositoryImpl(_userDs, _passwordHasher);
final _jwtService = JWTService(env);
final _userController = UserController(_userRepo, _jwtService);

// Handler middleware(Handler handler) {
//   final _db = DbClient.instance;
//   return handler
//       .use(requestLogger())
//       .use(provider<TodoDao>((_) => _db.todoDao))
//       .use(provider<TodoDataSource>((context) => TodoDataSourceImpl(context.read<TodoDao>())))
//       .use(provider<TodoRepository>((context) => TodoRepositoryImpl(context.read<TodoDataSource>())))
//       .use(provider<TodoController>((context) => TodoController(context.read<TodoRepository>())));
// }

// Handler middleware(Handler handler) {
//   final _db = DbClient.instance;
//   return handler
//       .use(requestLogger())
//       .use(provider<TodoDao>((_) => _db.todoDao))
//       .use(provider<TodoDataSource>((_) => _ds))
//       .use(provider<TodoRepository>((_) => _repo))
//       .use(provider<TodoController>((_) => _todoController));
// }
Handler middleware(Handler handler) {
  return handler
      .use(requestLogger())
      .use(provider<JWTService>((_) => _jwtService))
      .use(provider<UserDataSource>((_) => _userDs))
      .use(provider<UserRepository>((_) => _userRepo))
      .use(provider<UserController>((_) => _userController))
      .use(provider<PasswordHasherService>((_) => _passwordHasher));
}
