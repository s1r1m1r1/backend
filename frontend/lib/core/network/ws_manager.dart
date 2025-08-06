import 'dart:async';
import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:web_socket_client/web_socket_client.dart';
import 'package:sha_red/sha_red.dart';

import '../../features/admin/_domain/admin_repository.dart';
import '../typedef.dart';

@lazySingleton
class WsManager {
  final WsCounterRepository _counterRepository;
  final WsLettersRepository _lettersRepository;
  final AdminRepository _adminRepository;

  final WebSocket _ws;
  WsManager(this._counterRepository, this._lettersRepository, this._ws, this._adminRepository) {
    _counterRepository.send = send;
    _lettersRepository.send = send;
    _adminRepository.send = send;

    _listen();
  }

  /// Send an increment message to the server.
  void send(dynamic data) => _ws.send(data);
  StreamSubscription? _wsSubscription;

  void _listen() {
    _wsSubscription = _ws.messages.listen((rawData) {
      final decoded = jsonDecode(rawData) as Map<String, dynamic>;
      final fromServer = WsFromServer.fromJson(decoded);
      switch (fromServer.eventType) {
        case WsEventFromServer.letterCreated:
          _lettersRepository.onLetter(fromServer.payload as Json);
          break;
        case WsEventFromServer.joinedCounter:
        case WsEventFromServer.counter:
          _counterRepository.onCount(fromServer.payload as Json);
          break;
        case WsEventFromServer.letters:
          break;
        // final payload = InitialPayload.fromJson(fromServer.payload as Json);
        // _counterRepository.setCount(payload.counter);
        // _lettersRepository.setLetters(payload.letters.toList());

        case WsEventFromServer.joinedLetters:
          final payload = LettersPayload.fromJson(fromServer.payload as Json);
          _lettersRepository.setLetters(payload.letters.toList());
        case WsEventFromServer.adminInfo:
          final payload = IdPayload.fromJson(fromServer.payload as Json);
          _adminRepository.setInfo(payload.id);
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

  void joinRoom(String counterRoom) {
    send?.call(
      jsonEncode(WsToServer(roomId: counterRoom, eventType: WsEventToServer.joinCounter, payload: {}).toJson()),
    );
  }

  void increment(String counterRoom) => send?.call(
    jsonEncode(WsToServer(roomId: counterRoom, eventType: WsEventToServer.incrementCounter, payload: {}).toJson()),
  );

  void decrement(String counterRoom) => send?.call(
    jsonEncode(WsToServer(roomId: counterRoom, eventType: WsEventToServer.decrementCounter, payload: {}).toJson()),
  );

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

  final _lettersSubj = BehaviorSubject<List<LetterDto>>.seeded([]);

  Stream<List<LetterDto>> get letters => _lettersSubj.stream;

  void newLetter(String roomId, LetterDto letter) {
    send?.call(
      jsonEncode(WsToServer(roomId: roomId, eventType: WsEventToServer.newLetter, payload: letter.toJson()).toJson()),
    );
  }

  void joinRoom(String roomId) {
    send?.call(
      jsonEncode(
        WsToServer(roomId: roomId, eventType: WsEventToServer.joinLetters, payload: {'roomId': roomId}).toJson(),
      ),
    );
  }

  void leaveRoom(String roomId) {
    send?.call(
      jsonEncode(
        WsToServer(roomId: roomId, eventType: WsEventToServer.leaveRoom, payload: {'roomId': roomId}).toJson(),
      ),
    );
  }

  // void listRooms() {
  //   send?.call(
  //     jsonEncode(WsToServer(roomId: roomId, eventType: WsEventToServer.listRooms, payload: {}).toJson()),
  //   );
  // }

  void sendLetterToRoom(String roomId, LetterDto letter) {
    send?.call(
      jsonEncode(
        WsToServer(
          roomId: roomId,
          eventType: WsEventToServer.sendLetterToRoom,
          payload: {'roomId': roomId, 'letter': letter.toJson()},
        ).toJson(),
      ),
    );
  }

  void fetchRoomHistory(String roomId) {
    send?.call(
      jsonEncode(
        WsToServer(roomId: roomId, eventType: WsEventToServer.fetchRoomHistory, payload: {'roomId': roomId}).toJson(),
      ),
    );
  }

  void setLetters(List<LetterDto> letters) {
    _lettersSubj.add(letters);
  }

  void onLetter(Json rawPayload) {
    final payload = LetterDto.fromJson(rawPayload);
    setLetters(List.of(_lettersSubj.value)..add(payload));
  }

  @disposeMethod
  void dispose() {
    send = null;
    _lettersSubj.close();
  }
}
