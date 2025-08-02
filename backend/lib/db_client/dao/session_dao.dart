import 'dart:async';

import 'package:backend/db_client/db_client.dart';
import 'package:drift/drift.dart';

import '../tables/session_table.dart';

part 'session_dao.g.dart';

@DriftAccessor(tables: [SessionTable])
class SessionDao extends DatabaseAccessor<DbClient> with _$SessionDaoMixin {
  // this constructor is required so that the main database can create an instance
  // of this object.
  SessionDao(super.db);

  Future<int> insertRow(SessionTableCompanion toCompanion) {
    return into(sessionTable).insert(toCompanion);
  }

  Future<int> updateRow(SessionTableCompanion toCompanion) {
    return into(sessionTable).insert(toCompanion, mode: InsertMode.replace);
  }

  FutureOr<SessionEntry?> getSession({String? token, String? refreshToken, int? userId}) async {
    if (token == null && refreshToken == null && userId == null) {
      return null;
    }
    final query = select(sessionTable);
    if (token != null) query.where((t) => t.token.equals(token));
    if (refreshToken != null) query.where((t) => t.refreshToken.equals(refreshToken));
    if (userId != null) query.where((t) => t.userId.equals(userId));
    return query.getSingleOrNull();
  }

  void softDeleteSessionByUserId(int userId) {
    (update(
      sessionTable,
    )..where((t) => t.userId.equals(userId))).write(SessionTableCompanion(deletedAt: Value(DateTime.now())));
  }
}
