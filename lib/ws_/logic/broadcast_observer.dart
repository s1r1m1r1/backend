import 'package:backend/core/debug_log.dart';
import 'package:backend/core/log_colors.dart';
import 'package:backend/core/broadcast.dart';

class ServerBroadcastObserver extends BroadcastObserver {
  @override
  void onBroadcast(BroadcastMixin broadcast, Object? message) {
    debugLog('$yellow${broadcast.runtimeType} onBroadcast$reset ${message}');
    super.onBroadcast(broadcast, message);
  }

  @override
  void onError(Broadcast broadcastBloc, Object error, StackTrace stackTrace) {
    super.onError(broadcastBloc, error, stackTrace);
  }

  @override
  void onEvent(Broadcast broadcastBloc, String message) {
    super.onEvent(broadcastBloc, message);
  }

  @override
  void onDispose(Broadcast broadcastBloc) {
    debugLog('$yellow${broadcastBloc.runtimeType} onDispose$reset ');
    super.onDispose(broadcastBloc);
  }

  @override
  void onCreate(Broadcast broadcastBloc) {
    debugLog('$yellow${broadcastBloc.runtimeType} onCREATE$reset ');
    super.onCreate(broadcastBloc);
  }
}
