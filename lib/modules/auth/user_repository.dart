import 'dart:async';

import 'package:backend/core/debug_log.dart';
import 'package:injectable/injectable.dart';
import 'package:sha_red/sha_red.dart';

import 'package:backend/core/new_api_exceptions.dart';
import 'package:backend/models/user.dart';
import 'package:backend/core/log_colors.dart';
import 'package:backend/modules/auth/password_hash_service.dart';
import 'package:backend/modules/auth/user_datasource.dart';
import 'package:backend/modules/auth/mailing_service.dart';

abstract class UserRepository {
  Future<User?> getUser({
    int? userId,
    String? email,
    String? confirmationToken,
  });

  Future<FakeUserDto> createFakeUser(EmailCredentialDto createUserDto);
  Future<User> createUser(EmailCredentialDto createUserDto);

  Future<User> loginUser(EmailCredentialDto loginUserDto);

  Future<User> confirmEmail(String confirmationToken);

  Future<List<FakeUserDto>> getListFakes();
}

@LazySingleton(as: UserRepository)
class UserRepositoryImpl extends UserRepository {
  UserRepositoryImpl(
    this._datasource,
    this.passwordHasherService,
    this.mailingService,
  );
  final UserDataSource _datasource;

  /// The password hasher service used to hash and check passwords
  final PasswordHasherService passwordHasherService;

  /// The mailing service used to send emails
  final MailingService mailingService;

  @override
  Future<User?> getUser({
    int? userId,
    String? email,
    String? confirmationToken,
  }) async {
    final result = await _datasource.getUser(
      userId: userId,
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
    debugLog('createUser - email ${createUserDto.email}');
    final userExist = await _datasource.getUser(email: createUserDto.email);

    if (userExist != null) {
      throw ApiException.unauthorized(message: 'Email already in use');
    }

    debugLog('createUser email next');
    // dto is already validated in the controller
    // we will hash the password here
    final hashedPassword = passwordHasherService.hashPassword(
      createUserDto.password,
    );

    debugLog('createUser email next 2 $hashedPassword');
    final user = await _datasource.createUser(
      createUserDto.copyWith(password: hashedPassword),
    );
    if (user.confirmationToken != null) {
      debugLog('${yellow}createUser email confirmationToken${reset}');
      mailingService.sendConfirmationEmail(user.email, user.confirmationToken!);
    } else {
      debugLog('${yellow}createUser email no confirmationToken${reset}');
    }

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
    final isPasswordCorrect = passwordHasherService.checkPassword(
      password: password,
      hashedPassword: user.password,
    );
    if (!isPasswordCorrect) {
      debugLog('loginUser Fail check passwd incorrect');
      throw ApiException.forbidden(message: 'password is incorrect');
    }
    debugLog('loginUser Success  passwd ');
    return user;
  }

  @override
  Future<User> confirmEmail(String confirmationToken) async {
    final user = await _datasource.getUser(
      confirmationToken: confirmationToken,
    );

    if (user == null) {
      throw ApiException.notFound(message: 'Invalid confirmation token');
    }

    if (user.emailVerified) {
      throw ApiException.badRequest(message: 'Email already verified');
    }

    final updatedUser = await _datasource.updateUser(
      user.userId,
      emailVerified: true,
      confirmationToken: null,
    );

    return updatedUser;
  }

  //----------------------------------------------------------------
  @override
  Future<FakeUserDto> createFakeUser(EmailCredentialDto createUserDto) async {
    final user = await createUser(createUserDto, role: Role.user);
    final fakeUser = await _datasource.createFakeUser(
      user.userId,
      createUserDto,
    );
    return fakeUser;
  }

  @override
  Future<List<FakeUserDto>> getListFakes() {
    return _datasource.getListFakes();
  }
}
