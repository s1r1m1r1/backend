import 'dart:async';

import 'package:backend/core/bloc_id.dart';
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

  @override
  void broadcast(S message) {
    // observer?.onBroadcast(this, message.encoded());
    super.broadcast(message);
  }

  @mustCallSuper
  @override
  FutureOr<void> dispose() async {
    observer?.onDispose(this);
    // truck.dispose();
    super.dispose();
  }
}

mixin BroadcastMixin<S extends JsonMessage> implements Disposable {
  final _channels = <ISessionChannel>[];
  abstract BlocId blocId;
  // получить список подписчиков,
  // блок может получить список каналов подписчиков
  // новый список чтобы не изменять оригинальный
  List<ISessionChannel> get channels => List.of(_channels);

  @mustCallSuper
  void broadcast(S message) {
    final encodedJson = message.encoded();
    Broadcast.observer?.onBroadcast(this, message.encoded());
    for (final channel in _channels) {
      channel.sinkAdd(encodedJson);
    }
  }

  // удалить канал если он уже подписан
  // далее подписать новый канал
  void subscribe(ISessionChannel channel) {
    if (_channels.contains(channel)) {
      _channels.remove(channel);
    }
    _channels.add(channel);
  }

  // отписаться от блока
  // вызов для подписчика если он хочет отписаться
  void unsubscribe(ISessionChannel channel) => _channels.remove(channel);

  @mustCallSuper
  FutureOr<void> dispose() async {
    for (final channel in _channels) {
      // удалить key BlocId ,не нужно завершать подписку так как блок завершил
      // работу и больше не будет генерировать события
      // тем самым сохранить актуальный список подписок для каналов
      channel.onSubscriptionCancel(blocId);
    }
    _channels.clear();
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
