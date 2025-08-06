import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:rxdart/subjects.dart';
import 'package:sha_red/sha_red.dart';

import '../../../core/network/ws_manager.dart';

abstract class AdminRepository {
  WsCallback? send;

  void setInfo(int value);
  Stream<int> get connectionCount;

  void joinRoom();
}

@LazySingleton(as: AdminRepository)
class AdminRepositoryImpl implements AdminRepository {
  @override
  WsCallback? send;
  static const _adminRoom = 'admin';

  @override
  void joinRoom() {
    send?.call(jsonEncode(WsToServer(roomId: _adminRoom, eventType: WsEventToServer.joinAdmin, payload: {}).toJson()));
  }

  final _connectionCountSubj = BehaviorSubject<int>.seeded(0);

  @override
  Stream<int> get connectionCount => _connectionCountSubj.stream;

  @override
  void setInfo(int value) {
    _connectionCountSubj.add(value);
  }
}
