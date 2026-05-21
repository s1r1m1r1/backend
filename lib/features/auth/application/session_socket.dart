import 'dart:async';

import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:dto/dto.dart';

import '../../bot/application/ws_bot_repository.dart';
import '../domain/session.dart';

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
  void replaceSink(UserChannel? sink);
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
      ._(session, null, bot, true);

  factory GameSocket.fromChannel(GameSession session, UserChannel channel) =>
      ._(session, channel, null, false);

  final GameSession session;

  @override
  SocketId get socketId => SocketId(userId);
  @override
  UserId get userId => session.user.userId;

  UserChannel? _userSink;
  UserChannel? get userSink => _userSink;

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
  void replaceSink(UserChannel? sink) {
    botMode = false;
    _bot?.dispose();
    // передать userId в sink
    sink?.userId = userId;
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
//-------------------------------------------------------------

abstract class Sink<T extends WsResponse> {
  UserId get userId;
  set userId(UserId id);

  set unitId(UnitId id);
  UnitId get unitId;

  void sinkAdd(EncodedPacket<T> encoded);
  void dispose();
}

class UserChannel extends Sink<WsResponse> {
  UserChannel(this._channel, this._userId, this._unitId);
  final WebSocketChannel _channel;

  WebSocketChannel get channel => _channel;

  late UnitId _unitId;
  @override
  UnitId get unitId => _unitId;
  @override
  set unitId(UnitId id) => _unitId = id;

  @override
  void sinkAdd(EncodedPacket<WsResponse> encoded) {
    _channel.sink.add(encoded.rawJson);
  }

  Future<void> close(int? code, String? reason) =>
      _channel.sink.close(code, reason);

  @override
  bool operator ==(Object other) =>
      other is UserChannel && other._channel == _channel;

  @override
  int get hashCode => _channel.hashCode;

  @override
  void dispose() {}

  UserId _userId;
  @override
  UserId get userId => _userId;
  @override
  set userId(UserId id) => _userId = id;

  /// Short-window timestamps (1 second) — burst protection.
  @Deprecated('Use centralized RateLimiter service instead')
  final List<DateTime> _burstTimestamps = [];

  /// Long-window timestamps (10 seconds) — sustained flood protection.
  @Deprecated('Use centralized RateLimiter service instead')
  final List<DateTime> _sustainedTimestamps = [];

  /// Maximum messages per 1-second window (burst limit).
  @Deprecated('Use centralized RateLimiter service instead')
  static const _burstLimit = 5;

  /// Burst window duration.
  @Deprecated('Use centralized RateLimiter service instead')
  static const _burstWindow = Duration(seconds: 1);

  /// Maximum messages per 10-second window (sustained limit).
  @Deprecated('Use centralized RateLimiter service instead')
  static const _sustainedLimit = 30;

  /// Sustained window duration.
  @Deprecated('Use centralized RateLimiter service instead')
  static const _sustainedWindow = Duration(seconds: 10);

  /// Returns `true` if the user has exceeded either the burst or sustained rate limit.
  ///
  /// Two sliding windows are checked:
  /// - **Burst**: max [_burstLimit] messages per [_burstWindow] — prevents sudden spikes.
  /// - **Sustained**: max [_sustainedLimit] messages per [_sustainedWindow] — prevents continuous flood.
  ///
  /// Timestamps outside each window are purged before checking.
  @Deprecated('Use centralized RateLimiter service instead')
  bool isRateLimited() {
    final now = DateTime.now();

    // Purge old timestamps outside the sustained window (covers both windows).
    final cutoffSustained = now.subtract(_sustainedWindow);
    _sustainedTimestamps.removeWhere((t) => t.isBefore(cutoffSustained));

    final cutoffBurst = now.subtract(_burstWindow);
    _burstTimestamps.removeWhere((t) => t.isBefore(cutoffBurst));

    // Check burst limit (short window).
    if (_burstTimestamps.length >= _burstLimit) {
      return true;
    }

    // Check sustained limit (long window).
    if (_sustainedTimestamps.length >= _sustainedLimit) {
      return true;
    }

    // Record the message in both windows.
    _burstTimestamps.add(now);
    _sustainedTimestamps.add(now);
    return false;
  }
}

abstract class SinkBot<T extends WsResponse, W extends WsRequest>
    extends Sink<WsResponse> {
  SinkBot({
    required this._botRepository,
    required this._userId,
    required this._unitId,
  }) {
    botCallback = (WsRequest toServer) => _botRepository.add(this, toServer);
  }
  final BotRepository _botRepository;

  UserId _userId;

  UnitId _unitId;

  @override
  UserId get userId => _userId;
  @override
  set userId(UserId id) => _userId = id;

  @override
  UnitId get unitId => _unitId;
  @override
  set unitId(UnitId unitId) => _unitId = unitId;

  @override
  void sinkAdd(EncodedPacket<WsResponse> encoded);

  @override
  void dispose();

  void Function(WsRequest)? botCallback;
  FutureOr<void> init();
}
