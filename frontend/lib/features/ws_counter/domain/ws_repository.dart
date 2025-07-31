import 'dart:convert';

import 'package:frontend/core/network/network_constants.dart';
import 'package:injectable/injectable.dart';
import 'package:web_socket_client/web_socket_client.dart';
import 'package:shared/shared.dart';

/// {@template counter_repository}
/// A Dart package which manages the counter domain.
/// {@endtemplate}
@lazySingleton
class CounterRepository {
  /// {@macro counter_repository}
  CounterRepository() : _ws = WebSocket(Uri.parse(WebSocketConst.baseUrl));

  final WebSocket _ws;

  /// Send an increment message to the server.

  void increment() =>
      _ws.send(jsonEncode(WsToServer(eventType: WsEventToServer.incrementCounter, payload: {}).toJson()));

  /// Send a decrement message to the server.
  void decrement() =>
      _ws.send(jsonEncode(WsToServer(eventType: WsEventToServer.decrementCounter, payload: {}).toJson()));

  /// Return a stream of real-time count updates from the server.
  Stream<int> get count {
    // return _ws.messages.cast<String>().map(int.parse);
    return _ws.messages.map((rawData) {
      final decoded = jsonDecode(rawData) as Map<String, dynamic>;
      final fromServer = WsFromServer.fromJson(decoded);
      switch (fromServer.eventType) {
        case WsEventFromServer.messageCreated:
          return -10;
        case WsEventFromServer.counter:
          final count = CounterPayload.fromJson(fromServer.payload);
          return count.value;
      }
    });
  }

  /// Return a stream of connection updates from the server.
  Stream<ConnectionState> get connection => _ws.connection;

  /// Close the connection.
  void close() => _ws.close();
}
