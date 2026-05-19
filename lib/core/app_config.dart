import 'dart:io';

/// Centralized configuration for the server, reading from environment
/// variables with sensible defaults.
abstract class AppConfig {
  /// How long the access token remains valid.
  /// Default is 2 hours for development.
  static Duration get tokenExpiry {
    final seconds = int.tryParse(
      Platform.environment['TOKEN_EXPIRY_SEC'] ?? '',
    );
    return seconds != null
        ? Duration(seconds: seconds)
        : const Duration(hours: 2);
  }

  /// How long the refresh token remains valid.
  /// Default is 30 days.
  static Duration get refreshTokenExpiry {
    final seconds = int.tryParse(
      Platform.environment['REFRESH_TOKEN_EXPIRY_SEC'] ?? '',
    );
    return seconds != null
        ? Duration(seconds: seconds)
        : const Duration(days: 30);
  }

  /// Secret key for signing (if needed in the future).
  static String get secretKey =>
      Platform.environment['SECRET_KEY'] ?? 'DEV_INTERNAL_SECRET';

  /// Whether we are in development mode.
  static bool get isDev =>
      Platform.environment['APP_ENV']?.toLowerCase() != 'production';

  /// Timeout for bot attacks in Arena.
  /// Default is 5 seconds.
  static Duration get botAttackTimeout {
    final seconds = int.tryParse(
      Platform.environment['BOT_ATTACK_TIMEOUT_SEC'] ?? '',
    );
    return seconds != null
        ? Duration(seconds: seconds)
        : const Duration(seconds: 5);
  }
}
