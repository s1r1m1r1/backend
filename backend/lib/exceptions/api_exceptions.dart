// import 'dart:io' show HttpStatus;

// import 'dart:io'; // Make sure to import HttpStatus from dart:io

// class ApiException implements Exception {
//   const ApiException._({this.message, this.errors, required this.statusCode});
//   final String? message;
//   final List<String>? errors;
//   final int statusCode;

//   factory ApiException.badRequest({String? message, List<String>? errors}) =>
//       ApiException._(message: message, errors: errors, statusCode: HttpStatus.badRequest);

//   factory ApiException.notFound({String? message, List<String>? errors}) =>
//       ApiException._(message: message, errors: errors, statusCode: HttpStatus.notFound);

//   factory ApiException.unauthorized({String? message, List<String>? errors}) =>
//       ApiException._(message: message, errors: errors, statusCode: HttpStatus.unauthorized);

//   // You can add more factory constructors for other common HTTP status codes
//   factory ApiException.forbidden({String? message, List<String>? errors}) =>
//       ApiException._(message: message, errors: errors, statusCode: HttpStatus.forbidden);

//   factory ApiException.internalServerError({String? message, List<String>? errors}) =>
//       ApiException._(message: message, errors: errors, statusCode: HttpStatus.internalServerError);

//   @override
//   String toString() => '$runtimeType: $message (Status: $statusCode) Errors: ${errors?.join(', ') ?? 'None'}';
// }

// // And then update your other custom exceptions to be more specific
// // lib/core/errors/exceptions.dart
// class ServerException implements Exception {
//   final String message;
//   final int? statusCode;
//   ServerException({this.message = 'Server error', this.statusCode});
//   @override
//   String toString() => 'ServerException: $message (Status: $statusCode)';
// }

// class ClientException implements Exception {
//   final String message;
//   final int? statusCode;
//   ClientException({this.message = 'Client error', this.statusCode});
//   @override
//   String toString() => 'ClientException: $message (Status: $statusCode)';
// }

// class NetworkException implements Exception {
//   final String message;
//   NetworkException({this.message = 'Network error'});
//   @override
//   String toString() => 'NetworkException: $message';
// }
