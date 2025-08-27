import 'package:backend/core/session_channel.dart';
import 'package:backend/ws_/model/web_socket_disposer.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:backend/user/session.dart';

mixin class ActiveUsersMixin {
  //  userId
  final channel_idKV = <WebSocketChannel, int>{};
  final id_sessionChannelKV = <int, SessionChannel>{};
  // final userid_tokenKV = <int, String>{};

  // final shouldUnsubscribeKV = <WebSocketChannel, WebSocketDisposer>{};

  // список активных сессий
  List<GameSession> getListGameSessions() {
    return id_sessionChannelKV.values.map((i) => i.session).toList();
  }

  int? getUserId(WebSocketChannel channel) {
    final userId = channel_idKV[channel];
    return userId;
  }

  SessionChannel? getSessionChannel(int userId) {
    return id_sessionChannelKV[userId];
  }

  SessionChannel? sessionFromWSChannel(WebSocketChannel channel) {
    final userId = getUserId(channel);
    if (userId == null) return null;
    return id_sessionChannelKV[userId];
  }

  void addSession(WebSocketChannel channel, GameSession session) {
    final sessionChannel = SessionChannel(session, channel);
    id_sessionChannelKV[session.user.userId] = sessionChannel;
    channel_idKV[channel] = sessionChannel.userId;
  }

  // 1) удалить сессию
  // вызывается при закрытии соединения
  // важно что disposer должен оставаться в Map чтобы завершить подписки корректно
  int? removeChannelID(WebSocketChannel channel) {
    return channel_idKV.remove(channel);
  }

  SessionChannel? removeIDsession(int userId) {
    return id_sessionChannelKV.remove(userId);
  }

  // получить disposer
  // вызывается каждый раз при новой подписке , для хранения unsubscribe
  // 2) также вызывается для удаления сессии с отпиской от всех событий
  // 3) важно удалить disposer только после отписки от всех событий
}
