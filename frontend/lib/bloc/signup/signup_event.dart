part of 'signup_bloc.dart';

abstract class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object> get props => [];
}

class SignupButtonPressed extends SignupEvent {
  final String username;
  final String email;
  final String password;

  const SignupButtonPressed({required this.username, required this.email, required this.password});

  @override
  List<Object> get props => [username, email, password];
}
