import 'dart:convert';
import 'dart:io';

import '../../core/log_colors.dart';
import '../broadcast.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:sha_red/sha_red.dart';

import '../../models/user.dart';
import '_ws_cmd.dart';

class JoinAdminCommand implements WsCommand {
  const JoinAdminCommand();
  @override
  void execute(RequestContext context, String roomId, WebSocketChannel channel, dynamic payload) async {
    stdout.writeln('$magenta JoinAdminCommand:start ${roomId} } $reset');
    final broadcast = context.read<Broadcast>();
    // final user = context.read<User>();
    // todo send error

    stdout.writeln('$green JoinAdminCommand:hasCounter } $reset');
    final session = broadcast.getSession(channel);
    if (session == null) return;
    broadcast.subscribe(roomId: roomId, session: session, channel: channel);
    // final encoded = jsonEncode(
    //   WsFromServer(
    //     roomId: 'admin',
    //     eventType: WsEventFromServer.adminInfo,
    //     payload: IdPayload(broadcast.count).toJson(),
    //   ).toJson(),
    // );
    // broadcast.broadcast('admin', encoded);
  }
}
