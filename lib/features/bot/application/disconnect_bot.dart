import 'dart:async';

import 'package:dto/dto.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:synchronized/synchronized.dart';

import '../../auth/application/session_socket.dart';

class DisconnectBot extends SinkBot<WsResponse, WsRequest> {
  DisconnectBot({
    required super.botRepository,
    required super.userId,
    required super.unitId,
  });
  Timer? _timer;
  final _lock = Lock();

  @override
  void init() {
    _timer = Timer(const Duration(seconds: 10), () async {
      botCallback?.call(const DisconnectRequest(n: Noun('bot')));
    });
  }

  @override
  void sinkAdd(EncodedPacket<WsResponse> encoded) async {
    await _lock.synchronized(() async {
      // final result = simulate(toClient);
      // await _botRepository.add(result);
    });
  }

  @mustCallSuper
  @override
  void dispose() {
    _timer?.cancel();
  }
}
