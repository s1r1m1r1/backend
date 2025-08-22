import 'package:logging/logging.dart';

final black = "\x1B[30m";
final red = "\x1B[31m";
final green = "\x1B[32m";
final yellow = "\x1B[33m";
final blue = "\x1B[34m";
final magenta = "\x1B[35m";
final cyan = "\x1B[36m";
final white = "\x1B[37m";
final reset = "\x1B[0m";

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
