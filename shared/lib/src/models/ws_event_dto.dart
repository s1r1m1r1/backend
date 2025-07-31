import 'package:json_annotation/json_annotation.dart';

part 'ws_event_dto.g.dart';

@JsonSerializable()
class WsEventDto {
  final String eventType;
  final Map<String, dynamic> data;

  WsEventDto({required this.eventType, required this.data});

  factory WsEventDto.fromJson(Map<String, dynamic> json) => _$WsEventDtoFromJson(json);

  Map<String, dynamic> toJson() => _$WsEventDtoToJson(this);
}
