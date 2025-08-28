// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bloc_id.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BlocId {

 int get id; String get family;
/// Create a copy of BlocId
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BlocIdCopyWith<BlocId> get copyWith => _$BlocIdCopyWithImpl<BlocId>(this as BlocId, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BlocId&&(identical(other.id, id) || other.id == id)&&(identical(other.family, family) || other.family == family));
}


@override
int get hashCode => Object.hash(runtimeType,id,family);

@override
String toString() {
  return 'BlocId(id: $id, family: $family)';
}


}

/// @nodoc
abstract mixin class $BlocIdCopyWith<$Res>  {
  factory $BlocIdCopyWith(BlocId value, $Res Function(BlocId) _then) = _$BlocIdCopyWithImpl;
@useResult
$Res call({
 int id, String family
});




}
/// @nodoc
class _$BlocIdCopyWithImpl<$Res>
    implements $BlocIdCopyWith<$Res> {
  _$BlocIdCopyWithImpl(this._self, this._then);

  final BlocId _self;
  final $Res Function(BlocId) _then;

/// Create a copy of BlocId
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? family = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,family: null == family ? _self.family : family // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}



/// @nodoc


class _BlocId extends BlocId {
  const _BlocId({required this.id, required this.family}): super._();
  

@override final  int id;
@override final  String family;

/// Create a copy of BlocId
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BlocIdCopyWith<_BlocId> get copyWith => __$BlocIdCopyWithImpl<_BlocId>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BlocId&&(identical(other.id, id) || other.id == id)&&(identical(other.family, family) || other.family == family));
}


@override
int get hashCode => Object.hash(runtimeType,id,family);

@override
String toString() {
  return 'BlocId(id: $id, family: $family)';
}


}

/// @nodoc
abstract mixin class _$BlocIdCopyWith<$Res> implements $BlocIdCopyWith<$Res> {
  factory _$BlocIdCopyWith(_BlocId value, $Res Function(_BlocId) _then) = __$BlocIdCopyWithImpl;
@override @useResult
$Res call({
 int id, String family
});




}
/// @nodoc
class __$BlocIdCopyWithImpl<$Res>
    implements _$BlocIdCopyWith<$Res> {
  __$BlocIdCopyWithImpl(this._self, this._then);

  final _BlocId _self;
  final $Res Function(_BlocId) _then;

/// Create a copy of BlocId
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? family = null,}) {
  return _then(_BlocId(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,family: null == family ? _self.family : family // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
