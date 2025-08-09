import 'dart:async';
import 'dart:convert';

import '../../lib/core/debug_log.dart';
import '../../lib/web_socket/broadcast.dart';
import '../../lib/web_socket/command/_ws_cmd_handlers.dart';
import '../../lib/core/log_colors.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';

import 'package:sha_red/sha_red.dart';

Future<Response> onRequest(RequestContext context) async {
  final handler = webSocketHandler((channel, protocol) {
    final broadcast = context.read<Broadcast>();
    // final user = context.read<User>();
    channel.sink.add(WsFromServer(eventType: WsEventFromServer.unauthenticated, roomId: 'main', payload: {}).toJson());

    channel.stream.listen(
      (message) {
        debugLog('$magenta [WebSocket] Received message: $message $reset');
        if (message is! String) {
          debugLog('$red [WebSocket] Message is not a string. $reset');
          channel.sink.add('Invalid message');
          return;
        }

        var decoded;
        try {
          decoded = jsonDecode(message);
        } catch (e) {
          debugLog('$red [WebSocket] Failed to decode JSON: $e $reset');
          channel.sink.add('Invalid JSON');
          return;
        }
        debugLog('$green [WebSocket] Decoded message: $decoded $reset');
        final request = WsToServer.fromJson(decoded);
        final command = wsCommandHandlers[request.eventType];
        if (command != null) {
          debugLog(
            '$magenta [WebSocket] Executing command: ${request.eventType} for roomId: ${request.roomId} with payload: ${request.payload} $reset',
          );
          try {
            command.execute(context, request.roomId, channel, request.payload);
            debugLog('$green [WebSocket] Command ${request.eventType} executed successfully. $reset');
          } catch (e, stack) {
            debugLog('$red [WebSocket] Error executing command ${request.eventType}: $e $stack $reset');
            channel.sink.add('Error executing command: $e');
          }
        } else {
          debugLog('$red [WebSocket] Command not found for eventType: ${request.eventType} $reset');
        }
      },
      onDone: () {
        debugLog('$magenta [WebSocket] Connection closed, unsubscribing all. $reset');
        broadcast.unsubscribeAll(channel);
        channel.sink.close();
      },
    );
  });
  return handler(context);
}
