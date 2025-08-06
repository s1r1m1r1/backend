// TODO Implement this library.

import 'dart:convert';
import 'dart:io';

import 'package:backend/web_socket/broadcast.dart';
import 'package:backend/web_socket/counter_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:sha_red/sha_red.dart';

import '../../core/log_colors.dart';
import '_ws_command.dart';

class JoinCounterCommand implements WsCommand {
  @override
  void execute(RequestContext context, String roomId, WebSocketChannel channel, dynamic payload) async {
    stdout.writeln('$green JoinCounterCommand:start ${roomId} } $reset');
    final broadcast = context.read<Broadcast>();
    // final user = context.read<User>();
    final counter = context.read<CounterRepository>().counter(roomId);
    // todo send error

    stdout.writeln('$green JoinCounterCommand: $counter  $reset');
    if (counter == null) return;
    stdout.writeln('$green JoinCounterCommand:hasCounter } $reset');
    broadcast.subscribe(roomId, channel);
    broadcast.broadcast(
      'admin',
      jsonEncode(
        WsFromServer(
          roomId: 'admin',
          eventType: WsEventFromServer.adminInfo,
          payload: IdPayload(broadcast.count).toJson(),
        ).toJson(),
      ),
    );
    channel.sink.add(
      jsonEncode(
        WsFromServer(
          roomId: roomId,
          eventType: WsEventFromServer.joinedCounter,
          payload: CounterPayload(counter.value).toJson(),
        ).toJson(),
      ),
    );
  }
}
