import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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

  Future<TodoDto> updateTodo(UpdateTodoDto dto) async {
    print('start update');
    final response = await _client.put('/todos/${dto.id}', data: json.encode(dto.toJson()));
    if (response.statusCode != 200) {
      print('start not 200');
      throw Exception('Failed to update todo');
    }

    print('start good ${response.data}');
    return TodoDto.fromJson(response.data);
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
