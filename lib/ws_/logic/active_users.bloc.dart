import 'dart:convert';

import 'package:backend/user/session.dart';
import 'package:broadcast_bloc/broadcast_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sha_red/sha_red.dart';

part 'active_users.event.dart';
part 'active_users.state.dart';

// active_users_bloc.dart
class ActiveUsersBloc extends BroadcastBloc<ActiveUsersEvent, ActiveUsersState> {
  ActiveUsersBloc() : super(const ActiveUsersState([])) {
    on<AddUser>(_addUser);
    on<RemoveUser>(_removeUser);
  }

  void _addUser(AddUser event, Emitter<ActiveUsersState> emit) {
    // Only add if the user isn't already in the list.
    if (!state.gameSessions.contains(event.session)) {
      final updatedList = [...state.gameSessions, event.session];
      emit(ActiveUsersState(updatedList));
    }
  }

  void _removeUser(RemoveUser event, Emitter<ActiveUsersState> emit) {
    final updatedList = state.gameSessions.where((session) => session != event.session).toList();
    emit(ActiveUsersState(updatedList));
  }
}
