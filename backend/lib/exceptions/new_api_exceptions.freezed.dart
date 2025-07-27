// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'new_api_exceptions.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ApiException {

 String get message; List<String>? get errors;// Changed to nullable consistent with others
 int get statusCode;// HttpStatus.unprocessableEntity is 422
 StackTrace? get stackTrace;
/// Create a copy of ApiException
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApiExceptionCopyWith<ApiException> get copyWith => _$ApiExceptionCopyWithImpl<ApiException>(this as ApiException, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApiException&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.errors, errors)&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode)&&(identical(other.stackTrace, stackTrace) || other.stackTrace == stackTrace));
}


@override
int get hashCode => Object.hash(runtimeType,message,const DeepCollectionEquality().hash(errors),statusCode,stackTrace);



}

/// @nodoc
abstract mixin class $ApiExceptionCopyWith<$Res>  {
  factory $ApiExceptionCopyWith(ApiException value, $Res Function(ApiException) _then) = _$ApiExceptionCopyWithImpl;
@useResult
$Res call({
 String message, List<String>? errors, int statusCode, StackTrace? stackTrace
});




}
/// @nodoc
class _$ApiExceptionCopyWithImpl<$Res>
    implements $ApiExceptionCopyWith<$Res> {
  _$ApiExceptionCopyWithImpl(this._self, this._then);

  final ApiException _self;
  final $Res Function(ApiException) _then;

/// Create a copy of ApiException
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? message = null,Object? errors = freezed,Object? statusCode = null,Object? stackTrace = freezed,}) {
  return _then(_self.copyWith(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,errors: freezed == errors ? _self.errors : errors // ignore: cast_nullable_to_non_nullable
as List<String>?,statusCode: null == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int,stackTrace: freezed == stackTrace ? _self.stackTrace : stackTrace // ignore: cast_nullable_to_non_nullable
as StackTrace?,
  ));
}

}


