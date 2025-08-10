import 'dart:convert';
import 'dart:io';

import '../broadcast.dart';
import '../counter_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:sha_red/sha_red.dart';

import '../../core/log_colors.dart';
import '../../models/user.dart';
import '_ws_cmd.dart';

class JoinCounterCommand implements WsCommand {
  const JoinCounterCommand();
  @override
  void execute(RequestContext context, String roomId, WebSocketChannel channel, dynamic payload) async {
    stdout.writeln('$green JoinCounterCommand:start ${roomId} } $reset');
    final broadcast = context.read<Broadcast>();
    // final user = context.read<User>();
    final counter = context.read<CounterRepository>().counter(roomId);
    // todo send error

    stdout.writeln('$green JoinCounterCommand: $counter  $reset');
    if (counter == null) return;
    final session = broadcast.getSession(channel);
    if (session == null) return;
    stdout.writeln('$green JoinCounterCommand:hasCounter } $reset');
    broadcast.subscribe(roomId: roomId, session: session, channel: channel);
    // final encoded = jsonEncode(
    //   WsFromServer(
    //     roomId: 'admin',
    //     eventType: WsEventFromServer.adminInfo,
    //     payload: IdPayload(broadcast.count).toJson(),
    //   ).toJson(),
    // );
    // channel.sink.add(encoded);
  }
}
