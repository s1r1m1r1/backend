import 'dart:async';

import '../../core/debug_log.dart';
import '../db_client.dart';
import 'package:drift/drift.dart';

import '../../core/log_colors.dart';
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

  FutureOr<SessionEntry?> getSession({
    String? token,
    String? refreshToken,
    int? userId,
  }) async {
    debugLog(
      '$red getSession: token: ${token ?? 'null'} , refreshToken: ${refreshToken ?? null}, userId: ${userId ?? null}  $reset',
    );
    final query = select(sessionTable);
    if (token != null)
      query.where((t) => t.token.equals(token));
    else if (refreshToken != null)
      query.where((t) => t.refreshToken.equals(refreshToken));
    else if (userId != null)
      query.where((t) => t.userId.equals(userId));
    return query.getSingleOrNull();
  }

  void softDeleteSessionByUserId(int userId) {
    (update(sessionTable)..where((t) => t.userId.equals(userId))).write(
      SessionTableCompanion(deletedAt: Value(DateTime.now())),
    );
  }
}
