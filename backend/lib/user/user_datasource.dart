import 'package:backend/db_client/db_client.dart';
import 'package:drift/drift.dart';

import '../db_client/dao/user_dao.dart';
import '../core/new_api_exceptions.dart';
import '../models/create_user_dto.dart';
import '../models/user.dart';

abstract class UserDataSource {
  Future<User?> getUser({int? userId, String? email});

  Future<User> createUser(CreateUserDto user);
}

class UserDataSourceImpl implements UserDataSource {
  UserDataSourceImpl(this._userDao);

  final UserDao _userDao;
  Future<User> createUser(CreateUserDto user) async {
    try {
      // await _databaseConnection.connect();
      final entry = await _userDao.insert(
        UserTableCompanion(email: Value(user.email), password: Value(user.password), createdAt: Value(DateTime.now())),
      );
      // count rows
      return User(userId: entry.id, email: entry.email, createdAt: entry.createdAt);
    } on Object catch (e, stack) {
      throw ApiException.internalServerError(message: 'SQLite error with ${e.runtimeType}');
    } finally {
      // _dao.close();
      // await _databaseConnection.close();
    }
  }

  @override
  Future<User?> getUser({int? userId, String? email}) async {
    // await _databaseConnection.connect();
    final entry = await _userDao.getUser(userId: userId, email: email);
    if (entry == null) return null;
    return User(userId: entry.id, email: entry.email, createdAt: entry.createdAt);
  }
}