/// Adds pattern-matching-related methods to [ApiException].
extension ApiExceptionPatterns on ApiException {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _BadRequestException value)?  badRequest,TResult Function( _NotFoundException value)?  notFound,TResult Function( _UnauthorizedException value)?  unauthorized,TResult Function( _ForbiddenException value)?  forbidden,TResult Function( _ConflictException value)?  conflict,TResult Function( _UnprocessableContentException value)?  unprocessableContent,TResult Function( _InternalServerErrorException value)?  internalServerError,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BadRequestException() when badRequest != null:
return badRequest(_that);case _NotFoundException() when notFound != null:
return notFound(_that);case _UnauthorizedException() when unauthorized != null:
return unauthorized(_that);case _ForbiddenException() when forbidden != null:
return forbidden(_that);case _ConflictException() when conflict != null:
return conflict(_that);case _UnprocessableContentException() when unprocessableContent != null:
return unprocessableContent(_that);case _InternalServerErrorException() when internalServerError != null:
return internalServerError(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _BadRequestException value)  badRequest,required TResult Function( _NotFoundException value)  notFound,required TResult Function( _UnauthorizedException value)  unauthorized,required TResult Function( _ForbiddenException value)  forbidden,required TResult Function( _ConflictException value)  conflict,required TResult Function( _UnprocessableContentException value)  unprocessableContent,required TResult Function( _InternalServerErrorException value)  internalServerError,}){
final _that = this;
switch (_that) {
case _BadRequestException():
return badRequest(_that);case _NotFoundException():
return notFound(_that);case _UnauthorizedException():
return unauthorized(_that);case _ForbiddenException():
return forbidden(_that);case _ConflictException():
return conflict(_that);case _UnprocessableContentException():
return unprocessableContent(_that);case _InternalServerErrorException():
return internalServerError(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _BadRequestException value)?  badRequest,TResult? Function( _NotFoundException value)?  notFound,TResult? Function( _UnauthorizedException value)?  unauthorized,TResult? Function( _ForbiddenException value)?  forbidden,TResult? Function( _ConflictException value)?  conflict,TResult? Function( _UnprocessableContentException value)?  unprocessableContent,TResult? Function( _InternalServerErrorException value)?  internalServerError,}){
final _that = this;
switch (_that) {
case _BadRequestException() when badRequest != null:
return badRequest(_that);case _NotFoundException() when notFound != null:
return notFound(_that);case _UnauthorizedException() when unauthorized != null:
return unauthorized(_that);case _ForbiddenException() when forbidden != null:
return forbidden(_that);case _ConflictException() when conflict != null:
return conflict(_that);case _UnprocessableContentException() when unprocessableContent != null:
return unprocessableContent(_that);case _InternalServerErrorException() when internalServerError != null:
return internalServerError(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String message,  List<String>? errors,  int statusCode,  StackTrace? stackTrace)?  badRequest,TResult Function( String message,  List<String>? errors,  int statusCode,  StackTrace? stackTrace)?  notFound,TResult Function( String message,  List<String>? errors,  int statusCode,  StackTrace? stackTrace)?  unauthorized,TResult Function( String message,  List<String>? errors,  int statusCode,  StackTrace? stackTrace)?  forbidden,TResult Function( String message,  List<String>? errors,  int statusCode,  StackTrace? stackTrace)?  conflict,TResult Function( String message,  List<String>? errors,  int statusCode,  StackTrace? stackTrace)?  unprocessableContent,TResult Function( String message,  List<String>? errors,  int statusCode,  StackTrace? stackTrace)?  internalServerError,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BadRequestException() when badRequest != null:
return badRequest(_that.message,_that.errors,_that.statusCode,_that.stackTrace);case _NotFoundException() when notFound != null:
return notFound(_that.message,_that.errors,_that.statusCode,_that.stackTrace);case _UnauthorizedException() when unauthorized != null:
return unauthorized(_that.message,_that.errors,_that.statusCode,_that.stackTrace);case _ForbiddenException() when forbidden != null:
return forbidden(_that.message,_that.errors,_that.statusCode,_that.stackTrace);case _ConflictException() when conflict != null:
return conflict(_that.message,_that.errors,_that.statusCode,_that.stackTrace);case _UnprocessableContentException() when unprocessableContent != null:
return unprocessableContent(_that.message,_that.errors,_that.statusCode,_that.stackTrace);case _InternalServerErrorException() when internalServerError != null:
return internalServerError(_that.message,_that.errors,_that.statusCode,_that.stackTrace);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String message,  List<String>? errors,  int statusCode,  StackTrace? stackTrace)  badRequest,required TResult Function( String message,  List<String>? errors,  int statusCode,  StackTrace? stackTrace)  notFound,required TResult Function( String message,  List<String>? errors,  int statusCode,  StackTrace? stackTrace)  unauthorized,required TResult Function( String message,  List<String>? errors,  int statusCode,  StackTrace? stackTrace)  forbidden,required TResult Function( String message,  List<String>? errors,  int statusCode,  StackTrace? stackTrace)  conflict,required TResult Function( String message,  List<String>? errors,  int statusCode,  StackTrace? stackTrace)  unprocessableContent,required TResult Function( String message,  List<String>? errors,  int statusCode,  StackTrace? stackTrace)  internalServerError,}) {final _that = this;
switch (_that) {
case _BadRequestException():
return badRequest(_that.message,_that.errors,_that.statusCode,_that.stackTrace);case _NotFoundException():
return notFound(_that.message,_that.errors,_that.statusCode,_that.stackTrace);case _UnauthorizedException():
return unauthorized(_that.message,_that.errors,_that.statusCode,_that.stackTrace);case _ForbiddenException():
return forbidden(_that.message,_that.errors,_that.statusCode,_that.stackTrace);case _ConflictException():
return conflict(_that.message,_that.errors,_that.statusCode,_that.stackTrace);case _UnprocessableContentException():
return unprocessableContent(_that.message,_that.errors,_that.statusCode,_that.stackTrace);case _InternalServerErrorException():
return internalServerError(_that.message,_that.errors,_that.statusCode,_that.stackTrace);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String message,  List<String>? errors,  int statusCode,  StackTrace? stackTrace)?  badRequest,TResult? Function( String message,  List<String>? errors,  int statusCode,  StackTrace? stackTrace)?  notFound,TResult? Function( String message,  List<String>? errors,  int statusCode,  StackTrace? stackTrace)?  unauthorized,TResult? Function( String message,  List<String>? errors,  int statusCode,  StackTrace? stackTrace)?  forbidden,TResult? Function( String message,  List<String>? errors,  int statusCode,  StackTrace? stackTrace)?  conflict,TResult? Function( String message,  List<String>? errors,  int statusCode,  StackTrace? stackTrace)?  unprocessableContent,TResult? Function( String message,  List<String>? errors,  int statusCode,  StackTrace? stackTrace)?  internalServerError,}) {final _that = this;
switch (_that) {
case _BadRequestException() when badRequest != null:
return badRequest(_that.message,_that.errors,_that.statusCode,_that.stackTrace);case _NotFoundException() when notFound != null:
return notFound(_that.message,_that.errors,_that.statusCode,_that.stackTrace);case _UnauthorizedException() when unauthorized != null:
return unauthorized(_that.message,_that.errors,_that.statusCode,_that.stackTrace);case _ForbiddenException() when forbidden != null:
return forbidden(_that.message,_that.errors,_that.statusCode,_that.stackTrace);case _ConflictException() when conflict != null:
return conflict(_that.message,_that.errors,_that.statusCode,_that.stackTrace);case _UnprocessableContentException() when unprocessableContent != null:
return unprocessableContent(_that.message,_that.errors,_that.statusCode,_that.stackTrace);case _InternalServerErrorException() when internalServerError != null:
return internalServerError(_that.message,_that.errors,_that.statusCode,_that.stackTrace);case _:
  return null;

}
}

}

