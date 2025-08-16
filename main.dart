import 'dart:io';
import 'package:backend/core/inject.dart';
import 'package:backend/ws_/logic/server_bloc_observer.dart';
import 'package:broadcast_bloc/broadcast_bloc.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:get_it/get_it.dart';

Future<void> init(InternetAddress ip, int port) async {
  // Any code initialized within this method will only run on server start, any hot reloads
  // afterwards will not trigger this method until a hot restart.
  Bloc.observer = ServerBlocObserver();
  configInjector(GetIt.I);
}

/// Основная функция запуска сервера Dart Frog.
/// Принимает [handler] для обработки запросов, [ip] адрес для привязки и [port] порт.
Future<HttpServer> run(Handler handler, InternetAddress ip, int port) async {
  try {
    stdout.writeln('START FROG');
  } catch (e) {
    print('Failed');
    exit(1);
  }
  /*
  final chain = Platform.script.resolve('certificates/server_chain.pem').toFilePath();
  final key = Platform.script.resolve('certificates/server_key.pem').toFilePath();
  // Создаем контекст безопасности для использования SSL/TLS.
  final securityContext = SecurityContext()
    ..useCertificateChain(chain)
    ..usePrivateKey(key, password: 'MyPowerfulFrogPassword');
   
  // Запускаем сервер Dart Frog с указанным обработчиком, IP-адресом, портом и контекстом безопасности.
  return serve(handler, ip, port, securityContext: securityContext);
*/

  /// Scope correct works when hot-reload
  print('START');

  return serve(handler, ip, port);
}
