import 'dart:io';

import 'package:backend/core/app_observer.dart';
import 'package:backend/core/di/injection.dart';
import 'package:backend/core/k_debug_mode.dart';
import 'package:backend/core/on_records.dart';
import 'package:backend/core/system_health_service.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:logging/logging.dart';

// инициализация зависимостей один раз, во время  hot-reload  не перезапускается
Future<void> init(InternetAddress ip, int port) async {
  hierarchicalLoggingEnabled = true;
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen(onRecord);

  final env = Platform.environment['ENV'] ?? 'dev';
  configureDependencies(environment: kDebugMode ? 'memory' : env);

  // Wait for all async singletons (including SystemOrchestrator bots creation)
  await getIt.allReady();

  final isProd = env == 'production';
  if (isProd) {
    Logger.root.level = Level.INFO;
    // Mute verbose domain logs in production
    getIt<AppObserver>()
      ..setLevel('Repository', 'WARNING')
      ..setLevel('UseCase', 'WARNING')
      ..setLevel('Service', 'WARNING')
      ..setLevel('Supervisor', 'WARNING')
      ..setLevel('Broadcast', 'WARNING');
  } else {
    Logger.root.level = Level.ALL;
    // Default dev settings (can be adjusted by user)
    // getIt<AppObserver>().setLevel('Repository', 'OFF');
  }

  // Start periodic system health logging
  getIt<SystemHealthService>().start();
}

/// Основная функция запуска сервера Dart Frog.
/// Принимает [handler] для обработки запросов, [ip] адрес для привязки и [port] порт.
Future<HttpServer> run(Handler handler, InternetAddress ip, int port) async {
  try {
    stdout.writeln(' FROG');
    stdout.writeln('${Platform.environment['SMTP_HOST']}');
  } catch (e) {
    stdout.writeln('Failed');
    exit(1);
  }

  return serve(handler, ip, port);
}
