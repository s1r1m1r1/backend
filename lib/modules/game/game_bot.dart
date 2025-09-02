import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sha_red/sha_red.dart';
import 'package:synchronized/synchronized.dart';

// @module
// abstract class BotModule {
//   @injectable
//   GameBot gameBot(BotRepository repository) => GameBot(repository);

//   @injectable
//   DisconnectBot disconnectBot() => DisconnectBot(repository);
// }

abstract class Bot<T extends ToClient, W extends ToServer> {
  void Function(ToServer)? botCallback;
  void add(T toClient);
  W simulate(T toClient);
  @mustCallSuper
  void dispose() {}
}

class DisconnectBot extends Bot<ToClient, BotToServer> {
  DisconnectBot();
  Timer? _timer;
  final _lock = Lock();

  void start() {
    _timer = Timer(const Duration(seconds: 10), () async {
      botCallback?.call(DisconnectTS());
    });
  }

  @override
  void add(ToClient toClient) async {
    await _lock.synchronized(() async {
      // final result = simulate(toClient);
      // await _botRepository.add(result);
    });
  }

  @override
  BotToServer simulate(ToClient toClient) {
    return DisconnectTS();
  }

  @mustCallSuper
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

class GameBot extends Bot<ToClient, BotToServer> {
  final _lock = Lock();
  GameBot();

  @override
  void add(ToClient toClient) async {
    await _lock.synchronized(() async {
      // final result = simulate(toClient);
      // await _botRepository.add(result);
    });
  }

  @override
  BotToServer simulate(ToClient toClient) {
    return LeaveArenaTS();
  }
}
