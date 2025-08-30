import 'package:backend/core/broadcast.dart';
import 'package:colorfy/colorfy.dart';
import 'package:logging/logging.dart';

class ServerBroadcastObserver extends BroadcastObserver {
  ServerBroadcastObserver();
  static const loggerName = 'BroadcastObs';
  final _log = Logger(loggerName)..level = Level.ALL;

  @override
  void onBroadcast(BroadcastMixin broadcast, Object? message) {
    _log.finest(
      '${broadcast.runtimeType} onBroadcast: ${color('${message?.toString()}').yellow()}\n',
    );
    super.onBroadcast(broadcast, message);
  }

  @override
  void onError(Broadcast broadcastBloc, Object error, StackTrace stackTrace) {
    _log.warning(
      '${color(broadcastBloc.runtimeType.toString()).red()} onError: ${error} ${stackTrace}',
    );
    super.onError(broadcastBloc, error, stackTrace);
  }

  @override
  void onEvent(Broadcast broadcastBloc, String message) {
    _log.finest('${broadcastBloc.runtimeType} onEvent: ${message}');
    super.onEvent(broadcastBloc, message);
  }

  @override
  void onDispose(Broadcast broadcastBloc) {
    _log.finest('${broadcastBloc.runtimeType} onDispose:');
    super.onDispose(broadcastBloc);
  }

  @override
  void onCreate(Broadcast broadcastBloc) {
    _log.finest('${broadcastBloc.runtimeType} onCreate:');
    super.onCreate(broadcastBloc);
  }
}
