import 'dart:async';
import 'dart:convert';

import 'package:backend/models/typedefs.dart';
import 'package:dart_frog/dart_frog.dart';

import '../exceptions/new_api_exceptions.dart';
import '../failures/validation_failure.dart';
import '../request_handler/unimplemented_handler.dart';

@deprecated
abstract class HttpController {
  FutureOr<Response> index(Request request) => unimplementedHandler();

  FutureOr<Response> store(Request request) => unimplementedHandler();

  FutureOr<Response> show(Request request, String id) => unimplementedHandler();

  FutureOr<Response> update(Request request, String id) => unimplementedHandler();

  FutureOr<Response> destroy(Request request, String id) => unimplementedHandler();

  // Parses the request body into a json map
  /// Returns a [ValidationFailure] if the body is invalid
  Future<Json> parseJson(Request request) async {
    try {
      final body = await request.body();
      if (body.isEmpty) {
        throw ApiException.badRequest(message: 'Request body is empty');
      }

      try {
        final Json json = jsonDecode(body) as Json;
        return json;
      } on FormatException catch (e) {
        throw ApiException.badRequest(
          message: 'Request body is not valid JSON.',
          errors: [e.message], // Include the decoding error message
        );
      } on TypeError catch (e) {
        throw ApiException.badRequest(
          message: 'JSON body must be a top-level JSON object (Map).',
          errors: [e.toString()], // Include the type error
        );
      }
    } on ApiException catch (e) {
      // Catch existing ApiExceptions thrown above and re-throw them directly.
      // This ensures that the specific ApiException (e.g., 'JSON body is empty')
      // and its associated status code and message are propagated.
      rethrow;
    } on Object catch (e, stackTrace) {
      // Catch any other unexpected errors during body reading or initial parsing
      // This is for truly unexpected internal server issues
      throw ApiException.internalServerError(message: 'Internal server error during JSON parsing.');
    }
  }
}
