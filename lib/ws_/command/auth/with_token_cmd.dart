import 'dart:convert';

import 'package:backend/core/log_colors.dart';
import 'package:backend/core/new_api_exceptions.dart';
import 'package:backend/game/unit.dart';
import 'package:backend/game/unit_repository.dart';
import 'package:backend/user/session.dart';
import 'package:backend/ws_/cubit/active_users_cubit.dart';
import 'package:sha_red/sha_red.dart';

import '../../../core/debug_log.dart';
import '../../../user/session_repository.dart';
import '../../../user/ws_active_sessions.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';

import '../_ws_cmd.dart';

// email token

class WithTokenCMD implements WsCommand {
  const WithTokenCMD();
  @override
  void execute(RequestContext context, WebSocketChannel channel, dynamic payload) {
    final activeSessions = context.read<WsActiveSessions>();
    final activeUsersCubit = context.read<ActiveUsersCubit>();
    final sessionRepo = context.read<SessionRepository>();
    final unitRepo = context.read<UnitRepository>();
    final dto = AccessTokenDto.fromJson(payload);

    sessionRepo
        .getSession(token: dto.value)
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
            final gameSession = GameSession.fromSession(session, Unit.fromDto(unit));

            activeUsersCubit.subscribe(channel);
            activeUsersCubit.addUser(gameSession);
            activeSessions[channel] = gameSession;
            channel.sink.add(gameSession.toEncodedTokens());
          });
        })
        .onError((er, st) {
          if (er is ApiException && er.statusCode == 401) {
            debugLog('$yellow${er.message}$reset');
            channel.sink.add(
              jsonEncode(WsFromServer(eventType: WsEventFromServer.tokenExpired).toJsonEvent()),
            );
            return;
          }
          debugLog("UnKnown error $er");
          channel.sink.add(
            jsonEncode(
              WsFromServer(
                eventType: WsEventFromServer.unauthenticated,
                payload: WsErrorPayload(errorCode: 500),
              ).toJson(WsErrorPayload.toJsonF),
            ),
          );
        });
  }
}
