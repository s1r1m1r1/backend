import 'dart:async';

import 'package:backend/core/session_channel.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sha_red/sha_red.dart';

abstract class Broadcast<S extends JsonMessage> with BroadcastMixin<S> {
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
  void broadcast(S message) {
    super.broadcast(message);
  }

  @mustCallSuper
  @override
  FutureOr<void> dispose() async {
    observer?.onDispose(this);
    super.dispose();
  }
}

mixin BroadcastMixin<S extends JsonMessage> implements Disposable {
  // userId
  final channels = <int, ISessionChannel>{};
  abstract BroadcastId blocId;

  @mustCallSuper
  void broadcast(S message) {
    final encodedJson = message.encoded();
    Broadcast.observer?.onBroadcast(this, message.encoded());
    for (final channel in channels.values) {
      channel.sinkAdd(encodedJson);
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
  void onBroadcast(BroadcastMixin broadcast, Object? message) {}
}

abstract class Disposable {
  FutureOr<void> dispose();
}
