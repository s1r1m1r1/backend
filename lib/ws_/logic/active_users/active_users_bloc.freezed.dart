// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'active_users_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ActiveUsersEvent {

 WebSocketChannel get channel;
/// Create a copy of ActiveUsersEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActiveUsersEventCopyWith<ActiveUsersEvent> get copyWith => _$ActiveUsersEventCopyWithImpl<ActiveUsersEvent>(this as ActiveUsersEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActiveUsersEvent&&(identical(other.channel, channel) || other.channel == channel));
}


@override
int get hashCode => Object.hash(runtimeType,channel);

@override
String toString() {
  return 'ActiveUsersEvent(channel: $channel)';
}


}

/// @nodoc
abstract mixin class $ActiveUsersEventCopyWith<$Res>  {
  factory $ActiveUsersEventCopyWith(ActiveUsersEvent value, $Res Function(ActiveUsersEvent) _then) = _$ActiveUsersEventCopyWithImpl;
@useResult
$Res call({
 WebSocketChannel channel
});




}
/// @nodoc
class _$ActiveUsersEventCopyWithImpl<$Res>
    implements $ActiveUsersEventCopyWith<$Res> {
  _$ActiveUsersEventCopyWithImpl(this._self, this._then);

  final ActiveUsersEvent _self;
  final $Res Function(ActiveUsersEvent) _then;

/// Create a copy of ActiveUsersEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? channel = null,}) {
  return _then(_self.copyWith(
channel: null == channel ? _self.channel : channel // ignore: cast_nullable_to_non_nullable
as WebSocketChannel,
  ));
}

}


/// Adds pattern-matching-related methods to [ActiveUsersEvent].
extension ActiveUsersEventPatterns on ActiveUsersEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _WithTokenEvent value)?  withToken,TResult Function( _WithRefreshTokenEvent value)?  withRefresh,TResult Function( _LoginEvent value)?  login,TResult Function( _RemoveUser value)?  removeUser,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WithTokenEvent() when withToken != null:
return withToken(_that);case _WithRefreshTokenEvent() when withRefresh != null:
return withRefresh(_that);case _LoginEvent() when login != null:
return login(_that);case _RemoveUser() when removeUser != null:
return removeUser(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _WithTokenEvent value)  withToken,required TResult Function( _WithRefreshTokenEvent value)  withRefresh,required TResult Function( _LoginEvent value)  login,required TResult Function( _RemoveUser value)  removeUser,}){
final _that = this;
switch (_that) {
case _WithTokenEvent():
return withToken(_that);case _WithRefreshTokenEvent():
return withRefresh(_that);case _LoginEvent():
return login(_that);case _RemoveUser():
return removeUser(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _WithTokenEvent value)?  withToken,TResult? Function( _WithRefreshTokenEvent value)?  withRefresh,TResult? Function( _LoginEvent value)?  login,TResult? Function( _RemoveUser value)?  removeUser,}){
final _that = this;
switch (_that) {
case _WithTokenEvent() when withToken != null:
return withToken(_that);case _WithRefreshTokenEvent() when withRefresh != null:
return withRefresh(_that);case _LoginEvent() when login != null:
return login(_that);case _RemoveUser() when removeUser != null:
return removeUser(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( WebSocketChannel channel,  String token)?  withToken,TResult Function( WebSocketChannel channel,  String refreshToken)?  withRefresh,TResult Function( WebSocketChannel channel,  EmailCredentialDto dto)?  login,TResult Function( WebSocketChannel channel)?  removeUser,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WithTokenEvent() when withToken != null:
return withToken(_that.channel,_that.token);case _WithRefreshTokenEvent() when withRefresh != null:
return withRefresh(_that.channel,_that.refreshToken);case _LoginEvent() when login != null:
return login(_that.channel,_that.dto);case _RemoveUser() when removeUser != null:
return removeUser(_that.channel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( WebSocketChannel channel,  String token)  withToken,required TResult Function( WebSocketChannel channel,  String refreshToken)  withRefresh,required TResult Function( WebSocketChannel channel,  EmailCredentialDto dto)  login,required TResult Function( WebSocketChannel channel)  removeUser,}) {final _that = this;
switch (_that) {
case _WithTokenEvent():
return withToken(_that.channel,_that.token);case _WithRefreshTokenEvent():
return withRefresh(_that.channel,_that.refreshToken);case _LoginEvent():
return login(_that.channel,_that.dto);case _RemoveUser():
return removeUser(_that.channel);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( WebSocketChannel channel,  String token)?  withToken,TResult? Function( WebSocketChannel channel,  String refreshToken)?  withRefresh,TResult? Function( WebSocketChannel channel,  EmailCredentialDto dto)?  login,TResult? Function( WebSocketChannel channel)?  removeUser,}) {final _that = this;
switch (_that) {
case _WithTokenEvent() when withToken != null:
return withToken(_that.channel,_that.token);case _WithRefreshTokenEvent() when withRefresh != null:
return withRefresh(_that.channel,_that.refreshToken);case _LoginEvent() when login != null:
return login(_that.channel,_that.dto);case _RemoveUser() when removeUser != null:
return removeUser(_that.channel);case _:
  return null;

}
}

}

/// @nodoc


class _WithTokenEvent extends ActiveUsersEvent implements SequentialActive_UsersEvent {
  const _WithTokenEvent(this.channel, this.token): super._();
  

@override final  WebSocketChannel channel;
 final  String token;

/// Create a copy of ActiveUsersEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WithTokenEventCopyWith<_WithTokenEvent> get copyWith => __$WithTokenEventCopyWithImpl<_WithTokenEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WithTokenEvent&&(identical(other.channel, channel) || other.channel == channel)&&(identical(other.token, token) || other.token == token));
}


@override
int get hashCode => Object.hash(runtimeType,channel,token);

@override
String toString() {
  return 'ActiveUsersEvent.withToken(channel: $channel, token: $token)';
}


}

