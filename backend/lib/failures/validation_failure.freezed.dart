// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'validation_failure.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
ValidationFailure _$ValidationFailureFromJson(
  Map<String, dynamic> json
) {
    return $ValidationFailure.fromJson(
      json
    );
}

/// @nodoc
mixin _$ValidationFailure {

 String? get message; int get statusCode; List<String>? get errors;
/// Create a copy of ValidationFailure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ValidationFailureCopyWith<ValidationFailure> get copyWith => _$ValidationFailureCopyWithImpl<ValidationFailure>(this as ValidationFailure, _$identity);

  /// Serializes this ValidationFailure to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ValidationFailure&&(identical(other.message, message) || other.message == message)&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode)&&const DeepCollectionEquality().equals(other.errors, errors));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,message,statusCode,const DeepCollectionEquality().hash(errors));

@override
String toString() {
  return 'ValidationFailure(message: $message, statusCode: $statusCode, errors: $errors)';
}


}

/// @nodoc
abstract mixin class $ValidationFailureCopyWith<$Res>  {
  factory $ValidationFailureCopyWith(ValidationFailure value, $Res Function(ValidationFailure) _then) = _$ValidationFailureCopyWithImpl;
@useResult
$Res call({
 String? message, int statusCode, List<String>? errors
});




}
/// @nodoc
class _$ValidationFailureCopyWithImpl<$Res>
    implements $ValidationFailureCopyWith<$Res> {
  _$ValidationFailureCopyWithImpl(this._self, this._then);

  final ValidationFailure _self;
  final $Res Function(ValidationFailure) _then;

/// Create a copy of ValidationFailure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? message = freezed,Object? statusCode = null,Object? errors = freezed,}) {
  return _then(_self.copyWith(
message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,statusCode: null == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int,errors: freezed == errors ? _self.errors : errors // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}

}


/// Adds pattern-matching-related methods to [ValidationFailure].
extension ValidationFailurePatterns on ValidationFailure {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( $ValidationFailure value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case $ValidationFailure() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( $ValidationFailure value)  $default,){
final _that = this;
switch (_that) {
case $ValidationFailure():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( $ValidationFailure value)?  $default,){
final _that = this;
switch (_that) {
case $ValidationFailure() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? message,  int statusCode,  List<String>? errors)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case $ValidationFailure() when $default != null:
return $default(_that.message,_that.statusCode,_that.errors);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? message,  int statusCode,  List<String>? errors)  $default,) {final _that = this;
switch (_that) {
case $ValidationFailure():
return $default(_that.message,_that.statusCode,_that.errors);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? message,  int statusCode,  List<String>? errors)?  $default,) {final _that = this;
switch (_that) {
case $ValidationFailure() when $default != null:
return $default(_that.message,_that.statusCode,_that.errors);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class $ValidationFailure extends ValidationFailure {
  const $ValidationFailure({this.message, required this.statusCode, final  List<String>? errors}): _errors = errors,super._();
  factory $ValidationFailure.fromJson(Map<String, dynamic> json) => _$$ValidationFailureFromJson(json);

@override final  String? message;
@override final  int statusCode;
 final  List<String>? _errors;
@override List<String>? get errors {
  final value = _errors;
  if (value == null) return null;
  if (_errors is EqualUnmodifiableListView) return _errors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of ValidationFailure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$$ValidationFailureCopyWith<$ValidationFailure> get copyWith => _$$ValidationFailureCopyWithImpl<$ValidationFailure>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$$ValidationFailureToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is $ValidationFailure&&(identical(other.message, message) || other.message == message)&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode)&&const DeepCollectionEquality().equals(other._errors, _errors));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,message,statusCode,const DeepCollectionEquality().hash(_errors));

@override
String toString() {
  return 'ValidationFailure(message: $message, statusCode: $statusCode, errors: $errors)';
}


}

/// @nodoc
abstract mixin class $$ValidationFailureCopyWith<$Res> implements $ValidationFailureCopyWith<$Res> {
  factory $$ValidationFailureCopyWith($ValidationFailure value, $Res Function($ValidationFailure) _then) = _$$ValidationFailureCopyWithImpl;
@override @useResult
$Res call({
 String? message, int statusCode, List<String>? errors
});




}
/// @nodoc
class _$$ValidationFailureCopyWithImpl<$Res>
    implements $$ValidationFailureCopyWith<$Res> {
  _$$ValidationFailureCopyWithImpl(this._self, this._then);

  final $ValidationFailure _self;
  final $Res Function($ValidationFailure) _then;

/// Create a copy of ValidationFailure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = freezed,Object? statusCode = null,Object? errors = freezed,}) {
  return _then($ValidationFailure(
message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,statusCode: null == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int,errors: freezed == errors ? _self._errors : errors // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}


}

// dart format on
