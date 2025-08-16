import 'dart:async';

import 'package:backend/core/new_api_exceptions.dart';
import 'package:backend/models/user.dart';
import 'package:backend/user/hash_extension.dart';
import 'package:backend/user/session_datasource.dart';

import 'package:backend/user/session.dart';
import 'package:injectable/injectable.dart';

abstract class SessionRepository {
  Future<Session> createSession(User user);
  Future<Session> updateSession(Session session);

  Future<Session?> getSession({String? token, String? refreshToken, int? userId});

  bool validateToken(Session session);
  bool validateRefreshToken(Session session);

  FutureOr<void> deleteSession(int userId);
}

@LazySingleton(as: SessionRepository)
class SessionRepositoryImpl implements SessionRepository {
  /// {@macro session_repository}
  ///
  /// The [now] function is used to get the current date and time.
  const SessionRepositoryImpl(this.sessionDatasource) : _now = DateTime.now;

  final DateTime Function() _now;
  final SessionDatasource sessionDatasource;

  /// Creates a new session for the user with the given [userId].
  Future<Session> createSession(User user) async {
    final now = _now();
    final token = '${user.userId}_${now.toIso8601String()}'.hashValue;
    final refreshToken = '${user.userId}_refresh_${now.toIso8601String()}'.hashValue;
    final session = Session(
      token: token,
      user: user,
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
  @override
  Future<Session?> getSession({String? token, String? refreshToken, int? userId}) async {
    final session = await sessionDatasource.getSession(
      refreshToken: refreshToken,
      token: token,
      userId: userId,
    );
    return session;
  }

  @override
  FutureOr<void> deleteSession(int userId) {
    sessionDatasource.deleteSession(userId);
  }

  @override
  Future<Session> updateSession(Session session) async {
    final now = _now();
    final token = '${session.user.userId}_${now.toIso8601String()}'.hashValue;
    final refreshToken = '${session.user.userId}_refresh_${now.toIso8601String()}'.hashValue;
    final updated = session.copyWith(
      token: token,
      tokenExpiryDate: now.add(const Duration(minutes: 10)), // access token expiry
      refreshToken: refreshToken,
      refreshTokenExpiry: now.add(const Duration(minutes: 120)), // refresh token expiry
    );
    final isOk = await sessionDatasource.insertSession(updated);
    if (isOk) return updated;
    throw ApiException.internalServerError();
  }

  @override
  bool validateToken(Session session) {
    return session.tokenExpiryDate.isAfter(_now());
  }

  @override
  bool validateRefreshToken(Session session) {
    return session.refreshTokenExpiry.isAfter(_now());
  }
}
