import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:backend/core/new_api_exceptions.dart';

part 'login_user_dto.freezed.dart';
part 'login_user_dto.g.dart';

@freezed
abstract class LoginUserDto with _$LoginUserDto {
  const LoginUserDto._();
  const factory LoginUserDto({required String email, required String password}) = _LoginUserDto;

  factory LoginUserDto.fromJson(Map<String, dynamic> json) => _$LoginUserDtoFromJson(json);

  static LoginUserDto validated(Map<String, dynamic> json) {
    final errors = <String>[];
    final email = json['email'] as String? ?? '';
    final password = json['password'] as String? ?? '';
    if (email.isEmpty) {
      errors.add('Email is required');
    }
    if (password.isEmpty) {
      errors.add('Password is required');
    }
    if (errors.isEmpty) return LoginUserDto.fromJson(json);
    throw ApiException.badRequest(errors: errors);
  }
}
