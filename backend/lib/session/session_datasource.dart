import 'dart:async';

import 'package:backend/db_client/db_client.dart';
import 'package:backend/session/session.dart';
import 'package:drift/drift.dart' show Value;

import '../db_client/dao/session_dao.dart';

//--------------------------------------------------------------
abstract class SessionDatasource {
  FutureOr<Session?> sessionFromToken(String token);
  FutureOr<bool> saveSession(Session session);
  FutureOr<bool> deleteSession(Session session);
}

//--------------------------------------------------------------
class SessionMemoryDatasource implements SessionDatasource {
  SessionMemoryDatasource();
  final Map<String, Session> sessionDb = {};

  @override
  FutureOr<bool> saveSession(Session session) {
    sessionDb[session.token] = session;
    return true;
  }

  @override
  FutureOr<Session?> sessionFromToken(String token) {
    final s = sessionDb[token];
    return s;
  }

  @override
  FutureOr<bool> deleteSession(Session session) {
    sessionDb.remove(session.token);
    return true;
  }
}

//--------------------------------------------------------------
class SessionSqliteDatasourceImpl implements SessionDatasource {
  SessionSqliteDatasourceImpl(this._dao);
  final SessionDao _dao;

  @override
  FutureOr<bool> saveSession(Session session) async {
    await _dao.insertRow(
      SessionTableCompanion(
        token: Value(session.token),
        userId: Value(session.userId),
        expiryDate: Value(session.expiryDate),
        createdAt: Value(session.createdAt),
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
        expiryDate: entry.expiryDate,
      );
    } catch (_) {
      return null;
    }
  }

  @override
  FutureOr<bool> deleteSession(Session session) {
    _dao.softDeleteSessionByToken(session.token);
    return true;
  }
}
//--------------------------------------------------------------