// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'api_exceptions.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ApiException {

 String get message; String? get code; Object? get details; int get statusCode;



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApiException&&(identical(other.message, message) || other.message == message)&&(identical(other.code, code) || other.code == code)&&const DeepCollectionEquality().equals(other.details, details)&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode));
}


@override
int get hashCode => Object.hash(runtimeType,message,code,const DeepCollectionEquality().hash(details),statusCode);

@override
String toString() {
  return 'ApiException(message: $message, code: $code, details: $details, statusCode: $statusCode)';
}


}





/// @nodoc


class _BadRequestException extends ApiException {
  const _BadRequestException({this.message = 'Bad request', this.code, this.details, this.statusCode = HttpStatus.badRequest}): super._();
  

@override@JsonKey() final  String message;
@override final  String? code;
@override final  Object? details;
@override@JsonKey() final  int statusCode;




@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BadRequestException&&(identical(other.message, message) || other.message == message)&&(identical(other.code, code) || other.code == code)&&const DeepCollectionEquality().equals(other.details, details)&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode));
}


@override
int get hashCode => Object.hash(runtimeType,message,code,const DeepCollectionEquality().hash(details),statusCode);

@override
String toString() {
  return 'ApiException.badRequest(message: $message, code: $code, details: $details, statusCode: $statusCode)';
}


}




/// @nodoc


class _UnauthorizedException extends ApiException {
  const _UnauthorizedException({this.message = 'Unauthorized access', this.code, this.details, this.statusCode = HttpStatus.unauthorized}): super._();
  

@override@JsonKey() final  String message;
@override final  String? code;
@override final  Object? details;
@override@JsonKey() final  int statusCode;




@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UnauthorizedException&&(identical(other.message, message) || other.message == message)&&(identical(other.code, code) || other.code == code)&&const DeepCollectionEquality().equals(other.details, details)&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode));
}


@override
int get hashCode => Object.hash(runtimeType,message,code,const DeepCollectionEquality().hash(details),statusCode);

@override
String toString() {
  return 'ApiException.unauthorized(message: $message, code: $code, details: $details, statusCode: $statusCode)';
}


}




/// @nodoc


class _ForbiddenException extends ApiException {
  const _ForbiddenException({this.message = 'Forbidden access', this.code, this.details, this.statusCode = HttpStatus.forbidden}): super._();
  

@override@JsonKey() final  String message;
@override final  String? code;
@override final  Object? details;
@override@JsonKey() final  int statusCode;




@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ForbiddenException&&(identical(other.message, message) || other.message == message)&&(identical(other.code, code) || other.code == code)&&const DeepCollectionEquality().equals(other.details, details)&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode));
}


@override
int get hashCode => Object.hash(runtimeType,message,code,const DeepCollectionEquality().hash(details),statusCode);

@override
String toString() {
  return 'ApiException.forbidden(message: $message, code: $code, details: $details, statusCode: $statusCode)';
}


}




/// @nodoc


class _NotFoundException extends ApiException {
  const _NotFoundException({this.message = 'Resource not found', this.code, this.details, this.statusCode = HttpStatus.notFound}): super._();
  

@override@JsonKey() final  String message;
@override final  String? code;
@override final  Object? details;
@override@JsonKey() final  int statusCode;




@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotFoundException&&(identical(other.message, message) || other.message == message)&&(identical(other.code, code) || other.code == code)&&const DeepCollectionEquality().equals(other.details, details)&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode));
}


@override
int get hashCode => Object.hash(runtimeType,message,code,const DeepCollectionEquality().hash(details),statusCode);

@override
String toString() {
  return 'ApiException.notFound(message: $message, code: $code, details: $details, statusCode: $statusCode)';
}


}




/// @nodoc


class _ConflictException extends ApiException {
  const _ConflictException({this.message = 'Conflict', this.code, this.details, this.statusCode = HttpStatus.conflict}): super._();
  

@override@JsonKey() final  String message;
@override final  String? code;
@override final  Object? details;
@override@JsonKey() final  int statusCode;




@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConflictException&&(identical(other.message, message) || other.message == message)&&(identical(other.code, code) || other.code == code)&&const DeepCollectionEquality().equals(other.details, details)&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode));
}


@override
int get hashCode => Object.hash(runtimeType,message,code,const DeepCollectionEquality().hash(details),statusCode);

@override
String toString() {
  return 'ApiException.conflict(message: $message, code: $code, details: $details, statusCode: $statusCode)';
}


}




/// @nodoc


class _UnprocessableException extends ApiException {
  const _UnprocessableException({this.message = 'Unprocessable Entity', this.code, this.details, this.statusCode = HttpStatus.unprocessableEntity}): super._();
  

@override@JsonKey() final  String message;
@override final  String? code;
@override final  Object? details;
@override@JsonKey() final  int statusCode;




@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UnprocessableException&&(identical(other.message, message) || other.message == message)&&(identical(other.code, code) || other.code == code)&&const DeepCollectionEquality().equals(other.details, details)&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode));
}


@override
int get hashCode => Object.hash(runtimeType,message,code,const DeepCollectionEquality().hash(details),statusCode);

@override
String toString() {
  return 'ApiException.unprocessable(message: $message, code: $code, details: $details, statusCode: $statusCode)';
}


}




/// @nodoc


class _InternalServerErrorException extends ApiException {
  const _InternalServerErrorException({this.message = 'Internal server error', this.code, this.details, this.statusCode = HttpStatus.internalServerError}): super._();
  

@override@JsonKey() final  String message;
@override final  String? code;
@override final  Object? details;
@override@JsonKey() final  int statusCode;




@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InternalServerErrorException&&(identical(other.message, message) || other.message == message)&&(identical(other.code, code) || other.code == code)&&const DeepCollectionEquality().equals(other.details, details)&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode));
}


@override
int get hashCode => Object.hash(runtimeType,message,code,const DeepCollectionEquality().hash(details),statusCode);

@override
String toString() {
  return 'ApiException.internal(message: $message, code: $code, details: $details, statusCode: $statusCode)';
}


}




// dart format on
