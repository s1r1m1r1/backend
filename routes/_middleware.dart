import 'package:backend/core/api_exceptions.dart';
import 'package:backend/core/debug_log.dart';
import 'package:backend/core/di/injection.dart';
import 'package:backend/core/on_records.dart';
import 'package:backend/db_client/db_client.dart';
import 'package:backend/features/auth/application/online_repository_impl.dart';
import 'package:backend/features/auth/application/presence_manager.dart';
import 'package:backend/features/auth/application/system_orchestrator.dart';
import 'package:backend/features/auth/domain/session_repository.dart';
import 'package:backend/features/auth/domain/user_repository.dart';
import 'package:backend/features/bot/application/ws_bot_repository.dart';
import 'package:backend/features/chat/application/letters_broad_manager.dart';
import 'package:backend/features/chat/domain/letters_repository.dart';
import 'package:backend/features/game/application/arena_broadcast.dart';
import 'package:backend/features/game/application/combat_supervisor.dart';
import 'package:backend/features/game/domain/unit_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:logging/logging.dart';
import 'package:mailing/application/mailing_service.dart';
import 'package:shelf/shelf.dart' show HijackException;
import 'package:stack_trace/stack_trace.dart';

// No global variables needed anymore with getIt

Handler middleware(Handler handler) {
  return handler
      .use(provider<SystemOrchestrator>((_) => getIt<SystemOrchestrator>()))
      .use(provider<BotRepository>((_) => getIt<BotRepository>()))
      .use(provider<ArenaBroadcast>((_) => getIt<ArenaBroadcast>()))
      .use(provider<CombatSupervisor>((_) => getIt<CombatSupervisor>()))
      .use(provider<PresenceManager>((_) => getIt<PresenceManager>()))
      .use(provider<OnlineRepository>((_) => getIt<OnlineRepository>()))
      .use(provider<UnitRepository>((_) => getIt<UnitRepository>()))
      .use(provider<LettersBroadManager>((_) => getIt<LettersBroadManager>()))
      .use(provider<LettersRepository>((_) => getIt<LettersRepository>()))
      .use(provider<SessionRepository>((_) => getIt<SessionRepository>()))
      .use(provider<UserRepository>((_) => getIt<UserRepository>()))
      .use(provider<MailingService>((_) => getIt<MailingService>()))
      .use((handler) {
        initLoggingDb(getIt<DbClient>());
        return handler;
      })
      .use(loggerMiddleware)
      .use(exceptionHandler());
}

Middleware exceptionHandler() {
  return (handler) {
    return (context) async {
      try {
        return await handler(context);
      } on HijackException {
        rethrow;
      } on ApiException catch (e) {
        return Response.json(
          body: e.toResponseJson(),
          statusCode: e.statusCode,
        );
      } catch (e, st) {
        final trace = Trace.from(st).terse;
        debugLog('Uncaught error: $e\n$trace');
        return Response.json(
          body: {'message': 'Internal Server Error'},
          statusCode: 500,
        );
      }
    };
  };
}

Logger _log = Logger('middleware');

Handler loggerMiddleware(
  Handler handler, {
  bool logRequest = true,
  bool logResponse = true,
}) {
  return (context) async {
    if (logRequest) {
      final requestLog = generateLogReq(context.request);
      _log.info(requestLog);
    }

    final stopwatch = Stopwatch()..start();
    final response = await handler(context);
    stopwatch.stop();

    final time = stopwatch.elapsedMilliseconds;

    if (logResponse) {
      final responseLog = generateLogResp(context.request, response, time);
      _log.info(responseLog);
    }
    return response;
  };
}

String generateLogReq(Request request) {
  final sb = StringBuffer();
  sb.write('[${request.method.value}]');
  sb.write(' ${request.uri.path}');
  if (request.uri.query.isNotEmpty) {
    sb.write('?${request.uri.query}');
  }
  if (request.headers.isNotEmpty) {
    sb.write('\n');
    for (final entry in request.headers.entries) {
      sb.write('${entry.key}: ${entry.value}\n');
    }
  }
  return sb.toString();
}

String generateLogResp(Request request, Response response, int millisec) {
  final sb = StringBuffer();
  sb.write('[${request.method.value}]');
  sb.write(' ${request.uri.path}');
  if (request.uri.query.isNotEmpty) {
    sb.write('?${request.uri.query}');
  }
  sb.write(' | ${response.statusCode}');
  sb.write(' | $millisec ms');

  return sb.toString();
}
