import 'dart:io';
import 'package:backend/core/inject.dart';
import 'package:backend/core/broadcast.dart';
import 'package:backend/core/broadcast_observer.dart';
import 'package:backend/core/watch_records.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';
// import 'package:logging/logging.dart';

// инициализация зависимостей один раз, во время  hot-reload  не перезапускается
Future<void> init(InternetAddress ip, int port) async {
  hierarchicalLoggingEnabled = true;
  Broadcast.observer = ServerBroadcastObserver();
  Logger.root.onRecord.listen(watchRecords);

  configInjector(getIt, env: Environment.dev);
}

/// Основная функция запуска сервера Dart Frog.
/// Принимает [handler] для обработки запросов, [ip] адрес для привязки и [port] порт.
Future<HttpServer> run(Handler handler, InternetAddress ip, int port) async {
  try {
    stdout.writeln('START FROG');
    stdout.writeln('${Platform.environment['SMTP_HOST']}');
  } catch (e) {
    print('Failed');
    exit(1);
  }

  /// Scope correct works when hot-reload
  print('START');

  return serve(handler, ip, port);
}
