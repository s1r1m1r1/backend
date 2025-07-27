import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../features/auth/domain/auth_repository.dart';

@lazySingleton
class AuthInterceptor extends Interceptor {
  final AuthRepository _authRepository;

  AuthInterceptor(this._authRepository);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = _authRepository.getToken(); // Retrieve token from secure storage
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Handle token refresh logic here if needed (e.g., 401 Unauthorized)
    if (err.response?.statusCode == 401) {
      debugPrint('Unauthorized. Attempting to refresh token...');
      _authRepository.onTokenExpired();
      // Potentially attempt to refresh token and retry the request
    }
    super.onError(err, handler);
  }
}

@lazySingleton
class RegistrationInterceptor extends Interceptor {
  RegistrationInterceptor();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    debugPrint('Request URL: ${options.uri} body: ${options.data}');
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Handle token refresh logic here if needed (e.g., 401 Unauthorized)
    if (err.response?.statusCode == 401) {
      debugPrint('Unauthorized. Attempting to refresh token...');
      // Potentially attempt to refresh token and retry the request
    }
    super.onError(err, handler);
  }
}
