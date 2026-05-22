import 'dart:async';

import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:dto/dto.dart';

abstract class Sink<T extends WsResponse> {
  UserId? get userId;
  set userId(UserId? id);

  UnitId? get unitId;
  set unitId(UnitId? id);
  void sinkAdd(EncodedPacket<T> encoded);
  void dispose();
}

extension type RegisteredUserChannel._(UserChannel _raw) {
  factory RegisteredUserChannel(
    UserChannel channel,
    UserId userId,
    UnitId unitId,
  ) {
    channel.userId = userId;
    channel.unitId = unitId;
    return RegisteredUserChannel._(channel);
  }
  UserId get userId => _raw.userId!;
  UnitId get unitId => _raw.unitId!;
  set userId(UserId id) => _raw.userId = id;
  set unitId(UnitId id) => _raw.unitId = id;

  WebSocketChannel get channel => _raw.channel;
  void sinkAdd(EncodedPacket<WsResponse> encoded) => _raw.sinkAdd(encoded);
  void dispose() => _raw.dispose();
  Future<void> close(int? code, String? reason) => _raw.close(code, reason);
}

class UserChannel extends Sink<WsResponse> {
  UserChannel(this._channel, {UserId? userId, UnitId? unitId})
    : _userId = userId,
      _unitId = unitId;
  final WebSocketChannel _channel;

  WebSocketChannel get channel => _channel;

  UnitId? _unitId;
  @override
  UnitId? get unitId => _unitId;

  @override
  set unitId(UnitId? id) => _unitId = id;

  @override
  void sinkAdd(EncodedPacket<WsResponse> encoded) {
    _channel.sink.add(encoded.rawJson);
  }

  Future<void> close(int? code, String? reason) =>
      _channel.sink.close(code, reason);

  @override
  bool operator ==(Object other) =>
      other is UserChannel && other._channel == _channel;

  @override
  int get hashCode => _channel.hashCode;

  @override
  void dispose() {}

  UserId? _userId;
  @override
  UserId? get userId => _userId;
  @override
  set userId(UserId? id) => _userId = id;
}
