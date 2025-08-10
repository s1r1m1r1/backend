import 'dart:async';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';

abstract class WsCommand<T> {
  FutureOr<void> execute(
    RequestContext context,
    String roomId,
    WebSocketChannel channel,
    T payload,
  );
}
