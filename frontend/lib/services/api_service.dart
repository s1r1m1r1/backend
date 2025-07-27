// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/todo.dart';
import '../models/user.dart';

class ApiService {
  static const String _baseUrl = 'http://localhost:8080';

  Future<List<User>> fetchUsers() async {
    final response = await http.get(Uri.parse('$_baseUrl/users'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<User> createUser(User user) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/users'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(user.toJson()),
    );
    if (response.statusCode == 201) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create user');
    }
  }

  Future<void> deleteUser(String userId) async {
    final response = await http.delete(Uri.parse('$_baseUrl/users/$userId'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete user');
    }
  }

  // Example for Login
  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/users/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': username, 'password': password}),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body); // Assuming it returns some user data/token
    } else {
      throw Exception('Failed to log in');
    }
  }

  // Example for Signup
  Future<Map<String, dynamic>> signup(String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/users/signup'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'name': username, 'email': email, 'password': password}),
    );
    if (response.statusCode == 201) {
      return json.decode(response.body); // Assuming it returns some user data
    } else {
      throw Exception('Failed to sign up');
    }
  }

  // Todos API calls
  Future<List<Todo>> fetchTodos() async {
    final response = await http.get(Uri.parse('$_baseUrl/todos'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Todo.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load todos');
    }
  }

  Future<Todo> createTodo(Todo todo) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/todos'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(todo.toJson()),
    );
    if (response.statusCode == 201) {
      return Todo.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create todo');
    }
  }

  Future<void> updateTodo(String id, Todo todo) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/todos/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(todo.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update todo');
    }
  }

  Future<void> deleteTodo(String id) async {
    final response = await http.delete(Uri.parse('$_baseUrl/todos/$id'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete todo');
    }
  }

  Future<Todo> fetchTodoById(String id) async {
    final response = await http.get(Uri.parse('$_baseUrl/todos/$id'));
    if (response.statusCode == 200) {
      return Todo.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to fetch todo by ID');
    }
  }
}