/// @nodoc


class _BadRequestException extends ApiException {
  const _BadRequestException({this.message = 'Bad request', final  List<String>? errors, this.statusCode = HttpStatus.badRequest, this.stackTrace}): _errors = errors,super._();
  

@override@JsonKey() final  String message;
 final  List<String>? _errors;
@override List<String>? get errors {
  final value = _errors;
  if (value == null) return null;
  if (_errors is EqualUnmodifiableListView) return _errors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey() final  int statusCode;
@override final  StackTrace? stackTrace;

/// Create a copy of ApiException
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BadRequestExceptionCopyWith<_BadRequestException> get copyWith => __$BadRequestExceptionCopyWithImpl<_BadRequestException>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BadRequestException&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other._errors, _errors)&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode)&&(identical(other.stackTrace, stackTrace) || other.stackTrace == stackTrace));
}


@override
int get hashCode => Object.hash(runtimeType,message,const DeepCollectionEquality().hash(_errors),statusCode,stackTrace);



}

/// @nodoc
abstract mixin class _$BadRequestExceptionCopyWith<$Res> implements $ApiExceptionCopyWith<$Res> {
  factory _$BadRequestExceptionCopyWith(_BadRequestException value, $Res Function(_BadRequestException) _then) = __$BadRequestExceptionCopyWithImpl;
@override @useResult
$Res call({
 String message, List<String>? errors, int statusCode, StackTrace? stackTrace
});




}
/// @nodoc
class __$BadRequestExceptionCopyWithImpl<$Res>
    implements _$BadRequestExceptionCopyWith<$Res> {
  __$BadRequestExceptionCopyWithImpl(this._self, this._then);

  final _BadRequestException _self;
  final $Res Function(_BadRequestException) _then;

/// Create a copy of ApiException
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? errors = freezed,Object? statusCode = null,Object? stackTrace = freezed,}) {
  return _then(_BadRequestException(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,errors: freezed == errors ? _self._errors : errors // ignore: cast_nullable_to_non_nullable
as List<String>?,statusCode: null == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int,stackTrace: freezed == stackTrace ? _self.stackTrace : stackTrace // ignore: cast_nullable_to_non_nullable
as StackTrace?,
  ));
}


}

/// @nodoc


class _NotFoundException extends ApiException {
  const _NotFoundException({this.message = 'Resource not found', final  List<String>? errors, this.statusCode = HttpStatus.notFound, this.stackTrace}): _errors = errors,super._();
  

@override@JsonKey() final  String message;
 final  List<String>? _errors;
@override List<String>? get errors {
  final value = _errors;
  if (value == null) return null;
  if (_errors is EqualUnmodifiableListView) return _errors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey() final  int statusCode;
@override final  StackTrace? stackTrace;

/// Create a copy of ApiException
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotFoundExceptionCopyWith<_NotFoundException> get copyWith => __$NotFoundExceptionCopyWithImpl<_NotFoundException>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotFoundException&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other._errors, _errors)&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode)&&(identical(other.stackTrace, stackTrace) || other.stackTrace == stackTrace));
}


