// lib/blocs/user/user_event.dart

part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class LoadUsers extends UserEvent {}

class AddUser extends UserEvent {
  final User user;
  const AddUser(this.user);
  @override
  List<Object> get props => [user];
}

class DeleteUser extends UserEvent {
  final String id;
  const DeleteUser(this.id);
  @override
  List<Object> get props => [id];
}

class UpdateUser extends UserEvent {
  final User user;
  const UpdateUser(this.user);
  @override
  List<Object> get props => [user];
}
