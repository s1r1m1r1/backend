import 'dart:async';

import 'package:dto/dto.dart';

import '../domain/session.dart';
import 'bot_sink.dart';
import 'user_channel.dart';

export 'bot_sink.dart';
export 'user_channel.dart';

typedef LateCallback = FutureOr<void> Function();

abstract class ISocket<S extends WsResponse> {
  SocketId get socketId;
  abstract final Map<BroadcastId, LateCallback> shouldUnsubscribe;
  void sinkAdd(EncodedPacket<S> encoded);
  void onSubscriptionCancel(BroadcastId id);
  Future<void> dispose();
}

abstract class IGameSocket<S extends WsResponse> extends ISocket<S> {
  UserId get userId;
  UnitId get unitId;
  void replaceSink(RegisteredUserChannel sink);
  void setBot(SinkBot? bot);

  @override
  abstract final Map<BroadcastId, LateCallback> shouldUnsubscribe;
  @override
  void sinkAdd(EncodedPacket<S> encoded);
  @override
  void onSubscriptionCancel(BroadcastId id);
  @override
  Future<void> dispose();
}

class GameSocket extends IGameSocket {
  GameSocket._(this.session, this._userSink, this._bot, this.botMode);
  factory GameSocket.fromBot(GameSession session, SinkBot bot) =>
      GameSocket._(session, null, bot, true);

  factory GameSocket.fromChannel(GameSession session, UserChannel channel) {
    return GameSocket._(
      session,
      RegisteredUserChannel(channel, session.user.userId, session.unit.unitId),
      null,
      false,
    );
  }

  final GameSession session;

  @override
  SocketId get socketId => SocketId(userId);
  @override
  UserId get userId => session.user.userId;

  @override
  UnitId get unitId => session.unit.unitId;

  RegisteredUserChannel? _userSink;
  RegisteredUserChannel? get userSink => _userSink;

  String? get activeRoomId {
    final broads = joinedBroadsInfo();
    for (var info in broads) {
      if (info.id.startsWith('edict')) {
        return info.id;
      }
    }
    return null;
  }

  GameLocation get location {
    final broads = joinedBroads();
    if (broads.any((id) => id.id.startsWith('edict'))) {
      return GameLocation.game;
    }
    if (broads.any((id) => id.id == 'arena-2')) {
      return GameLocation.arena;
    }
    return GameLocation.menu;
  }

  SinkBot? _bot;
  SinkBot? get bot => _bot;
  bool botMode = false;
  bool get isBot => _bot != null && botMode;

  @override
  final shouldUnsubscribe = <BroadcastId, LateCallback>{};

  DateTime? lastActiveTime;

  /// Комната, в которую пользователь переходит.
  /// Заполняется при отправке [TransitionResponse], очищается после получения ACK.
  /// Подписка выполняется атомарно в [commitPendingTransition].
  BroadcastId? pendingTransitionRoom;
  void Function(GameSocket)? _pendingTransitionSubscriber;

  /// Атомарно подписывает сокет к [pendingTransitionRoom].
  /// Вызывается из AckCMD при получении AckRequest от клиента.
  void commitPendingTransition() {
    final room = pendingTransitionRoom;
    final subscriber = _pendingTransitionSubscriber;
    pendingTransitionRoom = null;
    _pendingTransitionSubscriber = null;
    if (room != null && subscriber != null) {
      subscriber(this);
    }
  }

  void setPendingTransition(
    BroadcastId room,
    void Function(GameSocket socket) subscribe,
  ) {
    pendingTransitionRoom = room;
    _pendingTransitionSubscriber = subscribe;
  }

  final Map<String, Completer<AckRequest>> _pendingAcks = {};

  /// Sends a message and waits for an acknowledgment.
  ///
  /// Multiple concurrent acks are supported as long as they have different nonces.
  /// If a nonce is reused while the previous ack is still pending, the old ack
  /// will be completed with an error and replaced with the new one.
  Future<AckRequest> sendWithAck<T extends RequiredAckResponse>(
    T message, {
    Duration timeout = const Duration(seconds: 10),
  }) {
    final n = message.n;
    final existing = _pendingAcks[n];

    // If there's an existing pending ack with the same nonce, complete it with an error
    // and replace it with the new one. This prevents "Ack already pending" errors
    // when the same nonce is reused (e.g., in broadcast scenarios).
    if (existing != null && !existing.isCompleted) {
      existing.completeError(
        StateError('Ack superseded by new request: socketId=$socketId n=$n'),
      );
    }

    final completer = Completer<AckRequest>();
    _pendingAcks[n] = completer;

    sinkAdd(message.toPacket());

    return completer.future.timeout(
      timeout,
      onTimeout: () {
        _pendingAcks.remove(n);
        throw TimeoutException('Ack timeout: socketId=$socketId n=$n');
      },
    );
  }

  void handleAck(AckRequest ack) {
    final completer = _pendingAcks.remove(ack.n);
    if (completer != null && !completer.isCompleted) {
      completer.complete(ack);
    }
  }

  @override
  void replaceSink(RegisteredUserChannel? sink) {
    botMode = false;
    _bot?.dispose();
    // передать userId в sink
    if (sink != null) {
      sink.userId = userId;
    }
    // сбросить ботов , и userId
    _userSink?.dispose();
    // заменить sink
    _userSink = sink;
  }

  @override
  void setBot(SinkBot? bot) {
    botMode = true;
    _bot = bot;
  }

  @override
  void sinkAdd(EncodedPacket<WsResponse> jsonBarrel) {
    if (isBot) {
      _bot?.sinkAdd(jsonBarrel);
    } else {
      _userSink?.sinkAdd(jsonBarrel);
    }
  }

  @override
  Future<void> dispose() async {
    final pending = Map.of(_pendingAcks);
    _pendingAcks.clear();
    for (final entry in pending.entries) {
      final completer = entry.value;
      if (!completer.isCompleted) {
        completer.completeError(
          StateError('Socket disposed: socketId=$socketId n=${entry.key}'),
        );
      }
    }

    final copy = Map.of(shouldUnsubscribe);
    await Future.forEach(copy.entries, (entry) async {
      await entry.value.call();
      shouldUnsubscribe.remove(entry.key);
    });

    shouldUnsubscribe.clear();
  }

  @override
  int get hashCode => userId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameSocket &&
          runtimeType == other.runtimeType &&
          userId == other.userId;

  @override
  void onSubscriptionCancel(BroadcastId id) {
    shouldUnsubscribe.remove(id);
  }

  List<BroadcastId> joinedBroads() {
    final keys = shouldUnsubscribe.keys.toList();
    return keys;
  }

  List<BroadcastMemberDto> joinedBroadsInfo() {
    return shouldUnsubscribe.keys.map((id) {
      return BroadcastMemberDto(id: id);
    }).toList();
  }
}
