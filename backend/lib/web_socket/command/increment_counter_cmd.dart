import 'dart:convert';

import 'package:backend/web_socket/counter_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:sha_red/sha_red.dart';

import '../broadcast.dart';
import '_ws_cmd.dart';

class IncrementCounterCommand implements WsCommand {
  const IncrementCounterCommand();
  @override
  void execute(RequestContext context, String roomId, WebSocketChannel channel, dynamic payload) {
    final counter = context.read<CounterRepository>().counter(roomId);
    if (counter == null) return;
    final broadcast = context.read<Broadcast>();
    final count = counter.increment();
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