@override
int get hashCode => Object.hash(runtimeType,message,const DeepCollectionEquality().hash(_errors),statusCode,stackTrace);



}

/// @nodoc
abstract mixin class _$NotFoundExceptionCopyWith<$Res> implements $ApiExceptionCopyWith<$Res> {
  factory _$NotFoundExceptionCopyWith(_NotFoundException value, $Res Function(_NotFoundException) _then) = __$NotFoundExceptionCopyWithImpl;
@override @useResult
$Res call({
 String message, List<String>? errors, int statusCode, StackTrace? stackTrace
});




}
/// @nodoc
class __$NotFoundExceptionCopyWithImpl<$Res>
    implements _$NotFoundExceptionCopyWith<$Res> {
  __$NotFoundExceptionCopyWithImpl(this._self, this._then);

  final _NotFoundException _self;
  final $Res Function(_NotFoundException) _then;

/// Create a copy of ApiException
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? errors = freezed,Object? statusCode = null,Object? stackTrace = freezed,}) {
  return _then(_NotFoundException(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,errors: freezed == errors ? _self._errors : errors // ignore: cast_nullable_to_non_nullable
as List<String>?,statusCode: null == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int,stackTrace: freezed == stackTrace ? _self.stackTrace : stackTrace // ignore: cast_nullable_to_non_nullable
as StackTrace?,
  ));
}


}

/// @nodoc


class _UnauthorizedException extends ApiException {
  const _UnauthorizedException({this.message = 'Unauthorized access', final  List<String>? errors, this.statusCode = HttpStatus.unauthorized, this.stackTrace}): _errors = errors,super._();
  

@override@JsonKey() final  String message;
 final  List<String>? _errors;
@override List<String>? get errors {
  final value = _errors;
  if (value == null) return null;
  if (_errors is EqualUnmodifiableListView) return _errors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey() final  int statusCode;
@override final  StackTrace? stackTrace;

/// Create a copy of ApiException
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UnauthorizedExceptionCopyWith<_UnauthorizedException> get copyWith => __$UnauthorizedExceptionCopyWithImpl<_UnauthorizedException>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UnauthorizedException&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other._errors, _errors)&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode)&&(identical(other.stackTrace, stackTrace) || other.stackTrace == stackTrace));
}


@override
int get hashCode => Object.hash(runtimeType,message,const DeepCollectionEquality().hash(_errors),statusCode,stackTrace);



}

/// @nodoc
abstract mixin class _$UnauthorizedExceptionCopyWith<$Res> implements $ApiExceptionCopyWith<$Res> {
  factory _$UnauthorizedExceptionCopyWith(_UnauthorizedException value, $Res Function(_UnauthorizedException) _then) = __$UnauthorizedExceptionCopyWithImpl;
@override @useResult
$Res call({
 String message, List<String>? errors, int statusCode, StackTrace? stackTrace
});




}
/// @nodoc
class __$UnauthorizedExceptionCopyWithImpl<$Res>
    implements _$UnauthorizedExceptionCopyWith<$Res> {
  __$UnauthorizedExceptionCopyWithImpl(this._self, this._then);

  final _UnauthorizedException _self;
  final $Res Function(_UnauthorizedException) _then;

/// Create a copy of ApiException
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? errors = freezed,Object? statusCode = null,Object? stackTrace = freezed,}) {
  return _then(_UnauthorizedException(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,errors: freezed == errors ? _self._errors : errors // ignore: cast_nullable_to_non_nullable
as List<String>?,statusCode: null == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int,stackTrace: freezed == stackTrace ? _self.stackTrace : stackTrace // ignore: cast_nullable_to_non_nullable
as StackTrace?,
  ));
}


}

/// @nodoc


class _ForbiddenException extends ApiException {
  const _ForbiddenException({this.message = 'Forbidden access', final  List<String>? errors, this.statusCode = HttpStatus.forbidden, this.stackTrace}): _errors = errors,super._();
  

@override@JsonKey() final  String message;
 final  List<String>? _errors;
@override List<String>? get errors {
  final value = _errors;
  if (value == null) return null;
  if (_errors is EqualUnmodifiableListView) return _errors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey() final  int statusCode;
@override final  StackTrace? stackTrace;

/// Create a copy of ApiException
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ForbiddenExceptionCopyWith<_ForbiddenException> get copyWith => __$ForbiddenExceptionCopyWithImpl<_ForbiddenException>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ForbiddenException&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other._errors, _errors)&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode)&&(identical(other.stackTrace, stackTrace) || other.stackTrace == stackTrace));
}


