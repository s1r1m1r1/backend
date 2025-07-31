import 'package:json_annotation/json_annotation.dart';

import 'ws_event_to_server.dart';

part 'ws_to_server.g.dart';

@JsonSerializable()
class WsToServer {
  @JsonKey(name: 'event')
  final WsEventToServer eventType;

  @JsonKey(name: 'payload')
  final Map<String, dynamic> payload;

  WsToServer({required this.eventType, required this.payload});

  factory WsToServer.fromJson(Map<String, dynamic> json) => _$WsToServerFromJson(json); // вызывает фронт

  Map<String, dynamic> toJson() => _$WsToServerToJson(this); // вызывает сервер
}
