import 'package:backend/db_client/db_client.dart';
import 'package:backend/session/session.dart';
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

  Future<SessionEntry> getSessionFromToken(String token) async {
    final result = await (select(sessionTable)..where((t) => t.token.equals(token))).getSingle();
    return result;
  }

  void softDeleteSessionByToken(String token) {
    (update(
      sessionTable,
    )..where((t) => t.token.equals(token))).write(SessionTableCompanion(deletedAt: Value(DateTime.now())));
  }
}
