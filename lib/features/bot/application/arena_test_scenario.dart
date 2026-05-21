import 'dart:async';
import 'package:dto/dto.dart';
import '../../../core/debug_log.dart';
import 'bot_strategy.dart';

/// Сценарий для Теста 1:
/// Бот-создатель заходит в арену и создает эдикт.
/// Бот-партнер заходит в арену и вступает в существующий эдикт.
/// Оба проверяют переход в состояние Combat.
class ArenaTestScenarioStrategy extends BotStrategy {
  ArenaTestScenarioStrategy({required this.isCreator});
  final bool isCreator;
  final Completer<void> combatStarted = Completer<void>();
  final Completer<void> battleLoaded = Completer<void>();

  @override
  FutureOr<void> onInit(ScenarioBot bot) {
    debugLog(
      'Bot ${bot.userId} starting ArenaTestScenarioStrategy (creator: $isCreator)',
    );
    bot.sendDelayed(const WsRequest.joinArena(n: Noun('test_join')));
  }

  @override
  void onMessage(ScenarioBot bot, WsResponse message) {
    // Send ack for any RequiredAckResponse message first
    if (message is RequiredAckResponse) {
      bot.send(
        WsRequest.ack(n: message.n, ts: DateTime.now().millisecondsSinceEpoch),
      );
    }

    // debugLog('Bot ${bot.userId} received message: ${message.runtimeType}'.dye(.cyan));
    switch (message) {
      case ActiveEdictsResponse(:final edicts):
        if (isCreator) {
          final alreadyMy = edicts.any(
            (e) => e.members.any((m) => m.userId == bot.userId),
          );
          if (!alreadyMy) {
            debugLog('Creator bot ${bot.userId} creating new edict');
            bot.sendDelayed(const .createNewEdict(n: Noun('test_create')));
          }
        } else {
          // Партнер ищет созданный эдикт
          if (edicts.isNotEmpty) {
            final target = edicts.first;
            final isNotMember = !target.members.any(
              (m) => m.userId == bot.userId,
            );
            if (isNotMember && target.members.length < target.maxMembers) {
              debugLog('Partner bot ${bot.userId} joining edict ${target.id}');
              bot.sendDelayed(
                .joinEdict(
                  n: const Noun('test_join_edict'),
                  edictId: target.id,
                ),
              );
            }
          }
        }

      case CombatStartedResponse():
        debugLog(
          'Bot ${bot.userId} received CombatStartedResponse: ${message.combatRoom}',
        );
        if (!combatStarted.isCompleted) combatStarted.complete();
        // Подтверждаем готовность к бою
        bot.sendDelayed(
          .joinBattleRoom(
            n: const Noun('test_ready'),
            combatRoomId: message.combatRoom,
          ),
        );

      case StartBattleResponse():
        debugLog(
          'Bot ${bot.userId} received StartBattleResponse. Ready: ${message.ready}',
        );
        if (!battleLoaded.isCompleted) battleLoaded.complete();

      case ArenaErrorResponse(:final error):
        debugLog('Bot ${bot.userId} ArenaError: $error');

      default:
        break;
    }
  }

  @override
  void onDispose(ScenarioBot bot) {
    debugLog('Bot ${bot.userId} disposing strategy');
  }
}
