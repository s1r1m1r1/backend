import 'dart:async';
import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';

import '../exceptions/bad_request_exceptions.dart';
import '../failures/failure.dart';
import '../failures/validation_failure.dart';
import '../utils/result.dart';

abstract class HttpController {
  FutureOr<Response> index(Request request);

  FutureOr<Response> store(Request request);

  FutureOr<Response> show(Request request, String id);

  FutureOr<Response> update(Request request, String id);

  FutureOr<Response> destroy(Request request, String id);

  // Parses the request body into a json map
  /// Returns a [ValidationFailure] if the body is invalid
  Future<Result<Failure, Map<String, dynamic>>> parseJson(
    Request request,
  ) async {
    try {
      final body = await request.body();
      if (body.isEmpty) {
        throw const BadRequestException(message: 'Invalid body');
      }
      late final Map<String, dynamic> json;
      try {
        json = jsonDecode(body) as Map<String, dynamic>;
        return Result.success(json);
      } catch (e) {
        throw const BadRequestException(message: 'Invalid body');
      }
    } on BadRequestException catch (e) {
      return Result.fail(
        ValidationFailure(
          message: e.message,
          errors: {},
        ),
      );
    }
  }
}
