import 'dart:async';

import 'package:dto/dto.dart';
import 'package:injectable/injectable.dart';
import 'package:synchronized/synchronized.dart';

import '../../../core/debug_log.dart';
import '../../bot/application/arena_bot.dart';
import '../../bot/application/bot_generator.dart';
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
    debugLog('SystemOrchestrator: createBots START');
    try {
      final existingBots = await userRepository.getBots();
      debugLog('Existing bots in DB: ${existingBots.length}');

      // If we don't have enough bots, generate more up to MAX_BOTS
      if (existingBots.length < targetBots) {
        final toGenerate = targetBots - existingBots.length;
        debugLog('Generating $toGenerate new bots');
        for (var i = 0; i < toGenerate; i++) {
          await botGenerator.generateBot();
        }
      }

      // Refresh list after generation
      final allBots = await userRepository.getBots();

      // Ensure bots are online (up to targetBots)
      var onlineCount = 0;
      for (var b in allBots) {
        if (onlineCount >= targetBots) break;
        // Check if bot is already online
        if (onlineBroadcast.getGameSocket(b.userId) != null) {
          onlineCount++;
          continue;
        }

        try {
          debugLog('SystemOrchestrator: Joining bot ${b.email} to online');
          final session = await sessionRepository.createSession(b);
          final unit = await unitRepository.getSelectedUnit(b.userId);
          if (unit == null) {
            debugLog('Bot ${b.email} has no unit selected');
            continue;
          }
          final gameSession = GameSession.fromSession(
            session,
            Unit.fromDto(unit),
          );
          final sinkBot = ArenaBot(
            botRepository: botRepository,
            userId: gameSession.user.userId,
            unitId: gameSession.unit.unitId,
          );
          await onlineBroadcast.joinBot(sinkBot, gameSession);
          onlineCount++;
        } catch (e, _) {
          debugLog('Error joining bot ${b.email}: $e');
        }
      }
      debugLog('SystemOrchestrator: Active bots online: $onlineCount');
    } catch (e, _) {
      debugLog('SystemOrchestrator: createBots Error: $e');
    }
  }

  /// Полное удаление ботов из базы данных
  Future<void> removeAllBotsFromDb() async {
    debugLog('SystemOrchestrator: removeAllBotsFromDb START');
    try {
      final bots = await userRepository.getBots();
      final botIds = bots.map((e) => e.userId.id).toList();

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
        if (userId == UserId.none) return;
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
