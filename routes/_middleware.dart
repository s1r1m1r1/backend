import 'package:backend/game/unit_datasource.dart';
import 'package:backend/game/unit_repository.dart';
import 'package:backend/ws_/chat_room_repository.dart';

import 'package:backend/ws_/counter_repository.dart';
import 'package:backend/ws_/logic/letter.bloc_manager.dart';
import 'package:backend/ws_/letters_repository.dart';
import 'package:backend/db_client/db_client.dart';
import 'package:backend/user/session_repository.dart';
import 'package:backend/user/user_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:get_it/get_it.dart';
// import 'package:drift/native.dart';

final _db = GetIt.I.get<DbClient>();
final _userRepo = GetIt.I.get<UserRepository>();
final _sessionRepository = GetIt.I.get<SessionRepository>();
final _letterRepository = GetIt.I.get<LettersRepository>();
final _counterRepository = CounterRepository();
final _chatRoomRepository = ChatRoomRepository(_db);

final _roomManager = GetIt.I.get<LetterBlocManager>()..createRoom('main');

final _unitRepository = UnitRepositoryImpl(UnitDatasourceImpl(_db));

Handler middleware(Handler handler) {
  return handler
      .use(requestLogger())
      .use(provider<DbClient>((_) => _db))
      .use(provider<UserRepository>((_) => _userRepo))
      .use(provider<SessionRepository>((_) => _sessionRepository))
      .use(provider<LettersRepository>((_) => _letterRepository))
      .use(provider<CounterRepository>((_) => _counterRepository))
      .use(provider<ChatRoomRepository>((_) => _chatRoomRepository))
      .use(provider<LetterBlocManager>((_) => _roomManager))
      .use(provider<UnitRepository>((_) => _unitRepository));

  // return handler(updatedContext);
}
