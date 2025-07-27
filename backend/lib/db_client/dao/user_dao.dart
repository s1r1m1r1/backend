import 'package:backend/db_client/db_client.dart';
import 'package:backend/db_client/tables/user_table.dart';
import 'package:backend/exceptions/api_exceptions.dart';
import 'package:drift/drift.dart';

part 'user_dao.g.dart';

@DriftAccessor(tables: [UserTable])
class UserDao extends DatabaseAccessor<DbClient> with _$UserDaoMixin {
  // this constructor is required so that the main database can create an instance
  // of this object.
  UserDao(super.db);

  Future<UserEntry> insert(UserTableCompanion companion) async {
    return into(userTable).insertReturning(companion, mode: InsertMode.insertOrFail);
  }

  Future<int> updateUser(String userId, UserTableCompanion companion) async {
    return (update(userTable)..where((t) => t.id.equals(userId))).write(companion);
  }

  Future<int> deleteUserById(String userId) async {
    return (delete(userTable)..where((t) => t.id.equals(userId))).go();
  }

  Future<List<UserEntry>> getAllUser() async {
    return (select(userTable)..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).get();
  }

  Future<UserEntry> getUserById(String userId) async {
    try {
      final result = await (select(userTable)..where((t) => t.id.equals(userId))).getSingle();
      return result;
    } catch (e) {
      throw ApiException.notFound(message: 'User with Id not found');
    }
  }

  Future<UserEntry> getUserByEmail(String email) async {
    try {
      final result = await (select(userTable)..where((t) => t.email.equals(email))).getSingle();
      return result;
    } catch (e) {
      print('Error getting user by email: $e');
      throw ApiException.notFound(message: 'User with email not found');
    }
  }
}
