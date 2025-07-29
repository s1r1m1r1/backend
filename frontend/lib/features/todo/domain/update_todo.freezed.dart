// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_todo.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UpdateTodo {

 int get id; String? get title; String? get description; bool? get completed;
/// Create a copy of UpdateTodo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateTodoCopyWith<UpdateTodo> get copyWith => _$UpdateTodoCopyWithImpl<UpdateTodo>(this as UpdateTodo, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateTodo&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.completed, completed) || other.completed == completed));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,description,completed);

@override
String toString() {
  return 'UpdateTodo(id: $id, title: $title, description: $description, completed: $completed)';
}


}

/// @nodoc
abstract mixin class $UpdateTodoCopyWith<$Res>  {
  factory $UpdateTodoCopyWith(UpdateTodo value, $Res Function(UpdateTodo) _then) = _$UpdateTodoCopyWithImpl;
@useResult
$Res call({
 int id, String? title, String? description, bool? completed
});




}
/// @nodoc
class _$UpdateTodoCopyWithImpl<$Res>
    implements $UpdateTodoCopyWith<$Res> {
  _$UpdateTodoCopyWithImpl(this._self, this._then);

  final UpdateTodo _self;
  final $Res Function(UpdateTodo) _then;

/// Create a copy of UpdateTodo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = freezed,Object? description = freezed,Object? completed = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,completed: freezed == completed ? _self.completed : completed // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateTodo].
extension UpdateTodoPatterns on UpdateTodo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateTodo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateTodo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateTodo value)  $default,){
final _that = this;
switch (_that) {
case _UpdateTodo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateTodo value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateTodo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String? title,  String? description,  bool? completed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateTodo() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.completed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String? title,  String? description,  bool? completed)  $default,) {final _that = this;
switch (_that) {
case _UpdateTodo():
return $default(_that.id,_that.title,_that.description,_that.completed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String? title,  String? description,  bool? completed)?  $default,) {final _that = this;
switch (_that) {
case _UpdateTodo() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.completed);case _:
  return null;

}
}

}

/// @nodoc


class _UpdateTodo extends UpdateTodo {
  const _UpdateTodo({required this.id, this.title, this.description, this.completed}): super._();
  

@override final  int id;
@override final  String? title;
@override final  String? description;
@override final  bool? completed;

/// Create a copy of UpdateTodo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateTodoCopyWith<_UpdateTodo> get copyWith => __$UpdateTodoCopyWithImpl<_UpdateTodo>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateTodo&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.completed, completed) || other.completed == completed));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,description,completed);

@override
String toString() {
  return 'UpdateTodo(id: $id, title: $title, description: $description, completed: $completed)';
}


}

/// @nodoc
abstract mixin class _$UpdateTodoCopyWith<$Res> implements $UpdateTodoCopyWith<$Res> {
  factory _$UpdateTodoCopyWith(_UpdateTodo value, $Res Function(_UpdateTodo) _then) = __$UpdateTodoCopyWithImpl;
@override @useResult
$Res call({
 int id, String? title, String? description, bool? completed
});




}
/// @nodoc
class __$UpdateTodoCopyWithImpl<$Res>
    implements _$UpdateTodoCopyWith<$Res> {
  __$UpdateTodoCopyWithImpl(this._self, this._then);

  final _UpdateTodo _self;
  final $Res Function(_UpdateTodo) _then;

/// Create a copy of UpdateTodo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = freezed,Object? description = freezed,Object? completed = freezed,}) {
  return _then(_UpdateTodo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,completed: freezed == completed ? _self.completed : completed // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
