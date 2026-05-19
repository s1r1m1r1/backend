import 'dart:async';
import 'package:dto/dto.dart';
import '../../auth/application/session_socket.dart';

/// Базовый интерфейс для сценариев поведения ботов.
abstract class BotStrategy {
  const BotStrategy();

  /// Вызывается при создании/подключении бота.
  FutureOr<void> onInit(ScenarioBot bot);

  /// Вызывается при получении сообщения от сервера.
  void onMessage(ScenarioBot bot, WsResponse message);

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

  @override
  void dispose() {
    strategy.onDispose(this);
  }
}
