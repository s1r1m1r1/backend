import 'package:backend/session/session_datasource.dart';
import 'package:backend/session/session_repository.dart';
// import 'package:backend/user2/session_repository.dart';
import 'package:backend/user2/user_repository2.dart';
import 'package:dart_frog/dart_frog.dart';

Handler middleware(Handler handler) {
  final userRepository = UserRepository2();
  final sessionRepository = SessionRepositoryImpl(sessionDatasource: SessionMemoryDatasource());

  return handler
      .use(requestLogger())
      .use(provider<UserRepository2>((_) => userRepository))
      .use(provider<SessionRepository>((_) => sessionRepository));
}
