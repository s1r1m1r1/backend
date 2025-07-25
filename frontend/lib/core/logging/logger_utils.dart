import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

import 'log_colors.dart';

void watchRecords(LogRecord rec) {
  if (rec.stackTrace != null) {
    debugPrintStack(
      stackTrace: rec.stackTrace,
      label: '${rec.level.color}:${rec.loggerName}: $red${rec.message}$reset',
    );
    return;
  }
  if (kDebugMode) {
    // force reset level logger
    // Logger(Name.loggerName).level = Level.ALL;
  }
  debugPrint('\n${rec.level.color}:${rec.loggerName}:${rec.message}');
}

extension LevelExt on Level {
  String get color => switch (this) {
        Level.ALL => '${cyan}ALL$reset',
        Level.FINE || Level.FINER || Level.FINEST => '${cyan}F$reset',
        Level.INFO => '${green}I$reset',
        Level.WARNING => '${red}W$reset',
        Level.SEVERE || Level.SHOUT => '${red}S$reset',
        Level.CONFIG => '${yellow}Config$reset',
        Level.OFF || _ => '',
      };
}
