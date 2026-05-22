import 'dart:async';

import 'package:dto/dto.dart';

import '../../bot/application/ws_bot_repository.dart';
import 'user_channel.dart';

abstract class SinkBot<T extends WsResponse, W extends WsRequest>
    extends Sink<WsResponse> {
  SinkBot({required this._botRepository, this._userId, this._unitId}) {
    botId = _createId();
    botCallback = (WsRequest toServer) => _botRepository.add(this, toServer);
  }

  static BotId _createId() => BotId('bot_${_counter++}');
  static int _counter = 0;
  late final BotId botId;

  final BotRepository _botRepository;
  UserId? _userId;
  UnitId? _unitId;

  @override
  UserId? get userId => _userId;
  @override
  set userId(UserId? id) => _userId = id;

  @override
  UnitId? get unitId => _unitId;
  @override
  set unitId(UnitId? unitId) => _unitId = unitId;

  @override
  void sinkAdd(EncodedPacket<WsResponse> encoded);

  @override
  void dispose();

  void Function(WsRequest)? botCallback;
  FutureOr<void> init();
}
