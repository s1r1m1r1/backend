import 'dart:async';

import 'package:drift/drift.dart';

import '../../features/auth/domain/session.dart';
import '../../models/user.dart';
import '../db_client.dart';
import '../tables/session_table.dart';

part 'session_dao.g.dart';

@DriftAccessor(tables: [SessionTable])
class SessionDao extends DatabaseAccessor<DbClient> with _$SessionDaoMixin {
  // this constructor is required so that the main database can create an instance
  // of this object.
  SessionDao(super.db);

  //------------------------------------------------------------------------------- --
  // Mapping methods
  //------------------------------------------------------------------------------- --

  Session _toSession(SessionEntry sessionEntry, User user) {
    return Session(
      id: sessionEntry.id,
      createdAt: sessionEntry.createdAt,
      token: sessionEntry.token,
      user: user,
      tokenExpiryDate: sessionEntry.expiryDate,
      refreshToken: sessionEntry.refreshToken,
      refreshTokenExpiry: sessionEntry.refreshTokenExpiry,
    );
  }

  //------------------------------------------------------------------------------- --
  // CRUD operations
  //------------------------------------------------------------------------------- --

  Future<int> insertSession(Session session) {
    return into(sessionTable).insert(
      SessionTableCompanion(
        token: Value(session.token),
        userId: Value(session.user.userId.id),
        expiryDate: Value(session.tokenExpiryDate),
        createdAt: Value(session.createdAt),
        refreshToken: Value(session.refreshToken),
        refreshTokenExpiry: Value(session.refreshTokenExpiry),
      ),
    );
  }

  Future<int> updateSession(Session session) {
    if (session.id == null) {
      throw ArgumentError('Session id cannot be null for update');
    }
    return into(sessionTable).insert(
      SessionTableCompanion(
        id: Value(session.id!),
        token: Value(session.token),
        userId: Value(session.user.userId.id),
        expiryDate: Value(session.tokenExpiryDate),
        createdAt: Value(session.createdAt),
        refreshToken: Value(session.refreshToken),
        refreshTokenExpiry: Value(session.refreshTokenExpiry),
      ),
      mode: InsertMode.replace,
    );
  }

  Future<Session?> getSessionWithUser({
    String? token,
    String? refreshToken,
    String? userId,
  }) async {
    if (token == null && refreshToken == null && userId == null) {
      return null;
    }

    final query = select(sessionTable);
    if (token != null) {
      query.where((t) => t.token.equals(token));
    } else if (refreshToken != null) {
      query.where((t) => t.refreshToken.equals(refreshToken));
    } else if (userId != null) {
      query.where((t) => t.userId.equals(userId));
    }

    final sessionEntry = await query.getSingleOrNull();
    if (sessionEntry == null) {
      return null;
    }

    // Join with user table
    final userEntry = await db.userDao.getUser(userId: sessionEntry.userId);
    if (userEntry == null) {
      return null;
    }

    return _toSession(sessionEntry, userEntry);
  }

  Future<void> softDeleteSessionByUserId(String userId) async {
    await (update(sessionTable)..where((t) => t.userId.equals(userId))).write(
      SessionTableCompanion(deletedAt: Value(DateTime.now())),
    );
  }
}
