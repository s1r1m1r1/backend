import 'package:backend/ws_/model/web_socket_disposer.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:backend/user/session.dart';

mixin class ActiveUsersMixin {
  // value userId
  final channel_useridKV = <WebSocketChannel, int>{};
  final userid_sessionKV = <int, GameSession>{};
  final userid_channelKV = <int, WebSocketChannel>{};
  // final userid_tokenKV = <int, String>{};

  final shouldUnsubscribeKV = <WebSocketChannel, WebSocketDisposer>{};

  // список активных сессий
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

  void addSession(WebSocketChannel channel, GameSession session) {
    channel_useridKV[channel] = session.user.userId;
    userid_sessionKV[session.user.userId] = session;
    userid_channelKV[session.user.userId] = channel;
    shouldUnsubscribeKV[channel] = WebSocketDisposer();
  }

  // 1) удалить сессию
  // вызывается при закрытии соединения
  // важно что disposer должен оставаться в Map чтобы завершить подписки корректно
  void removeSession(WebSocketChannel channel) {
    final userId = channel_useridKV[channel];
    userid_sessionKV.remove(userId);
    userid_channelKV.remove(userId);
    channel_useridKV.remove(channel);
  }

  // получить disposer
  // вызывается каждый раз при новой подписке , для хранения unsubscribe
  // 2) также вызывается для удаления сессии с отпиской от всех событий
  WebSocketDisposer? getDisposer(WebSocketChannel channel) {
    return shouldUnsubscribeKV[channel];
  }

  // 3) важно удалить disposer только после отписки от всех событий
  void removeDisposer(WebSocketChannel channel) {
    shouldUnsubscribeKV.remove(channel);
  }
}
