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
  Future<Either<Failure, User>> getUserById(String userId);

  Future<User> createUser(CreateUserDto createUserDto);

  Future<Either<Failure, User>> loginUser(LoginUserDto loginUserDto);

  Future<Either<Failure, User>> getUserByEmail(String email);
}

class UserRepositoryImpl extends UserRepository {
  UserRepositoryImpl(this._datasource, this.passwordHasherService);
  final UserDataSource _datasource;

  /// The password hasher service used to hash and check passwords
  final PasswordHasherService passwordHasherService;

  @override
  Future<Either<Failure, User>> getUserById(String userId) async {
    try {
      final result = await _datasource.getUserById(userId);
      return Right(result);
    } on ApiException catch (e) {
      return Left(ServerFailure(message: 'user with this id did not found'));
    }
  }

  @override
  Future<User> createUser(CreateUserDto createUserDto) async {
    final userExists = await getUserByEmail(createUserDto.email);
    if (userExists.isRight) {
      throw ApiException.conflict(message: 'Email already in use');
    }
    // dto is already validated in the controller
    // we will hash the password here
    final hashedPassword = passwordHasherService.hashPassword(createUserDto.password);
    final user = await _datasource.createUser(createUserDto.copyWith(password: hashedPassword));
    return user;
  }

  @override
  Future<Either<Failure, User>> getUserByEmail(String email) async {
    try {
      final result = await _datasource.getUserByEmail(email);
      return Right(result);
    } on ApiException {
      return Left(ServerFailure(message: 'user with this email did not found'));
    }
  }

  @override
  Future<Either<Failure, User>> loginUser(LoginUserDto loginUserDto) async {
    try {
      stdout.writeln('loginUser email ${loginUserDto.email}');
      final email = loginUserDto.email;
      final userExists = await getUserByEmail(email);
      switch (userExists) {
        case Left(value: var f):
          stdout.writeln('loginUser exception not userExits');
          throw ApiException.notFound(message: f.message ?? '');

        case Right(value: var s):
          final user = s;
          final password = loginUserDto.password;

          stdout.writeln(
            'loginUser check passw----\n'
            '--pass: $password\n'
            '--hashPass: ${user.password.length} ${user.password}\n',
          );
          final isPasswordCorrect = passwordHasherService.checkPassword(
            password: password,
            hashedPassword: user.password,
          );
          if (!isPasswordCorrect) {
            stdout.writeln('loginUser Fail check passw incorrect');
            throw ApiException.forbidden(message: 'password is incorrect');
          }
          stdout.writeln('loginUser Success  passw ');
          return Right(user);
      }
    } on ApiException catch (e) {
      stdout.writeln('exception login user ${e.runtimeType}');
      return Left(ServerFailure(message: e.message, statusCode: HttpStatus.unauthorized));
    }
  }
}
