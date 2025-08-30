import 'package:backend/core/debug_log.dart';
import 'package:backend/core/log_colors.dart';
import 'package:backend/db_client/db_client.dart'
    show DbClient, FakeUserTableCompanion, UserEntry, UserTableCompanion;
import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:sha_red/sha_red.dart';
import 'package:uuid/uuid.dart';
import 'package:backend/core/new_api_exceptions.dart';
import 'package:backend/models/user.dart';

abstract class UserDataSource {
  Future<User?> getUser({
    int? userId,
    String? email,
    String? confirmationToken,
  });

  Future<User> createUser(EmailCredentialDto user, {Role role = Role.user});

  Future<User> updateUser(
    int userId, {
    bool? emailVerified,
    String? confirmationToken,
  });

  Future<List<FakeUserDto>> getListFakes();

  Future<FakeUserDto> createFakeUser(int userId, EmailCredentialDto dto);
}

@LazySingleton(as: UserDataSource)
class UserDataSourceImpl implements UserDataSource {
  UserDataSourceImpl(this._db);
  final DbClient _db;
  Future<User> createUser(
    EmailCredentialDto user, {
    Role role = Role.user,
  }) async {
    try {
      debugLog(
        '$magenta createUser email ${user.email} p: ${user.password} $reset',
      );
      // await _databaseConnection.connect();
      const uuid = Uuid();
      final confirmationToken = uuid.v4();
      final entry = await _db.userDao.insert(
        UserTableCompanion(
          email: Value(user.email),
          password: Value(user.password),
          createdAt: Value(DateTime.now()),
          confirmationToken: Value(confirmationToken),
          role: Value(role),
        ),
      );
      return _toUser(entry);
    } on Object catch (e, stack) {
      debugLog('$red createUser exception ${e.runtimeType} $stack $reset');
      throw ApiException.internalServerError(
        message: 'SQLite error with ${e.runtimeType}',
      );
    } finally {
      // _dao.close();
      // await _databaseConnection.close();
    }
  }

  @override
  Future<User?> getUser({
    int? userId,
    String? email,
    String? confirmationToken,
  }) async {
    // await _databaseConnection.connect();
    final entry = await _db.userDao.getUser(
      userId: userId,
      email: email,
      confirmationToken: confirmationToken,
    );
    if (entry == null) return null;
    return _toUser(entry);
  }

  @override
  Future<User> updateUser(
    int userId, {
    bool? emailVerified,
    String? confirmationToken,
  }) async {
    await _db.userDao.updateUser(
      userId,
      UserTableCompanion(
        emailVerified: Value.absentIfNull(emailVerified),
        confirmationToken: Value(confirmationToken),
      ),
    );
    final entry = await _db.userDao.getUser(userId: userId);
    if (entry == null) {
      throw ApiException.notFound(message: 'User not found');
    }
    return _toUser(entry);
  }
  //-------------------------------------------------------------

  @override
  Future<List<FakeUserDto>> getListFakes() async {
    final entries = await _db.userDao.getListFakes();
    final fakes = entries.map((record) {
      return FakeUserDto(
        email: record.$1.email,
        password: record.$1.password,
        user: _toUser(record.$2).toDto(),
      );
    }).toList();
    return fakes;
  }

  @override
  Future<FakeUserDto> createFakeUser(int userId, EmailCredentialDto dto) async {
    final fakeEntry = await _db.userDao.insertFakeUser(
      FakeUserTableCompanion.insert(
        email: dto.email,
        password: dto.password,
        userId: userId,
      ),
    );
    final user = await getUser(userId: userId);
    if (user == null) {
      throw ApiException.notFound(message: 'User not found');
    }
    final fakeUser = FakeUserDto(
      user: user.toDto(),
      email: fakeEntry.email,
      password: fakeEntry.password,
    );
    return fakeUser;
  }
}

User _toUser(UserEntry entry) {
  return User(
    userId: entry.id,
    email: entry.email,
    password: entry.password,
    createdAt: entry.createdAt,
    role: entry.role,
    emailVerified: entry.emailVerified,
    confirmationToken: entry.confirmationToken,
  );
}
