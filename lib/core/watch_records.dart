import 'package:backend/core/debug_log.dart';
import 'package:backend/core/log_colors.dart';
import 'package:logging/logging.dart';

import 'k_debug_mode.dart';

void watchRecords(LogRecord rec) {
  // ---- filter --------

  if (kDebugMode) {
    // Logger(Unit.loggerName).level = Level.ALL;
  }
  debugLog('${rec.level.color}:${rec.loggerName}: ${rec.message}');
}
