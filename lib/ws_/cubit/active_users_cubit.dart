// active_users_cubit.dart
import 'dart:convert';

import 'package:backend/user/session.dart';
import 'package:broadcast_bloc/broadcast_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sha_red/sha_red.dart';

class ActiveUsersCubit extends BroadcastCubit<ActiveMembersState> {
  ActiveUsersCubit() : super(ActiveMembersState(const []));

  // Method to add a user to the state
  void addUser(GameSession session) {
    // Only add if the user isn't already in the list.
    if (!state.gameSessions.contains(session)) {
      final updatedList = [...state.gameSessions, session];
      emit(ActiveMembersState(updatedList));
    }
  }

  // Method to remove a user from the state
  void removeUser(GameSession session) {
    final updatedList = state.gameSessions.where((user) => user != session).toList();
    emit(ActiveMembersState(updatedList));
  }
}

class ActiveMembersState extends Equatable {
  ActiveMembersState(this.gameSessions);
  final List<GameSession> gameSessions;

  @override
  List<Object?> get props => [gameSessions];

  /// jsonEncode(this)
  @override
  String toString() {
    final asMap = WsFromServer(
      eventType: WsEventFromServer.onlineUsers,
      payload: OnlineMemberPayload(
        members: gameSessions.map((i) => OnlineMemberDto(i.unit.id, i.unit.name)).toList(),
      ),
    ).toJson(OnlineMemberPayload.toJsonF);
    final json = jsonEncode(asMap);
    return json;
  }
}

// final t = OnlineMemberDto();
