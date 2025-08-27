import 'dart:async';
import 'dart:convert';

import 'package:backend/core/debug_log.dart';
import 'package:backend/core/log_colors.dart';
import 'package:backend/core/session_channel.dart';
import 'package:backend/game/unit.dart';
import 'package:backend/game/unit_repository.dart';
import 'package:backend/user/session.dart';
import 'package:backend/user/session_repository.dart';
import 'package:backend/ws_/logic/active_users/active_sessions_mixin.dart';
import 'package:backend/ws_/model/web_socket_disposer.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:sha_red/sha_red.dart';
import 'package:backend/core/broadcast_bloc.dart';

part 'active_users_event.dart';
part 'active_users_state.dart';
part 'active_users_bloc.freezed.dart';

const _timeoutDuration = Duration(milliseconds: 100);

@lazySingleton
class ActiveUsersBloc extends BroadcastBloc<ActiveUsersEvent, ActiveUsersState>
    with ActiveUsersMixin {
  static const loggerName = 'ActiveUsersBloc';
  final UnitRepository _unitRepository;
  final SessionRepository _sessionRepository;
  ActiveUsersBloc(this._unitRepository, this._sessionRepository)
    : super(const ActiveUsersState()) {
    on<_SetRoomIdEvent>(_onSetRoom);
    on<_RemoveUser>(_removeUser);
    on<_JoinEvent>(_onJoin, transformer: sequential());
  }

  FutureOr<void> _onJoin(
    _JoinEvent event,
    Emitter<ActiveUsersState> emit,
  ) async {
    final channel = event.channel;
    try {
      final session = await _sessionRepository
          .getSession(token: event.token)
          .timeout(_timeoutDuration);
      debugLog('$green ActiveUsersBloc$reset result session: $session');
      if (session == null) {
        channel.sink.add(
          ToClient.authError(error: WsAuthError.tokenSessionNotFound).encoded(),
        );
        return;
      }

      final isValid = _sessionRepository.validateToken(session);
      if (!isValid) {
        channel.sink.add(
          ToClient.authError(error: WsAuthError.expiredToken).encoded(),
        );
        return;
      }
      final SessionChannel? sessionChannel = getSessionChannel(
        session.user.userId,
      );
      if (sessionChannel != null && sessionChannel.channel != channel) {
        final previousChannel = sessionChannel.channel;
        // заменить канал в сессии на новый , это позволит передать подписки
        // на новый канал
        sessionChannel.replaceChannel(channel);
        // сообщить что сессия была прервана другой сессией
        previousChannel?.sink.add(
          ToClient.authError(
            error: WsAuthError.stoppedByAnotherSession,
          ).encoded(),
        );
        // сообщить что сессия прервала другую сессию
        channel.sink.add(
          ToClient.authError(error: WsAuthError.continueAsNewSession).encoded(),
        );
        return;
      }

      final unit = await _unitRepository
          .getSelectedUnit(session.user.userId)
          .timeout(_timeoutDuration);
      if (unit == null) {
        channel.sink.add(
          ToClient.statusError(error: WsServerError.unitNotFound).encoded(),
        );
        return;
      }
      final gameSession = GameSession.fromSession(session, Unit.fromDto(unit));
      addSession(channel, gameSession);
      final newSessionChannel = getSessionChannel(gameSession.user.userId);
      if (newSessionChannel == null) return;
      subscribe(newSessionChannel);
      newSessionChannel.shouldUnsubscribe.add(
        () => unsubscribe(newSessionChannel),
      );
      channel.sink.add(gameSession.sessionDTO(state.roomId).encoded());
      emit(state.copyWith(gameSessions: getListGameSessions()));
    } on TimeoutException {
      channel.sink.add(ToClient.statusError(error: WsServerError.timeout));
    } on Object catch (e, s) {
      // addError(e, s);
      debugLog('$red [ActiveUsersBloc] _onJoin $e $s $reset');
      channel.sink.add(
        ToClient.statusError(error: WsServerError.authenticationFailed),
      );
    }
  }

  void _removeUser(_RemoveUser event, Emitter<ActiveUsersState> emit) {
    final userId = getUserId(event.channel);
    if (userId == null) return;
    final sessionChannel = getSessionChannel(userId);
    sessionChannel?.dispose();
    removeChannelID(event.channel);
    removeIDsession(userId);
    emit(state.copyWith(gameSessions: getListGameSessions()));
  }

  FutureOr<void> _onSetRoom(
    _SetRoomIdEvent event,
    Emitter<ActiveUsersState> emit,
  ) {
    emit(ActiveUsersState(roomId: event.roomId));
  }
}
