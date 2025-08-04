import 'package:json_annotation/json_annotation.dart';

import 'ws_event_to_server.dart';

part 'ws_to_server.g.dart';

@JsonSerializable()
class WsToServer {
  @JsonKey(name: 'event')
  final WsEventToServer eventType;

  @JsonKey(name: 'payload')
  final Object? payload;

  @JsonKey(name: 'room')
  final String roomId;

  WsToServer({required this.roomId, required this.eventType, required this.payload});

  factory WsToServer.fromJson(Map<String, dynamic> json) => _$WsToServerFromJson(json); // вызывает фронт

  Map<String, dynamic> toJson() => _$WsToServerToJson(this); // вызывает сервер
}
