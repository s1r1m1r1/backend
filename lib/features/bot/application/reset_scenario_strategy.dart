import 'dart:async';
import 'package:dto/dto.dart';
import '../../../core/debug_log.dart';
import 'bot_strategy.dart';

class ResetScenarioStrategy extends BotStrategy {
  ResetScenarioStrategy({required this.isResetEdicts});
  final bool isResetEdicts;
  final Completer<void> done = Completer<void>();

  @override
  FutureOr<void> onInit(ScenarioBot bot) {
    debugLog(
      'Bot ${bot.userId} starting ResetScenarioStrategy (isResetEdicts: $isResetEdicts)',
    );
    if (isResetEdicts) {
      bot.send(const WsRequest.resetEdicts(n: 'test_reset_edicts'));
    } else {
      bot.send(const WsRequest.resetCombats(n: 'test_reset_combats'));
    }
    Future.delayed(const Duration(milliseconds: 100), () => done.complete());
  }

  @override
  void onMessage(ScenarioBot bot, WsResponse message) {
    if (isResetEdicts && message is ActiveEdictsTc) {
      if (message.edicts.isEmpty) {
        debugLog('Edicts reset verified!');
      }
    }
  }

  @override
  void onDispose(ScenarioBot bot) {}
}
