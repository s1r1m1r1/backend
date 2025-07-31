import 'dart:async';
import 'dart:io';

import 'package:backend/exceptions/new_api_exceptions.dart';
import 'package:backend/session/hash_extension.dart';
import 'package:backend/session/session_datasource.dart';

import '../other/log_colors.dart';
import 'session.dart';

abstract class SessionRepository {
  Future<Session> createSession(String userId);
  Future<Session> updateSession(Session session);

  Future<Session?> getSessionByToken(String token);
  Future<Session?> getSessionByRefreshToken(String token);

  FutureOr<void> deleteSession(String userId);
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
    final token = '${userId}_${now.toIso8601String()}'.hashValue;
    final refreshToken = '${userId}_refresh_${now.toIso8601String()}'.hashValue;
    final session = Session(
      token: token,
      userId: userId,
      tokenExpiryDate: now.add(const Duration(seconds: 10)), // access token expiry
      createdAt: now,
      refreshToken: refreshToken,
      refreshTokenExpiry: now.add(const Duration(seconds: 1000)), // refresh token expiry
    );
    final isOk = await sessionDatasource.insertSession(session);
    if (isOk) return session;
    throw ApiException.internalServerError();
  }

  /// Searches and return a session by its [token].
  ///
  /// If the session is not found or is expired, returns `null`.
  Future<Session?> getSessionByToken(String token) async {
    final session = await sessionDatasource.sessionFromToken(token);

    if (session != null && session.tokenExpiryDate.isAfter(_now())) {
      return session;
    }

    return null;
  }

  /// Searches and return a session by its [token].
  ///
  /// If the session is not found or is expired, returns `null`.
  @override
  Future<Session?> getSessionByRefreshToken(String token) async {
    stdout.writeln('$green getSessionByRefreshToken $reset $token');
    final session = await sessionDatasource.sessionFromRefreshToken(token);

    if (session != null && session.refreshTokenExpiry.isAfter(_now())) {
      return session;
    } else if (session != null) {
      await sessionDatasource.deleteSession(session.userId);
    }

    return null;
  }

  @override
  FutureOr<void> deleteSession(String userId) {
    sessionDatasource.deleteSession(userId);
  }

  @override
  Future<Session> updateSession(Session session) async {
    final now = _now();
    final token = '${session.userId}_${now.toIso8601String()}'.hashValue;
    final refreshToken = '${session.userId}_refresh_${now.toIso8601String()}'.hashValue;
    final updated = session.copyWith(
      token: token,
      tokenExpiryDate: now.add(const Duration(seconds: 10)), // access token expiry
      refreshToken: refreshToken,
      refreshTokenExpiry: now.add(const Duration(seconds: 1000)), // refresh token expiry
    );
    final isOk = await sessionDatasource.insertSession(updated);
    if (isOk) return updated;
    throw ApiException.internalServerError();
  }
}
