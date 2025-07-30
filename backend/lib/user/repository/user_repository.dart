import 'dart:async';
import 'dart:io';

import '../../exceptions/new_api_exceptions.dart';
import '../../failures/failure.dart';
import '../../failures/server_failure.dart';
import '../../models/create_user_dto.dart';
import '../../models/login_user_dto.dart';
import '../../models/user.dart';
import '../../services/password_hash_service.dart';
import '../datasource/user_datasource.dart';
import 'package:either_dart/either.dart';

abstract class UserRepository {
  Future<User> getUserById(String userId);

  Future<User> createUser(CreateUserDto createUserDto);

  Future<User> loginUser(LoginUserDto loginUserDto);

  FutureOr<User?> getUserByEmail(String email);
}

class UserRepositoryImpl extends UserRepository {
  UserRepositoryImpl(this._datasource, this.passwordHasherService);
  final UserDataSource _datasource;

  /// The password hasher service used to hash and check passwords
  final PasswordHasherService passwordHasherService;

  @override
  Future<User> getUserById(String userId) async {
    final result = await _datasource.getUserById(userId);
    return result;
  }

  @override
  Future<User> createUser(CreateUserDto createUserDto) async {
    final userExists = await getUserByEmail(createUserDto.email);
    if (userExists != null) {
      throw ApiException.unauthorized(message: 'Email already in use');
    }
    // dto is already validated in the controller
    // we will hash the password here
    final hashedPassword = passwordHasherService.hashPassword(createUserDto.password);
    final user = await _datasource.createUser(createUserDto.copyWith(password: hashedPassword));
    return user;
  }

  @override
  FutureOr<User?> getUserByEmail(String email) async {
    try {
      final user = await _datasource.getUserByEmail(email);
      return user;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<User> loginUser(LoginUserDto loginUserDto) async {
    stdout.writeln('loginUser email ${loginUserDto.email}');
    final email = loginUserDto.email;
    final user = await getUserByEmail(email);

    if (user == null) {
      stdout.writeln('loginUser exception not userExits');
      throw ApiException.notFound();
    }
    final password = loginUserDto.password;

    stdout.writeln(
      'loginUser check passw----\n'
      '--pass: $password\n'
      '--hashPass: ${user.password.length} ${user.password}\n',
    );
    final isPasswordCorrect = passwordHasherService.checkPassword(password: password, hashedPassword: user.password);
    if (!isPasswordCorrect) {
      stdout.writeln('loginUser Fail check passw incorrect');
      throw ApiException.forbidden(message: 'password is incorrect');
    }
    stdout.writeln('loginUser Success  passw ');
    return user;
  }
}
