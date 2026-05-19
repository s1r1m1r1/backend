import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:dto/dto.dart';

import '../../core/api_exceptions.dart';

Future<Json> parseJson(Request request) async {
  try {
    final body = await request.body();
    if (body.isEmpty) {
      throw const ApiException.badRequest(message: 'Request body is empty');
    }

    try {
      final json = jsonDecode(body) as Json;
      return json;
    } on FormatException catch (e) {
      throw ApiException.badRequest(
        message: 'Request body is not valid JSON.',
        details: [e.message], // Include the decoding error message
      );
    } on TypeError catch (e) {
      throw ApiException.badRequest(
        message: 'JSON body must be a top-level JSON object (Map).',
        details: [e.toString()], // Include the type error
      );
    }
  } on ApiException catch (_) {
    // Catch existing ApiExceptions thrown above and re-throw them directly.
    // This ensures that the specific ApiException (e.g., 'JSON body is empty')
    // and its associated status code and message are propagated.
    rethrow;
  } on Object catch (_) {
    // Catch any other unexpected errors during body reading or initial parsing
    // This is for truly unexpected internal server issues
    throw const ApiException.internal(
      message: 'Internal server error during JSON parsing.',
    );
  }
}
