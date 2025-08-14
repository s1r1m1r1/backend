import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:backend/core/debug_log.dart';
import 'package:backend/user/ws_active_sessions.dart';
import 'package:backend/core/log_colors.dart';
import 'package:backend/ws_/command/_ws_cmd_handlers.dart';
import 'package:backend/ws_/cubit/active_users_cubit.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:sha_red/sha_red.dart';

Future<Response> onRequest(RequestContext context) async {
  final handler = webSocketHandler((channel, protocol) {
    debugLog('$green ON Request 1 $protocol $reset');
    final activeSessions = context.read<WsActiveSessions>();
    final activeUsersCubit = context.read<ActiveUsersCubit>();

    debugLog('$green ON Request 2  $reset');
    // final user = context.read<User>();
    // channel.sink.add(
    //   jsonEncode(
    //     WsFromServer(
    //       eventType: WsEventFromServer.unauthenticated,
    //       roomId: 'main',
    //       payload: WsErrorPayload(message: 'Unauthorized'),
    //     ).toJson(WsErrorPayload.toJsonF),
    //   ),
    // );

    channel.stream.listen(
      (message) async {
        debugLog('$green ON MESSAGE: $reset');
        // try {
        if (message is! String) {
          debugLog('$red [WebSocket] Message is not a string. $reset');
          // channel.sink.add('Invalid message');
          return;
        }
        var decoded = jsonDecode(message);
        stdout.writeln('DECODED: $decoded');
        final eventType = WsToServer.eventFromJson(decoded);
        final payload = decoded['payload'];

        //   try {
        //     decoded = jsonDecode(message);
        //   } catch (e) {
        //     debugLog('$red [WebSocket] Failed to decode JSON: $e $reset');
        //     // channel.sink.add('Invalid JSON');
        //     return;
        //   }
        //   final roomId = decoded['room'] as String;
        //   if (eventType == null) {
        //     debugLog('$red [WebSocket] Event is null. $reset');
        //     return;
        //   }
        //   debugLog('$green [WebSocket] Decoded message: $decoded $reset');
        final command = wsCommandHandlers[eventType];
        if (command != null) {
          debugLog(
            '$magenta [WebSocket] Executing command: ${eventType} for  with payload: ${payload} $reset',
          );
          try {
            await command.execute(context, channel, payload);
            debugLog('$green [WebSocket] Command ${eventType} executed successfully. $reset');
          } catch (e, stack) {
            debugLog('$red [WebSocket] Error executing command ${eventType}: $e $stack $reset');
            // channel.sink.add('Error executing command: $e');
          }
        } else {
          debugLog('$red [WebSocket] Command not found for eventType: ${eventType} $reset');
        }
        // } catch (e) {
        //   debugLog('$red [WebSocket] Error: $e $reset');
        // }
      },
      onDone: () async {
        debugLog('$magenta [WebSocket] Connection closed, unsubscribing all. $reset');
        final session = activeSessions[channel];
        if (session != null) {
          activeUsersCubit.removeUser(session);
          activeUsersCubit.unsubscribe(channel);
        }
        channel.sink.close();
      },

      cancelOnError: true,
    );
  }, pingInterval: const Duration(seconds: 30));
  // Set a ping interval to detect inactive connections.
  // The server will send a ping every 30 seconds.
  // If the client doesn't respond with a pong, the connection is closed.
  return handler(context);
}
