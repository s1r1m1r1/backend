import 'dart:async';
import 'package:dto/dto.dart';
import '../../../core/debug_log.dart';
import '../../auth/application/bot_sink.dart';
import '../../auth/application/session_socket.dart';
import 'arena_bot.dart';
import 'ws_bot_repository.dart';

/// Базовый интерфейс для сценариев поведения ботов.
abstract class BotStrategy {
  const BotStrategy();

  /// Задержка между получением сообщения и отправкой действия.
  /// Имитирует время принятия решения пользователем.
  Duration get actionDelay => const Duration(milliseconds: 500);

  /// Вызывается при создании/подключении бота.
  FutureOr<void> onInit(RegisteredScenarioBot bot);

  /// Вызывается при получении сообщения от сервера.
  void onMessage(RegisteredScenarioBot bot, WsResponse message) {
    // Default implementation: handle rate limit errors
    if (message is RateLimitErrorResponse_) {
      _handleRateLimitError(bot, message);
    }
  }

  /// Handle rate limit error responses from server.
  /// Stops the bot if penalty level is 'close'.
  void _handleRateLimitError(
    RegisteredScenarioBot bot,
    RateLimitErrorResponse_ message,
  ) {
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
  void onDispose(RegisteredScenarioBot bot);
}

/// Безопасный бот, который гарантирует наличие userId и unitId на уровне компиляции.
extension type RegisteredScenarioBot._(ScenarioBot _raw)
    implements ScenarioBot {
  /// Фабрика сразу принимает не-nullable UserId и UnitId
  factory RegisteredScenarioBot({
    required BotStrategy strategy,
    required BotRepository botRepository,
    required UserId userId,
    required UnitId unitId,
  }) {
    final bot = ScenarioBot(
      strategy: strategy,
      botRepository: botRepository,
      userId: userId,
      unitId: unitId,
    );
    return RegisteredScenarioBot._(bot);
  }

  /// НОВАЯ ФАБРИКА: Специально для ArenaBot
  factory RegisteredScenarioBot.arena({
    required BotRepository botRepository,
    required UserId userId,
    required UnitId unitId,
    ArenaBotStrategy? strategy,
  }) {
    final bot = ArenaBot(
      botRepository: botRepository,
      userId: userId,
      unitId: unitId,
      strategy: strategy,
    );
    return RegisteredScenarioBot._(bot);
  }

  /// Переопределяем геттеры, гарантируя не-nullable типы
  UserId get userId => _raw.userId!;
  UnitId get unitId => _raw.unitId!;
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
    // Безопасно оборачиваем `this` в extension type без использования `as`
    await strategy.onInit(RegisteredScenarioBot._(this));
  }

  @override
  void sinkAdd(EncodedPacket<WsResponse> encoded) {
    // Безопасно оборачиваем `this` в extension type без использования `as`
    strategy.onMessage(RegisteredScenarioBot._(this), encoded.data);
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
    // Безопасно оборачиваем `this` в extension type без использования `as`
    strategy.onDispose(RegisteredScenarioBot._(this));
  }
}
