import 'dart:async';

import 'package:drift/drift.dart';
import 'package:logging/logging.dart';

import '../db_client/db_client.dart';

/// Minimal level to show in terminal.
Level minTerminalLevel = Level.ALL;

/// Minimal level to persist in database.
/// Setting this to INFO or WARNING significantly reduces DB pressure.
Level minDatabaseLevel = Level.INFO;

DbClient? _loggingDb;
final List<LogEntriesCompanion> _logBuffer = [];
Timer? _flushTimer;

/// Maximum number of logs to hold in memory before forcing a flush to DB.
const int _maxBufferSize = 50;

/// Interval for periodic log flushing.
const Duration _flushInterval = Duration(seconds: 5);

void initLoggingDb(DbClient db) {
  _loggingDb = db;
  // Start periodic flush
  _flushTimer?.cancel();
  _flushTimer = Timer.periodic(_flushInterval, (_) => _flushLogs());
}

/// Centralized log listener.
void onRecord(LogRecord rec) {
  _logToTerminal(rec);
  _logToDatabase(rec);
}

void _logToTerminal(LogRecord rec) {
  if (rec.level < minTerminalLevel) return;

  final levelLabel = rec.level.name;
  final loggerName = rec.loggerName.isNotEmpty ? '[${rec.loggerName}]' : '';

  final message =
      '[${rec.time.toString().split(' ').last}] [$levelLabel] $loggerName ${rec.message}';

  // ignore: avoid_print
  print(message);

  if (rec.error != null) {
    // ignore: avoid_print
    print('  ERROR: ${rec.error}');
  }
}

void _logToDatabase(LogRecord rec) {
  if (rec.level < minDatabaseLevel) return;
  if (_loggingDb == null) return;

  _logBuffer.add(
    LogEntriesCompanion.insert(
      level: rec.level.name,
      loggerName: rec.loggerName,
      message: rec.message,
      error: Value(rec.error?.toString()),
      stackTrace: Value(rec.stackTrace?.toString()),
      createdAt: Value(rec.time),
    ),
  );

  if (_logBuffer.length >= _maxBufferSize) {
    _flushLogs();
  }
}

Future<void> _flushLogs() async {
  if (_logBuffer.isEmpty || _loggingDb == null) return;

  final logsToWrite = List<LogEntriesCompanion>.from(_logBuffer);
  _logBuffer.clear();

  try {
    // drift supports batching via insertAll
    await _loggingDb!.batch((batch) {
      batch.insertAll(_loggingDb!.logEntries, logsToWrite);
    });
  } catch (e) {
    // ignore: avoid_print
    print('CRITICAL: Failed to flush logs to database: $e');
    // Optionally: Put them back to buffer or drop if too many
  }
}
