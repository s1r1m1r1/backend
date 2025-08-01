import 'dart:async';
import 'dart:convert';

import 'package:frontend/core/network/network_constants.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:web_socket_client/web_socket_client.dart';
import 'package:shared/shared.dart';

import '../../../core/typedef.dart';

@lazySingleton
class WsManager {
  final WsCounterRepository _counterRepository;
  final WsLettersRepository _lettersRepository;

  WsManager(this._counterRepository, this._lettersRepository) : _ws = WebSocket(Uri.parse(WebSocketConst.baseUrl)) {
    listen();
    _counterRepository.send = send;
    _lettersRepository.send = send;
  }

  final WebSocket _ws;

  /// Send an increment message to the server.
  void send(dynamic data) => _ws.send(data);
  StreamSubscription? _wsSubscription;
  void listen() {
    _wsSubscription = _ws.messages.listen((rawData) {
      final decoded = jsonDecode(rawData) as Map<String, dynamic>;
      final fromServer = WsFromServer.fromJson(decoded);
      switch (fromServer.eventType) {
        case WsEventFromServer.messageCreated:
          _lettersRepository.onMessage(fromServer.payload as Json);
          break;
        case WsEventFromServer.counter:
          _counterRepository.onCount(fromServer.payload as Json);
          break;
        case WsEventFromServer.messages:
          break;
        case WsEventFromServer.initial:
          final payload = InitialPayload.fromJson(fromServer.payload as Json);
          _counterRepository.setCount(payload.counter);
          _lettersRepository.setMessages(payload.letters.toList());
      }
    });
  }

  /// Return a stream of connection updates from the server.
  Stream<ConnectionState> get connection => _ws.connection;

  /// Close the connection.
  void close() => _ws.close();
  @disposeMethod
  void dispose() {
    _wsSubscription?.cancel();
    _ws.close();
  }
}

typedef WsCallback = void Function(dynamic data);

@lazySingleton
class WsCounterRepository {
  WsCounterRepository();
  WsCallback? send;

  void increment() =>
      send?.call(jsonEncode(WsToServer(eventType: WsEventToServer.incrementCounter, payload: {}).toJson()));

  void decrement() =>
      send?.call(jsonEncode(WsToServer(eventType: WsEventToServer.decrementCounter, payload: {}).toJson()));

  final _counterSubj = BehaviorSubject<int>.seeded(0);

  Stream<int> get countStream => _counterSubj.stream;

  void setCount(int value) => _counterSubj.add(value);
  void onCount(Json rawPayload) {
    final payload = CounterPayload.fromJson(rawPayload);
    setCount(payload.value);
  }

  @disposeMethod
  void dispose() {
    send = null;
    _counterSubj.close();
  }
}

@lazySingleton
class WsLettersRepository {
  WsCallback? send;

  final _messagesSubj = BehaviorSubject<List<LetterDto>>.seeded([]);

  Stream<List<LetterDto>> get letters => _messagesSubj.stream;

  void newLetter(LetterDto letters) {
    send?.call(jsonEncode(WsToServer(eventType: WsEventToServer.newMessage, payload: letters.toJson()).toJson()));
  }

  void initMessages(Json payload) {
    final messages = (payload as List).map((i) => LetterDto.fromJson(i as Json));
    _messagesSubj.add([...messages]);
  }

  void setMessages(List<LetterDto> letters) {
    _messagesSubj.add(letters);
  }

  void onMessage(Json rawPayload) {
    final payload = LetterDto.fromJson(rawPayload);
    setMessages(List.of(_messagesSubj.value)..add(payload));
  }

  @disposeMethod
  void dispose() {
    send = null;
    _messagesSubj.close();
  }
}
