import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:synchronized/synchronized.dart';

import '../../../core/debug_log.dart';
import '../../bot/application/bot_generator.dart';
import '../../bot/application/bot_strategy.dart';
import '../../bot/application/disconnect_bot.dart';
import '../../bot/application/ws_bot_repository.dart';
import '../../game/domain/unit.dart';
import '../../game/domain/unit_repository.dart';
import '../domain/session.dart';
import '../domain/session_repository.dart';
import '../domain/user_repository.dart';
import 'presence_manager.dart';
import 'session_socket.dart';

/// репозитория в самом хвосте зависоместей
/// для операций которые требуют комлексного взаимодейтсвия
/// репозиториев и бродкастов
@singleton
class SystemOrchestrator {
  SystemOrchestrator(
    this.userRepository,
    this.sessionRepository,
    this.unitRepository,
    this.botRepository,
    this.onlineBroadcast,
    this.botGenerator, // Inject BotGenerator
  );
  final UserRepository userRepository;
  final SessionRepository sessionRepository;
  final UnitRepository unitRepository;
  final BotRepository botRepository;
  final PresenceManager onlineBroadcast;
  final BotGenerator botGenerator;
  final _lock = Lock();

  static const int maxBots = 30; // Max bots allowed in DB
  static const int targetBots = 10; // Target online bots

  // добавить ботов для тестирования
  @postConstruct
  Future<void> createBots() async {
    debugLog('[BotCreate] START');
    try {
      final existingBots = await userRepository.getBots();
      debugLog('[BotCreate] Existing bots in DB: ${existingBots.length}');

      if (existingBots.length < targetBots) {
        final toGenerate = targetBots - existingBots.length;
        debugLog('[BotCreate] Generating $toGenerate new bots');
        for (var i = 0; i < toGenerate; i++) {
          try {
            await botGenerator.generateBot();
            debugLog('[BotCreate] Generated bot ${i + 1}/$toGenerate');
          } catch (e) {
            debugLog('[BotCreate] ERROR generating bot $i: $e');
          }
        }
      }

      final allBots = await userRepository.getBots();
      debugLog('[BotCreate] Total bots in DB: ${allBots.length}');

      var onlineCount = 0;
      var errorCount = 0;
      for (var b in allBots) {
        if (onlineCount >= targetBots) break;
        if (onlineBroadcast.getGameSocket(b.userId) != null) {
          debugLog('[BotCreate] Bot already online: ${b.email} (${b.userId})');
          onlineCount++;
          continue;
        }

        try {
          debugLog('[BotCreate] Connecting bot: ${b.email} (${b.userId})');
          final session = await sessionRepository.createSession(b);
          final unit = await unitRepository.getSelectedUnit(b.userId);
          if (unit == null) {
            debugLog('[BotCreate] SKIP bot ${b.email} — no unit selected');
            continue;
          }
          final gameSession = GameSession.fromSession(
            session,
            Unit.fromDto(unit),
          );
          final sinkBot = RegisteredScenarioBot.arena(
            botRepository: botRepository,
            userId: gameSession.user.userId,
            unitId: gameSession.unit.unitId,
          );
          await onlineBroadcast.joinBot(sinkBot, gameSession);
          debugLog('[BotCreate] Bot connected: ${b.email} (${b.userId})');
          onlineCount++;
        } catch (e, st) {
          errorCount++;
          debugLog('[BotCreate] ERROR connecting bot ${b.email}: $e\n$st');
        }
      }
      debugLog('[BotCreate] DONE — online: $onlineCount, errors: $errorCount');
    } catch (e, st) {
      debugLog('[BotCreate] FATAL ERROR: $e\n$st');
    }
  }

  /// Полное удаление ботов из базы данных
  Future<void> removeAllBotsFromDb() async {
    debugLog('SystemOrchestrator: removeAllBotsFromDb START');
    try {
      final bots = await userRepository.getBots();
      final botIds = bots.map((e) => e.userId).toList();

      // 1. Remove from units
      final unitDao = botGenerator.unitDao;
      await unitDao.deleteAllBotUnits(botIds);

      // 2. Remove from users
      final userDao = botGenerator.userDao;
      await userDao.deleteAllBots();

      debugLog('All bots and their units removed from system.');
    } catch (e) {
      debugLog('SystemOrchestrator: removeAllBotsFromDb Error: $e');
    }
  }

  void onUserClose(UserChannel userChannel) {
    _lock.synchronized(() async {
      try {
        final userId = userChannel.userId;
        if (userId == null) return;
        final session = onlineBroadcast.getGameSocket(userId);
        if (session == null) return;
        final replacedByUser =
            session.userSink != null &&
            session.userSink!.channel != userChannel.channel;

        if (replacedByUser) {
          debugLog('no bot replacedByUser');
          return;
        }
        // if (session.location == .menu) {
        //   debugLog('location menu nothing changed'.dye(.yellow));
        //   return;
        // }

        /// пока не тестируем бота
        final hasBot = session.bot != null;
        if (hasBot) {
          debugLog('hasBot');
          return;
        }

        final bot = DisconnectBot(
          botRepository: botRepository,
          userId: userId,
          unitId: userChannel.unitId,
        );
        session.setBot(bot);
        bot.init();
        // _broadcastOnlineUsers();
      } catch (e) {
        debugLog(e.toString());
        // addError(e, s);
      }
    });
  }
}
