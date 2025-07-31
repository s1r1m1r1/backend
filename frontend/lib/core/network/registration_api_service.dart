// lib/services/api_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:frontend/features/auth/data/request_email_credential_dto.dart';
import 'package:injectable/injectable.dart';
import 'package:shared/shared.dart';

import '../../models/user.dart';

@lazySingleton
class RegistrationApiService {
  final Dio _client;

  RegistrationApiService(@Named('registration') this._client);

  Future<TokenDto> signup(RequestEmailCredentialDto dto) async {
    final response = await _client.post(
      '/users/signup',
      data: json.encode(dto.toJson()),
      options: Options(headers: {'Content-Type': 'application/json'}),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final decoded = response.data; // Assuming it returns some user data/

      return TokenDto.fromJson(decoded);
    } else {
      throw Exception('Failed to sign up');
    }
  }

  Future<User> createUser(User user) async {
    final response = await _client.post('/users', data: user.toJson());

    if (response.statusCode == HttpStatus.created) {
      return User.fromJson(response.data);
    } else {
      throw Exception('Failed to create user');
    }
  }

  Future<TokenDto> login(RequestEmailCredentialDto dto) async {
    final response = await _client.post('/users/login', data: dto.toJson());
    if (response.statusCode == HttpStatus.accepted) {
      final decoded = response.data; // Assuming it returns some user data/token

      debugPrint('Login  response: $decoded');
      return TokenDto.fromJson(decoded);
    } else {
      throw Exception('Failed to log in');
    }
  }

  Future<TokenDto> refresh(String refreshToken) async {
    final response = await _client.post(
      '/users/refresh',
      data: RefreshDto(refreshToken).toJson(),
      options: Options(headers: {'Content-Type': 'application/json'}),
    );

    if (response.statusCode == HttpStatus.accepted) {
      final decoded = response.data; // Assuming it returns some user data/token
      debugPrint('Refresh token response: $decoded');
      return TokenDto.fromJson(decoded);
    } else {
      throw Exception('Failed to refresh token');
    }
  }
}
