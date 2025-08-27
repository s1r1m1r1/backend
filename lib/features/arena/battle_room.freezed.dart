// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'battle_room.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BattleRoom {

 int get id; List<int> get unitIds; DateTime get createdAt; DateTime? get battleStartIn; bool get isFighting;
/// Create a copy of BattleRoom
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BattleRoomCopyWith<BattleRoom> get copyWith => _$BattleRoomCopyWithImpl<BattleRoom>(this as BattleRoom, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BattleRoom&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other.unitIds, unitIds)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.battleStartIn, battleStartIn) || other.battleStartIn == battleStartIn)&&(identical(other.isFighting, isFighting) || other.isFighting == isFighting));
}


@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(unitIds),createdAt,battleStartIn,isFighting);

@override
String toString() {
  return 'BattleRoom(id: $id, unitIds: $unitIds, createdAt: $createdAt, battleStartIn: $battleStartIn, isFighting: $isFighting)';
}


}

/// @nodoc
abstract mixin class $BattleRoomCopyWith<$Res>  {
  factory $BattleRoomCopyWith(BattleRoom value, $Res Function(BattleRoom) _then) = _$BattleRoomCopyWithImpl;
@useResult
$Res call({
 int id, List<int> unitIds, DateTime createdAt, DateTime? battleStartIn, bool isFighting
});




}
/// @nodoc
class _$BattleRoomCopyWithImpl<$Res>
    implements $BattleRoomCopyWith<$Res> {
  _$BattleRoomCopyWithImpl(this._self, this._then);

  final BattleRoom _self;
  final $Res Function(BattleRoom) _then;

/// Create a copy of BattleRoom
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? unitIds = null,Object? createdAt = null,Object? battleStartIn = freezed,Object? isFighting = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,unitIds: null == unitIds ? _self.unitIds : unitIds // ignore: cast_nullable_to_non_nullable
as List<int>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,battleStartIn: freezed == battleStartIn ? _self.battleStartIn : battleStartIn // ignore: cast_nullable_to_non_nullable
as DateTime?,isFighting: null == isFighting ? _self.isFighting : isFighting // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}



/// @nodoc


class _BattleRoom implements BattleRoom {
  const _BattleRoom({required this.id, final  List<int> unitIds = const [], required this.createdAt, this.battleStartIn, this.isFighting = false}): _unitIds = unitIds;
  

@override final  int id;
 final  List<int> _unitIds;
@override@JsonKey() List<int> get unitIds {
  if (_unitIds is EqualUnmodifiableListView) return _unitIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_unitIds);
}

@override final  DateTime createdAt;
@override final  DateTime? battleStartIn;
@override@JsonKey() final  bool isFighting;

/// Create a copy of BattleRoom
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BattleRoomCopyWith<_BattleRoom> get copyWith => __$BattleRoomCopyWithImpl<_BattleRoom>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BattleRoom&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other._unitIds, _unitIds)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.battleStartIn, battleStartIn) || other.battleStartIn == battleStartIn)&&(identical(other.isFighting, isFighting) || other.isFighting == isFighting));
}


@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(_unitIds),createdAt,battleStartIn,isFighting);

@override
String toString() {
  return 'BattleRoom(id: $id, unitIds: $unitIds, createdAt: $createdAt, battleStartIn: $battleStartIn, isFighting: $isFighting)';
}


}

/// @nodoc
abstract mixin class _$BattleRoomCopyWith<$Res> implements $BattleRoomCopyWith<$Res> {
  factory _$BattleRoomCopyWith(_BattleRoom value, $Res Function(_BattleRoom) _then) = __$BattleRoomCopyWithImpl;
@override @useResult
$Res call({
 int id, List<int> unitIds, DateTime createdAt, DateTime? battleStartIn, bool isFighting
});




}
/// @nodoc
class __$BattleRoomCopyWithImpl<$Res>
    implements _$BattleRoomCopyWith<$Res> {
  __$BattleRoomCopyWithImpl(this._self, this._then);

  final _BattleRoom _self;
  final $Res Function(_BattleRoom) _then;

/// Create a copy of BattleRoom
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? unitIds = null,Object? createdAt = null,Object? battleStartIn = freezed,Object? isFighting = null,}) {
  return _then(_BattleRoom(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,unitIds: null == unitIds ? _self._unitIds : unitIds // ignore: cast_nullable_to_non_nullable
as List<int>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,battleStartIn: freezed == battleStartIn ? _self.battleStartIn : battleStartIn // ignore: cast_nullable_to_non_nullable
as DateTime?,isFighting: null == isFighting ? _self.isFighting : isFighting // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
