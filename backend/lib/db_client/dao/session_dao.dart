import 'package:backend/db_client/db_client.dart';
import 'package:drift/drift.dart';

import '../tables/session_table.dart';

part 'session_dao.g.dart';

@DriftAccessor(tables: [SessionTable])
class SessionDao extends DatabaseAccessor<DbClient> with _$SessionDaoMixin {
  // this constructor is required so that the main database can create an instance
  // of this object.
  SessionDao(super.db);

  Future<SessionEntry> getByUserId(String userId) async {
    final result = await (select(sessionTable)..where((t) => t.userId.equals(userId))).getSingle();
    return result;
  }

  Future<int> insertRow(SessionTableCompanion toCompanion) {
    return into(sessionTable).insert(toCompanion);
  }

  Future<int> updateRow(SessionTableCompanion toCompanion) {
    return into(sessionTable).insert(toCompanion, mode: InsertMode.replace);
  }

  Future<SessionEntry> getSessionFromToken(String token) async {
    final result = await (select(sessionTable)..where((t) => t.token.equals(token))).getSingle();
    return result;
  }

  Future<SessionEntry> getSessionFromRefreshToken(String refresh) async {
    final result = await (select(sessionTable)..where((t) => t.refreshToken.equals(refresh))).getSingle();
    return result;
  }

  void softDeleteSessionByToken(String token) {
    (update(
      sessionTable,
    )..where((t) => t.token.equals(token))).write(SessionTableCompanion(deletedAt: Value(DateTime.now())));
  }

  void softDeleteSessionByUserId(String userId) {
    (update(
      sessionTable,
    )..where((t) => t.userId.equals(userId))).write(SessionTableCompanion(deletedAt: Value(DateTime.now())));
  }
}
