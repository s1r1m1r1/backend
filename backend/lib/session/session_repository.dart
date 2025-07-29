import 'package:backend/exceptions/new_api_exceptions.dart';
import 'package:backend/session/hash_extension.dart';
import 'package:backend/session/session_datasource.dart';

import 'session.dart';

abstract class SessionRepository {
  Future<Session> createSession(String userId);
  Future<Session?> sessionFromToken(String token);
}

class SessionRepositoryImpl implements SessionRepository {
  /// {@macro session_repository}
  ///
  /// The [now] function is used to get the current date and time.
  const SessionRepositoryImpl({DateTime Function()? now, required this.sessionDatasource}) : _now = now ?? DateTime.now;

  final DateTime Function() _now;
  final SessionDatasource sessionDatasource;

  /// Creates a new session for the user with the given [userId].
  Future<Session> createSession(String userId) async {
    final now = _now();
    final session = Session(
      token: '${userId}_${now.toIso8601String()}'.hashValue,
      userId: userId,
      expiryDate: now.add(const Duration(days: 1)),
      createdAt: now,
    );
    final isOk = await sessionDatasource.saveSession(session);
    if (isOk) return session;
    throw ApiException.internalServerError();
  }

  /// Searches and return a session by its [token].
  ///
  /// If the session is not found or is expired, returns `null`.
  Future<Session?> sessionFromToken(String token) async {
    final session = await sessionDatasource.sessionFromToken(token);

    if (session != null && session.expiryDate.isAfter(_now())) {
      return session;
    } else if (session != null) {
      await sessionDatasource.deleteSession(session);
    }

    return null;
  }
}