@override
int get hashCode => Object.hash(runtimeType,message,const DeepCollectionEquality().hash(_errors),statusCode,stackTrace);



}

/// @nodoc
abstract mixin class _$ForbiddenExceptionCopyWith<$Res> implements $ApiExceptionCopyWith<$Res> {
  factory _$ForbiddenExceptionCopyWith(_ForbiddenException value, $Res Function(_ForbiddenException) _then) = __$ForbiddenExceptionCopyWithImpl;
@override @useResult
$Res call({
 String message, List<String>? errors, int statusCode, StackTrace? stackTrace
});




}
/// @nodoc
class __$ForbiddenExceptionCopyWithImpl<$Res>
    implements _$ForbiddenExceptionCopyWith<$Res> {
  __$ForbiddenExceptionCopyWithImpl(this._self, this._then);

  final _ForbiddenException _self;
  final $Res Function(_ForbiddenException) _then;

/// Create a copy of ApiException
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? errors = freezed,Object? statusCode = null,Object? stackTrace = freezed,}) {
  return _then(_ForbiddenException(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,errors: freezed == errors ? _self._errors : errors // ignore: cast_nullable_to_non_nullable
as List<String>?,statusCode: null == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int,stackTrace: freezed == stackTrace ? _self.stackTrace : stackTrace // ignore: cast_nullable_to_non_nullable
as StackTrace?,
  ));
}


}

/// @nodoc


class _ConflictException extends ApiException {
  const _ConflictException({this.message = 'Conflict', final  List<String>? errors, this.statusCode = HttpStatus.conflict, this.stackTrace}): _errors = errors,super._();
  

@override@JsonKey() final  String message;
 final  List<String>? _errors;
@override List<String>? get errors {
  final value = _errors;
  if (value == null) return null;
  if (_errors is EqualUnmodifiableListView) return _errors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey() final  int statusCode;
@override final  StackTrace? stackTrace;

/// Create a copy of ApiException
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConflictExceptionCopyWith<_ConflictException> get copyWith => __$ConflictExceptionCopyWithImpl<_ConflictException>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConflictException&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other._errors, _errors)&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode)&&(identical(other.stackTrace, stackTrace) || other.stackTrace == stackTrace));
}


@override
int get hashCode => Object.hash(runtimeType,message,const DeepCollectionEquality().hash(_errors),statusCode,stackTrace);



}

/// @nodoc
abstract mixin class _$ConflictExceptionCopyWith<$Res> implements $ApiExceptionCopyWith<$Res> {
  factory _$ConflictExceptionCopyWith(_ConflictException value, $Res Function(_ConflictException) _then) = __$ConflictExceptionCopyWithImpl;
@override @useResult
$Res call({
 String message, List<String>? errors, int statusCode, StackTrace? stackTrace
});




}
/// @nodoc
class __$ConflictExceptionCopyWithImpl<$Res>
    implements _$ConflictExceptionCopyWith<$Res> {
  __$ConflictExceptionCopyWithImpl(this._self, this._then);

  final _ConflictException _self;
  final $Res Function(_ConflictException) _then;

/// Create a copy of ApiException
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? errors = freezed,Object? statusCode = null,Object? stackTrace = freezed,}) {
  return _then(_ConflictException(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,errors: freezed == errors ? _self._errors : errors // ignore: cast_nullable_to_non_nullable
as List<String>?,statusCode: null == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int,stackTrace: freezed == stackTrace ? _self.stackTrace : stackTrace // ignore: cast_nullable_to_non_nullable
as StackTrace?,
  ));
}


}

/// @nodoc


class _UnprocessableContentException extends ApiException {
  const _UnprocessableContentException({this.message = 'Unprocessable Content', final  List<String>? errors, this.statusCode = HttpStatus.unprocessableEntity, this.stackTrace}): _errors = errors,super._();
  

@override@JsonKey() final  String message;
 final  List<String>? _errors;
@override List<String>? get errors {
  final value = _errors;
  if (value == null) return null;
  if (_errors is EqualUnmodifiableListView) return _errors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey() final  int statusCode;
// HttpStatus.unprocessableEntity is 422
@override final  StackTrace? stackTrace;

/// Create a copy of ApiException
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UnprocessableContentExceptionCopyWith<_UnprocessableContentException> get copyWith => __$UnprocessableContentExceptionCopyWithImpl<_UnprocessableContentException>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UnprocessableContentException&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other._errors, _errors)&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode)&&(identical(other.stackTrace, stackTrace) || other.stackTrace == stackTrace));
}


