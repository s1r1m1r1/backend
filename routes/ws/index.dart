import 'dart:async';
import 'dart:convert';

import 'package:backend/core/debug_log.dart';
import 'package:backend/ws_/broadcast.dart';
import 'package:backend/ws_/command/_ws_cmd_handlers.dart';
import 'package:backend/core/log_colors.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';

import 'package:sha_red/sha_red.dart';

Future<Response> onRequest(RequestContext context) async {
  final handler = webSocketHandler((channel, protocol) {
    final broadcast = context.read<Broadcast>();
    // final user = context.read<User>();
    channel.sink.add(
      jsonEncode(
        WsFromServer(
          eventType: WsEventFromServer.unauthenticated,
          roomId: 'main',
          payload: WsErrorPayload(message: 'Unauthorized'),
        ).toJson(WsErrorPayload.toJsonF),
      ),
    );

    channel.stream.listen(
      (message) {
        debugLog('$magenta [WebSocket] Received message: $message $reset');
        if (message is! String) {
          debugLog('$red [WebSocket] Message is not a string. $reset');
          // channel.sink.add('Invalid message');
          return;
        }

        var decoded;
        try {
          decoded = jsonDecode(message);
        } catch (e) {
          debugLog('$red [WebSocket] Failed to decode JSON: $e $reset');
          // channel.sink.add('Invalid JSON');
          return;
        }
        final eventType = decoded['event'] as String?;
        final roomId = decoded['room'] as String;
        final payload = decoded['payload'];
        if (eventType == null) {
          debugLog('$red [WebSocket] Event is null. $reset');
          return;
        }
        debugLog('$green [WebSocket] Decoded message: $decoded $reset');
        final command = wsCommandHandlers[eventType];
        if (command != null) {
          debugLog(
            '$magenta [WebSocket] Executing command: ${eventType} for roomId: ${roomId} with payload: ${payload} $reset',
          );
          try {
            command.execute(context, roomId, channel, payload);
            debugLog('$green [WebSocket] Command ${eventType} executed successfully. $reset');
          } catch (e, stack) {
            debugLog('$red [WebSocket] Error executing command ${eventType}: $e $stack $reset');
            // channel.sink.add('Error executing command: $e');
          }
        } else {
          debugLog('$red [WebSocket] Command not found for eventType: ${eventType} $reset');
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
