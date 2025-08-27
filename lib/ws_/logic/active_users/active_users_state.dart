part of 'active_users_bloc.dart';

class ActiveUsersState extends Equatable implements BroadcastState {
  const ActiveUsersState({
    this.gameSessions = const <GameSession>[],
    this.roomId = -1,
  });
  final List<GameSession> gameSessions;
  final int roomId;

  @override
  List<Object?> get props => [gameSessions, roomId];

  ActiveUsersState copyWith({List<GameSession>? gameSessions, int? roomId}) {
    return ActiveUsersState(
      gameSessions: gameSessions ?? this.gameSessions,
      roomId: roomId ?? this.roomId,
    );
  }

  @override
  ToClient? toClient() {
    return ToClient.onlineUsers(
      OnlineMemberPayload(
        roomId: roomId,
        members: gameSessions
            .map((i) => OnlineMemberDto(i.unit.id, i.unit.name))
            .toList(),
      ),
    );
  }
}
