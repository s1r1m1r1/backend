import 'dart:async';
import 'dart:convert';

import 'package:backend/game/unit.dart';
import 'package:backend/game/unit_repository.dart';
import 'package:backend/user/session.dart';
import 'package:backend/user/session_repository.dart';
import 'package:backend/user/user_repository.dart';
import 'package:backend/user/active_sessions_repository.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:broadcast_bloc/broadcast_bloc.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:sha_red/sha_red.dart';

part 'active_users.event.dart';
part 'active_users.state.dart';
part 'active_users.bloc.freezed.dart';

const _timeoutDuration = Duration(milliseconds: 100);

// active_users_bloc.dart
@lazySingleton
class ActiveUsersBloc
    extends BroadcastBloc<ActiveUsersEvent, ActiveUsersState> {
  final ActiveSessionsRepository _activeSessionsRepo;
  final UnitRepository _unitRepository;
  final UserRepository _userRepository;
  final SessionRepository _sessionRepository;
  ActiveUsersBloc(
    this._activeSessionsRepo,
    this._unitRepository,
    this._sessionRepository,
    this._userRepository,
  ) : super(const ActiveUsersState([])) {
    on<_RemoveUser>(_removeUser);
    on<SequentialActive_UsersEvent>((event, emit) async {
      switch (event) {
        case _WithTokenEvent():
          await _withToken(event, emit);
        case _WithRefreshTokenEvent():
          await _withRefreshToken(event, emit);
        case _LoginEvent():
          await _login(event, emit);
      }
    }, transformer: sequential());
  }

  FutureOr<void> _withToken(
    _WithTokenEvent event,
    Emitter<ActiveUsersState> emit,
  ) async {
    final channel = event.channel;
    try {
      final session = await _sessionRepository
          .getSession(token: event.token)
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
      _activeSessionsRepo.addSession(channel, gameSession);
      final disposer = _activeSessionsRepo.getDisposer(channel);
      if (!state.gameSessions.any(
        (session) => session.user.userId == gameSession.user.userId,
      )) {
        final updatedList = [...state.gameSessions, gameSession];
        subscribe(channel);
        disposer!.shouldUnsubscribe.add(unsubscribe);
        channel.sink.add(gameSession.toEncodedTokens());
        emit(ActiveUsersState(updatedList));
      } else {
        _activeSessionsRepo.finishOtherSession(channel, gameSession);
        final updatedList = List.of(state.gameSessions)
          ..removeWhere((i) => session.user.userId == gameSession.user.userId)
          ..add(gameSession);
        subscribe(channel);
        disposer!.shouldUnsubscribe.add(unsubscribe);
        channel.sink.add(gameSession.toEncodedTokens());
        emit(ActiveUsersState(updatedList));
      }
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

  FutureOr<void> _withRefreshToken(
    _WithRefreshTokenEvent event,
    Emitter<ActiveUsersState> emit,
  ) async {
    final channel = event.channel;
    try {
      final session = await _sessionRepository
          .getSession(refreshToken: event.refreshToken)
          .timeout(_timeoutDuration);
      if (session == null) {
        channel.sink.add(
          ToClient.statusError(
            error: WsServerError.authenticationFailed,
          ).encoded(),
        );
        return;
      }
      ;
      final isValid = _sessionRepository.validateRefreshToken(session);
      if (!isValid) {
        channel.sink.add(
          ToClient.statusError(error: WsServerError.sessionExpired).encoded(),
        );
        return;
      }
      ;
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
      _activeSessionsRepo.addSession(channel, gameSession);
      final disposer = _activeSessionsRepo.getDisposer(channel);
      if (!state.gameSessions.any(
        (session) => session.user.userId == gameSession.user.userId,
      )) {
        final updatedList = [...state.gameSessions, gameSession];
        subscribe(channel);
        disposer!.shouldUnsubscribe.add(unsubscribe);
        channel.sink.add(gameSession.toEncodedTokens());
        emit(ActiveUsersState(updatedList));
      } else {
        _activeSessionsRepo.finishOtherSession(channel, gameSession);
        final updatedList = List.of(state.gameSessions)
          ..removeWhere((i) => session.user.userId == gameSession.user.userId)
          ..add(gameSession);
        subscribe(channel);
        disposer!.shouldUnsubscribe.add(unsubscribe);
        channel.sink.add(gameSession.toEncodedTokens());
        emit(ActiveUsersState(updatedList));
      }
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

  FutureOr<void> _login(
    _LoginEvent event,
    Emitter<ActiveUsersState> emit,
  ) async {
    final channel = event.channel;
    try {
      final user = await _userRepository
          .loginUser(event.dto)
          .timeout(_timeoutDuration);
      final session = await _sessionRepository
          .createSession(user)
          .timeout(_timeoutDuration);
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
      _activeSessionsRepo.addSession(channel, gameSession);
      final disposer = _activeSessionsRepo.getDisposer(channel);
      if (!state.gameSessions.any(
        (session) => session.user.userId == gameSession.user.userId,
      )) {
        final updatedList = [...state.gameSessions, gameSession];
        subscribe(channel);
        disposer!.shouldUnsubscribe.add(unsubscribe);
        channel.sink.add(gameSession.toEncodedTokens());
        emit(ActiveUsersState(updatedList));
      } else {
        _activeSessionsRepo.finishOtherSession(channel, gameSession);
        final updatedList = List.of(state.gameSessions)
          ..removeWhere((i) => session.user.userId == gameSession.user.userId)
          ..add(gameSession);
        channel.sink.add(
          ToClient.statusError(
            error: WsServerError.sessionAlreadyRegistered,
          ).encoded(),
        );
      }
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
    final updatedList = state.gameSessions
        .where((session) => session != event.session)
        .toList();
    emit(ActiveUsersState(updatedList));
  }
}
