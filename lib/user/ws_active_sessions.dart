import 'package:backend/ws_/model/web_socket_disposer.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';

import 'package:backend/user/session.dart';
import 'package:injectable/injectable.dart';

// typedef WsActiveSessions = Map<WebSocketChannel, GameSession>;

@lazySingleton
class WsActiveSessions {
  final activeSessionKV = <WebSocketChannel, GameSession>{};

  final shouldUnsubscribeKV = <WebSocketChannel, WebSocketDisposer>{};

  GameSession? getSession(WebSocketChannel channel) {
    return activeSessionKV[channel];
  }

  void addDisposer(WebSocketChannel channel, WebSocketDisposer disposer) {
    shouldUnsubscribeKV[channel] = disposer;
  }

  WebSocketDisposer? getDisposer(WebSocketChannel channel) {
    return shouldUnsubscribeKV[channel];
  }

  void addSession(WebSocketChannel channel, GameSession session) {
    activeSessionKV[channel] = session;
    shouldUnsubscribeKV[channel] = WebSocketDisposer(channel);
  }

  void removeSession(WebSocketChannel channel) {
    activeSessionKV.remove(channel);
  }
}
