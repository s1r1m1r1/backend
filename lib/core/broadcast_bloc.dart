import 'package:backend/core/session_channel.dart';
import 'package:bloc/bloc.dart';
import 'package:sha_red/sha_red.dart';
export 'package:bloc/bloc.dart';

class BroadcastBloc<Event, State extends BroadcastState>
    extends Bloc<Event, State>
    with BroadcastMixin {
  /// {@macro broadcast_bloc}
  BroadcastBloc(super.initialState);
}

/// {@template broadcast_cubit}
/// A specialized [Cubit] which supports broadcasting state changes
/// to all subscribed stream channels.
/// {@endtemplate}
class BroadcastCubit<State extends BroadcastState> extends Cubit<State>
    with BroadcastMixin {
  /// {@macro broadcast_cubit}
  BroadcastCubit(super.initialState);
}

/// A mixin on [BlocBase] which exposes APIs to [subscribe]/[unsubscribe]
/// stream channels and broadcast all state changes to subscribed channels.
mixin BroadcastMixin<State extends BroadcastState> on BlocBase<State> {
  List<SessionChannel>? _channels = <SessionChannel>[];

  @override
  void onChange(Change<State> change) {
    super.onChange(change);
    final toClient = change.nextState.toClient();
    if (toClient != null) {
      _broadcast(toClient);
    }
  }

  void _broadcast(ToClient message) {
    if (_channels == null) return;
    for (final channel in _channels!) {
      channel.sinkAdd(message);
    }
  }

  /// The provided [channel] will be notified of all state changes.
  void subscribe(SessionChannel channel) => _channels?.add(channel);

  /// The provided [channel] will no longer be notified of state changes.
  void unsubscribe(SessionChannel channel) => _channels?.remove(channel);

  @override
  Future<void> close() {
    _channels?.clear();
    _channels = null;
    return super.close();
  }
}

abstract class BroadcastState {
  ToClient? toClient();
}
