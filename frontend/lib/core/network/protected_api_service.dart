import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:shared/shared.dart';

@lazySingleton
class ProtectedApiService {
  final Dio _client;
  const ProtectedApiService(@Named('withToken') this._client);

  Future<List<TodoDto>> fetchTodos() async {
    final response = await _client.get('/todos');
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = response.data;
      return jsonList.map((json) => TodoDto.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load todos');
    }
  }

  Future<TodoDto> createTodo(CreateTodoDto todo) async {
    final response = await _client.post('/todos', data: json.encode(todo.toJson()));
    if (response.statusCode == 200) {
      return TodoDto.fromJson(response.data);
    } else {
      throw Exception('Failed to create todo');
    }
  }

  Future<void> updateTodo(String id, TodoDto todo) async {
    final response = await _client.put('/users/todos/$id', data: json.encode(todo.toJson()));
    if (response.statusCode != 200) {
      throw Exception('Failed to update todo');
    }
  }

  Future<bool> deleteTodo(int id) async {
    final response = await _client.delete('/todos/$id');
    if (response.statusCode == 200 || response.statusCode == 204) {
      return true;
    }
    return false;
  }

  Future<TodoDto> fetchTodoById(String id) async {
    final response = await _client.get('/todos/$id');
    if (response.statusCode == 200) {
      return TodoDto.fromJson(response.data);
    } else {
      throw Exception('Failed to fetch todo by ID');
    }
  }
}
