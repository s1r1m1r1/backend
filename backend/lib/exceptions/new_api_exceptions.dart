import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:io' show HttpStatus; // For HttpStatus

part 'new_api_exceptions.freezed.dart'; // This will be generated

@freezed
sealed class ApiException with _$ApiException implements Exception {
  const ApiException._(); // Private constructor for the sealed class

  // Factory constructors representing different API error types
  // Note: message, errors, and stackTrace are common properties.
  // We'll expose them through a custom getter in the base class.

  // Use for client-side input validation errors (400)
  const factory ApiException.badRequest({
    @Default('Bad request') String message,
    List<String>? errors,
    @Default(HttpStatus.badRequest) int statusCode,
  }) = _BadRequestException;

  // Use when a requested resource is not found (404)
  const factory ApiException.notFound({
    @Default('Resource not found') String message,
    List<String>? errors,
    @Default(HttpStatus.notFound) int statusCode,
  }) = _NotFoundException;

  // Use for authentication failures (401)
  const factory ApiException.unauthorized({
    @Default('Unauthorized access') String message,
    List<String>? errors,
    @Default(HttpStatus.unauthorized) int statusCode,
  }) = _UnauthorizedException;

  // Use when access to a resource is forbidden (403)
  const factory ApiException.forbidden({
    @Default('Forbidden access') String message,
    List<String>? errors,
    @Default(HttpStatus.forbidden) int statusCode,
  }) = _ForbiddenException;

  // Use for conflict errors (e.g., duplicate resource, 409)
  const factory ApiException.conflict({
    @Default('Conflict') String message,
    List<String>? errors,
    @Default(HttpStatus.conflict) int statusCode,
  }) = _ConflictException; // Added for email already exists

  // Use for semantic validation errors where input is valid but unprocessable (422)
  const factory ApiException.unprocessableContent({
    @Default('Unprocessable Content') String message,
    List<String>? errors,
    @Default(HttpStatus.unprocessableEntity) int statusCode, // HttpStatus.unprocessableEntity is 422
  }) = _UnprocessableContentException;

  // Use for server-side errors (500)
  const factory ApiException.internalServerError({
    @Default('Internal server error') String message,
    List<String>? errors, // Changed to nullable consistent with others
    @Default(HttpStatus.internalServerError) int statusCode,
  }) = _InternalServerErrorException;

  // You can define common getters for all sealed union types
  String get errorMessage {
    return errors?.join(', ') ?? 'No specific errors.';
  }

  // Override toString for better logging/debugging
  @override
  String toString() {
    return 'ApiException ($runtimeType): $message (Status: $statusCode) Errors: $errorMessage';
  }
}
