// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connection_stats_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConnectionStatsDto _$ConnectionStatsDtoFromJson(Map<String, dynamic> json) =>
    ConnectionStatsDto(
      totalActiveConnections: (json['total_active_connections'] as num).toInt(),
      connectionsPerChannel: Map<String, int>.from(
        json['connections_per_channel'] as Map,
      ),
    );

Map<String, dynamic> _$ConnectionStatsDtoToJson(ConnectionStatsDto instance) =>
    <String, dynamic>{
      'total_active_connections': instance.totalActiveConnections,
      'connections_per_channel': instance.connectionsPerChannel,
    };
