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
// final host = 'container-app-rhrbr-universe.containerapps.ru';

abstract class HttpConst {
  static final baseUrl = 'http://$host:$port';
  // static final baseUrl = 'https://$host';
}

abstract class WebSocketConst {
  static final baseUrl = 'ws://$host:$port/ws/';
  // static final baseUrl = 'wss://$host/ws/';
}
