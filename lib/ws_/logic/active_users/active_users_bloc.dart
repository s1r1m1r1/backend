import 'dart:async';
import 'dart:convert';

import 'package:backend/core/debug_log.dart';
import 'package:backend/game/unit.dart';
import 'package:backend/game/unit_repository.dart';
import 'package:backend/user/session.dart';
import 'package:backend/user/session_repository.dart';
import 'package:backend/user/user_repository.dart';
import 'package:backend/ws_/logic/active_users/active_sessions_mixin.dart';
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

// active_users_bloc.dart
@lazySingleton
class ActiveUsersBloc extends BroadcastBloc<ActiveUsersEvent, ActiveUsersState>
    with ActiveUsersMixin {
  final UnitRepository _unitRepository;
  final UserRepository _userRepository;
  final SessionRepository _sessionRepository;
  ActiveUsersBloc(
    this._unitRepository,
    this._sessionRepository,
    this._userRepository,
  ) : super(const ActiveUsersState([])) {
    on<_RemoveUser>(_removeUser);
    on<_JoinEvent>(_onJoin, transformer: sequential());
  }

  FutureOr<void> _onJoin(
    _JoinEvent event,
    Emitter<ActiveUsersState> emit,
  ) async {
    final channel = event.channel;
    try {
      if (event.token == null && event.refreshToken == null) return;
      final session = await _sessionRepository
          .getSession(token: event.token, refreshToken: event.refreshToken)
          .timeout(_timeoutDuration);

      if (session == null) {
        channel.sink.add(
          ToClient.statusError(
            error: WsServerError.authenticationFailed,
          ).encoded(),
        );
        return;
      }

      final isValid = _sessionRepository.validateToken(session);
      if (isValid) {
        channel.sink.add(
          ToClient.statusError(error: WsServerError.invalidToken).encoded(),
        );
        return;
      }
      final existingChannel = getChannelForUser(session.user.userId);
      if (existingChannel != null && existingChannel != channel) {
        existingChannel.sink.add(
          ToClient.statusError(
            error: WsServerError.finishedDuplicateSession,
          ).encoded(),
        );
        await existingChannel.sink.close(1000, 'New login from another device');
        debugLog('Closed old session for user ${session.user.userId}');
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
      final disposer = getDisposer(channel);
      subscribe(channel);
      disposer!.shouldUnsubscribe.add(unsubscribe);
      channel.sink.add(gameSession.toEncodedTokens());
      emit(ActiveUsersState(getListGameSessions()));
    } on TimeoutException {
      channel.sink.add(
        ToClient.statusError(error: WsServerError.timeout).encoded(),
      );
    } on Object catch (e, s) {
      addError(e, s);
      channel.sink.add(
        ToClient.statusError(
          error: WsServerError.authenticationFailed,
        ).encoded(),
      );
    }
  }

  void _removeUser(_RemoveUser event, Emitter<ActiveUsersState> emit) {
    removeSession(event.channel);
    event.channel.sink.close();
    emit(ActiveUsersState(getListGameSessions()));
  }
}
