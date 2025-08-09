import 'package:backend/core/debug_log.dart';
import 'package:backend/core/log_colors.dart';
import 'package:backend/db_client/db_client.dart' show UserTableCompanion;
import 'package:drift/drift.dart';
import 'package:sha_red/sha_red.dart';

import '../db_client/dao/user_dao.dart';
import '../core/new_api_exceptions.dart';
import '../models/user.dart';

abstract class UserDataSource {
  Future<User?> getUser({int? userId, String? email});

  Future<User> createUser(EmailCredentialDto user);
}

class UserDataSourceImpl implements UserDataSource {
  UserDataSourceImpl(this._userDao);

  final UserDao _userDao;
  Future<User> createUser(EmailCredentialDto user) async {
    try {
      debugLog('$magenta createUser email ${user.email} p: ${user.password} $reset');
      // await _databaseConnection.connect();
      final entry = await _userDao.insert(
        UserTableCompanion(email: Value(user.email), password: Value(user.password), createdAt: Value(DateTime.now())),
      );
      // count rows
      return User(userId: entry.id, email: entry.email, createdAt: entry.createdAt, role: entry.role);
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
    return User(
      userId: entry.id,
      email: entry.email,
      password: entry.password,
      createdAt: entry.createdAt,
      role: entry.role,
    );
  }
}
