part of 'active_users_bloc.dart';

@Freezed(copyWith: false)
sealed class ActiveUsersEvent with _$ActiveUsersEvent {
  const ActiveUsersEvent._();
  const factory ActiveUsersEvent.join({
    required WebSocketChannel channel,
    required String token,
    required bool isRefresh,
  }) = _JoinEvent;

  const factory ActiveUsersEvent.removeUser(WebSocketChannel channel) =
      _RemoveUser;
}
