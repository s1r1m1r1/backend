import 'package:equatable/equatable.dart';

class Session extends Equatable {
  /// {@macro session}
  const Session({required this.token, required this.userId, required this.expiryDate, required this.createdAt});

  /// The session token.
  final String token;

  /// The user id.
  final String userId;

  /// The session expiration date.
  final DateTime expiryDate;

  /// The session creation date.
  final DateTime createdAt;

  @override
  List<Object?> get props => [token, userId, expiryDate, createdAt];
}
