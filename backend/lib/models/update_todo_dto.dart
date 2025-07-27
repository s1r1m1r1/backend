import 'package:either_dart/either.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../exceptions/new_api_exceptions.dart';
import '../failures/validation_failure.dart';

part 'update_todo_dto.freezed.dart';
part 'update_todo_dto.g.dart';

@freezed
abstract class UpdateTodoDto with _$UpdateTodoDto {
  const UpdateTodoDto._();
  const factory UpdateTodoDto({String? title, String? description, bool? completed}) = _UpdateTodoDto;

  factory UpdateTodoDto.fromJson(Map<String, dynamic> json) => _$UpdateTodoDtoFromJson(json);

  static Either<ValidationFailure, UpdateTodoDto> validated(Map<String, dynamic> json) {
    try {
      final errors = <String>[];
      if (json['title'] == null || json['title'] == '') {
        errors.add('title must not be empty');
      }
      if (json['description'] == null || json['description'] == '') {
        errors.add('description must not be empty');
      }
      if (json['completed'] == null) {
        errors.add('completed must not be empty');
      }
      if (errors.length < 3) return Right(UpdateTodoDto.fromJson(json));
      throw ApiException.badRequest(message: 'Validation failed', errors: errors);
    } on ApiException catch (e) {
      return Left(ValidationFailure(message: e.message, statusCode: e.statusCode, errors: e.errors));
    }
  }
}
