// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'letter.bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LetterEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LetterEvent);
}


@override
int get hashCode => runtimeType.hashCode;



}

/// @nodoc
class $LetterEventCopyWith<$Res>  {
$LetterEventCopyWith(LetterEvent _, $Res Function(LetterEvent) __);
}



/// @nodoc


class _SetRoomLE implements LetterEvent {
  const _SetRoomLE(this.roomId);
  

 final  int roomId;

/// Create a copy of LetterEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SetRoomLECopyWith<_SetRoomLE> get copyWith => __$SetRoomLECopyWithImpl<_SetRoomLE>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SetRoomLE&&(identical(other.roomId, roomId) || other.roomId == roomId));
}


@override
int get hashCode => Object.hash(runtimeType,roomId);



}

/// @nodoc
abstract mixin class _$SetRoomLECopyWith<$Res> implements $LetterEventCopyWith<$Res> {
  factory _$SetRoomLECopyWith(_SetRoomLE value, $Res Function(_SetRoomLE) _then) = __$SetRoomLECopyWithImpl;
@useResult
$Res call({
 int roomId
});




}
/// @nodoc
class __$SetRoomLECopyWithImpl<$Res>
    implements _$SetRoomLECopyWith<$Res> {
  __$SetRoomLECopyWithImpl(this._self, this._then);

  final _SetRoomLE _self;
  final $Res Function(_SetRoomLE) _then;

/// Create a copy of LetterEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? roomId = null,}) {
  return _then(_SetRoomLE(
null == roomId ? _self.roomId : roomId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class _NewLetterLE implements LetterEvent {
  const _NewLetterLE(this.channel, this.session, this.dto);
  

 final  WebSocketChannel channel;
 final  GameSession session;
 final  CreateLetterDto dto;

/// Create a copy of LetterEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NewLetterLECopyWith<_NewLetterLE> get copyWith => __$NewLetterLECopyWithImpl<_NewLetterLE>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NewLetterLE&&(identical(other.channel, channel) || other.channel == channel)&&(identical(other.session, session) || other.session == session)&&(identical(other.dto, dto) || other.dto == dto));
}


@override
int get hashCode => Object.hash(runtimeType,channel,session,dto);



}

/// @nodoc
abstract mixin class _$NewLetterLECopyWith<$Res> implements $LetterEventCopyWith<$Res> {
  factory _$NewLetterLECopyWith(_NewLetterLE value, $Res Function(_NewLetterLE) _then) = __$NewLetterLECopyWithImpl;
@useResult
$Res call({
 WebSocketChannel channel, GameSession session, CreateLetterDto dto
});


$CreateLetterDtoCopyWith<$Res> get dto;

}
/// @nodoc
class __$NewLetterLECopyWithImpl<$Res>
    implements _$NewLetterLECopyWith<$Res> {
  __$NewLetterLECopyWithImpl(this._self, this._then);

  final _NewLetterLE _self;
  final $Res Function(_NewLetterLE) _then;

/// Create a copy of LetterEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? channel = null,Object? session = null,Object? dto = null,}) {
  return _then(_NewLetterLE(
null == channel ? _self.channel : channel // ignore: cast_nullable_to_non_nullable
as WebSocketChannel,null == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as GameSession,null == dto ? _self.dto : dto // ignore: cast_nullable_to_non_nullable
as CreateLetterDto,
  ));
}

/// Create a copy of LetterEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CreateLetterDtoCopyWith<$Res> get dto {
  
  return $CreateLetterDtoCopyWith<$Res>(_self.dto, (value) {
    return _then(_self.copyWith(dto: value));
  });
}
}

/// @nodoc


class _SubscribeLE implements LetterEvent {
  const _SubscribeLE(this.channel, this.disposer);
  

 final  WebSocketChannel channel;
 final  WebSocketDisposer disposer;

/// Create a copy of LetterEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubscribeLECopyWith<_SubscribeLE> get copyWith => __$SubscribeLECopyWithImpl<_SubscribeLE>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SubscribeLE&&(identical(other.channel, channel) || other.channel == channel)&&(identical(other.disposer, disposer) || other.disposer == disposer));
}


@override
int get hashCode => Object.hash(runtimeType,channel,disposer);



}

