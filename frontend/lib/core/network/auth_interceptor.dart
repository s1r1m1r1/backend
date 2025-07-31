import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../features/auth/domain/auth_repository.dart';

class AuthInterceptor extends Interceptor {
  final AuthRepository _authRepository;
  final Dio retryDio;

  AuthInterceptor(this._authRepository, this.retryDio);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = _authRepository.getToken(); // Retrieve token from secure storage
    if (token != null) {
      debugPrint('with Bearer $token');
      options.headers['Authorization'] = 'Bearer $token';
    } else {
      debugPrint('No token found, proceeding without Authorization header');
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint('Response body: ${response.data} status code: ${response.statusCode}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Handle token refresh logic here if needed (e.g., 401 Unauthorized)
    if (err.response?.statusCode == 401) {
      debugPrint('Unauthorized. Attempting to refresh token...');
      _authRepository.onTokenExpired();
      // Potentially attempt to refresh token and retry the request

      // Prevent infinite loop if refresh token itself fails with 401
      // Make sure the refresh token endpoint doesn't itself trigger this logic
      // by either having a specific path check or handling its 401s differently.
      final RequestOptions requestOptions = err.requestOptions;
      final bool tokenRefreshed = await _authRepository.refreshAccessToken();
      if (tokenRefreshed) {
        debugPrint('Token refresh successful. Retrying original request.');
        // Update the token in the original request's headers
        requestOptions.headers['Authorization'] = 'Bearer ${_authRepository.getToken()}';

        // Retry the original request with the new token
        try {
          final response = await retryDio.fetch(requestOptions);
          handler.resolve(response); // Resolve with the new response
          return; // Important: prevent further handling
        } on DioException catch (retryErr) {
          debugPrint('Retry failed: $retryErr');
          _authRepository.onTokenExpired(); // Force re-login if retry fails
          handler.next(retryErr); // Pass the retry error down
          return;
        }
      } else {
        debugPrint('Token refresh failed. User needs to re-authenticate.');
        _authRepository.onTokenExpired(); // Navigate to login screen
      }
    }
    super.onError(err, handler);
  }
}

class RegistrationInterceptor extends Interceptor {
  RegistrationInterceptor();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    debugPrint('Request headers: ${options.headers}');

    debugPrint('Request URL: ${options.uri} body: ${options.data}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint('Response  body: ${response.data} ${response.statusCode}');
    super.onResponse(response, handler);
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
