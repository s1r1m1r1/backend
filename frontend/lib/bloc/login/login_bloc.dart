import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../services/api_service.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final ApiService _apiService;

  LoginBloc(this._apiService) : super(LoginInitial()) {
    on<LoginButtonPressed>(_onLoginButtonPressed);
  }

  void _onLoginButtonPressed(LoginButtonPressed event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    try {
      final response = await _apiService.login(event.username, event.password);
      emit(LoginSuccess('Login successful! Welcome ${response['username'] ?? ''}'));
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }
}