/// @nodoc
abstract mixin class _$SubscribeLECopyWith<$Res> implements $LetterEventCopyWith<$Res> {
  factory _$SubscribeLECopyWith(_SubscribeLE value, $Res Function(_SubscribeLE) _then) = __$SubscribeLECopyWithImpl;
@useResult
$Res call({
 WebSocketChannel channel, WebSocketDisposer disposer
});




}
/// @nodoc
class __$SubscribeLECopyWithImpl<$Res>
    implements _$SubscribeLECopyWith<$Res> {
  __$SubscribeLECopyWithImpl(this._self, this._then);

  final _SubscribeLE _self;
  final $Res Function(_SubscribeLE) _then;

/// Create a copy of LetterEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? channel = null,Object? disposer = null,}) {
  return _then(_SubscribeLE(
null == channel ? _self.channel : channel // ignore: cast_nullable_to_non_nullable
as WebSocketChannel,null == disposer ? _self.disposer : disposer // ignore: cast_nullable_to_non_nullable
as WebSocketDisposer,
  ));
}


}

/// @nodoc


class _RemoveLetterLE implements LetterEvent {
  const _RemoveLetterLE(this.channel, this.session, this.letterId);
  

 final  WebSocketChannel channel;
 final  GameSession session;
 final  int letterId;

/// Create a copy of LetterEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RemoveLetterLECopyWith<_RemoveLetterLE> get copyWith => __$RemoveLetterLECopyWithImpl<_RemoveLetterLE>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RemoveLetterLE&&(identical(other.channel, channel) || other.channel == channel)&&(identical(other.session, session) || other.session == session)&&(identical(other.letterId, letterId) || other.letterId == letterId));
}


@override
int get hashCode => Object.hash(runtimeType,channel,session,letterId);



}

