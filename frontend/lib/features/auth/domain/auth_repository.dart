import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:frontend/core/network/registration_api_service.dart';
import 'package:frontend/db/db_client.dart';
import 'package:rxdart/rxdart.dart';
import 'package:injectable/injectable.dart';

import '../../../app/logger/log_colors.dart';
import '../data/request_email_credential_dto.dart';
import 'auth_status.dart';

const _tokenKey = '__tokenK__';
const _refreshTokenK = '__refreshTokenK__';

abstract class AuthRepository {
  Future<void> init();
  void dispose();
  Future<bool> login(String email, String password);

  AuthStatus get authStatus;
  Stream<AuthStatus> get authStatusStream;

  String? getToken();
  String? getRefreshToken();

  void onTokenExpired();

  Future<void> signup(String email, String password);

  Future<bool> refreshAccessToken();
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
      final token = await _client.getKeyValue(_tokenKey);
      final refreshToken = await _client.getKeyValue(_refreshTokenK);
      debugPrint('$green LOADED token: $token ,refresh: $refreshToken $reset');
      _tokenSubj.add(token);
      _refreshTokenSubj.add(refreshToken);
      _authStatusSbj.add(token != null ? AuthStatus.loggedIn : AuthStatus.loggedOut);
    } catch (e) {
      debugPrint(e.toString());
    }
    // _sessionManager.addListener(_onChangeSessionStatus);
  }

  final _tokenSubj = BehaviorSubject<String?>.seeded(null);
  final _refreshTokenSubj = BehaviorSubject<String?>.seeded(null);

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
  String? getRefreshToken() => _refreshTokenSubj.value;

  @override
  void onTokenExpired() {
    debugPrint('$red onTokenExpired $reset');
    unawaited(_client.deleteKeyValue(_tokenKey));
    _tokenSubj.add(null);
    _authStatusSbj.add(AuthStatus.loggedOut);
  }

  @override
  void onRefreshTokenExpired() {
    unawaited(_client.deleteKeyValue(_refreshTokenK));
    _tokenSubj.add(null);
    _authStatusSbj.add(AuthStatus.loggedOut);
  }

  @override
  Future<bool> login(String email, String password) async {
    try {
      debugPrint('login');
      final response = await _api.login(RequestEmailCredentialDto(email: email, password: password));
      _authStatusSbj.add(AuthStatus.loggedIn);
      _refreshTokenSubj.add(response.refreshToken);
      _tokenSubj.add(response.accessToken);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> signup(String email, String password) async {
    final response = await _api.signup(RequestEmailCredentialDto(email: email, password: password));
    await _client.saveKeyValue(_tokenKey, response.accessToken);
    await _client.saveKeyValue(_refreshTokenK, response.refreshToken);
    _authStatusSbj.add(AuthStatus.loggedIn);
    _refreshTokenSubj.add(response.refreshToken);
    _tokenSubj.add(response.accessToken);
  }

  @override
  Future<bool> refreshAccessToken() async {
    if (_refreshTokenSubj.value == null) {
      debugPrint('No refresh token available');
      return false;
    }
    try {
      final tokens = await _api.refresh(_refreshTokenSubj.value!);
      await _client.saveKeyValue(_tokenKey, tokens.accessToken);
      await _client.saveKeyValue(_refreshTokenK, tokens.refreshToken);
      _refreshTokenSubj.add(tokens.refreshToken);
      _tokenSubj.add(tokens.accessToken);
      _authStatusSbj.add(AuthStatus.loggedIn);
      return true;
    } catch (e) {
      debugPrint('Failed to refresh access token: $e');
      return false;
    }
  }
}
