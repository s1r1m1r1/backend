import 'package:backend/db_client/db_client.dart';
import 'package:backend/services/jwt_service.dart';
import 'package:backend/services/password_hash_service.dart';
import 'package:backend/session/session_datasource.dart';
import 'package:backend/session/session_repository.dart';
import 'package:backend/user/controller/user_controller.dart';
import 'package:backend/user/datasource/user_datasource.dart';
import 'package:backend/user/repository/user_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dotenv/dotenv.dart';

final env = DotEnv()..load();
final _db = DbClient(DbClient.openConnection());
final _userDatasource = UserDataSourceImpl(_db.userDao);
const _passwordHasher = PasswordHasherService();
final _userRepo = UserRepositoryImpl(_userDatasource, _passwordHasher);
final _jwtService = JWTService(env);
final _userController = UserController(_userRepo, _jwtService);
final _sessionRepository = SessionRepositoryImpl(sessionDatasource: SessionSqliteDatasourceImpl(_db.sessionDao));

Handler middleware(Handler handler) {
  return handler
      .use(requestLogger())
      .use(provider<JWTService>((_) => _jwtService))
      .use(provider<DbClient>((_) => _db))
      .use(provider<UserRepository>((_) => _userRepo))
      .use(provider<UserController>((_) => _userController))
      .use(provider<SessionRepository>((_) => _sessionRepository))
      .use(provider<PasswordHasherService>((_) => _passwordHasher));
}
