import 'package:either_dart/either.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../exceptions/api_exceptions.dart';
import '../failures/validation_failure.dart';

part 'create_todo_dto.freezed.dart';
part 'create_todo_dto.g.dart';

@freezed
abstract class CreateTodoDto with _$CreateTodoDto {
  const CreateTodoDto._();
  const factory CreateTodoDto({required String title, String? description, bool? completed}) = _CreateTodoDto;

  factory CreateTodoDto.fromJson(Map<String, dynamic> json) => _$CreateTodoDtoFromJson(json);

  static Either<ValidationFailure, CreateTodoDto> validated(Map<String, dynamic> json) {
    try {
      final errors = <String>[];
      if (json['title'] == null) {
        errors.add('Title is required');
      }
      if (json['description'] == null) {
        errors.add('Description is required');
      }
      if (errors.isEmpty) return Right(CreateTodoDto.fromJson(json));
      throw ApiException.badRequest(message: 'Validation failed', errors: errors);
    } on ApiException catch (e) {
      return Left(ValidationFailure(message: e.message, errors: e.errors, statusCode: e.statusCode));
    }
  }
}
