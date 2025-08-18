part of 'active_users.bloc.dart';

class ActiveUsersState extends Equatable {
  const ActiveUsersState(this.gameSessions);
  final List<GameSession> gameSessions;

  @override
  List<Object?> get props => [gameSessions];

  /// jsonEncode(this)
  @override
  String toString() {
    final asMap = ToClient.onlineUsers(
      OnlineMemberPayload(
        gameSessions
            .map((i) => OnlineMemberDto(i.unit.id, i.unit.name))
            .toList(),
      ),
    ).toJson();
    final json = jsonEncode(asMap);
    return json;
  }
}
