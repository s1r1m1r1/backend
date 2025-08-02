import 'package:backend/chat/counter_repository.dart';
import 'package:backend/chat/letters_repository.dart';
import 'package:backend/db_client/db_client.dart';
import 'package:backend/services/jwt_service.dart';
import 'package:backend/user/password_hash_service.dart';
import 'package:backend/session/session_datasource.dart';
import 'package:backend/session/session_repository.dart';
import 'package:backend/user/user_datasource.dart';
import 'package:backend/user/user_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dotenv/dotenv.dart';
import 'package:drift/native.dart';

final env = DotEnv()..load();

/// final _db = DbClient(DbClient.openConnection());
final _db = DbClient(NativeDatabase.memory());
final _userDatasource = UserDataSourceImpl(_db.userDao);
const _passwordHasher = PasswordHasherService();
final _userRepo = UserRepositoryImpl(_userDatasource, _passwordHasher);
final _jwtService = JWTService(env);
final _sessionRepository = SessionRepositoryImpl(sessionDatasource: SessionSqliteDatasourceImpl(_db.sessionDao));
final _messageRepository = LettersRepository(_db.lettersDao);
final _counterRepository = CounterRepository();
Handler middleware(Handler handler) {
  return handler
      .use(requestLogger())
      .use(provider<JWTService>((_) => _jwtService))
      .use(provider<DbClient>((_) => _db))
      .use(provider<UserRepository>((_) => _userRepo))
      .use(provider<SessionRepository>((_) => _sessionRepository))
      .use(provider<LettersRepository>((_) => _messageRepository))
      .use(provider<CounterRepository>((_) => _counterRepository))
      .use(provider<PasswordHasherService>((_) => _passwordHasher));
}
