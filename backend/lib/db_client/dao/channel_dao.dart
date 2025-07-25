import 'package:backend/db_client/db_client.dart';
import 'package:backend/db_client/tables/channel_table.dart';
import 'package:drift/drift.dart';

part 'channel_dao.g.dart';

@DriftAccessor(tables: [ChannelTable])
class ChannelDao extends DatabaseAccessor<DbClient> with _$ChannelDaoMixin {
  // this constructor is required so that the main database can create an instance
  // of this object.
  ChannelDao(super.db);

  Future<List<ChannelEntry>> get() {
    return select(channelTable).get();
  }

  Future<int> insertRow(ChannelTableCompanion toCompanion) {
    return into(channelTable).insert(toCompanion);
  }
}
