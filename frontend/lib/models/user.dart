// lib/models/user.dart
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String? username; // Assuming optional
  final String? email; // Assuming optional

  const User({required this.id, this.username, this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(id: json['id'] as String, username: json['username'] as String?, email: json['email'] as String?);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'username': username, 'email': email};
  }

  @override
  List<Object?> get props => [id, username, email];
}
