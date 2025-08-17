import 'dart:async';
import 'dart:convert';

import 'package:backend/game/unit.dart';
import 'package:backend/game/unit_repository.dart';
import 'package:backend/user/session.dart';
import 'package:backend/user/session_repository.dart';
import 'package:backend/user/user_repository.dart';
import 'package:backend/user/ws_active_sessions.dart';
import 'package:broadcast_bloc/broadcast_bloc.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:sha_red/sha_red.dart';

part 'active_users.event.dart';
part 'active_users.state.dart';

// active_users_bloc.dart
@lazySingleton
class ActiveUsersBloc
    extends BroadcastBloc<ActiveUsersEvent, ActiveUsersState> {
  final WsActiveSessions _activeSessions;
  final UnitRepository _unitRepository;
  final UserRepository _userRepository;
  final SessionRepository _sessionRepository;
  ActiveUsersBloc(
    this._activeSessions,
    this._unitRepository,
    this._sessionRepository,
    this._userRepository,
  ) : super(const ActiveUsersState([])) {
    on<AddUser>(_addUser);
    on<RemoveUser>(_removeUser);
    on<_WithTokenEvent>(_withToken);
    on<_WithRefreshTokenEvent>(_withRefreshToken);
    on<_LoginEvent>(_login);
  }

  FutureOr<void> _withToken(
    _WithTokenEvent event,
    Emitter<ActiveUsersState> emit,
  ) async {
    final channel = event.channel;
    try {
      final session = await _sessionRepository.getSession(token: event.token);
      if (session == null) {
        channel.sink.add(
          WWsFromServer.statusError(
            error: WsServerError.authenticationFailed,
          ).encoded(),
        );
        return;
      }
      ;
      final isTokenValid = _sessionRepository.validateToken(session);
      if (isTokenValid) {
        channel.sink.add(
          WWsFromServer.statusError(
            error: WsServerError.invalidToken,
          ).encoded(),
        );
        return;
      }
      ;
      final unit = await _unitRepository.getSelectedUnit(session.user.userId);
      if (unit == null) {
        channel.sink.add(
          WWsFromServer.statusError(
            error: WsServerError.unitNotFound,
          ).encoded(),
        );
        return;
      }
      final gameSession = GameSession.fromSession(session, Unit.fromDto(unit));
      _activeSessions.addSession(channel, gameSession);
      final disposer = _activeSessions.getDisposer(channel);
      if (!state.gameSessions.contains(gameSession)) {
        final updatedList = [...state.gameSessions, gameSession];
        subscribe(channel);
        channel.sink.add(gameSession.toEncodedTokens());
        disposer!.shouldUnsubscribe.add(unsubscribe);
        emit(ActiveUsersState(updatedList));
      } else {
        channel.sink.add(
          WWsFromServer.statusError(
            error: WsServerError.sessionAlreadyRegistered,
          ).encoded(),
        );
      }
    } catch (e, s) {
      addError(e, s);
      channel.sink.add(
        WWsFromServer.statusError(
          error: WsServerError.authenticationFailed,
        ).encoded(),
      );
    }
  }

  FutureOr<void> _withRefreshToken(
    _WithRefreshTokenEvent event,
    Emitter<ActiveUsersState> emit,
  ) async {
    final channel = event.channel;
    try {
      final session = await _sessionRepository.getSession(
        refreshToken: event.refreshToken,
      );
      if (session == null) {
        channel.sink.add(
          WWsFromServer.statusError(
            error: WsServerError.authenticationFailed,
          ).encoded(),
        );
        return;
      }
      ;
      final isRefreshValid = _sessionRepository.validateRefreshToken(session);
      if (isRefreshValid) {
        channel.sink.add(
          WWsFromServer.statusError(
            error: WsServerError.sessionExpired,
          ).encoded(),
        );
        return;
      }
      ;
      final unit = await _unitRepository.getSelectedUnit(session.user.userId);
      if (unit == null) {
        channel.sink.add(
          WWsFromServer.statusError(
            error: WsServerError.unitNotFound,
          ).encoded(),
        );
        return;
      }
      final gameSession = GameSession.fromSession(session, Unit.fromDto(unit));
      _activeSessions.addSession(channel, gameSession);
      final disposer = _activeSessions.getDisposer(channel);
      if (!state.gameSessions.contains(gameSession)) {
        final updatedList = [...state.gameSessions, gameSession];
        subscribe(channel);
        channel.sink.add(gameSession.toEncodedTokens());
        disposer!.shouldUnsubscribe.add(unsubscribe);
        emit(ActiveUsersState(updatedList));
      } else {
        channel.sink.add(
          WWsFromServer.statusError(
            error: WsServerError.sessionAlreadyRegistered,
          ).encoded(),
        );
      }
    } catch (e, s) {
      addError(e, s);
      channel.sink.add(
        WWsFromServer.statusError(
          error: WsServerError.authenticationFailed,
        ).encoded(),
      );
    }
  }

  FutureOr<void> _login(
    _LoginEvent event,
    Emitter<ActiveUsersState> emit,
  ) async {
    final channel = event.channel;
    try {
      final user = await _userRepository.loginUser(event.dto);
      final session = await _sessionRepository.createSession(user);
      final unit = await _unitRepository.getSelectedUnit(session.user.userId);
      if (unit == null) {
        channel.sink.add(
          WWsFromServer.statusError(
            error: WsServerError.unitNotFound,
          ).encoded(),
        );
        return;
      }
      final gameSession = GameSession.fromSession(session, Unit.fromDto(unit));
      _activeSessions.addSession(channel, gameSession);
      final disposer = _activeSessions.getDisposer(channel);
      if (!state.gameSessions.contains(gameSession)) {
        final updatedList = [...state.gameSessions, gameSession];
        subscribe(channel);
        channel.sink.add(gameSession.toEncodedTokens());
        disposer!.shouldUnsubscribe.add(unsubscribe);
        emit(ActiveUsersState(updatedList));
      } else {
        channel.sink.add(
          WWsFromServer.statusError(
            error: WsServerError.sessionAlreadyRegistered,
          ).encoded(),
        );
      }
    } catch (e, s) {
      addError(e, s);
      channel.sink.add(
        WWsFromServer.statusError(
          error: WsServerError.authenticationFailed,
        ).encoded(),
      );
    }
  }

  void _addUser(AddUser event, Emitter<ActiveUsersState> emit) {
    // Only add if the user isn't already in the list.
    final session = _activeSessions.getSession(event.channel);
    final disposer = _activeSessions.getDisposer(event.channel);
    if (session == null || disposer == null) return;
    if (!state.gameSessions.contains(session)) {
      final updatedList = [...state.gameSessions, session];
      subscribe(event.channel);
      disposer.shouldUnsubscribe.add(unsubscribe);
      emit(ActiveUsersState(updatedList));
    }
  }

  void _removeUser(RemoveUser event, Emitter<ActiveUsersState> emit) {
    final updatedList = state.gameSessions
        .where((session) => session != event.session)
        .toList();
    emit(ActiveUsersState(updatedList));
  }
}
