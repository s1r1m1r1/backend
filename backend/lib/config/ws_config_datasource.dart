import 'package:shared/shared.dart';

import '../db_client/dao/config_dao.dart';

abstract class WsConfigDatasource {
  Future<List<WsConfigDto>> getListConfig();
}

class WsConfigDatasourceImpl implements WsConfigDatasource {
  final ConfigDao _dao;

  WsConfigDatasourceImpl(this._dao);

  Future<List<WsConfigDto>> getListConfig() async {
    final list = await _dao.getListConfig();
    return list
        .map(
          (i) => WsConfigDto(name: i.name, role: i.role, lettersRoom: i.name, counterRoom: i.name, version: i.version),
        )
        .toList();
  }
}
