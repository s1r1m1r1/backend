import 'dart:async';
import 'package:dto/dto.dart';
import '../../../core/debug_log.dart';
import '../../auth/application/session_socket.dart';

/// Базовый интерфейс для сценариев поведения ботов.
abstract class BotStrategy {
  const BotStrategy();

  /// Задержка между получением сообщения и отправкой действия.
  /// Имитирует время принятия решения пользователем.
  Duration get actionDelay => const Duration(milliseconds: 500);

  /// Вызывается при создании/подключении бота.
  FutureOr<void> onInit(ScenarioBot bot);

  /// Вызывается при получении сообщения от сервера.
  void onMessage(ScenarioBot bot, WsResponse message) {
    // Default implementation: handle rate limit errors
    if (message is RateLimitErrorResponse_) {
      _handleRateLimitError(bot, message);
    }
  }

  /// Handle rate limit error responses from server.
  /// Stops the bot if penalty level is 'close'.
  void _handleRateLimitError(ScenarioBot bot, RateLimitErrorResponse_ message) {
    final penaltyLevel = message.error.penaltyLevel;
    debugLog(
      '[BotStrategy] Rate limit error: penaltyLevel=$penaltyLevel, '
      'message: ${message.error.message}',
    );

    // Stop the bot if penalty is 'close'
    if (penaltyLevel == PenaltyLevel.close.value) {
      debugLog('[BotStrategy] Bot disabled due to rate limit close penalty');
      bot.dispose();
    }
  }

  /// Вызывается при удалении бота.
  void onDispose(ScenarioBot bot);
}

/// Универсальный бот, который делегирует свою логику заданной стратегии.
class ScenarioBot extends SinkBot<WsResponse, WsRequest> {
  ScenarioBot({
    required this.strategy,
    required super.botRepository,
    required super.userId,
    required super.unitId,
  });
  final BotStrategy strategy;

  @override
  FutureOr<void> init() async {
    await strategy.onInit(this);
  }

  @override
  void sinkAdd(EncodedPacket<WsResponse> encoded) {
    strategy.onMessage(this, encoded.data);
  }

  /// Удобный метод для отправки команд серверу через BotRepository.
  void send(WsRequest command) {
    botCallback?.call(command);
  }

  /// Отправить команду с задержкой (имитация времени принятия решения).
  void sendDelayed(WsRequest command) {
    Future.delayed(actionDelay, () => send(command));
  }

  Duration get actionDelay => strategy.actionDelay;

  @override
  void dispose() {
    strategy.onDispose(this);
  }
}
