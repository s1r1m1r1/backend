import 'package:backend/modules/game/domain/ws_bot_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:sha_red/sha_red.dart';
import 'package:synchronized/synchronized.dart';

@module
abstract class BotModule {
  @injectable
  GameBot gameBot(BotRepository repository) => GameBot(repository);
}

abstract class Bot<T extends ToClient, W extends ToServer> {
  void add(T toClient);
  W simulate(T toClient);
}

class GameBot extends Bot<ToClient, BotToServer> {
  final BotRepository _botRepository;
  final _lock = Lock();
  GameBot(this._botRepository);

  @override
  void add(ToClient toClient) async {
    await _lock.synchronized(() async {
      final result = simulate(toClient);
      await _botRepository.add(result);
    });
  }

  @override
  BotToServer simulate(ToClient toClient) {
    return LeaveArenaTS();
  }
}
