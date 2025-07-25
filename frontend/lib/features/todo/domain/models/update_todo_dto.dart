import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/exceptions/bad_request_exceptions.dart';
import '../../../../core/failures/validation_failure.dart';
import '../../../../core/utils/result.dart';
part 'update_todo_dto.freezed.dart';
part 'update_todo_dto.g.dart';

@freezed
abstract class UpdateTodoDto with _$UpdateTodoDto {
  const UpdateTodoDto._();
  const factory UpdateTodoDto({String? title, String? description, bool? completed}) = _UpdateTodoDto;

  factory UpdateTodoDto.fromJson(Map<String, dynamic> json) => _$UpdateTodoDtoFromJson(json);

  static Result<ValidationFailure, UpdateTodoDto> validated(Map<String, dynamic> json) {
    try {
      final errors = <String, List<String>>{};
      if (json['title'] == null || json['title'] == '') {
        errors['title'] = ['At least one field must be provided'];
      }
      if (json['description'] == null || json['description'] == '') {
        errors['description'] = ['At least one field must be provided'];
      }
      if (json['completed'] == null) {
        errors['completed'] = ['At least one field must be provided'];
      }
      if (errors.length < 3) return Result.success(UpdateTodoDto.fromJson(json));
      throw BadRequestException(message: 'Validation failed', errors: errors);
    } on BadRequestException catch (e) {
      return Result.fail(ValidationFailure(message: e.message, statusCode: e.statusCode, errors: e.errors));
    }
  }
}
