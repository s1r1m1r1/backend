import 'dart:async';

import 'package:dto/dto.dart';
import 'package:injectable/injectable.dart';

import '../../../core/app_config.dart';
import '../../../core/debug_log.dart';
import '../../../db_client/db_client.dart';
import '../../../models/user.dart';
import '../application/hash_extension.dart';
import '../domain/session.dart';
import '../domain/session_repository.dart';

@LazySingleton(as: SessionRepository)
class SessionRepositoryImpl implements SessionRepository {
  const SessionRepositoryImpl(this._db) : _now = DateTime.now;

  final DateTime Function() _now;
  final DbClient _db;

  @override
  Future<Session> createSession(User user) async {
    debugLog('CREATE Session');
    final now = _now();
    final token = '${user.userId}_${now.toIso8601String()}'.hashValue;
    final refreshToken =
        '${user.userId}_refresh_${now.toIso8601String()}'.hashValue;
    final session = Session(
      token: token,
      user: user,
      tokenExpiryDate: now.add(AppConfig.tokenExpiry),
      createdAt: now,
      refreshToken: refreshToken,
      refreshTokenExpiry: now.add(AppConfig.refreshTokenExpiry),
    );
    await _db.sessionDao.insertSession(session);
    return session;
  }

  @override
  Future<Session?> getSession({
    String? token,
    String? refreshToken,
    UserId? userId,
  }) async {
    final session = await _db.sessionDao.getSessionWithUser(
      token: token,
      refreshToken: refreshToken,
      userId: userId,
    );
    return session;
  }

  @override
  Future<void> deleteSession(UserId userId) async {
    await _db.sessionDao.softDeleteSessionByUserId(userId);
  }

  @override
  Future<Session> updateSession(Session session) async {
    debugLog('UPDATE Session');
    final now = _now();
    final token = '${session.user.userId}_${now.toIso8601String()}'.hashValue;
    final refreshToken =
        '${session.user.userId}_refresh_${now.toIso8601String()}'.hashValue;
    final updated = session.copyWith(
      token: token,
      tokenExpiryDate: now.add(AppConfig.tokenExpiry),
      refreshToken: refreshToken,
      refreshTokenExpiry: now.add(AppConfig.refreshTokenExpiry),
    );
    await _db.sessionDao.updateSession(updated);
    return updated;
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
