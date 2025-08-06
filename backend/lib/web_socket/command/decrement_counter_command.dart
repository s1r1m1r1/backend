import 'dart:convert';

import 'package:backend/web_socket/command/_ws_command.dart';
import 'package:backend/web_socket/counter_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:sha_red/sha_red.dart';

class DecrementCounterCommand implements WsCommand {
  @override
  void execute(RequestContext context, String roomId, WebSocketChannel channel, dynamic payload) {
    final counter = context.read<CounterRepository>().counter(roomId);
    if (counter == null) return;
    final count = counter.decrement();

    channel.sink.add(
      jsonEncode(
        WsFromServer(
          roomId: 'counter',
          eventType: WsEventFromServer.counter,
          payload: CounterPayload(count).toJson(),
        ).toJson(),
      ),
    );
  }
}
