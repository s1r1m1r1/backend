import 'package:backend/ws_/counter_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';

import 'package:backend/ws_/broadcast.dart';
import 'package:backend/ws_/command/_ws_cmd.dart';

class IncrementCounterCommand implements WsCommand {
  const IncrementCounterCommand();
  @override
  void execute(RequestContext context, WebSocketChannel channel, dynamic payload) {
    final counter = context.read<CounterRepository>().counter('counter');
    if (counter == null) return;
    final broadcast = context.read<Broadcast>();
    final count = counter.increment();
    // final encoded = jsonEncode(
    //   WsFromServer(
    //     roomId: 'counter',
    //     eventType: WsEventFromServer.counter,
    //     payload: CounterPayload(count).toJson(),
    //   ).toJson(),
    // );
    // broadcast.broadcast(roomId, encoded);
  }
}
