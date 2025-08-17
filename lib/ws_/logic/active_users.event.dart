part of 'active_users.bloc.dart';

abstract class ActiveUsersEvent extends Equatable {
  const ActiveUsersEvent();

  factory ActiveUsersEvent.addUser(WebSocketChannel channel) = AddUser;

  const factory ActiveUsersEvent.withToken(
    WebSocketChannel channel,
    String token,
  ) = _WithTokenEvent;
  const factory ActiveUsersEvent.withRefresh(
    WebSocketChannel channel,
    String refreshToken,
  ) = _WithRefreshTokenEvent;

  const factory ActiveUsersEvent.login(
    WebSocketChannel channel,
    EmailCredentialDto dto,
  ) = _LoginEvent;

  factory ActiveUsersEvent.removeUser(GameSession session) = RemoveUser;
}

class AddUser extends ActiveUsersEvent {
  final WebSocketChannel channel;
  const AddUser(this.channel);
  @override
  List<Object> get props => [channel];
}

class _WithTokenEvent extends ActiveUsersEvent {
  final WebSocketChannel channel;
  final String token;
  const _WithTokenEvent(this.channel, this.token);
  @override
  List<Object> get props => [channel, token];
}

class _WithRefreshTokenEvent extends ActiveUsersEvent {
  final WebSocketChannel channel;
  final String refreshToken;
  const _WithRefreshTokenEvent(this.channel, this.refreshToken);
  @override
  List<Object> get props => [channel, refreshToken];
}

class _LoginEvent extends ActiveUsersEvent {
  final WebSocketChannel channel;
  final EmailCredentialDto dto;
  const _LoginEvent(this.channel, this.dto);
  @override
  List<Object> get props => [channel, dto];
}

class RemoveUser extends ActiveUsersEvent {
  final GameSession session;
  const RemoveUser(this.session);
  @override
  List<Object> get props => [session];
}
