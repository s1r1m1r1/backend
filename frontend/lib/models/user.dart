// lib/models/user.dart
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String? username; // Assuming optional
  final String? email; // Assuming optional
  final String? role; // Added role field

  const User({required this.id, this.username, this.email, this.role});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      username: json['username'] as String?,
      email: json['email'] as String?,
      role: json['role'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'username': username, 'email': email, 'role': role};
  }

  @override
  List<Object?> get props => [id, username, email, role];
}
