import 'package:json_annotation/json_annotation.dart';
part 'connection_stats_dto.g.dart';

@JsonSerializable()
class ConnectionStatsDto {
  @JsonKey(name: 'total_active_connections')
  final int totalActiveConnections;

  @JsonKey(name: 'connections_per_channel')
  final Map<String, int> connectionsPerChannel;

  ConnectionStatsDto({required this.totalActiveConnections, required this.connectionsPerChannel});

  factory ConnectionStatsDto.fromJson(Map<String, dynamic> json) => _$ConnectionStatsDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ConnectionStatsDtoToJson(this);
}
