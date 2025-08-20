import '../db_client.dart';
import '../tables/user_table.dart';
import 'package:drift/drift.dart';

part 'user_dao.g.dart';

@DriftAccessor(tables: [UserTable])
class UserDao extends DatabaseAccessor<DbClient> with _$UserDaoMixin {
  // this constructor is required so that the main database can create an instance
  // of this object.
  UserDao(super.db);

  Future<UserEntry> insert(UserTableCompanion companion) async {
    return into(
      userTable,
    ).insertReturning(companion, mode: InsertMode.insertOrFail);
  }

  Future<int> updateUser(int userId, UserTableCompanion companion) async {
    final query = update(userTable);
    query.where((t) => t.id.equals(userId));
    return query.write(companion);
  }

  Future<int> deleteUser(int userId) async {
    final query = delete(userTable);
    query.where((t) => t.id.equals(userId));
    return query.go();
  }

  Future<List<UserEntry>> getListUser() async {
    final query = select(userTable);
    query.orderBy([(t) => OrderingTerm.desc(t.createdAt)]);
    return query.get();
  }

  Future<UserEntry?> getUser({
    int? userId,
    String? email,
    String? confirmationToken,
  }) async {
    if (userId == null && email == null && confirmationToken == null) {
      return null;
    }
    final query = userTable.select();
    if (userId != null) query.where((t) => t.id.equals(userId));
    if (email != null) query.where((t) => t.email.equals(email));
    if (confirmationToken != null)
      query.where((t) => t.confirmationToken.equals(confirmationToken));
    return query.getSingleOrNull();
  }

  Future<UserEntry?> findByConfirmationToken(String token) async {
    final query = select(userTable)
      ..where((t) => t.confirmationToken.equals(token));
    return query.getSingleOrNull();
  }

  Future<void> updateEmailConfirmed(int userId) async {
    final companion = UserTableCompanion(
      emailVerified: const Value(true),
      confirmationToken: const Value(null),
    );
    await (update(
      userTable,
    )..where((t) => t.id.equals(userId))).write(companion);
  }
}
