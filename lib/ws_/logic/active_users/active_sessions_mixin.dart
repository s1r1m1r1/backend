import 'package:backend/ws_/model/web_socket_disposer.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:backend/user/session.dart';

// typedef WsActiveSessions = Map<WebSocketChannel, GameSession>;

mixin class ActiveUsersMixin {
  // value userId
  final channel_useridKV = <WebSocketChannel, int>{};
  final userid_sessionKV = <int, GameSession>{};
  final userid_channelKV = <int, WebSocketChannel>{};

  final shouldUnsubscribeKV = <WebSocketChannel, WebSocketDisposer>{};

  List<GameSession> getListGameSessions() {
    return userid_sessionKV.values.toList();
  }

  GameSession? getSession(WebSocketChannel channel) {
    final userId = channel_useridKV[channel];
    return userid_sessionKV[userId];
  }

  WebSocketChannel? getChannelForUser(int userId) {
    return userid_channelKV[userId];
  }

  void addDisposer(WebSocketChannel channel, WebSocketDisposer disposer) {
    shouldUnsubscribeKV[channel] = disposer;
  }

  WebSocketDisposer? getDisposer(WebSocketChannel channel) {
    return shouldUnsubscribeKV[channel];
  }

  void addSession(WebSocketChannel channel, GameSession session) {
    channel_useridKV[channel] = session.user.userId;
    userid_sessionKV[session.user.userId] = session;
    userid_channelKV[session.user.userId] = channel;
    shouldUnsubscribeKV[channel] = WebSocketDisposer(channel);
  }

  void removeSession(WebSocketChannel channel) {
    final userId = channel_useridKV[channel];
    userid_sessionKV.remove(userId);
    userid_channelKV.remove(userId);
    channel_useridKV.remove(channel);
  }
}
