import 'dart:io';
import 'package:backend/core/inject.dart';
import 'package:backend/db_client/db_client.dart';
import 'package:backend/ws_/logic/active_users/active_users_bloc.dart';
import 'package:backend/ws_/logic/letter.bloc_manager.dart';
import 'package:backend/ws_/logic/server_bloc_observer.dart';
import 'package:broadcast_bloc/broadcast_bloc.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:get_it/get_it.dart';
import 'package:sha_red/sha_red.dart';
// import 'package:logging/logging.dart';

// инициализация зависимостей один раз, во время  hot-reload  не перезапускается
Future<void> init(InternetAddress ip, int port) async {
  Bloc.observer = ServerBlocObserver();
  configInjector(GetIt.I);
  final tables = await GetIt.I.get<DbClient>().configDao.getListConfig();
  final indexRoom = tables.indexWhere((i) => i.role == Role.user);
  if (indexRoom == -1) exit(1);
  final roomId = tables[indexRoom].id;
  GetIt.I.get<ActiveUsersBloc>()..add(ActiveUsersEvent.setRoomId(roomId));
  GetIt.I.get<LetterBlocManager>()..createRoom(roomId);
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
