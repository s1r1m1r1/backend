import 'dart:io';

import 'k_debug_mode.dart';

void debugLog(String message) {
  if (kDebugMode) {
    stdout.writeln(message);
  }
}
