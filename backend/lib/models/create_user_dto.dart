import 'package:backend/exceptions/bad_request_exceptions.dart';
import 'package:backend/failures/validation_failure.dart';
import 'package:either_dart/either.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_user_dto.freezed.dart';
part 'create_user_dto.g.dart';

@freezed
abstract class CreateUserDto with _$CreateUserDto {
  const CreateUserDto._();
  const factory CreateUserDto({required String name, required String email, required String password}) = _CreateUserDto;

  factory CreateUserDto.fromJson(Map<String, dynamic> json) => _$CreateUserDtoFromJson(json);

  static Either<ValidationFailure, CreateUserDto> validated(Map<String, dynamic> json) {
    try {
      final errors = <String, List<String>>{};
      final name = json['name'] as String? ?? '';
      final email = json['email'] as String? ?? '';
      final password = json['password'] as String? ?? '';
      if (name.isEmpty) {
        errors['name'] = ['Name is required'];
      }
      if (email.isEmpty) {
        errors['email'] = ['Email is required'];
      }
      if (!email.contains('@')) {
        errors['email'] = ['Email is invalid'];
      }
      if (password.isEmpty) {
        errors['password'] = ['Password is required'];
      }
      if (password.length < 6) {
        errors['password'] = ['Password must be at least 6 characters'];
      }

      if (errors.isEmpty) return Right(CreateUserDto.fromJson(json));
      throw BadRequestException(message: 'Validation failed', errors: errors);
    } on BadRequestException catch (e) {
      return Left(ValidationFailure(message: e.message, errors: e.errors, statusCode: e.statusCode));
    }
  }
}
