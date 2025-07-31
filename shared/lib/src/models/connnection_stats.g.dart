// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connection_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConnectionStats _$ConnectionStatsFromJson(Map<String, dynamic> json) => ConnectionStats(
  totalActiveConnections: (json['total_active_connections'] as num).toInt(),
  connectionsPerChannel: Map<String, int>.from(json['connections_per_channel'] as Map),
);

Map<String, dynamic> _$ConnectionStatsToJson(ConnectionStats instance) => <String, dynamic>{
  'total_active_connections': instance.totalActiveConnections,
  'connections_per_channel': instance.connectionsPerChannel,
};
