import 'package:drift/drift.dart';
import 'package:dto/dto.dart';

import '../../models/user.dart';
import '../db_client.dart';
import '../tables/user_table.dart';

part 'user_dao.g.dart';

@DriftAccessor(tables: [UserTable])
class UserDao extends DatabaseAccessor<DbClient> with _$UserDaoMixin {
  UserDao(super.db);

  //------------------------------------------------------------------------------- --
  // Mapping methods
  //------------------------------------------------------------------------------- --

  User _toUser(UserEntry entry) {
    return User(
      userId: UserId(entry.id),
      email: Email(entry.email),
      password: entry.password,
      createdAt: entry.createdAt,
      role: entry.role,
      emailVerified: entry.emailVerified,
      confirmationToken: entry.confirmationToken,
    );
  }

  //------------------------------------------------------------------------------- --
  // CRUD operations returning User domain objects
  //------------------------------------------------------------------------------- --

  Future<User> insert(UserTableCompanion companion) async {
    final entry = await into(
      userTable,
    ).insertReturning(companion, mode: InsertMode.insertOrFail);
    return _toUser(entry);
  }

  Future<List<User>> getBots() async {
    final query = select(userTable);
    query.where((t) => t.role.equals(Role.fullBot.name));
    final entries = await query.get();
    return entries.map(_toUser).toList();
  }

  Future<User> updateUser(String userId, UserTableCompanion companion) async {
    final query = update(userTable);
    query.where((t) => t.id.equals(userId));
    await query.write(companion);

    final entry = await getUser(userId: userId);
    if (entry == null) {
      throw StateError('User not found after update');
    }
    return entry;
  }

  Future<int> deleteUser(String userId) async {
    final query = delete(userTable);
    query.where((t) => t.id.equals(userId));
    return query.go();
  }

  Future<List<User>> getListUser() async {
    final query = select(userTable);
    query.orderBy([(t) => OrderingTerm.desc(t.createdAt)]);
    final entries = await query.get();
    return entries.map(_toUser).toList();
  }

  Future<User?> getUser({
    String? userId,
    String? email,
    String? confirmationToken,
  }) async {
    if (userId == null && email == null && confirmationToken == null) {
      return null;
    }
    final query = userTable.select();
    if (userId != null) query.where((t) => t.id.equals(userId));
    if (email != null) query.where((t) => t.email.equals(email));
    if (confirmationToken != null) {
      query.where((t) => t.confirmationToken.equals(confirmationToken));
    }
    final entry = await query.getSingleOrNull();
    if (entry == null) return null;
    return _toUser(entry);
  }

  Future<User?> findByConfirmationToken(String token) async {
    final query = select(userTable)
      ..where((t) => t.confirmationToken.equals(token));
    final entry = await query.getSingleOrNull();
    if (entry == null) return null;
    return _toUser(entry);
  }

  Future<void> updateEmailConfirmed(String userId) async {
    const companion = UserTableCompanion(
      emailVerified: Value(true),
      confirmationToken: Value(null),
    );
    await (update(
      userTable,
    )..where((t) => t.id.equals(userId))).write(companion);
  }

  Future<User> insertBot({
    required String email,
    required String password,
  }) async {
    final entry = await into(userTable).insertReturning(
      UserTableCompanion.insert(
        email: email,
        password: password,
        role: const Value(Role.fullBot),
        emailVerified: const Value(true),
      ),
    );
    return _toUser(entry);
  }

  Future<int> deleteAllBots() async {
    final query = delete(userTable);
    query.where((t) => t.role.equals(Role.fullBot.name));
    return query.go();
  }
}
