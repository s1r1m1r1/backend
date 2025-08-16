import 'dart:convert';

import 'package:backend/core/debug_log.dart';
import 'package:backend/core/new_api_exceptions.dart';
import 'package:backend/game/unit.dart';
import 'package:backend/game/unit_repository.dart';
import 'package:backend/user/session.dart';
import 'package:backend/ws_/logic/active_users.bloc.dart';
// import 'package:backend/ws_/logic/active_users_cubit.dart';

import '../../../core/log_colors.dart';
import '../../../user/session_repository.dart';
import '../../../user/ws_active_sessions.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:sha_red/sha_red.dart';

import '../../../user/user_repository.dart';
import '../_ws_cmd.dart';

// email pswd

class LoginCMD implements WsCommand {
  const LoginCMD();
  @override
  void execute(
    RequestContext context,
    WebSocketChannel channel,
    dynamic payload,
  ) {
    debugLog("LoginCMD START\n\n");
    final activeUsersBloc = context.read<ActiveUsersBloc>();
    final activeSessions = context.read<WsActiveSessions>();
    final userRepo = context.read<UserRepository>();
    final unitRepo = context.read<UnitRepository>();
    final sessionRepo = context.read<SessionRepository>();
    if (payload is! Map<String, dynamic>) {
      debugLog("LoginCMD payload is not Map<String, dynamic>");

      return;
    }
    final dto = payload as EmailCredentialDto;
    userRepo
        .loginUser(dto)
        .then((user) async {
          sessionRepo.createSession(user).then((session) {
            unitRepo.getSelectedUnit(session.user.userId).then((unit) {
              if (unit == null) {
                throw ApiException.notFound(message: 'Unit not found');
              }
              final gSession = GameSession.fromSession(
                session,
                Unit.fromDto(unit),
              );
              activeSessions.addSession(channel, gSession);
              activeUsersBloc.add(ActiveUsersEvent.addUser(channel));
              channel.sink.add(gSession.toEncodedTokens());
            });
          });
        })
        .onError((er, st) {
          if (er is ApiException && er.statusCode == 401) {
            debugLog('$yellow${er.message}$reset');
            channel.sink.add(jsonEncode(WWsFromServer.tokenExpired().toJson()));
            return;
          }
          debugLog("UnKnown error $er");
        });

    // final encoded = jsonEncode(
    //   WsFromServer(
    //     roomId: 'counter',
    //     eventType: WsEventFromServer.counter,
    //     payload: CounterPayload(count).toJson(),
    //   ).toJson(),
    // );
  }
}
