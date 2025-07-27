import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../services/api_service.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final ApiService _apiService;

  SignupBloc(this._apiService) : super(SignupInitial()) {
    on<SignupButtonPressed>(_onSignupButtonPressed);
  }

  void _onSignupButtonPressed(SignupButtonPressed event, Emitter<SignupState> emit) async {
    emit(SignupLoading());
    try {
      await _apiService.signup(event.username, event.email, event.password);
      emit(const SignupSuccess('Signup successful! Please log in.'));
    } catch (e) {
      emit(SignupFailure(e.toString()));
    }
  }
}
