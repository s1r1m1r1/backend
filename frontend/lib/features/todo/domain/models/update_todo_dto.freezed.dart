// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_todo_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UpdateTodoDto {

 String? get title; String? get description; bool? get completed;
/// Create a copy of UpdateTodoDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateTodoDtoCopyWith<UpdateTodoDto> get copyWith => _$UpdateTodoDtoCopyWithImpl<UpdateTodoDto>(this as UpdateTodoDto, _$identity);

  /// Serializes this UpdateTodoDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateTodoDto&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.completed, completed) || other.completed == completed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,description,completed);

@override
String toString() {
  return 'UpdateTodoDto(title: $title, description: $description, completed: $completed)';
}


}

/// @nodoc
abstract mixin class $UpdateTodoDtoCopyWith<$Res>  {
  factory $UpdateTodoDtoCopyWith(UpdateTodoDto value, $Res Function(UpdateTodoDto) _then) = _$UpdateTodoDtoCopyWithImpl;
@useResult
$Res call({
 String? title, String? description, bool? completed
});




}
/// @nodoc
class _$UpdateTodoDtoCopyWithImpl<$Res>
    implements $UpdateTodoDtoCopyWith<$Res> {
  _$UpdateTodoDtoCopyWithImpl(this._self, this._then);

  final UpdateTodoDto _self;
  final $Res Function(UpdateTodoDto) _then;

/// Create a copy of UpdateTodoDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = freezed,Object? description = freezed,Object? completed = freezed,}) {
  return _then(_self.copyWith(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,completed: freezed == completed ? _self.completed : completed // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateTodoDto].
extension UpdateTodoDtoPatterns on UpdateTodoDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateTodoDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateTodoDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateTodoDto value)  $default,){
final _that = this;
switch (_that) {
case _UpdateTodoDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateTodoDto value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateTodoDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? title,  String? description,  bool? completed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateTodoDto() when $default != null:
return $default(_that.title,_that.description,_that.completed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? title,  String? description,  bool? completed)  $default,) {final _that = this;
switch (_that) {
case _UpdateTodoDto():
return $default(_that.title,_that.description,_that.completed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? title,  String? description,  bool? completed)?  $default,) {final _that = this;
switch (_that) {
case _UpdateTodoDto() when $default != null:
return $default(_that.title,_that.description,_that.completed);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateTodoDto extends UpdateTodoDto {
  const _UpdateTodoDto({this.title, this.description, this.completed}): super._();
  factory _UpdateTodoDto.fromJson(Map<String, dynamic> json) => _$UpdateTodoDtoFromJson(json);

@override final  String? title;
@override final  String? description;
@override final  bool? completed;

/// Create a copy of UpdateTodoDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateTodoDtoCopyWith<_UpdateTodoDto> get copyWith => __$UpdateTodoDtoCopyWithImpl<_UpdateTodoDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateTodoDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateTodoDto&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.completed, completed) || other.completed == completed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,description,completed);

@override
String toString() {
  return 'UpdateTodoDto(title: $title, description: $description, completed: $completed)';
}


}

/// @nodoc
abstract mixin class _$UpdateTodoDtoCopyWith<$Res> implements $UpdateTodoDtoCopyWith<$Res> {
  factory _$UpdateTodoDtoCopyWith(_UpdateTodoDto value, $Res Function(_UpdateTodoDto) _then) = __$UpdateTodoDtoCopyWithImpl;
@override @useResult
$Res call({
 String? title, String? description, bool? completed
});




}
/// @nodoc
class __$UpdateTodoDtoCopyWithImpl<$Res>
    implements _$UpdateTodoDtoCopyWith<$Res> {
  __$UpdateTodoDtoCopyWithImpl(this._self, this._then);

  final _UpdateTodoDto _self;
  final $Res Function(_UpdateTodoDto) _then;

/// Create a copy of UpdateTodoDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = freezed,Object? description = freezed,Object? completed = freezed,}) {
  return _then(_UpdateTodoDto(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,completed: freezed == completed ? _self.completed : completed // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
