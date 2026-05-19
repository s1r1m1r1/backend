import 'package:dto/dto.dart';

import '../../../models/user.dart';
import 'session.dart';

abstract class SessionRepository {
  Future<Session> createSession(User user);
  Future<Session> updateSession(Session session);

  Future<Session?> getSession({
    String? token,
    String? refreshToken,
    UserId? userId,
  });

  bool validateToken(Session session);
  bool validateRefreshToken(Session session);

  Future<void> deleteSession(UserId userId);
}
