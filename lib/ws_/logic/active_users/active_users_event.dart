part of 'active_users_bloc.dart';

@freezed
sealed class ActiveUsersEvent with _$ActiveUsersEvent {
  const ActiveUsersEvent._();
  @Implements<SequentialActive_UsersEvent>()
  const factory ActiveUsersEvent.withToken(
    WebSocketChannel channel,
    String token,
  ) = _WithTokenEvent;

  @Implements<SequentialActive_UsersEvent>()
  const factory ActiveUsersEvent.withRefresh(
    WebSocketChannel channel,
    String refreshToken,
  ) = _WithRefreshTokenEvent;

  @Implements<SequentialActive_UsersEvent>()
  const factory ActiveUsersEvent.login(
    WebSocketChannel channel,
    EmailCredentialDto dto,
  ) = _LoginEvent;

  const factory ActiveUsersEvent.removeUser(WebSocketChannel channel) =
      _RemoveUser;
}

sealed class SequentialActive_UsersEvent implements ActiveUsersEvent {}
