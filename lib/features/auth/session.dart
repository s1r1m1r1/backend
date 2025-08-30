import 'package:backend/game/unit.dart';
import 'package:backend/models/user.dart';
import 'package:equatable/equatable.dart';
import 'package:sha_red/sha_red.dart';

abstract class IGameSession {
  abstract final Unit unit;
}

// The base Session class without the unit.
class Session extends Equatable {
  const Session({
    this.id,
    required this.token,
    required this.user,
    required this.tokenExpiryDate,
    required this.createdAt,
    required this.refreshToken,
    required this.refreshTokenExpiry,
  });

  final int? id;
  final String token;
  final User user;
  final DateTime tokenExpiryDate;
  final DateTime createdAt;
  final String refreshToken;
  final DateTime refreshTokenExpiry;

  Session copyWith({
    String? token,
    User? user,
    DateTime? tokenExpiryDate,
    DateTime? createdAt,
    String? refreshToken,
    DateTime? refreshTokenExpiry,
  }) {
    return Session(
      id: id,
      token: token ?? this.token,
      user: user ?? this.user,
      tokenExpiryDate: tokenExpiryDate ?? this.tokenExpiryDate,
      createdAt: createdAt ?? this.createdAt,
      refreshToken: refreshToken ?? this.refreshToken,
      refreshTokenExpiry: refreshTokenExpiry ?? this.refreshTokenExpiry,
    );
  }

  @override
  List<Object?> get props => [user];
}

// The GameSession class with the unit, extending Session.
class GameSession extends Session implements IGameSession {
  const GameSession({
    int? id,
    required String token,
    required User user,
    required DateTime tokenExpiryDate,
    required DateTime createdAt,
    required String refreshToken,
    required DateTime refreshTokenExpiry,
    required this.unit,
  }) : super(
         id: id,
         token: token,
         user: user,
         tokenExpiryDate: tokenExpiryDate,
         createdAt: createdAt,
         refreshToken: refreshToken,
         refreshTokenExpiry: refreshTokenExpiry,
       );

  factory GameSession.fromSession(Session session, Unit unit) {
    return GameSession(
      id: session.id,
      token: session.token,
      user: session.user,
      tokenExpiryDate: session.tokenExpiryDate,
      createdAt: session.createdAt,
      refreshToken: session.refreshToken,
      refreshTokenExpiry: session.refreshTokenExpiry,
      unit: unit,
    );
  }

  GameSession changeUnit(Unit unit) {
    return GameSession(
      id: id,
      token: token,
      user: user,
      tokenExpiryDate: tokenExpiryDate,
      createdAt: createdAt,
      refreshToken: refreshToken,
      refreshTokenExpiry: refreshTokenExpiry,
      unit: unit,
    );
  }

  @override
  final Unit unit;
}

extension GameSessionExt on GameSession {
  ToClient sessionDTO(int roomId) {
    return ToClient.joinedServer(
      mainRoomId: roomId,
      user: user.toDto(),
      unit: unit.toDto(),
      tokens: TokensDto(accessToken: token, refreshToken: refreshToken),
    );
  }
}
