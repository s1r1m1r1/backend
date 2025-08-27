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





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActiveUsersEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ActiveUsersEvent()';
}


}





/// @nodoc


class _SetRoomIdEvent extends ActiveUsersEvent {
  const _SetRoomIdEvent(this.roomId): super._();
  

 final  int roomId;




@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SetRoomIdEvent&&(identical(other.roomId, roomId) || other.roomId == roomId));
}


@override
int get hashCode => Object.hash(runtimeType,roomId);

@override
String toString() {
  return 'ActiveUsersEvent.setRoomId(roomId: $roomId)';
}


}




/// @nodoc


class _JoinEvent extends ActiveUsersEvent {
  const _JoinEvent({required this.channel, required this.token}): super._();
  

 final  WebSocketChannel channel;
 final  String token;




@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JoinEvent&&(identical(other.channel, channel) || other.channel == channel)&&(identical(other.token, token) || other.token == token));
}


@override
int get hashCode => Object.hash(runtimeType,channel,token);

@override
String toString() {
  return 'ActiveUsersEvent.join(channel: $channel, token: $token)';
}


}




/// @nodoc


class _RemoveUser extends ActiveUsersEvent {
  const _RemoveUser(this.channel): super._();
  

 final  WebSocketChannel channel;




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




// dart format on
