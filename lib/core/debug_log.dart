import 'package:logging/logging.dart';

/// Global logger for manual debug messages
final _debugLogger = Logger('Debug');

/// Legacy helper that now routes everything through the central logging system.
void debugLog(String message) {
  _debugLogger.info('\n$message\n-----------------');
}
