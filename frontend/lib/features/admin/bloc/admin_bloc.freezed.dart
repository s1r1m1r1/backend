// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AdminEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AdminEvent()';
}


}

/// @nodoc
class $AdminEventCopyWith<$Res>  {
$AdminEventCopyWith(AdminEvent _, $Res Function(AdminEvent) __);
}



/// @nodoc


class _CreateAdminEvent extends AdminEvent {
  const _CreateAdminEvent(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateAdminEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AdminEvent.create()';
}


}

/// @nodoc
class _$CreateAdminEventCopyWith<$Res> implements $AdminEventCopyWith<$Res> {
_$CreateAdminEventCopyWith(_CreateAdminEvent _, $Res Function(_CreateAdminEvent) __);
}
/// @nodoc
class __$CreateAdminEventCopyWithImpl<$Res>
    implements _$CreateAdminEventCopyWith<$Res> {
  __$CreateAdminEventCopyWithImpl(this._self, this._then);

  final _CreateAdminEvent _self;
  final $Res Function(_CreateAdminEvent) _then;




}

/// @nodoc


class _ReadAdminEvent extends AdminEvent {
  const _ReadAdminEvent(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReadAdminEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AdminEvent.read()';
}


}

/// @nodoc
class _$ReadAdminEventCopyWith<$Res> implements $AdminEventCopyWith<$Res> {
_$ReadAdminEventCopyWith(_ReadAdminEvent _, $Res Function(_ReadAdminEvent) __);
}
/// @nodoc
class __$ReadAdminEventCopyWithImpl<$Res>
    implements _$ReadAdminEventCopyWith<$Res> {
  __$ReadAdminEventCopyWithImpl(this._self, this._then);

  final _ReadAdminEvent _self;
  final $Res Function(_ReadAdminEvent) _then;




}

/// @nodoc


class _UpdateAdminEvent extends AdminEvent {
  const _UpdateAdminEvent(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateAdminEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AdminEvent.update()';
}


}

/// @nodoc
class _$UpdateAdminEventCopyWith<$Res> implements $AdminEventCopyWith<$Res> {
_$UpdateAdminEventCopyWith(_UpdateAdminEvent _, $Res Function(_UpdateAdminEvent) __);
}
/// @nodoc
class __$UpdateAdminEventCopyWithImpl<$Res>
    implements _$UpdateAdminEventCopyWith<$Res> {
  __$UpdateAdminEventCopyWithImpl(this._self, this._then);

  final _UpdateAdminEvent _self;
  final $Res Function(_UpdateAdminEvent) _then;




}

/// @nodoc


class _DeleteAdminEvent extends AdminEvent {
  const _DeleteAdminEvent(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeleteAdminEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AdminEvent.delete()';
}


}

/// @nodoc
class _$DeleteAdminEventCopyWith<$Res> implements $AdminEventCopyWith<$Res> {
_$DeleteAdminEventCopyWith(_DeleteAdminEvent _, $Res Function(_DeleteAdminEvent) __);
}
/// @nodoc
class __$DeleteAdminEventCopyWithImpl<$Res>
    implements _$DeleteAdminEventCopyWith<$Res> {
  __$DeleteAdminEventCopyWithImpl(this._self, this._then);

  final _DeleteAdminEvent _self;
  final $Res Function(_DeleteAdminEvent) _then;




}

/// @nodoc
mixin _$AdminState {

 int get connectionCount;
/// Create a copy of AdminState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminStateCopyWith<AdminState> get copyWith => _$AdminStateCopyWithImpl<AdminState>(this as AdminState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminState&&(identical(other.connectionCount, connectionCount) || other.connectionCount == connectionCount));
}


@override
int get hashCode => Object.hash(runtimeType,connectionCount);

@override
String toString() {
  return 'AdminState(connectionCount: $connectionCount)';
}


}

/// @nodoc
abstract mixin class $AdminStateCopyWith<$Res>  {
  factory $AdminStateCopyWith(AdminState value, $Res Function(AdminState) _then) = _$AdminStateCopyWithImpl;
@useResult
$Res call({
 int connectionCount
});




}
/// @nodoc
class _$AdminStateCopyWithImpl<$Res>
    implements $AdminStateCopyWith<$Res> {
  _$AdminStateCopyWithImpl(this._self, this._then);

  final AdminState _self;
  final $Res Function(AdminState) _then;

/// Create a copy of AdminState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? connectionCount = null,}) {
  return _then(_self.copyWith(
connectionCount: null == connectionCount ? _self.connectionCount : connectionCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}



/// @nodoc


class _AdminState extends AdminState {
  const _AdminState({this.connectionCount = 0}): super._();
  

@override@JsonKey() final  int connectionCount;

/// Create a copy of AdminState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminStateCopyWith<_AdminState> get copyWith => __$AdminStateCopyWithImpl<_AdminState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminState&&(identical(other.connectionCount, connectionCount) || other.connectionCount == connectionCount));
}


@override
int get hashCode => Object.hash(runtimeType,connectionCount);

@override
String toString() {
  return 'AdminState(connectionCount: $connectionCount)';
}


}

/// @nodoc
abstract mixin class _$AdminStateCopyWith<$Res> implements $AdminStateCopyWith<$Res> {
  factory _$AdminStateCopyWith(_AdminState value, $Res Function(_AdminState) _then) = __$AdminStateCopyWithImpl;
@override @useResult
$Res call({
 int connectionCount
});




}
/// @nodoc
class __$AdminStateCopyWithImpl<$Res>
    implements _$AdminStateCopyWith<$Res> {
  __$AdminStateCopyWithImpl(this._self, this._then);

  final _AdminState _self;
  final $Res Function(_AdminState) _then;

/// Create a copy of AdminState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? connectionCount = null,}) {
  return _then(_AdminState(
connectionCount: null == connectionCount ? _self.connectionCount : connectionCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
