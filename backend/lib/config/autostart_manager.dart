import 'dart:async';
import 'dart:io';

import 'package:backend/web_socket/counter_repository.dart';
import 'package:backend/core/log_colors.dart';
import 'package:backend/inject/inject.dart';
import 'package:injectable/injectable.dart';

import 'ws_config_repository.dart';

@LazySingleton(scope: BackendScope.name)
class AutostartManager {
  final WsConfigRepository _wsConfigRepo;
  final CounterRepository _counterRepo;
  AutostartManager(this._wsConfigRepo, this._counterRepo);

  Future<void> init() async {
    try {
      await _wsConfigRepo.init();
      final configs = _wsConfigRepo.configs;
      for (final c in configs.values) {
        _counterRepo.putCounter(c.counterRoom);
      }
      stdout.writeln(
        '$green AutostartManager:counter ${_counterRepo.counter('user')} ,2: ${_counterRepo.counter('test')}',
      );
    } catch (e) {
      stdout.writeln('$red init WsConfigRepositoryImpl error $e$reset');
    }
  }
}
