import 'package:backend/failures/failure.dart';
import 'package:either_dart/either.dart';

import '../exceptions/bad_request_exceptions.dart';
import '../failures/request_failure.dart';

/// id todo
typedef TodoId = int;
typedef UserId = int;
typedef Json = Map<String, dynamic>;
Either<Failure, TodoId> mapTodoId(String id) {
  try {
    final todoId = int.tryParse(id);
    if (todoId == null) throw const BadRequestException(message: 'Invalid id');
    return Right(todoId);
  } on BadRequestException catch (e) {
    return Left(RequestFailure(message: e.message, statusCode: e.statusCode));
  }
}
