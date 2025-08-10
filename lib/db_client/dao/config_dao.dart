import 'package:drift/drift.dart';

import 'package:backend/db_client/db_client.dart';
import 'package:backend/db_client/tables/ws_config_table.dart';

part 'config_dao.g.dart';

@DriftAccessor(tables: [WsConfigTable])
class ConfigDao extends DatabaseAccessor<DbClient> with _$ConfigDaoMixin {
  // this constructor is required so that the main database can create an instance
  // of this object.
  ConfigDao(super.db);

  Future<WsConfigEntry?> insertRow(WsConfigTableCompanion toCompanion) {
    return into(wsConfigTable).insertReturningOrNull(toCompanion);
  }

  Future<List<WsConfigEntry>> getListConfig() async {
    final query = select(wsConfigTable);
    return await query.get();
  }
}

class WsConfigBarrel {
  final WsConfigEntry wsConfigEntry;
  final RoomEntry letterEntry;
  final RoomEntry counterEntry;
  WsConfigBarrel(this.wsConfigEntry, this.letterEntry, this.counterEntry);
}
