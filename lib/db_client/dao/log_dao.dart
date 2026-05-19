import 'package:drift/drift.dart';
import '../db_client.dart';
import '../tables/log_entry_table.dart';

part 'log_dao.g.dart';

@DriftAccessor(tables: [LogEntries])
class LogDao extends DatabaseAccessor<DbClient> with _$LogDaoMixin {
  LogDao(super.db);

  /// Inserts a new log entry into the database.
  Future<void> insertLog(LogEntriesCompanion entry) =>
      into(logEntries).insert(entry);

  /// Deletes logs older than the specified duration (default: 24 hours).
  Future<int> deleteOldLogs({Duration olderThan = const Duration(hours: 24)}) {
    final threshold = DateTime.now().subtract(olderThan);
    return (delete(
      logEntries,
    )..where((t) => t.createdAt.isSmallerThanValue(threshold))).go();
  }

  /// Returns total count of logs
  Future<int> countLogs() {
    final countExp = logEntries.id.count();
    final query = selectOnly(logEntries)..addColumns([countExp]);
    return query.map((row) => row.read(countExp) ?? 0).getSingle();
  }
}
