// lib/services/api_service.dart
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:frontend/features/auth/data/request_email_credential_dto.dart';
import 'package:frontend/features/auth/data/response_token_dto.dart';
import 'package:injectable/injectable.dart';

import '../../models/user.dart';

@lazySingleton
class RegistrationApiService {
  final Dio _client;

  RegistrationApiService(@Named('registration') this._client);

  Future<ResponseTokenDto> signup(RequestEmailCredentialDto dto) async {
    final response = await _client.post(
      '/users/signup',
      data: json.encode(dto.toJson()),
      options: Options(headers: {'Content-Type': 'application/json'}),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final decoded = response.data; // Assuming it returns some user data/
      print(
        '/n'
        '${decoded}'
        '',
      );
      return ResponseTokenDto.fromJson(decoded);
    } else {
      throw Exception('Failed to sign up');
    }
  }

  Future<User> createUser(User user) async {
    final response = await _client.post('/users', data: user.toJson());
    if (response.statusCode == 201) {
      return User.fromJson(response.data);
    } else {
      throw Exception('Failed to create user');
    }
  }

  Future<ResponseTokenDto> login(RequestEmailCredentialDto dto) async {
    final response = await _client.post('/users/login', data: dto.toJson());
    if (response.statusCode == 200 || response.statusCode == 201) {
      final decoded = response.data; // Assuming it returns some user data/token
      return ResponseTokenDto.fromJson(decoded);
    } else {
      throw Exception('Failed to log in');
    }
  }
}
