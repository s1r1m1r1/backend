// import 'dart:io';

// import 'package:backend/ws_/broadcast.dart';
// import 'package:backend/ws_/counter_repository.dart';
// import 'package:dart_frog/dart_frog.dart';
// import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';

// import 'package:backend/core/log_colors.dart';
// import '_ws_cmd.dart';

// class JoinCounterCommand implements WsCommand {
//   const JoinCounterCommand();
//   @override
//   void execute(RequestContext context, WebSocketChannel channel, dynamic payload) async {
//     stdout.writeln('$green JoinCounterCommand:start  } $reset');
//     final broadcast = context.read<Broadcast>();
//     // final user = context.read<User>();
//     final counter = context.read<CounterRepository>().counter('counter');
//     // todo send error

//     stdout.writeln('$green JoinCounterCommand: $counter  $reset');
//     if (counter == null) return;
//     final session = broadcast.getSession(channel);
//     if (session == null) return;
//     stdout.writeln('$green JoinCounterCommand:hasCounter } $reset');
//     broadcast.subscribe(roomId: 'room', session: session, channel: channel);
//     // final encoded = jsonEncode(
//     //   WsFromServer(
//     //     roomId: 'admin',
//     //     eventType: WsEventFromServer.adminInfo,
//     //     payload: IdPayload(broadcast.count).toJson(),
//     //   ).toJson(),
//     // );
//     // channel.sink.add(encoded);
//   }
// }
