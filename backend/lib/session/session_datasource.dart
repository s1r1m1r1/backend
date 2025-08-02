import 'dart:async';

import 'package:backend/db_client/db_client.dart';
import 'package:backend/session/session.dart';
import 'package:drift/drift.dart' show Value;

import '../db_client/dao/session_dao.dart';

//--------------------------------------------------------------
abstract class SessionDatasource {
  FutureOr<Session?> sessionFromToken(String token);
  FutureOr<Session?> sessionFromRefreshToken(String token);
  FutureOr<bool> insertSession(Session session);
  FutureOr<bool> updateSession(Session session);
  FutureOr<bool> deleteSession(int userId);
}

//--------------------------------------------------------------
class SessionSqliteDatasourceImpl implements SessionDatasource {
  SessionSqliteDatasourceImpl(this._dao);
  final SessionDao _dao;

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
  FutureOr<Session?> sessionFromToken(String token) async {
    try {
      final entry = await _dao.getSessionFromToken(token);
      return Session(
        createdAt: entry.createdAt,
        token: entry.token,
        userId: entry.userId,
        tokenExpiryDate: entry.expiryDate,
        refreshToken: entry.refreshToken,
        refreshTokenExpiry: entry.refreshTokenExpiry,
      );
    } catch (_) {
      return null;
    }
  }

  @override
  FutureOr<bool> deleteSession(int userId) {
    _dao.softDeleteSessionByUserId(userId);
    return true;
  }

  @override
  FutureOr<Session?> sessionFromRefreshToken(String token) async {
    final entry = await _dao.getSessionFromRefreshToken(token);
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