import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:frontend/core/network/registration_api_service.dart';
import 'package:frontend/db/db_client.dart';
import 'package:rxdart/rxdart.dart';
import 'package:injectable/injectable.dart';

import '../data/request_email_credential_dto.dart';
import 'auth_status.dart';

abstract class AuthRepository {
  Future<void> init();
  void dispose();
  Future<bool> login(String email, String password);

  AuthStatus get authStatus;
  Stream<AuthStatus> get authStatusStream;

  String? getToken();

  void onTokenExpired();

  Future<void> signup(String email, String password);
}

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl extends AuthRepository {
  final RegistrationApiService _api;
  final DbClient _client;
  AuthRepositoryImpl(this._api, this._client) {
    init();
  }

  @override
  Future<void> init() async {
    try {
      final token = await _client.getKeyValue('accessToken');
      _tokenSubj.add(token);
      _authStatusSbj.add(token != null ? AuthStatus.loggedIn : AuthStatus.loggedOut);
    } catch (e) {
      debugPrint(e.toString());
    }
    // _sessionManager.addListener(_onChangeSessionStatus);
  }

  final _tokenSubj = BehaviorSubject<String?>();

  @override
  Stream<AuthStatus> get authStatusStream => _authStatusSbj.stream;

  final _authStatusSbj = BehaviorSubject<AuthStatus>.seeded(AuthStatus.loggedOut);

  void _onChangeSessionStatus() {
    // _authStatusSbj.value = _sessionManager.isSignedIn ? AuthStatus.loggedIn : AuthStatus.loggedOut;
  }

  @override
  @disposeMethod
  void dispose() {
    // _sessionManager.removeListener(_onChangeSessionStatus);
  }

  @override
  AuthStatus get authStatus => _authStatusSbj.value;

  @override
  String? getToken() => _tokenSubj.value;

  @override
  void onTokenExpired() {
    unawaited(_client.deleteKeyValue('accessToken'));
    _tokenSubj.add(null);
    _authStatusSbj.add(AuthStatus.loggedOut);
  }

  @override
  Future<bool> login(String email, String password) async {
    try {
      debugPrint('login');
      final tokens = await _api.login(RequestEmailCredentialDto(email: email, password: password));
      await _client.saveKeyValue('accessToken', tokens.accessToken);
      _authStatusSbj.add(AuthStatus.loggedIn);
      _tokenSubj.add(tokens.accessToken);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> signup(String email, String password) async {
    final response = await _api.signup(RequestEmailCredentialDto(email: email, password: password));
    await _client.saveKeyValue('accessToken', response.accessToken);
    _authStatusSbj.add(AuthStatus.loggedIn);
    _tokenSubj.add(response.accessToken);
  }
}
