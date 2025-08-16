import 'dart:convert';

import 'package:backend/user/session.dart';
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
  ActiveUsersBloc(this._activeSessions) : super(const ActiveUsersState([])) {
    on<AddUser>(_addUser);
    on<RemoveUser>(_removeUser);
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
