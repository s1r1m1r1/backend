// lib/services/api_service.dart
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:frontend/features/auth/data/request_email_credential_dto.dart';
import 'package:frontend/features/auth/data/response_token_dto.dart';
import 'package:injectable/injectable.dart';

import '../../features/todo/data/response_todo_dto.dart';
import '../../models/todo.dart';
import '../../models/user.dart';

@lazySingleton
class ProtectedApiService {
  final Dio _client;

  ProtectedApiService(@Named('protectedDio') this._client) {}

  Future<List<ResponseTodoDto>> fetchTodos() async {
    final response = await _client.get('/users/me/todos');
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = response.data;
      return jsonList.map((json) => ResponseTodoDto.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load todos');
    }
  }

  Future<Todo> createTodo(Todo todo) async {
    final response = await _client.post('/users/me/todos', data: json.encode(todo.toJson()));
    if (response.statusCode == 201) {
      return Todo.fromJson(response.data);
    } else {
      throw Exception('Failed to create todo');
    }
  }

  Future<void> updateTodo(String id, Todo todo) async {
    final response = await _client.put(
      '/users/me/todos/$id',
      data: json.encode(todo.toJson()),
      options: Options(headers: {'Content-Type': 'application/json'}),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update todo');
    }
  }

  Future<void> deleteTodo(String id) async {
    final response = await _client.delete('/users/me/todos/$id');
    if (response.statusCode != 204) {
      throw Exception('Failed to delete todo');
    }
  }

  Future<Todo> fetchTodoById(String id) async {
    final response = await _client.get('/users/me/todos/$id');
    if (response.statusCode == 200) {
      return Todo.fromJson(response.data);
    } else {
      throw Exception('Failed to fetch todo by ID');
    }
  }
}

@lazySingleton
class RegistrationApiService {
  final Dio _client;

  RegistrationApiService(@Named('unauthorizedDio') this._client);

  Future<ResponseTokenDto> signup(RequestEmailCredentialDto dto) async {
    final response = await _client.post(
      '/users/signup',
      data: json.encode(dto.toJson()),
      options: Options(headers: {'Content-Type': 'application/json'}),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final decoded = response.data; // Assuming it returns some user data/
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
