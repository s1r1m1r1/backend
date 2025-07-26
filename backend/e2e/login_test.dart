import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:test/test.dart';

void main() {
  final String baseUrl = 'http://localhost:8080';

  group('User E2E Tests', () {
    // Test for successful user login
    test('should successfully log in a user with valid credentials', () async {
      final response = await http.post(
        Uri.parse('$baseUrl/users/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': 'saileshbro@gmail.com',
          'password':
              '6aMj@UBByu%7BzN^C9tMe#Te4b!4cJrXwwFi#HgKrQ&g&ddNN6eHQ94vd5SuJtEc%7^H6L^xews8soG@R7GnW*RvfJVMaKEuBXNtVtbP5!3^qs*n!Z%87q8eRJmKFUHg',
        }),
      );

      expect(response.statusCode, 200);
      final body = jsonDecode(response.body);
      expect(body, containsPair('token', isA<String>()));
      expect(body, containsPair('user', isA<Map>()));
      expect(body['user'], containsPair('email', 'saileshbro@gmail.com'));
      expect(body['user'], containsPair('name', 'Sailesh Dahal'));
      expect(body['user'], containsPair('id', isA<String>()));
      expect(body['user'], containsPair('created_at', isA<String>()));
    });

    // Test for unsuccessful user login with invalid credentials
    test('should return an error for invalid login credentials', () async {
      final response = await http.post(
        Uri.parse('$baseUrl/users/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': 'sa@gmail.com',
          'password':
              '6aMj@UBByu%7BzN^C9tMe#Te4b!4cJrXwwFi#HgKrQ&g&ddNN6eHQ94vd5SuJtEc%7^H6L^xews8soG@R7GnW*RvfJVMaKEuBXNtVtbP5!3^qs*n!Z%87q8eRJmKFUHg',
        }),
      );

      expect(response.statusCode, 200); // Or the appropriate error status code your API returns, e.g., 401 or 400
      final body = jsonDecode(response.body);
      expect(body, containsPair('message', 'Invalid email or password'));
    });

    // Test for unsuccessful user signup due to validation errors
    test('should return validation errors for incomplete signup data', () async {
      final response = await http.post(
        Uri.parse('$baseUrl/users/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': 'sailes@gmail.com', 'password': '6aMj@UBByu'}),
      );

      expect(response.statusCode, 200); // Or the appropriate error status code your API returns, e.g., 400 or 422
      final body = jsonDecode(response.body);
      expect(body, containsPair('message', 'Validation failed'));
      expect(body, containsPair('errors', isA<Map>()));
      expect(body['errors'], containsPair('name', ['Name is required']));
    });

    // Add more tests for other scenarios like successful signup,
    // email already exists, etc., following the same pattern.
  });
}
