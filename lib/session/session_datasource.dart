import 'dart:async';

import 'package:backend/core/debug_log.dart';
import 'package:backend/core/log_colors.dart';
import 'package:backend/db_client/db_client.dart';
import 'package:backend/session/session.dart';
import 'package:drift/drift.dart' show Value;

import 'package:backend/db_client/dao/session_dao.dart';

//--------------------------------------------------------------
abstract class SessionDatasource {
  FutureOr<Session?> getSession({String? token, String? refreshToken, int? userId});
  FutureOr<bool> insertSession(Session session);
  FutureOr<bool> updateSession(Session session);
  FutureOr<bool> deleteSession(int userId);
}

//--------------------------------------------------------------
class SessionSqliteDatasourceImpl implements SessionDatasource {
  SessionSqliteDatasourceImpl(this._db);
  final DbClient _db;
  SessionDao get _dao => _db.sessionDao;

  @override
  FutureOr<bool> insertSession(Session session) async {
    await _dao.insertRow(
      SessionTableCompanion(
        token: Value(session.token),
        userId: Value(session.userId),
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
    await _dao.insertRow(
      SessionTableCompanion(
        id: Value(session.id!),
        token: Value(session.token),
        userId: Value(session.userId),
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
  FutureOr<Session?> getSession({String? token, String? refreshToken, int? userId}) async {
    final entry = await _dao.getSession(refreshToken: refreshToken, token: token, userId: userId);
    if (entry == null) {
      debugLog('$red getSession: entry is null $reset');
      return null;
    }
    ;
    return Session(
      createdAt: entry.createdAt,
      token: entry.token,
      userId: entry.userId,
      tokenExpiryDate: entry.expiryDate,
      refreshToken: entry.refreshToken,
      refreshTokenExpiry: entry.refreshTokenExpiry,
    );
  }
}
//--------------------------------------------------------------