/// @nodoc
abstract mixin class _$WithTokenEventCopyWith<$Res> implements $ActiveUsersEventCopyWith<$Res> {
  factory _$WithTokenEventCopyWith(_WithTokenEvent value, $Res Function(_WithTokenEvent) _then) = __$WithTokenEventCopyWithImpl;
@override @useResult
$Res call({
 WebSocketChannel channel, String token
});




}
/// @nodoc
class __$WithTokenEventCopyWithImpl<$Res>
    implements _$WithTokenEventCopyWith<$Res> {
  __$WithTokenEventCopyWithImpl(this._self, this._then);

  final _WithTokenEvent _self;
  final $Res Function(_WithTokenEvent) _then;

/// Create a copy of ActiveUsersEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? channel = null,Object? token = null,}) {
  return _then(_WithTokenEvent(
null == channel ? _self.channel : channel // ignore: cast_nullable_to_non_nullable
as WebSocketChannel,null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _WithRefreshTokenEvent extends ActiveUsersEvent implements SequentialActive_UsersEvent {
  const _WithRefreshTokenEvent(this.channel, this.refreshToken): super._();
  

@override final  WebSocketChannel channel;
 final  String refreshToken;

/// Create a copy of ActiveUsersEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WithRefreshTokenEventCopyWith<_WithRefreshTokenEvent> get copyWith => __$WithRefreshTokenEventCopyWithImpl<_WithRefreshTokenEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WithRefreshTokenEvent&&(identical(other.channel, channel) || other.channel == channel)&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken));
}


@override
int get hashCode => Object.hash(runtimeType,channel,refreshToken);

@override
String toString() {
  return 'ActiveUsersEvent.withRefresh(channel: $channel, refreshToken: $refreshToken)';
}


}

/// @nodoc
abstract mixin class _$WithRefreshTokenEventCopyWith<$Res> implements $ActiveUsersEventCopyWith<$Res> {
  factory _$WithRefreshTokenEventCopyWith(_WithRefreshTokenEvent value, $Res Function(_WithRefreshTokenEvent) _then) = __$WithRefreshTokenEventCopyWithImpl;
@override @useResult
$Res call({
 WebSocketChannel channel, String refreshToken
});




}
/// @nodoc
class __$WithRefreshTokenEventCopyWithImpl<$Res>
    implements _$WithRefreshTokenEventCopyWith<$Res> {
  __$WithRefreshTokenEventCopyWithImpl(this._self, this._then);

  final _WithRefreshTokenEvent _self;
  final $Res Function(_WithRefreshTokenEvent) _then;

/// Create a copy of ActiveUsersEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? channel = null,Object? refreshToken = null,}) {
  return _then(_WithRefreshTokenEvent(
null == channel ? _self.channel : channel // ignore: cast_nullable_to_non_nullable
as WebSocketChannel,null == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _LoginEvent extends ActiveUsersEvent implements SequentialActive_UsersEvent {
  const _LoginEvent(this.channel, this.dto): super._();
  

@override final  WebSocketChannel channel;
 final  EmailCredentialDto dto;

/// Create a copy of ActiveUsersEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoginEventCopyWith<_LoginEvent> get copyWith => __$LoginEventCopyWithImpl<_LoginEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoginEvent&&(identical(other.channel, channel) || other.channel == channel)&&(identical(other.dto, dto) || other.dto == dto));
}


@override
int get hashCode => Object.hash(runtimeType,channel,dto);

@override
String toString() {
  return 'ActiveUsersEvent.login(channel: $channel, dto: $dto)';
}


}

/// @nodoc
abstract mixin class _$LoginEventCopyWith<$Res> implements $ActiveUsersEventCopyWith<$Res> {
  factory _$LoginEventCopyWith(_LoginEvent value, $Res Function(_LoginEvent) _then) = __$LoginEventCopyWithImpl;
@override @useResult
$Res call({
 WebSocketChannel channel, EmailCredentialDto dto
});


$EmailCredentialDtoCopyWith<$Res> get dto;

}
/// @nodoc
class __$LoginEventCopyWithImpl<$Res>
    implements _$LoginEventCopyWith<$Res> {
  __$LoginEventCopyWithImpl(this._self, this._then);

  final _LoginEvent _self;
  final $Res Function(_LoginEvent) _then;

/// Create a copy of ActiveUsersEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? channel = null,Object? dto = null,}) {
  return _then(_LoginEvent(
null == channel ? _self.channel : channel // ignore: cast_nullable_to_non_nullable
as WebSocketChannel,null == dto ? _self.dto : dto // ignore: cast_nullable_to_non_nullable
as EmailCredentialDto,
  ));
}

/// Create a copy of ActiveUsersEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EmailCredentialDtoCopyWith<$Res> get dto {
  
  return $EmailCredentialDtoCopyWith<$Res>(_self.dto, (value) {
    return _then(_self.copyWith(dto: value));
  });
}
}

/// @nodoc


class _RemoveUser extends ActiveUsersEvent {
  const _RemoveUser(this.channel): super._();
  

@override final  WebSocketChannel channel;

/// Create a copy of ActiveUsersEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RemoveUserCopyWith<_RemoveUser> get copyWith => __$RemoveUserCopyWithImpl<_RemoveUser>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RemoveUser&&(identical(other.channel, channel) || other.channel == channel));
}


@override
int get hashCode => Object.hash(runtimeType,channel);

@override
String toString() {
  return 'ActiveUsersEvent.removeUser(channel: $channel)';
}


}

/// @nodoc
abstract mixin class _$RemoveUserCopyWith<$Res> implements $ActiveUsersEventCopyWith<$Res> {
  factory _$RemoveUserCopyWith(_RemoveUser value, $Res Function(_RemoveUser) _then) = __$RemoveUserCopyWithImpl;
@override @useResult
$Res call({
 WebSocketChannel channel
});




}
/// @nodoc
class __$RemoveUserCopyWithImpl<$Res>
    implements _$RemoveUserCopyWith<$Res> {
  __$RemoveUserCopyWithImpl(this._self, this._then);

  final _RemoveUser _self;
  final $Res Function(_RemoveUser) _then;

/// Create a copy of ActiveUsersEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? channel = null,}) {
  return _then(_RemoveUser(
null == channel ? _self.channel : channel // ignore: cast_nullable_to_non_nullable
as WebSocketChannel,
  ));
}


}

// dart format on
