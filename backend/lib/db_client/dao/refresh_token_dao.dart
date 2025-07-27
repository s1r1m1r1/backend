import 'package:drift/drift.dart';

import '../db_client.dart';
import '../tables/refresh_token_table.dart';

part 'refresh_token_dao.g.dart';

@DriftAccessor(tables: [RefreshTokenTable])
class RefreshTokenDao extends DatabaseAccessor<DbClient> with _$RefreshTokenDaoMixin {
  // this constructor is required so that the main database can create an instance
  // of this object.
  RefreshTokenDao(super.db);

  Future<void> saveRefreshToken(String refreshToken, String userId) async {
    await into(
      refreshTokenTable,
    ).insert(RefreshTokenTableCompanion(hashedToken: Value(refreshToken), userId: Value(userId)));
  }
}