/// @nodoc
abstract mixin class _$RemoveLetterLECopyWith<$Res> implements $LetterEventCopyWith<$Res> {
  factory _$RemoveLetterLECopyWith(_RemoveLetterLE value, $Res Function(_RemoveLetterLE) _then) = __$RemoveLetterLECopyWithImpl;
@useResult
$Res call({
 WebSocketChannel channel, GameSession session, int letterId
});




}
/// @nodoc
class __$RemoveLetterLECopyWithImpl<$Res>
    implements _$RemoveLetterLECopyWith<$Res> {
  __$RemoveLetterLECopyWithImpl(this._self, this._then);

  final _RemoveLetterLE _self;
  final $Res Function(_RemoveLetterLE) _then;

/// Create a copy of LetterEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? channel = null,Object? session = null,Object? letterId = null,}) {
  return _then(_RemoveLetterLE(
null == channel ? _self.channel : channel // ignore: cast_nullable_to_non_nullable
as WebSocketChannel,null == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as GameSession,null == letterId ? _self.letterId : letterId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$LetterState {

 int get roomId;
/// Create a copy of LetterState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LetterStateCopyWith<LetterState> get copyWith => _$LetterStateCopyWithImpl<LetterState>(this as LetterState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LetterState&&(identical(other.roomId, roomId) || other.roomId == roomId));
}


@override
int get hashCode => Object.hash(runtimeType,roomId);



}

/// @nodoc
abstract mixin class $LetterStateCopyWith<$Res>  {
  factory $LetterStateCopyWith(LetterState value, $Res Function(LetterState) _then) = _$LetterStateCopyWithImpl;
@useResult
$Res call({
 int roomId
});




}
/// @nodoc
class _$LetterStateCopyWithImpl<$Res>
    implements $LetterStateCopyWith<$Res> {
  _$LetterStateCopyWithImpl(this._self, this._then);

  final LetterState _self;
  final $Res Function(LetterState) _then;

/// Create a copy of LetterState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? roomId = null,}) {
  return _then(_self.copyWith(
roomId: null == roomId ? _self.roomId : roomId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}



/// @nodoc


class _HasRoomState extends LetterState {
  const _HasRoomState(this.roomId): super._();
  

@override final  int roomId;

/// Create a copy of LetterState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HasRoomStateCopyWith<_HasRoomState> get copyWith => __$HasRoomStateCopyWithImpl<_HasRoomState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HasRoomState&&(identical(other.roomId, roomId) || other.roomId == roomId));
}


@override
int get hashCode => Object.hash(runtimeType,roomId);



}

/// @nodoc
abstract mixin class _$HasRoomStateCopyWith<$Res> implements $LetterStateCopyWith<$Res> {
  factory _$HasRoomStateCopyWith(_HasRoomState value, $Res Function(_HasRoomState) _then) = __$HasRoomStateCopyWithImpl;
@override @useResult
$Res call({
 int roomId
});




}
/// @nodoc
class __$HasRoomStateCopyWithImpl<$Res>
    implements _$HasRoomStateCopyWith<$Res> {
  __$HasRoomStateCopyWithImpl(this._self, this._then);

  final _HasRoomState _self;
  final $Res Function(_HasRoomState) _then;

/// Create a copy of LetterState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? roomId = null,}) {
  return _then(_HasRoomState(
null == roomId ? _self.roomId : roomId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class _NewLetterState extends LetterState {
  const _NewLetterState(this.roomId, this.letter): super._();
  

@override final  int roomId;
 final  LetterDto letter;

/// Create a copy of LetterState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NewLetterStateCopyWith<_NewLetterState> get copyWith => __$NewLetterStateCopyWithImpl<_NewLetterState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NewLetterState&&(identical(other.roomId, roomId) || other.roomId == roomId)&&(identical(other.letter, letter) || other.letter == letter));
}


@override
int get hashCode => Object.hash(runtimeType,roomId,letter);



}

/// @nodoc
abstract mixin class _$NewLetterStateCopyWith<$Res> implements $LetterStateCopyWith<$Res> {
  factory _$NewLetterStateCopyWith(_NewLetterState value, $Res Function(_NewLetterState) _then) = __$NewLetterStateCopyWithImpl;
@override @useResult
$Res call({
 int roomId, LetterDto letter
});


$LetterDtoCopyWith<$Res> get letter;

}
/// @nodoc
class __$NewLetterStateCopyWithImpl<$Res>
    implements _$NewLetterStateCopyWith<$Res> {
  __$NewLetterStateCopyWithImpl(this._self, this._then);

  final _NewLetterState _self;
  final $Res Function(_NewLetterState) _then;

/// Create a copy of LetterState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? roomId = null,Object? letter = null,}) {
  return _then(_NewLetterState(
null == roomId ? _self.roomId : roomId // ignore: cast_nullable_to_non_nullable
as int,null == letter ? _self.letter : letter // ignore: cast_nullable_to_non_nullable
as LetterDto,
  ));
}

/// Create a copy of LetterState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LetterDtoCopyWith<$Res> get letter {
  
  return $LetterDtoCopyWith<$Res>(_self.letter, (value) {
    return _then(_self.copyWith(letter: value));
  });
}
}

/// @nodoc


class _DeletedLetterState extends LetterState {
  const _DeletedLetterState({required this.roomId, required this.letterId}): super._();
  

@override final  int roomId;
 final  int letterId;

/// Create a copy of LetterState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeletedLetterStateCopyWith<_DeletedLetterState> get copyWith => __$DeletedLetterStateCopyWithImpl<_DeletedLetterState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeletedLetterState&&(identical(other.roomId, roomId) || other.roomId == roomId)&&(identical(other.letterId, letterId) || other.letterId == letterId));
}


@override
int get hashCode => Object.hash(runtimeType,roomId,letterId);



}

/// @nodoc
abstract mixin class _$DeletedLetterStateCopyWith<$Res> implements $LetterStateCopyWith<$Res> {
  factory _$DeletedLetterStateCopyWith(_DeletedLetterState value, $Res Function(_DeletedLetterState) _then) = __$DeletedLetterStateCopyWithImpl;
@override @useResult
$Res call({
 int roomId, int letterId
});




}
/// @nodoc
class __$DeletedLetterStateCopyWithImpl<$Res>
    implements _$DeletedLetterStateCopyWith<$Res> {
  __$DeletedLetterStateCopyWithImpl(this._self, this._then);

  final _DeletedLetterState _self;
  final $Res Function(_DeletedLetterState) _then;

/// Create a copy of LetterState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? roomId = null,Object? letterId = null,}) {
  return _then(_DeletedLetterState(
roomId: null == roomId ? _self.roomId : roomId // ignore: cast_nullable_to_non_nullable
as int,letterId: null == letterId ? _self.letterId : letterId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
