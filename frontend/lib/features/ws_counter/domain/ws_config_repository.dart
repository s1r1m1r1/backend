import 'dart:async';

import 'package:frontend/core/network/protected_api_service.dart';
import 'package:injectable/injectable.dart';
import 'package:sha_red/sha_red.dart';

abstract class WsConfigRepository {
  FutureOr<WsConfigDto?> getConfig();
}

@LazySingleton(as: WsConfigRepository)
class WsConfigRepositoryImpl implements WsConfigRepository {
  final ProtectedApiService _api;
  WsConfigRepositoryImpl(this._api);
  WsConfigDto? _wsConfigDto;

  @override
  FutureOr<WsConfigDto?> getConfig() async {
    _wsConfigDto ??= await _api.getWsConfig();
    return _wsConfigDto;
  }
}
