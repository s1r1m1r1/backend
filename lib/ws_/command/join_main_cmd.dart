import 'dart:convert';

import 'package:backend/ws_/broadcast.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:sha_red/sha_red.dart';

import 'package:backend/core/debug_log.dart';
import 'package:backend/ws_/command/_ws_cmd.dart';

const _mainRoomId = "main";

class JoinMainCommand implements WsCommand {
  const JoinMainCommand();
  @override
  void execute(
    RequestContext context,
    String roomId,
    WebSocketChannel channel,
    dynamic payload,
  ) async {
    debugLog('JoinMainCommand execute');
    final broadcast = context.read<Broadcast>();
    // final user = context.read<User>();
    if (_mainRoomId != roomId) return;
    debugLog('JoinMainCommand 1');
    if (payload != String) return;
    debugLog('JoinMainCommand 2');
    if (payload != String) return;
    final session = broadcast.getSession(channel);
    if (session == null) return;
    broadcast.subscribe(roomId: roomId, session: session, channel: channel);
    final encoded = jsonEncode(
      WsFromServer(
        roomId: roomId,
        eventType: WsEventFromServer.onlineUsers,
        payload: [broadcast.activeUsersList],
      ).toJson,
    );

    debugLog('JoinMainCommand broadcast members ${broadcast.activeUsersList.length}');
    broadcast.broadcast(roomId, encoded);
  }
}

// TODO Implement this library.
