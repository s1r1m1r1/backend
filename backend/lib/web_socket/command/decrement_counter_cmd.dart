import 'dart:convert';

import 'package:backend/web_socket/command/_ws_cmd.dart';
import 'package:backend/web_socket/counter_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:sha_red/sha_red.dart';

import '../broadcast.dart';

class DecrementCounterCommand implements WsCommand {
  const DecrementCounterCommand();
  @override
  void execute(RequestContext context, String roomId, WebSocketChannel channel, dynamic payload) {
    final counter = context.read<CounterRepository>().counter(roomId);
    if (counter == null) return;
    final count = counter.decrement();
    final broadcast = context.read<Broadcast>();
    final encoded = jsonEncode(
      WsFromServer(
        roomId: 'counter',
        eventType: WsEventFromServer.counter,
        payload: CounterPayload(count).toJson(),
      ).toJson(),
    );
    broadcast.broadcast(roomId, encoded);
  }
}
