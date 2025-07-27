import 'package:backend/db_client/db_client.dart';
import 'package:drift/drift.dart';

import '../../db_client/dao/user_dao.dart';
import '../../exceptions/server_exceptions.dart';
import '../../models/create_user_dto.dart';
import '../../models/user.dart';

abstract class UserDataSource {
  Future<User> getUserById(String userId);

  Future<User> createUser(CreateUserDto user);

  Future<User> getUserByEmail(String email);
}

class UserDataSourceImpl implements UserDataSource {
  UserDataSourceImpl(this._userDao);

  final UserDao _userDao;
  Future<User> createUser(CreateUserDto user) async {
    try {
      // await _databaseConnection.connect();
      final entry = await _userDao.insert(
        UserTableCompanion(
          name: Value(user.name),
          email: Value(user.email),
          password: Value(user.password),
          createdAt: Value(DateTime.now()),
        ),
      );
      // count rows
      return User(userId: entry.id, email: entry.email, name: entry.name, createdAt: entry.createdAt);
    } on Exception catch (e) {
      throw ServerException('Unexpected error');
    } finally {
      // _dao.close();
      // await _databaseConnection.close();
    }
  }

  @override
  Future<User> getUserByEmail(String email) async {
    try {
      // await _databaseConnection.connect();
      final entry = await _userDao.getUserByEmail(email);
      return User(
        userId: entry.id,
        name: entry.name,
        email: entry.email,
        password: entry.password,
        createdAt: entry.createdAt,
      );
    } on Exception catch (e) {
      throw ServerException('Unexpected error');
    } finally {
      // await _databaseConnection.close();
    }
  }

  @override
  Future<User> getUserById(String userId) async {
    try {
      // await _databaseConnection.connect();
      final entry = await _userDao.getUserById(userId);
      return User(userId: entry.id, name: entry.name, email: entry.email, createdAt: entry.createdAt);
    } on Exception catch (e) {
      throw ServerException('Unexpected error');
    } finally {
      // await _databaseConnection.close();
    }
  }
}
