import 'package:flutter/foundation.dart';

// iOS
const iosHost = '127.0.0.1';
// android
const androidHost = '127.0.2.2';

const localhost = 'localhost';

const port = 8080;

final host = switch (defaultTargetPlatform) {
  TargetPlatform.android => androidHost,
  TargetPlatform.iOS => iosHost,
  TargetPlatform.macOS => iosHost,
  _ => localhost,
};

abstract class HttpConst {
  static final baseUrl = 'http://$host:$port';
}

abstract class WebSocketConst {
  static final baseUrl = 'ws://$host:$port/counter/ws';
}
