import 'package:backend/cf/autostart_manager.dart';
import 'package:backend/cf/ws_config_datasource.dart';
import 'package:backend/game/unit_datasource.dart';
import 'package:backend/game/unit_repository.dart';
import 'package:backend/user/session_datasource.dart';
import 'package:backend/user/password_hash_service.dart';
import 'package:backend/user/user_datasource.dart';
import 'package:backend/ws_/chat_room_repository.dart';

import 'package:backend/ws_/counter_repository.dart';
import 'package:backend/ws_/letters_repository.dart';
import 'package:backend/cf/ws_config_repository.dart';
import 'package:backend/db_client/db_client.dart';
import 'package:backend/user/session_repository.dart';
import 'package:backend/user/user_repository.dart';
import 'package:dart_frog/dart_frog.dart';
// import 'package:drift/native.dart';

final _db = DbClient(DbClient.openConnection());
final _userRepo = UserRepositoryImpl(UserDataSourceImpl(_db), PasswordHasherService());
final _sessionRepository = SessionRepositoryImpl(SessionSqliteDatasourceImpl(_db));
final _messageRepository = LettersRepository(_db.lettersDao);
final _counterRepository = CounterRepository();
final _wsConfigRepository = WsConfigRepositoryImpl(WsConfigDatasourceImpl(_db));
final _chatRoomRepository = ChatRoomRepository(_db);
final _autostartManager = AutostartManager(
  _wsConfigRepository,
  _counterRepository,
  _chatRoomRepository,
);

final _unitRepository = UnitRepositoryImpl(UnitDatasourceImpl(_db));

Handler middleware(Handler handler) {
  return handler
      .use(requestLogger())
      .use(provider<DbClient>((_) => _db))
      .use(provider<UserRepository>((_) => _userRepo))
      .use(provider<SessionRepository>((_) => _sessionRepository))
      .use(provider<LettersRepository>((_) => _messageRepository))
      .use(provider<CounterRepository>((_) => _counterRepository))
      .use(provider<WsConfigRepository>((_) => _wsConfigRepository))
      .use(provider<ChatRoomRepository>((_) => _chatRoomRepository))
      .use(provider<UnitRepository>((_) => _unitRepository))
      .use(provider<AutostartManager>((_) => _autostartManager));

  // return handler(updatedContext);
}
