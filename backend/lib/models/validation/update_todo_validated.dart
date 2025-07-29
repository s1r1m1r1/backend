import 'package:shared/shared.dart';

import '../../exceptions/new_api_exceptions.dart';

abstract class UpdateTodoMethod {
  static UpdateTodoDto validated(Map<String, dynamic> json) {
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
    if (errors.length < 3) return UpdateTodoDto.fromJson(json);
    throw ApiException.badRequest(message: 'Validation failed', errors: errors);
  }
}
