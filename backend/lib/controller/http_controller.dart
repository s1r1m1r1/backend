import 'dart:async';
import 'dart:convert';

import 'package:backend/utils/typedefs.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:either_dart/either.dart';

import '../exceptions/bad_request_exceptions.dart';
import '../failures/failure.dart';
import '../failures/validation_failure.dart';
import '../request_handler/unimplemented_handler.dart';

abstract class HttpController {
  FutureOr<Response> index(Request request) => unimplementedHandler();

  FutureOr<Response> store(Request request) => unimplementedHandler();

  FutureOr<Response> show(Request request, String id) => unimplementedHandler();

  FutureOr<Response> update(Request request, String id) => unimplementedHandler();

  FutureOr<Response> destroy(Request request, String id) => unimplementedHandler();

  // Parses the request body into a json map
  /// Returns a [ValidationFailure] if the body is invalid
  Future<Either<Failure, Json>> parseJson(Request request) async {
    try {
      final body = await request.body();
      if (body.isEmpty) {
        throw const BadRequestException(message: 'Invalid body');
      }
      late final Map<String, dynamic> json;
      try {
        json = jsonDecode(body) as Map<String, dynamic>;
        return Right(json);
      } catch (e) {
        throw const BadRequestException(message: 'Invalid body');
      }
    } on BadRequestException catch (e) {
      return Left(ValidationFailure(message: e.message, errors: {}));
    }
  }
}
