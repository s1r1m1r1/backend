import 'package:backend/ws_/model/web_socket_disposer.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:collection/collection.dart';
import 'package:backend/user/session.dart';
import 'package:injectable/injectable.dart';
import 'package:sha_red/sha_red.dart';

// typedef WsActiveSessions = Map<WebSocketChannel, GameSession>;

@lazySingleton
class ActiveSessionsRepository {
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

  void finishOtherSession(WebSocketChannel channel, GameSession gameSession) {
    final entries = activeSessionKV.entries.where(
      (entry) => entry.value.user.userId == gameSession.user.userId,
    );

    final message = ToClient.statusError(
      error: WsServerError.finishDuplicateSession,
    ).encoded();
    entries.forEach((i) {
      final otherChannel = i.key;
      if (otherChannel == channel) return;
      final disposer = shouldUnsubscribeKV[otherChannel];
      otherChannel.sink.add(message);
      disposer?.dispose();
      channel.sink.close();
    });
  }
}
