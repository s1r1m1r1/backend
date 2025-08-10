import 'dart:async';

import 'package:backend/cf/ws_config_datasource.dart';
import 'package:backend/core/debug_log.dart';
import 'package:backend/core/log_colors.dart';
import 'package:backend/core/new_api_exceptions.dart';

import 'package:sha_red/sha_red.dart';

abstract class WsConfigRepository {
  FutureOr<void> init();
  FutureOr<WsConfigDto> getConfig(Role role);
  Map<Role, WsConfigDto> get configs;
}

class WsConfigRepositoryImpl implements WsConfigRepository {
  final WsConfigDatasource _datasource;

  WsConfigRepositoryImpl(this._datasource);
  final Map<Role, WsConfigDto> _configs = {};

  @override
  FutureOr<void> init() async {
    debugLog('$magenta init WsConfigRepositoryImpl$reset');
    final entries = await _datasource.getListConfig();
    debugLog('$magenta init count ${entries.length}$reset');
    for (final entry in entries) {
      debugLog(
        '$magenta init name: ${entry.name},letterRoom: ${entry.lettersRoom},counterRoom: ${entry.counterRoom} role: ${entry.role}$reset',
      );
      _configs[entry.role] = entry;
    }
  }

  @override
  FutureOr<WsConfigDto> getConfig(Role role) async {
    if (_configs.isEmpty) await init();
    final dto = _configs[role];
    if (dto == null) throw ApiException.notFound(message: 'ws not found config for role $role');
    return dto;
  }

  @override
  Map<Role, WsConfigDto> get configs => _configs;
}
