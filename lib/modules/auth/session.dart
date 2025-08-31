import 'package:backend/game/unit.dart';
import 'package:backend/models/user.dart';
import 'package:equatable/equatable.dart';
import 'package:sha_red/sha_red.dart';

abstract class IGameSession {
  abstract final Unit unit;
}

abstract class ISession {
  abstract final User user;
}

// The base Session class without the unit.
class Session extends Equatable implements ISession {
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
class GameSession implements ISession, IGameSession {
  const GameSession({required this.user, required this.unit});

  factory GameSession.fromSession(Session session, Unit unit) {
    return GameSession(user: session.user, unit: unit);
  }

  GameSession changeUnit(Unit unit) {
    return GameSession(user: user, unit: unit);
  }

  @override
  final Unit unit;
  @override
  final User user;
}

extension GameSessionExt on GameSession {
  ToClient sessionDTO(int roomId) {
    return ToClient.joinedServer(
      mainRoomId: roomId,
      user: user.toDto(),
      unit: unit.toDto(),
    );
  }
}
