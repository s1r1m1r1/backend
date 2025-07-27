import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/auth_repository.dart';
import '../../domain/auth_status.dart';

@injectable
class AuthCubit extends Cubit<AuthStatus> with ChangeNotifier {
  final AuthRepository _authRepository;
  AuthCubit(this._authRepository) : super(AuthStatus.loggedOut);

  StreamSubscription? _subscription;

  void subscribe() {
    _subscription = _authRepository.authStatusStream.listen((status) {
      if (state != status) {
        emit(status);
        notifyListeners();
      }
    });
  }

  @override
  Future<void> close() async {
    _subscription?.cancel();
    return await super.close();
  }
}
