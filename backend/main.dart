import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

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
  return serve(handler, ip, port);
}
