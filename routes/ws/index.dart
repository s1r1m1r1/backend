import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:backend/core/debug_log.dart';
import 'package:backend/user/ws_active_sessions.dart';
import 'package:backend/core/log_colors.dart';
import 'package:backend/ws_/command/_ws_cmd_handlers.dart';
import 'package:backend/ws_/command/auth/login_cmd.dart';
import 'package:backend/ws_/command/auth/with_refresh_cmd.dart';
import 'package:backend/ws_/command/auth/with_token_cmd.dart';
import 'package:backend/ws_/command/decrement_counter_cmd.dart';
import 'package:backend/ws_/command/increment_counter_cmd.dart';
import 'package:backend/ws_/command/unimplemented_cmd.dart';
import 'package:backend/ws_/logic/active_users_cubit.dart';
import 'package:backend/ws_/logic/letter.bloc.dart';
import 'package:backend/ws_/logic/letter.bloc_manager.dart';
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
        try {
          switch (eventType) {
            case WsEventToServer.login:
              LoginCMD().execute(context, channel, payload);
            case WsEventToServer.signup:
              break;
            case WsEventToServer.withToken:
              WithTokenCMD().execute(context, channel, payload);
            case WsEventToServer.withRefresh:
              WithRefreshCMD().execute(context, channel, payload);
            case WsEventToServer.newMessage:
              break;
            case WsEventToServer.deleteMessage:
              break;
            case WsEventToServer.incrementCounter:
              IncrementCounterCommand().execute(context, channel, payload);
            case WsEventToServer.decrementCounter:
              DecrementCounterCommand().execute(context, channel, payload);
            case WsEventToServer.deleteLetter:
              final blocManager = context.read<LetterBlocManager>();
              final dto = IdLetterPayload.fromJson(payload as Json);
              blocManager.removeLetter(
                channel,
                'main' /*dto.roomId*/,
                dto.letterId,
              );
              break;
            case WsEventToServer.newLetter:
              final blocManager = context.read<LetterBlocManager>();
              final dto = NewLetterPayload.fromJson(payload as Json);
              blocManager.newLetter(channel, 'main' /*dto.roomId*/, dto.letter);

            case WsEventToServer.joinLetters:
              final room = LetterRoomPayload.fromJson(payload as Json);
              final letterBlocManager = context.read<LetterBlocManager>();
              letterBlocManager.subscribe(channel, 'main' /*room.roomId*/);
            case WsEventToServer.joinCounter:
              break;
            case WsEventToServer.leaveRoom:
              LeaveRoomCommand().execute(context, channel, payload);
            case WsEventToServer.listRooms:
              ListRoomsCommand().execute(context, channel, payload);
            case WsEventToServer.sendLetterToRoom:
              SendLetterToRoomCommand().execute(context, channel, payload);
            case WsEventToServer.fetchRoomHistory:
              FetchRoomHistoryCommand().execute(context, channel, payload);
            case WsEventToServer.joinAdmin:
            case WsEventToServer.joinMain:
              break;
            // WsEventToServer.joinCounter: JoinCounterCommand(),
            // WsEventToServer.joinMain: JoinMainCommand(),
          }
        } catch (e, s) {
          debugLog('$red [WebSocket] Error: $e $s $reset');
        }

        // } catch (e) {
        //   debugLog('$red [WebSocket] Error: $e $reset');
        // }
      },
      onDone: () async {
        final session = activeSessions.getSession(channel);
        final disposer = activeSessions.getDisposer(channel);
        if (disposer != null) {
          disposer.dispose();
        }
        if (session != null) {
          activeUsersCubit.removeUser(session);
          activeUsersCubit.unsubscribe(channel);
          activeSessions.removeSession(channel);
          // letterBloc.roomLetter['main']?.unsubscribe(channel);
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
