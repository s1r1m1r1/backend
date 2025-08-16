part of 'active_users.bloc.dart';

abstract class ActiveUsersEvent extends Equatable {
  const ActiveUsersEvent();

  factory ActiveUsersEvent.addUser(WebSocketChannel channel) = AddUser;
  factory ActiveUsersEvent.removeUser(GameSession session) = RemoveUser;
}

class AddUser extends ActiveUsersEvent {
  final WebSocketChannel channel;
  const AddUser(this.channel);
  @override
  List<Object> get props => [channel];
}

class RemoveUser extends ActiveUsersEvent {
  final GameSession session;
  const RemoveUser(this.session);
  @override
  List<Object> get props => [session];
}
