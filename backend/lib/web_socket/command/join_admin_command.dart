import 'dart:convert';
import 'dart:io';

import 'package:backend/core/log_colors.dart';
import 'package:backend/web_socket/broadcast.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:sha_red/sha_red.dart';

import '_ws_command.dart';

class JoinAdminCommand implements WsCommand {
  const JoinAdminCommand();
  @override
  void execute(RequestContext context, String roomId, WebSocketChannel channel, dynamic payload) async {
    stdout.writeln('$magenta JoinAdminCommand:start ${roomId} } $reset');
    final broadcast = context.read<Broadcast>();
    // final user = context.read<User>();
    // todo send error

    stdout.writeln('$green JoinAdminCommand:hasCounter } $reset');
    broadcast.subscribe(roomId, channel);
    final encoded = jsonEncode(
      WsFromServer(
        roomId: 'admin',
        eventType: WsEventFromServer.adminInfo,
        payload: IdPayload(broadcast.count).toJson(),
      ).toJson(),
    );
    broadcast.broadcast('admin', encoded);
  }
}
