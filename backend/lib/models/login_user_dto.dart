import 'package:either_dart/either.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../exceptions/new_api_exceptions.dart';
import '../failures/validation_failure.dart';

part 'login_user_dto.freezed.dart';
part 'login_user_dto.g.dart';

@freezed
abstract class LoginUserDto with _$LoginUserDto {
  const LoginUserDto._();
  const factory LoginUserDto({required String email, required String password}) = _LoginUserDto;

  factory LoginUserDto.fromJson(Map<String, dynamic> json) => _$LoginUserDtoFromJson(json);

  static Either<ValidationFailure, LoginUserDto> validated(Map<String, dynamic> json) {
    try {
      final errors = <String>[];
      final email = json['email'] as String? ?? '';
      final password = json['password'] as String? ?? '';
      if (email.isEmpty) {
        errors.add('Email is required');
      }
      if (password.isEmpty) {
        errors.add('Password is required');
      }
      if (errors.isEmpty) return Right(LoginUserDto.fromJson(json));
      throw ApiException.badRequest(errors: errors);
    } on ApiException catch (e) {
      return Left(ValidationFailure(message: e.message, errors: e.errors, statusCode: e.statusCode));
    }
  }
}
