import 'dart:convert';

import 'package:backend/core/log_colors.dart';
import 'package:backend/core/new_api_exceptions.dart';
import 'package:backend/game/unit.dart';
import 'package:backend/game/unit_repository.dart';
import 'package:backend/user/session.dart';
import 'package:backend/ws_/logic/active_users.bloc.dart';
import 'package:sha_red/sha_red.dart';

import 'package:backend/core/debug_log.dart';
import 'package:backend/user/session_repository.dart';
import 'package:backend/user/ws_active_sessions.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';

import 'package:backend/ws_/command/_ws_cmd.dart';

// email token

class WithTokenCMD implements WsCommand {
  const WithTokenCMD();
  @override
  void execute(
    RequestContext context,
    WebSocketChannel channel,
    dynamic payload,
  ) {
    final activeSessions = context.read<WsActiveSessions>();
    final activeUsersBloc = context.read<ActiveUsersBloc>();
    final sessionRepo = context.read<SessionRepository>();
    final unitRepo = context.read<UnitRepository>();
    final dto = payload as String;

    sessionRepo
        .getSession(token: dto)
        .then((session) {
          if (session == null) {
            throw ApiException.unauthorized(message: 'Session not found');
          }
          final isTokenValid = sessionRepo.validateToken(session);
          if (!isTokenValid) {
            throw ApiException.unauthorized(message: 'Token expired');
          }
          unitRepo.getSelectedUnit(session.user.userId).then((unit) {
            if (unit == null) {
              throw ApiException.notFound(message: 'Unit not found');
            }
            final gameSession = GameSession.fromSession(
              session,
              Unit.fromDto(unit),
            );

            // important fist
            activeSessions.addSession(channel, gameSession);
            // important second
            activeUsersBloc.add(ActiveUsersEvent.addUser(channel));
            channel.sink.add(gameSession.toEncodedTokens());
          });
        })
        .onError((er, st) {
          if (er is ApiException && er.statusCode == 401) {
            debugLog('$yellow${er.message}$reset');
            channel.sink.add(jsonEncode(WWsFromServer.tokenExpired().toJson()));
            return;
          }
          debugLog("UnKnown error $er");
          // channel.sink.add(
          //   jsonEncode(
          //     WWsFromServer.unauthenticated(
          //       WsErrorPayload(errorCode: 500),
          //     ).toJson(),
          //   ),
          // );
        });
  }
}
