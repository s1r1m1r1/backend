import 'dart:async';

import 'package:drift/drift.dart' show Value;
import 'package:dto/dto.dart';
import 'package:injectable/injectable.dart';
import 'package:mailing/application/mailing_service.dart';
import 'package:uuid/uuid.dart';

import '../../../core/api_exceptions.dart';
import '../../../core/app_observer.dart';
import '../../../db_client/db_client.dart';
import '../../../models/user.dart';
import '../application/password_utils.dart';
import '../domain/user_repository.dart';

@LazySingleton(as: UserRepository)
class UserRepositoryImpl extends UserRepository with LifecycleLogging {
  UserRepositoryImpl(this._db, this.mailingService) {
    captureCreate();
  }
  final DbClient _db;

  /// The mailing service used to send emails
  final MailingService mailingService;

  @override
  Future<User?> getUser({
    UserId? userId,
    String? email,
    String? confirmationToken,
  }) async {
    final result = await _db.userDao.getUser(
      userId: userId?.id,
      email: email,
      confirmationToken: confirmationToken,
    );
    return result;
  }

  @override
  Future<User> createUser(
    EmailCredentialDto createUserDto, {
    Role role = Role.user,
  }) async {
    try {
      observer.onStart('UserRepositoryImpl', 'createUser', {
        'email': createUserDto.email,
      });

      final userExist = await _db.userDao.getUser(email: createUserDto.email);

      if (userExist != null) {
        throw const ApiException.unauthorized(message: 'Email already in use');
      }

      final hashedPassword = PasswordUtils.hashPassword(createUserDto.password);

      const uuid = Uuid();
      final confirmationToken = uuid.v4();

      final user = await _db.userDao.insert(
        UserTableCompanion(
          email: Value(createUserDto.email),
          password: Value(hashedPassword),
          createdAt: Value(DateTime.now()),
          confirmationToken: Value(confirmationToken),
          role: Value(role),
        ),
      );

      if (user.confirmationToken != null) {
        await mailingService.sendConfirmationEmail(
          user.email,
          user.confirmationToken!,
        );
      }

      observer.onSuccess('UserRepositoryImpl', 'createUser');
      return user;
    } on Object catch (e, stack) {
      captureError(e, stack);
      throw ApiException.internal(
        message: 'SQLite error with ${e.runtimeType}',
      );
    }
  }

  @override
  Future<User> loginUser(EmailCredentialDto loginUserDto) async {
    final email = loginUserDto.email;
    observer.onStart('UserRepositoryImpl', 'loginUser', {'email': email});
    final User? user = await _db.userDao.getUser(email: email);

    if (user == null) {
      observer.warn('UserRepositoryImpl', 'loginUser: user not found $email');
      throw const ApiException.notFound();
    }
    final password = loginUserDto.password;

    final isPasswordCorrect = PasswordUtils.checkPassword(
      password: password,
      hashedPassword: user.password,
    );
    if (!isPasswordCorrect) {
      observer.warn(
        'UserRepositoryImpl',
        'loginUser: incorrect password for $email',
      );
      throw const ApiException.forbidden(message: 'password is incorrect');
    }
    observer.onSuccess('UserRepositoryImpl', 'loginUser', {
      'userId': user.userId,
    });
    return user;
  }

  @override
  Future<User> confirmEmail(String confirmationToken) async {
    observer.onStart('UserRepositoryImpl', 'confirmEmail');
    final user = await _db.userDao.getUser(
      confirmationToken: confirmationToken,
    );

    if (user == null) {
      observer.warn('UserRepositoryImpl', 'confirmEmail: invalid token');
      throw const ApiException.notFound(message: 'Invalid confirmation token');
    }

    if (user.emailVerified) {
      observer.warn('UserRepositoryImpl', 'confirmEmail: already verified');
      throw const ApiException.badRequest(message: 'Email already verified');
    }

    final updatedUser = await _db.userDao.updateUser(
      user.userId.id,
      const UserTableCompanion(
        emailVerified: Value(true),
        confirmationToken: Value(null),
      ),
    );

    observer.onSuccess('UserRepositoryImpl', 'confirmEmail');
    return updatedUser;
  }

  @override
  Future<List<User>> getBots() {
    return _db.userDao.getBots();
  }
}
