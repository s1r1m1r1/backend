import 'package:freezed_annotation/freezed_annotation.dart';

import '../exceptions/bad_request_exceptions.dart';
import '../failures/validation_failure.dart';
import '../utils/result.dart';

part 'login_user_dto.freezed.dart';
part 'login_user_dto.g.dart';

@freezed
abstract class LoginUserDto with _$LoginUserDto {
  const LoginUserDto._();
  const factory LoginUserDto({required String email, required String password}) = _LoginUserDto;

  factory LoginUserDto.fromJson(Map<String, dynamic> json) => _$LoginUserDtoFromJson(json);

  static Result<ValidationFailure, LoginUserDto> validated(Map<String, dynamic> json) {
    try {
      final errors = <String, List<String>>{};
      final email = json['email'] as String? ?? '';
      final password = json['password'] as String? ?? '';
      if (email.isEmpty) {
        errors['email'] = ['Email is required'];
      }
      if (password.isEmpty) {
        errors['password'] = ['Password is required'];
      }
      if (errors.isEmpty) return Success(LoginUserDto.fromJson(json));
      throw BadRequestException(message: 'Validation failed', errors: errors);
    } on BadRequestException catch (e) {
      return Fail(ValidationFailure(message: e.message, errors: e.errors, statusCode: e.statusCode));
    }
  }
}
