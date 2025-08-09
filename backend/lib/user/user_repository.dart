import 'dart:async';

import 'package:backend/core/debug_log.dart';
import 'package:backend/models/validation/email_password_ext.dart';
import 'package:sha_red/sha_red.dart';

import '../core/new_api_exceptions.dart';
import '../models/login_user_dto.dart';
import '../models/user.dart';
import '../core/log_colors.dart';
import 'password_hash_service.dart';
import 'user_datasource.dart';

abstract class UserRepository {
  Future<User?> getUser({int? userId, String? email});

  Future<User> createUser(EmailCredentialDto createUserDto);

  Future<User> loginUser(EmailCredentialDto loginUserDto);
}

class UserRepositoryImpl extends UserRepository {
  UserRepositoryImpl(this._datasource, this.passwordHasherService);
  final UserDataSource _datasource;

  /// The password hasher service used to hash and check passwords
  final PasswordHasherService passwordHasherService;

  @override
  Future<User?> getUser({int? userId, String? email}) async {
    final result = await _datasource.getUser(userId: userId, email: email);
    return result;
  }

  @override
  Future<User> createUser(EmailCredentialDto createUserDto) async {
    debugLog('createUser - email ${createUserDto.email}');
    final userExist = await _datasource.getUser(email: createUserDto.email);

    if (userExist != null) {
      throw ApiException.unauthorized(message: 'Email already in use');
    }

    debugLog('createUser email next');
    // dto is already validated in the controller
    // we will hash the password here
    final hashedPassword = passwordHasherService.hashPassword(createUserDto.password);

    debugLog('createUser email next 2 $hashedPassword');
    final user = await _datasource.createUser(createUserDto.copyWith(password: hashedPassword));

    debugLog('createUser email next 3');
    return user;
  }

  @override
  Future<User> loginUser(EmailCredentialDto loginUserDto) async {
    debugLog('loginUser email ${loginUserDto.email}');
    final email = loginUserDto.email;
    User? user = await _datasource.getUser(email: email);

    if (user == null) {
      debugLog('$reset loginUser exception not userExits $reset');
      throw ApiException.notFound();
    }
    final password = loginUserDto.password;

    debugLog('$reset loginUser ${password}, h: ${user.password} $reset');
    final isPasswordCorrect = passwordHasherService.checkPassword(password: password, hashedPassword: user.password);
    if (!isPasswordCorrect) {
      debugLog('loginUser Fail check passw incorrect');
      throw ApiException.forbidden(message: 'password is incorrect');
    }
    debugLog('loginUser Success  passw ');
    return user;
  }
}
