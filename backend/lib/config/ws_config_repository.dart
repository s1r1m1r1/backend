import 'dart:async';
import 'dart:io';

import 'package:backend/config/ws_config_datasource.dart';
import 'package:backend/core/log_colors.dart';
import 'package:backend/core/new_api_exceptions.dart';
import 'package:shared/shared.dart';

abstract class WsConfigRepository {
  FutureOr<void> init();
  FutureOr<WsConfigDto> getConfig(Role role);
}

class WsConfigRepositoryImpl implements WsConfigRepository {
  final WsConfigDatasource _datasource;

  WsConfigRepositoryImpl(this._datasource);
  final Map<Role, WsConfigDto> _configs = {};

  @override
  FutureOr<void> init() async {
    stdout.writeln('$magenta init WsConfigRepositoryImpl$reset');
    final entries = await _datasource.getListConfig();
    stdout.writeln('$magenta init count ${entries.length}$reset');
    for (final entry in entries) {
      stdout.writeln('$magenta init role ${entry.role}$reset');
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
}
