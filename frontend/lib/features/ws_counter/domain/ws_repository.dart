import 'package:frontend/core/network/network_constants.dart';
import 'package:injectable/injectable.dart';
import 'package:web_socket_client/web_socket_client.dart';

import '../../../core/network/dio_module.dart';
import 'message.dart';

/// {@template counter_repository}
/// A Dart package which manages the counter domain.
/// {@endtemplate}
@lazySingleton
class CounterRepository {
  /// {@macro counter_repository}
  CounterRepository() : _ws = WebSocket(Uri.parse(WebSocketConst.baseUrl));

  final WebSocket _ws;

  /// Send an increment message to the server.
  void increment() => _ws.send(Message.increment.value);

  /// Send a decrement message to the server.
  void decrement() => _ws.send(Message.decrement.value);

  /// Return a stream of real-time count updates from the server.
  Stream<int> get count => _ws.messages.cast<String>().map(int.parse);

  /// Return a stream of connection updates from the server.
  Stream<ConnectionState> get connection => _ws.connection;

  /// Close the connection.
  void close() => _ws.close();
}
