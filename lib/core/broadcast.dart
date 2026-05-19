import 'dart:async';

import 'package:dto/dto.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rxdart/rxdart.dart';

import '../features/auth/application/session_socket.dart';
import 'app_observer.dart';
import 'di/injection.dart';

abstract class BroadcastThrottle<T extends WsResponse> extends Broadcast<T> {
  BehaviorSubject<T>? _controller;
  StreamSubscription<T>? _subscription;

  @mustCallSuper
  void initBroadcast({
    Duration throttleDuration = const Duration(seconds: 10),
  }) {
    _controller = BehaviorSubject<T>();
    _subscription = _controller?.stream
        .throttleTime(throttleDuration, trailing: true, leading: true)
        .distinct()
        .listen(super.broadcast);
  }

  @override
  // ignore: must_call_super
  void broadcast(T message) {
    _controller?.add(message);
    // super.broadcast(message);
  }

  @override
  Future<void> dispose() async {
    await _controller?.close();
    await _subscription?.cancel();
    _controller = null;
    _subscription = null;
    await super.dispose();
  }
}

abstract class Broadcast<T extends WsResponse> extends IBroadcast<T> {
  Broadcast() {
    observer?.onCreate(this);
  }
  static AppObserver? get observer =>
      getIt.isRegistered<AppObserver>() ? getIt<AppObserver>() : null;

  void addError(Object error, StackTrace stackTrace) {
    observer?.onLifecycleError(this, error, stackTrace);
  }

  @mustCallSuper
  @override
  FutureOr<void> dispose() async {
    observer?.onDispose(this);
    super.dispose();
  }
}

abstract mixin class IBroadcast<T extends WsResponse> {
  final channels = <String, ISocket>{};
  abstract BroadcastId broadcastId;

  @mustCallSuper
  void broadcast(T message) {
    final encodedPacket = message.toPacket();
    Broadcast.observer?.onBroadcast(this, message.encode());
    final currentChannels = channels.values.toList();
    for (final channel in currentChannels) {
      channel.sinkAdd(encodedPacket);
    }
  }

  void subscribe(ISocket channel) {
    final socketId = channel.socketId;
    final oldChannel = channels[socketId];
    if (oldChannel != null) {
      oldChannel.onSubscriptionCancel(broadcastId);
    }
    channels[socketId] = channel;
  }

  void unsubscribe(ISocket channel) => channels.remove(channel.socketId);

  @mustCallSuper
  FutureOr<void> dispose() async {
    for (final channel in channels.entries) {
      channel.value.onSubscriptionCancel(broadcastId);
    }
    channels.clear();
  }
}

abstract base class BroadcastSupervisor<
  T extends WsResponse,
  R extends WsResponse,
  Room extends Broadcast<R>
>
    extends Broadcast<T>
    implements ISocket {
  final _rooms = <BroadcastId, Room>{};
  void addRoom(BroadcastId id, Room room) => _rooms[id] = room;
  Room? removeRoom(BroadcastId id) => _rooms.remove(id);
  Room? getRoom(BroadcastId id) => _rooms[id];

  Iterable<Room> get rooms => _rooms.values;

  /// Returns the number of active rooms.
  int get roomCount => _rooms.length;

  @override
  final shouldUnsubscribe = <BroadcastId, LateCallback>{};

  @override
  void onSubscriptionCancel(BroadcastId id) {
    shouldUnsubscribe.remove(id);
  }

  /// перехватить сообщения и обработать
  void onRoomBroadcast(EncodedPacket<R> response);

  @protected
  @override
  void sinkAdd(EncodedPacket<WsResponse> encoded) {
    if (encoded.data is R) {
      onRoomBroadcast(EncodedPacket<R>(encoded.data as R, encoded.rawJson));
    }
  }

  @override
  Future<void> dispose() async {
    for (final room in _rooms.values) {
      await room.dispose();
    }
    _rooms.clear();
    return super.dispose();
  }
}

extension LogBroadcastEx on Broadcast<dynamic> {
  void log(String message) {
    Broadcast.observer?.log('Broadcast.$runtimeType.$broadcastId', message);
  }

  void warn(String message) {
    Broadcast.observer?.warn('Broadcast.$runtimeType.$broadcastId', message);
  }
}

extension LogSupervisorEx on BroadcastSupervisor {
  void log(String message) {
    Broadcast.observer?.log('Supervisor.$runtimeType.$broadcastId', message);
  }

  void warn(String message) {
    Broadcast.observer?.warn('Supervisor.$runtimeType.$broadcastId', message);
  }
}
