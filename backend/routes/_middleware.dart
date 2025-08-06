import 'package:backend/web_socket/counter_repository.dart';
import 'package:backend/web_socket/letters_repository.dart';
import 'package:backend/config/ws_config_repository.dart';
import 'package:backend/db_client/db_client.dart';
import 'package:backend/inject/inject.dart';
import 'package:backend/user/password_hash_service.dart';
import 'package:backend/session/session_datasource.dart';
import 'package:backend/session/session_repository.dart';
import 'package:backend/user/user_datasource.dart';
import 'package:backend/user/user_repository.dart';
import 'package:dart_frog/dart_frog.dart';
// import 'package:drift/native.dart';

final _db = getIt<DbClient>();
// final _db = DbClient(NativeDatabase.memory());
final _userDatasource = UserDataSourceImpl(_db.userDao);
const _passwordHasher = PasswordHasherService();
final _userRepo = UserRepositoryImpl(_userDatasource, _passwordHasher);
final _sessionRepository = SessionRepositoryImpl(sessionDatasource: SessionSqliteDatasourceImpl(_db.sessionDao));
final _messageRepository = LettersRepository(_db.lettersDao);

Handler middleware(Handler handler) {
  return handler
      .use(requestLogger())
      .use(provider<DbClient>((_) => _db))
      .use(provider<UserRepository>((_) => _userRepo))
      .use(provider<SessionRepository>((_) => _sessionRepository))
      .use(provider<LettersRepository>((_) => _messageRepository))
      .use(provider<CounterRepository>((_) => getIt<CounterRepository>()))
      .use(provider<PasswordHasherService>((_) => _passwordHasher))
      .use(provider<WsConfigRepository>((_) => getIt<WsConfigRepository>()));
}
