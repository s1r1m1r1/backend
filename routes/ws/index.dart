import 'dart:async';

import 'package:backend/core/debug_log.dart';
import 'package:backend/core/log_colors.dart';
import 'package:backend/ws_/logic/active_users/active_users_bloc.dart';
import 'package:backend/ws_/logic/letter.bloc_manager.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:sha_red/sha_red.dart';

Future<Response> onRequest(RequestContext context) async {
  final handler = webSocketHandler((channel, protocol) {
    debugLog('$green ON Request 1 $protocol $reset');
    final activeUsersBloc = context.read<ActiveUsersBloc>();

    channel.stream.listen(
      (message) async {
        debugLog('$green ON MESSAGE: $reset');
        if (message is! String) {
          return;
        }

        try {
          final freezed = ToServer.decoded(message);
          debugLog('$green ON MESSAGE: $freezed $reset');
          switch (freezed) {
            case WithTokenTS(:final token):
              // 1. Authenticate the token
              activeUsersBloc.add(
                ActiveUsersEvent.join(
                  channel: channel,
                  token: token,
                  isRefresh: false,
                ),
              );
              break;
            case WithRefreshTS(:final refresh):
              activeUsersBloc.add(
                ActiveUsersEvent.join(
                  channel: channel,
                  token: refresh,
                  isRefresh: true,
                ),
              );

              break;
            case NewLetterTS(:final letter, :final room, :final sender):
              final blocManager = context.read<LetterBlocManager>();
              final session = activeUsersBloc.getSession(channel);
              if (session == null) {
                channel.sink.add(
                  ToClient.statusError(
                    error: WsServerError.unauthorized,
                  ).encoded(),
                );
                return;
              }
              blocManager.newLetter(
                channel,
                'main' /*dto.roomId*/,
                session,
                letter,
              );
            case DeleteLetterTS(:final sender, :final letterId):
              final blocManager = context.read<LetterBlocManager>();
              final session = activeUsersBloc.getSession(channel);
              if (session == null) {
                channel.sink.add(
                  ToClient.statusError(
                    error: WsServerError.unauthorized,
                  ).encoded(),
                );
                return;
              }
              blocManager.removeLetter(
                channel,
                session,
                'main' /*dto.roomId*/,
                letterId,
              );
            case JoinLettersTS(:final token, :final room):
              final letterBlocManager = context.read<LetterBlocManager>();
              final session = activeUsersBloc.getSession(channel);
              final disposer = activeUsersBloc.getDisposer(channel);
              if (session == null || disposer == null) {
                channel.sink.add(
                  ToClient.statusError(
                    error: WsServerError.unauthorized,
                  ).encoded(),
                );
                return;
              }
              letterBlocManager.subscribe(
                channel,
                session,
                disposer,
                'main' /*room.roomId*/,
              );
          }
        } catch (e, s) {
          debugLog('$red [WebSocket] Error: $e $s $reset');
        }
      },
      onDone: () async {
        activeUsersBloc.add(ActiveUsersEvent.removeUser(channel));
      },

      cancelOnError: true,
    );
  }, pingInterval: const Duration(seconds: 30));
  // Set a ping interval to detect inactive connections.
  // The server will send a ping every 30 seconds.
  // If the client doesn't respond with a pong, the connection is closed.
  return handler(context);
}
