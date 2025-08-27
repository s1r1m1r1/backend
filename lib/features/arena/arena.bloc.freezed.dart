// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'arena.bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ArenaEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ArenaEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ArenaEvent()';
}


}

/// @nodoc
class $ArenaEventCopyWith<$Res>  {
$ArenaEventCopyWith(ArenaEvent _, $Res Function(ArenaEvent) __);
}



/// @nodoc


class _JoinEvent implements ArenaEvent {
  const _JoinEvent();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JoinEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ArenaEvent.join()';
}


}




/// @nodoc


class _CreateBattleEvent implements ArenaEvent {
  const _CreateBattleEvent();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateBattleEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ArenaEvent.createBattle()';
}


}




/// @nodoc


class _JoinBattleEvent implements ArenaEvent {
  const _JoinBattleEvent();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JoinBattleEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ArenaEvent.joinBattle()';
}


}




/// @nodoc


class _LeaveBattleEvent implements ArenaEvent {
  const _LeaveBattleEvent();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LeaveBattleEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ArenaEvent.leaveBattle()';
}


}




/// @nodoc
mixin _$ArenaState {

 List<BattleRoom> get rooms;
/// Create a copy of ArenaState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ArenaStateCopyWith<ArenaState> get copyWith => _$ArenaStateCopyWithImpl<ArenaState>(this as ArenaState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ArenaState&&const DeepCollectionEquality().equals(other.rooms, rooms));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(rooms));

@override
String toString() {
  return 'ArenaState(rooms: $rooms)';
}


}

/// @nodoc
abstract mixin class $ArenaStateCopyWith<$Res>  {
  factory $ArenaStateCopyWith(ArenaState value, $Res Function(ArenaState) _then) = _$ArenaStateCopyWithImpl;
@useResult
$Res call({
 List<BattleRoom> rooms
});




}
/// @nodoc
class _$ArenaStateCopyWithImpl<$Res>
    implements $ArenaStateCopyWith<$Res> {
  _$ArenaStateCopyWithImpl(this._self, this._then);

  final ArenaState _self;
  final $Res Function(ArenaState) _then;

/// Create a copy of ArenaState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? rooms = null,}) {
  return _then(_self.copyWith(
rooms: null == rooms ? _self.rooms : rooms // ignore: cast_nullable_to_non_nullable
as List<BattleRoom>,
  ));
}

}



/// @nodoc


class _ArenaState extends ArenaState {
  const _ArenaState({final  List<BattleRoom> rooms = const []}): _rooms = rooms,super._();
  

 final  List<BattleRoom> _rooms;
@override@JsonKey() List<BattleRoom> get rooms {
  if (_rooms is EqualUnmodifiableListView) return _rooms;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_rooms);
}


/// Create a copy of ArenaState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ArenaStateCopyWith<_ArenaState> get copyWith => __$ArenaStateCopyWithImpl<_ArenaState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ArenaState&&const DeepCollectionEquality().equals(other._rooms, _rooms));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_rooms));

@override
String toString() {
  return 'ArenaState(rooms: $rooms)';
}


}

/// @nodoc
abstract mixin class _$ArenaStateCopyWith<$Res> implements $ArenaStateCopyWith<$Res> {
  factory _$ArenaStateCopyWith(_ArenaState value, $Res Function(_ArenaState) _then) = __$ArenaStateCopyWithImpl;
@override @useResult
$Res call({
 List<BattleRoom> rooms
});




}
/// @nodoc
class __$ArenaStateCopyWithImpl<$Res>
    implements _$ArenaStateCopyWith<$Res> {
  __$ArenaStateCopyWithImpl(this._self, this._then);

  final _ArenaState _self;
  final $Res Function(_ArenaState) _then;

/// Create a copy of ArenaState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? rooms = null,}) {
  return _then(_ArenaState(
rooms: null == rooms ? _self._rooms : rooms // ignore: cast_nullable_to_non_nullable
as List<BattleRoom>,
  ));
}


}

// dart format on
