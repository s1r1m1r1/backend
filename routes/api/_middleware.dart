import 'package:backend/features/auth/application/check_session.dart';
import 'package:backend/features/auth/domain/session.dart';
import 'package:backend/models/user.dart';
import 'package:dart_frog/dart_frog.dart';

Handler middleware(Handler handler) {
  return (context) async {
    final userRecordFuture = checkSession(context);

    return handler
        .use(provider<Future<UserRecord>>((_) => userRecordFuture))
        // Also provide User and Session directly for convenience
        .use(provider<Future<User>>((_) async => (await userRecordFuture).user))
        .use(
          provider<Future<Session>>(
            (_) async => (await userRecordFuture).session,
          ),
        )(context);
  };
}
