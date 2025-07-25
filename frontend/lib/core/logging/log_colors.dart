// not supported colors for iOS
import 'package:flutter/foundation.dart';

final black = defaultTargetPlatform == TargetPlatform.iOS ? "" : "\x1B[30m";
final red = defaultTargetPlatform == TargetPlatform.iOS ? "" : "\x1B[31m";
final green = defaultTargetPlatform == TargetPlatform.iOS ? "" : "\x1B[32m";
final yellow = defaultTargetPlatform == TargetPlatform.iOS ? "" : "\x1B[33m";
final blue = defaultTargetPlatform == TargetPlatform.iOS ? "" : "\x1B[34m";
final magenta = defaultTargetPlatform == TargetPlatform.iOS ? "" : "\x1B[35m";
final cyan = defaultTargetPlatform == TargetPlatform.iOS ? "" : "\x1B[36m";
final white = defaultTargetPlatform == TargetPlatform.iOS ? "" : "\x1B[37m";
final reset = defaultTargetPlatform == TargetPlatform.iOS ? "" : "\x1B[0m";
