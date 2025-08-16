part of 'active_users.bloc.dart';

abstract class ActiveUsersEvent extends Equatable {
  const ActiveUsersEvent();
}

class AddUser extends ActiveUsersEvent {
  final GameSession session;
  const AddUser(this.session);
  @override
  List<Object> get props => [session];
}

class RemoveUser extends ActiveUsersEvent {
  final GameSession session;
  const RemoveUser(this.session);
  @override
  List<Object> get props => [session];
}
