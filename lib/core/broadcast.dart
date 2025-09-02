import 'dart:async';

import 'package:backend/modules/game/session_channel.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sha_red/sha_red.dart';

abstract class Broadcast<T extends ToClient> extends IBroadcast<T> {
  static BroadcastObserver? observer;
  Broadcast() {
    observer?.onCreate(this);
  }

  void addError(Object error, StackTrace stackTrace) {
    observer?.onError(this, error, stackTrace);
  }

  void addEvent(String event) {
    observer?.onEvent(this, event);
  }

  void onEvent(String message) {
    observer?.onEvent(this, message);
  }

  @override
  void broadcast(T message) {
    super.broadcast(message);
  }

  @mustCallSuper
  @override
  FutureOr<void> dispose() async {
    observer?.onDispose(this);
    super.dispose();
  }
}

abstract class IBroadcast<T extends ToClient> implements Disposable {
  // userId
  final channels = <int, ISessionChannel>{};
  abstract BroadcastId blocId;

  @mustCallSuper
  void broadcast(T message) {
    final jsonBarrel = message.jsonBarrel();
    Broadcast.observer?.onBroadcast(this, message.encoded());
    for (final channel in channels.values) {
      channel.sinkAdd(jsonBarrel);
    }
  }

  // удалить канал если он уже подписан
  // далее подписать новый канал
  void subscribe(ISessionChannel channel) {
    final userId = channel.userId;
    final oldChannel = channels[userId];
    if (oldChannel != null) {
      oldChannel.onSubscriptionCancel(blocId);
    }
    channels[userId] = channel;
  }

  // отписаться от блока
  // вызов для подписчика если он хочет отписаться
  void unsubscribe(ISessionChannel channel) => channels.remove(channel);

  @mustCallSuper
  FutureOr<void> dispose() async {
    for (final channel in channels.entries) {
      // удалить key BroadId ,не нужно завершать подписку так как блок завершил
      // работу и больше не будет генерировать события
      // тем самым сохранить актуальный список подписок для каналов
      channel.value.onSubscriptionCancel(blocId);
    }
    channels.clear();
  }
}

abstract class BroadcastObserver {
  const BroadcastObserver();
  @mustCallSuper
  void onCreate(Broadcast bloc) {}

  @mustCallSuper
  void onError(Broadcast truck, Object error, StackTrace stackTrace) {}

  @mustCallSuper
  void onEvent(Broadcast bloc, String message) {}

  @mustCallSuper
  void onDispose(Broadcast trick) {}

  @mustCallSuper
  void onBroadcast(IBroadcast broadcast, Object? message) {}
}

abstract class Disposable {
  FutureOr<void> dispose();
}
