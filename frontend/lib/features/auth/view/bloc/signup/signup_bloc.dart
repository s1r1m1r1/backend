import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:frontend/features/auth/domain/auth_repository.dart';
import 'package:injectable/injectable.dart';

part 'signup_event.dart';
part 'signup_state.dart';

@injectable
class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final AuthRepository _authRepository;

  SignupBloc(this._authRepository) : super(SignupInitial()) {
    on<SignupButtonPressed>(_onSignupButtonPressed);
  }

  void _onSignupButtonPressed(SignupButtonPressed event, Emitter<SignupState> emit) async {
    emit(SignupLoading());
    try {
      await _authRepository.signup(event.email, event.password);
      emit(const SignupSuccess('Signup successful! Please log in.'));
    } catch (e) {
      emit(SignupFailure(e.toString()));
    }
  }
}
