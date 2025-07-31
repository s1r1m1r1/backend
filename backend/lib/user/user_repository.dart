import 'dart:async';
import 'dart:io';

import '../core/new_api_exceptions.dart';
import '../models/create_user_dto.dart';
import '../models/login_user_dto.dart';
import '../models/user.dart';
import '../core/log_colors.dart';
import 'password_hash_service.dart';
import 'user_datasource.dart';

abstract class UserRepository {
  Future<User> getUserById(String userId);

  Future<User> createUser(CreateUserDto createUserDto);

  Future<User> loginUser(LoginUserDto loginUserDto);
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
    stdout.writeln('createUser - email ${createUserDto.email}');
    final userExist = await _datasource.getUserByEmail(createUserDto.email);

    if (userExist != null) {
      throw ApiException.unauthorized(message: 'Email already in use');
    }

    stdout.writeln('createUser email next');
    // dto is already validated in the controller
    // we will hash the password here
    final hashedPassword = passwordHasherService.hashPassword(createUserDto.password);

    stdout.writeln('createUser email next 2');
    final user = await _datasource.createUser(createUserDto.copyWith(password: hashedPassword));

    stdout.writeln('createUser email next 3');
    return user;
  }

  @override
  Future<User> loginUser(LoginUserDto loginUserDto) async {
    stdout.writeln('loginUser email ${loginUserDto.email}');
    final email = loginUserDto.email;
    User? user = await _datasource.getUserByEmail(email);

    if (user == null) {
      stdout.writeln('$reset loginUser exception not userExits $reset');
      throw ApiException.notFound();
    }
    final password = loginUserDto.password;

    final isPasswordCorrect = passwordHasherService.checkPassword(password: password, hashedPassword: user.password);
    if (!isPasswordCorrect) {
      stdout.writeln('loginUser Fail check passw incorrect');
      throw ApiException.forbidden(message: 'password is incorrect');
    }
    stdout.writeln('loginUser Success  passw ');
    return user;
  }
}
