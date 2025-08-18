part of 'active_users_bloc.dart';

@Freezed(copyWith: false)
sealed class ActiveUsersEvent with _$ActiveUsersEvent {
  const ActiveUsersEvent._();
  const factory ActiveUsersEvent.join({
    required WebSocketChannel channel,
    String? token,
    String? refreshToken,
  }) = _JoinEvent;

  const factory ActiveUsersEvent.removeUser(WebSocketChannel channel) =
      _RemoveUser;
}
