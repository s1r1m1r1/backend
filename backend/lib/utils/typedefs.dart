import 'package:backend/failures/failure.dart';

import '../exceptions/bad_request_exceptions.dart';
import '../failures/request_failure.dart';
import 'result.dart';

/// id todo
typedef TodoId = int;
typedef UserId = int;
typedef Json = Map<String, dynamic>;
Result<Failure, TodoId> mapTodoId(String id) {
  try {
    final todoId = int.tryParse(id);
    if (todoId == null) throw const BadRequestException(message: 'Invalid id');
    return Success(todoId);
  } on BadRequestException catch (e) {
    return Fail(RequestFailure(message: e.message, statusCode: e.statusCode));
  }
}
