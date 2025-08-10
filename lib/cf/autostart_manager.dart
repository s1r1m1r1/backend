import 'dart:async';
import 'dart:io';

import 'package:backend/ws_/chat_room_repository.dart';
import 'package:backend/ws_/counter_repository.dart';
import 'package:backend/core/log_colors.dart';
// import '../inject/inject.dart';

import 'package:backend/cf/ws_config_repository.dart';

class AutostartManager {
  final WsConfigRepository _wsConfigRepo;
  final CounterRepository _counterRepo;
  final ChatRoomRepository _chatRoomRepo;
  AutostartManager(this._wsConfigRepo, this._counterRepo, this._chatRoomRepo);

  bool isReady = false;

  Future<void> init() async {
    if (isReady) return;
    try {
      await _wsConfigRepo.init();
      final configs = _wsConfigRepo.configs;
      for (final c in configs.values) {
        _counterRepo.putCounter(c.counterRoom);
        _chatRoomRepo.add(c.counterRoom);
      }
      stdout.writeln(
        '$green AutostartManager:counter ${_counterRepo.counter('user')} ,2: ${_counterRepo.counter('test')}',
      );
      isReady = true;
    } catch (e) {
      stdout.writeln('$red init WsConfigRepositoryImpl error $e$reset');
    }
  }
}
