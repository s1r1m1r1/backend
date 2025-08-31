import 'dart:async';

import 'package:backend/core/debug_log.dart';
import 'package:backend/core/log_colors.dart';
import 'package:backend/db_client/db_client.dart';
import 'package:backend/models/user.dart';
import 'package:backend/modules/auth/session.dart';
import 'package:drift/drift.dart' show Value;

import 'package:backend/db_client/dao/session_dao.dart';
import 'package:injectable/injectable.dart';

//--------------------------------------------------------------
abstract class SessionDatasource {
  FutureOr<Session?> getSession({
    String? token,
    String? refreshToken,
    int? userId,
  });
  FutureOr<bool> insertSession(Session session);
  FutureOr<bool> updateSession(Session session);
  FutureOr<bool> deleteSession(int userId);
}

//--------------------------------------------------------------

@LazySingleton(as: SessionDatasource)
class SessionSqliteDatasourceImpl implements SessionDatasource {
  SessionSqliteDatasourceImpl(this._db);
  final DbClient _db;
  SessionDao get _dao => _db.sessionDao;

  @override
  FutureOr<bool> insertSession(Session session) async {
    await _dao.insertRow(
      SessionTableCompanion(
        token: Value(session.token),
        userId: Value(session.user.userId),
        expiryDate: Value(session.tokenExpiryDate),
        createdAt: Value(session.createdAt),
        refreshToken: Value(session.refreshToken),
        refreshTokenExpiry: Value(session.refreshTokenExpiry),
      ),
    );
    return true;
  }

  @override
  FutureOr<bool> updateSession(Session session) async {
    if (session.id == null) return false;
    await _dao.updateRow(
      SessionTableCompanion(
        id: Value(session.id!),
        token: Value(session.token),
        userId: Value(session.user.userId),
        expiryDate: Value(session.tokenExpiryDate),
        createdAt: Value(session.createdAt),
        refreshToken: Value(session.refreshToken),
        refreshTokenExpiry: Value(session.refreshTokenExpiry),
      ),
    );
    return true;
  }

  @override
  FutureOr<bool> deleteSession(int userId) {
    _dao.softDeleteSessionByUserId(userId);
    return true;
  }

  @override
  FutureOr<Session?> getSession({
    String? token,
    String? refreshToken,
    int? userId,
  }) async {
    debugLog(
      '$magenta fetch getSession:$reset t: $token, r: $refreshToken, u: $userId ',
    );
    if (token == null && refreshToken == null && userId == null) {
      return null;
    }
    final entry = await _dao.getSession(
      refreshToken: refreshToken,
      token: token,
      userId: userId,
    );

    debugLog('$green getSession $reset  $entry ');

    if (entry == null) {
      return null;
    }
    final user = await _db.userDao.getUser(userId: entry.userId);
    if (user == null) {
      debugLog('$red getSession user not found $reset');
      return null;
    }

    return Session(
      id: entry.id,
      createdAt: entry.createdAt,
      token: entry.token,
      user: User(
        userId: user.id,
        email: user.email,
        role: user.role,
        createdAt: user.createdAt,
      ),
      tokenExpiryDate: entry.expiryDate,
      refreshToken: entry.refreshToken,
      refreshTokenExpiry: entry.refreshTokenExpiry,
    );
  }
}
//--------------------------------------------------------------