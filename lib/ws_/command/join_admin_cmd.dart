// import 'dart:io';

// import 'package:backend/core/log_colors.dart';
// import 'package:backend/ws_/broadcast.dart';
// import 'package:dart_frog/dart_frog.dart';
// import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';

// import 'package:backend/ws_/command/_ws_cmd.dart';

// class JoinAdminCommand implements WsCommand {
//   const JoinAdminCommand();
//   @override
//   void execute(RequestContext context, WebSocketChannel channel, dynamic payload) async {
//     stdout.writeln('$magenta JoinAdminCommand:start ${'room'} } $reset');
//     final broadcast = context.read<Broadcast>();
//     // final user = context.read<User>();
//     // todo send error

//     stdout.writeln('$green JoinAdminCommand:hasCounter } $reset');
//     final session = broadcast.getSession(channel);
//     if (session == null) return;
//     broadcast.subscribe(roomId: 'room', session: session, channel: channel);
//     // final encoded = jsonEncode(
//     //   WsFromServer(
//     //     roomId: 'admin',
//     //     eventType: WsEventFromServer.adminInfo,
//     //     payload: IdPayload(broadcast.count).toJson(),
//     //   ).toJson(),
//     // );
//     // broadcast.broadcast('admin', encoded);
//   }
// }
