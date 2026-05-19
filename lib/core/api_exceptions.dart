import 'dart:io' show HttpStatus;
import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_exceptions.freezed.dart';

/// Базовый класс для всех исключений API.
/// Построен по принципу Union Types для удобного паттерн-матчинга
/// и соответствия стандартам структурированных ответов об ошибках.
@Freezed(
  copyWith: false,
  makeCollectionsUnmodifiable: false,
  when: FreezedWhenOptions.none,
  map: FreezedMapOptions.none,
)
sealed class ApiException with _$ApiException implements Exception {
  const ApiException._();

  /// 400 Bad Request: Ошибка в запросе клиента (невалидный синтаксис и т.д.)
  const factory ApiException.badRequest({
    @Default('Bad request') String message,
    String? code,
    Object? details,
    @Default(HttpStatus.badRequest) int statusCode,
  }) = _BadRequestException;

  /// 401 Unauthorized: Отсутствует или невалидна аутентификация
  const factory ApiException.unauthorized({
    @Default('Unauthorized access') String message,
    String? code,
    Object? details,
    @Default(HttpStatus.unauthorized) int statusCode,
  }) = _UnauthorizedException;

  /// 403 Forbidden: Аутентификация пройдена, но прав недостаточно
  const factory ApiException.forbidden({
    @Default('Forbidden access') String message,
    String? code,
    Object? details,
    @Default(HttpStatus.forbidden) int statusCode,
  }) = _ForbiddenException;

  /// 404 Not Found: Ресурс не найден
  const factory ApiException.notFound({
    @Default('Resource not found') String message,
    String? code,
    Object? details,
    @Default(HttpStatus.notFound) int statusCode,
  }) = _NotFoundException;

  /// 409 Conflict: Конфликт состояния ресурса (например, дубликат email)
  const factory ApiException.conflict({
    @Default('Conflict') String message,
    String? code,
    Object? details,
    @Default(HttpStatus.conflict) int statusCode,
  }) = _ConflictException;

  /// 422 Unprocessable Content: Данные валидны, но нарушена бизнес-логика
  const factory ApiException.unprocessable({
    @Default('Unprocessable Entity') String message,
    String? code,
    Object? details,
    @Default(HttpStatus.unprocessableEntity) int statusCode,
  }) = _UnprocessableException;

  /// 500 Internal Server Error: Непредвиденная ошибка на сервере
  const factory ApiException.internal({
    @Default('Internal server error') String message,
    String? code,
    Object? details,
    @Default(HttpStatus.internalServerError) int statusCode,
  }) = _InternalServerErrorException;

  /// Формирует стандартный JSON для HTTP ответа.
  Map<String, dynamic> toResponseJson() {
    return {
      'error': {
        'message': message,
        if (code != null) 'code': code,
        if (details != null) 'details': details,
        'status': statusCode,
      },
    };
  }

  @override
  String toString() => 'ApiException[$statusCode]: $message (Code: $code)';
}
