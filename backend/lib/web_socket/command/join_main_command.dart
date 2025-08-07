import 'package:backend/web_socket/broadcast.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';

import '_ws_command.dart';

const _mainRoomId = "main";

class JoinMainCommand implements WsCommand {
  const JoinMainCommand();
  @override
  void execute(RequestContext context, String roomId, WebSocketChannel channel, dynamic payload) async {
    final broadcast = context.read<Broadcast>();
    if (_mainRoomId != roomId) return;
    if (payload != String) return;
    broadcast.subscribe(roomId, channel);
  }
}

// TODO Implement this library.
