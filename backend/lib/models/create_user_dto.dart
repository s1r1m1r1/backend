import 'package:backend/failures/validation_failure.dart';
import 'package:either_dart/either.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../exceptions/api_exceptions.dart';

part 'create_user_dto.freezed.dart';
part 'create_user_dto.g.dart';

@freezed
abstract class CreateUserDto with _$CreateUserDto {
  const CreateUserDto._();
  const factory CreateUserDto({required String email, required String password}) = _CreateUserDto;

  factory CreateUserDto.fromJson(Map<String, dynamic> json) => _$CreateUserDtoFromJson(json);

  static Either<ValidationFailure, CreateUserDto> validated(Map<String, dynamic> json) {
    try {
      final errors = <String>[];

      final email = json['email'] as String? ?? '';
      if (!RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$").hasMatch(email)) {
        errors.add('Email is invalid');
      }

      final password = json['password'] as String? ?? '';
      if (!RegExp(r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{6,}$").hasMatch(password)) {
        errors.add(
          'Password must contain at least 6 characters, one uppercase letter, one lowercase letter and one number',
        );
      }

      if (errors.isEmpty) return Right(CreateUserDto.fromJson(json));
      throw ApiException.badRequest(errors: errors);
    } on ApiException catch (e) {
      return Left(ValidationFailure(message: e.message, errors: e.errors, statusCode: e.statusCode));
    }
  }
}
