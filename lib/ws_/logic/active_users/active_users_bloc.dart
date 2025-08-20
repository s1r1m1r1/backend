import 'dart:async';
import 'dart:convert';

import 'package:backend/core/debug_log.dart';
import 'package:backend/core/log_colors.dart';
import 'package:backend/game/unit.dart';
import 'package:backend/game/unit_repository.dart';
import 'package:backend/user/session.dart';
import 'package:backend/user/session_repository.dart';
import 'package:backend/ws_/logic/active_users/active_sessions_mixin.dart';
import 'package:backend/ws_/model/web_socket_disposer.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:broadcast_bloc/broadcast_bloc.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:sha_red/sha_red.dart';

part 'active_users_event.dart';
part 'active_users_state.dart';
part 'active_users_bloc.freezed.dart';

const _timeoutDuration = Duration(milliseconds: 100);

@lazySingleton
class ActiveUsersBloc extends BroadcastBloc<ActiveUsersEvent, ActiveUsersState>
    with ActiveUsersMixin {
  final UnitRepository _unitRepository;
  final SessionRepository _sessionRepository;
  ActiveUsersBloc(this._unitRepository, this._sessionRepository)
    : super(const ActiveUsersState([])) {
    on<_RemoveUser>(_removeUser);
    on<_JoinEvent>(_onJoin, transformer: sequential());
  }

  FutureOr<void> _onJoin(
    _JoinEvent event,
    Emitter<ActiveUsersState> emit,
  ) async {
    final channel = event.channel;
    try {
      final isRefresh = event.isRefresh;
      final session = await _sessionRepository
          .getSession(
            token: isRefresh ? null : event.token,
            refreshToken: isRefresh ? event.token : null,
          )
          .timeout(_timeoutDuration);
      if (session == null) {
        channel.sink.add(
          ToClient.statusError(error: WsServerError.sessionExpired).encoded(),
        );
        return;
      }

      final isValid = _sessionRepository.validateToken(session);
      if (isValid) {
        channel.sink.add(
          ToClient.statusError(
            error: isRefresh
                ? WsServerError.sessionExpired
                : WsServerError.invalidToken,
          ).encoded(),
        );
        return;
      }
      final existingChannel = getChannelForUser(session.user.userId);
      if (existingChannel != null && existingChannel != channel) {
        removeSession(existingChannel);
        final disposer = getDisposer(channel);
        existingChannel.sink.add(
          ToClient.statusError(
            error: WsServerError.finishedDuplicateSession,
          ).encoded(),
        );
        await existingChannel.sink.close(1000, 'New login from another device');
        disposer?.dispose();
        removeDisposer(channel);
        debugLog('Closed old session for user ${session.user.userId}');
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
      final WebSocketDisposer? disposer = getDisposer(channel);
      subscribe(channel);
      disposer?.shouldUnsubscribe.add(() => unsubscribe(channel));

      channel.sink.add(gameSession.encodedSession());
      emit(ActiveUsersState(getListGameSessions()));
    } on TimeoutException {
      channel.sink.add(
        ToClient.statusError(error: WsServerError.timeout).encoded(),
      );
    } on Object catch (e, s) {
      // addError(e, s);
      debugLog('$red [ActiveUsersBloc] _onJoin $e $s $reset');
      channel.sink.add(
        ToClient.statusError(
          error: WsServerError.authenticationFailed,
        ).encoded(),
      );
    }
  }

  void _removeUser(_RemoveUser event, Emitter<ActiveUsersState> emit) {
    removeSession(event.channel);
    final disposer = getDisposer(event.channel);
    disposer?.dispose();
    event.channel.sink.close(1000, 'Removed');
    removeDisposer(event.channel);
    emit(ActiveUsersState(getListGameSessions()));
  }
}
