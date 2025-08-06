import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:backend/web_socket/broadcast.dart';
import 'package:backend/web_socket/command/_ws_command_handlers.dart';
import 'package:backend/core/log_colors.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';

import 'package:sha_red/sha_red.dart';

Future<Response> onRequest(RequestContext context) async {
  final handler = webSocketHandler((channel, protocol) {
    final broadcast = context.read<Broadcast>();
    stdout.writeln('$green onEvent $reset');
    channel.stream.listen(
      (message) {
        stdout.writeln('$magenta [WebSocket] Received message: $message $reset');
        if (message is! String) {
          stdout.writeln('$red [WebSocket] Message is not a string. $reset');
          channel.sink.add('Invalid message');
          return;
        }

        Map<String, dynamic> decoded;
        try {
          decoded = jsonDecode(message);
        } catch (e) {
          stdout.writeln('$red [WebSocket] Failed to decode JSON: $e $reset');
          channel.sink.add('Invalid JSON');
          return;
        }
        stdout.writeln('$green [WebSocket] Decoded message: $decoded $reset');
        final request = WsToServer.fromJson(decoded);
        final command = wsCommandHandlers[request.eventType];
        if (command != null) {
          stdout.writeln(
            '$magenta [WebSocket] Executing command: ${request.eventType} for roomId: ${request.roomId} with payload: ${request.payload} $reset',
          );
          try {
            command.execute(context, request.roomId, channel, request.payload);
            stdout.writeln('$green [WebSocket] Command ${request.eventType} executed successfully. $reset');
          } catch (e, stack) {
            stdout.writeln('$red [WebSocket] Error executing command ${request.eventType}: $e $stack $reset');
            channel.sink.add('Error executing command: $e');
          }
        } else {
          stdout.writeln('$red [WebSocket] Command not found for eventType: ${request.eventType} $reset');
        }
      },
      onDone: () {
        stdout.writeln('$magenta [WebSocket] Connection closed, unsubscribing all. $reset');
        broadcast.unsubscribeAll(channel);
        channel.sink.close();
      },
    );
  });
  return handler(context);
}