@override
int get hashCode => Object.hash(runtimeType,message,const DeepCollectionEquality().hash(_errors),statusCode,stackTrace);



}

/// @nodoc
abstract mixin class _$UnprocessableContentExceptionCopyWith<$Res> implements $ApiExceptionCopyWith<$Res> {
  factory _$UnprocessableContentExceptionCopyWith(_UnprocessableContentException value, $Res Function(_UnprocessableContentException) _then) = __$UnprocessableContentExceptionCopyWithImpl;
@override @useResult
$Res call({
 String message, List<String>? errors, int statusCode, StackTrace? stackTrace
});




}
/// @nodoc
class __$UnprocessableContentExceptionCopyWithImpl<$Res>
    implements _$UnprocessableContentExceptionCopyWith<$Res> {
  __$UnprocessableContentExceptionCopyWithImpl(this._self, this._then);

  final _UnprocessableContentException _self;
  final $Res Function(_UnprocessableContentException) _then;

/// Create a copy of ApiException
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? errors = freezed,Object? statusCode = null,Object? stackTrace = freezed,}) {
  return _then(_UnprocessableContentException(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,errors: freezed == errors ? _self._errors : errors // ignore: cast_nullable_to_non_nullable
as List<String>?,statusCode: null == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int,stackTrace: freezed == stackTrace ? _self.stackTrace : stackTrace // ignore: cast_nullable_to_non_nullable
as StackTrace?,
  ));
}


}

/// @nodoc


class _InternalServerErrorException extends ApiException {
  const _InternalServerErrorException({this.message = 'Internal server error', final  List<String>? errors, this.statusCode = HttpStatus.internalServerError, this.stackTrace}): _errors = errors,super._();
  

@override@JsonKey() final  String message;
 final  List<String>? _errors;
@override List<String>? get errors {
  final value = _errors;
  if (value == null) return null;
  if (_errors is EqualUnmodifiableListView) return _errors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

// Changed to nullable consistent with others
@override@JsonKey() final  int statusCode;
@override final  StackTrace? stackTrace;

/// Create a copy of ApiException
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InternalServerErrorExceptionCopyWith<_InternalServerErrorException> get copyWith => __$InternalServerErrorExceptionCopyWithImpl<_InternalServerErrorException>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InternalServerErrorException&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other._errors, _errors)&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode)&&(identical(other.stackTrace, stackTrace) || other.stackTrace == stackTrace));
}


@override
int get hashCode => Object.hash(runtimeType,message,const DeepCollectionEquality().hash(_errors),statusCode,stackTrace);



}

/// @nodoc
abstract mixin class _$InternalServerErrorExceptionCopyWith<$Res> implements $ApiExceptionCopyWith<$Res> {
  factory _$InternalServerErrorExceptionCopyWith(_InternalServerErrorException value, $Res Function(_InternalServerErrorException) _then) = __$InternalServerErrorExceptionCopyWithImpl;
@override @useResult
$Res call({
 String message, List<String>? errors, int statusCode, StackTrace? stackTrace
});




}
/// @nodoc
class __$InternalServerErrorExceptionCopyWithImpl<$Res>
    implements _$InternalServerErrorExceptionCopyWith<$Res> {
  __$InternalServerErrorExceptionCopyWithImpl(this._self, this._then);

  final _InternalServerErrorException _self;
  final $Res Function(_InternalServerErrorException) _then;

/// Create a copy of ApiException
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? errors = freezed,Object? statusCode = null,Object? stackTrace = freezed,}) {
  return _then(_InternalServerErrorException(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,errors: freezed == errors ? _self._errors : errors // ignore: cast_nullable_to_non_nullable
as List<String>?,statusCode: null == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int,stackTrace: freezed == stackTrace ? _self.stackTrace : stackTrace // ignore: cast_nullable_to_non_nullable
as StackTrace?,
  ));
}


}

// dart format on
