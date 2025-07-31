import 'package:equatable/equatable.dart';

class Session extends Equatable {
  const Session({
    this.id,
    required this.token,
    required this.userId,
    required this.tokenExpiryDate,
    required this.createdAt,
    required this.refreshToken,
    required this.refreshTokenExpiry,
  });
  final int? id;

  /// The session token.
  final String token;

  /// The user id.
  final String userId;

  /// The session expiration date.
  final DateTime tokenExpiryDate;

  /// The session creation date.
  final DateTime createdAt;

  /// The refresh token for this session.
  final String refreshToken;

  /// The refresh token expiration date.
  final DateTime refreshTokenExpiry;

  Session copyWith({String? token, DateTime? tokenExpiryDate, String? refreshToken, DateTime? refreshTokenExpiry}) {
    return Session(
      id: this.id,
      token: token ?? this.token,
      userId: this.userId,
      tokenExpiryDate: tokenExpiryDate ?? this.tokenExpiryDate,
      createdAt: this.createdAt,
      refreshToken: refreshToken ?? this.refreshToken,
      refreshTokenExpiry: refreshTokenExpiry ?? this.refreshTokenExpiry,
    );
  }

  @override
  List<Object?> get props => [id, token, userId, tokenExpiryDate, createdAt, refreshToken, refreshTokenExpiry];
}
