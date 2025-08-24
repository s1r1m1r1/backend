part of 'active_users_bloc.dart';

@Freezed(copyWith: false)
sealed class ActiveUsersEvent with _$ActiveUsersEvent {
  const ActiveUsersEvent._();
  const factory ActiveUsersEvent.setRoomId(int roomId) = _SetRoomIdEvent;
  const factory ActiveUsersEvent.join({
    required WebSocketChannel channel,
    required String token,
  }) = _JoinEvent;

  const factory ActiveUsersEvent.removeUser(WebSocketChannel channel) =
      _RemoveUser;
}
