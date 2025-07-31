import 'package:shared/shared.dart';

import '../../core/new_api_exceptions.dart';

abstract class CreateTodoMethod {
  static CreateTodoDto validated(Map<String, dynamic> json) {
    final errors = <String>[];
    if (json['title'] == null) {
      errors.add('Title is required');
    }
    if (json['description'] == null) {
      errors.add('Description is required');
    }
    if (errors.isEmpty) return CreateTodoDto.fromJson(json);
    throw ApiException.badRequest(message: 'Validation failed', errors: errors);
  }
}
