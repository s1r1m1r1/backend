import 'package:backend/db_client/db_client.dart';

import 'package:sha_red/sha_red.dart';

abstract class WsConfigDatasource {
  Future<List<WsConfigDto>> getListConfig();
}

class WsConfigDatasourceImpl implements WsConfigDatasource {
  final DbClient _db;

  WsConfigDatasourceImpl(this._db);

  Future<List<WsConfigDto>> getListConfig() async {
    final list = await _db.configDao.getListConfig();
    return list
        .map(
          (i) => WsConfigDto(
            name: i.name,
            role: i.role,
            lettersRoom: i.name,
            counterRoom: i.name,
            version: i.version,
          ),
        )
        .toList();
  }
}
