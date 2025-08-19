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


class _JoinEvent extends ActiveUsersEvent {
  const _JoinEvent({required this.channel, required this.token, required this.isRefresh}): super._();
  

@override final  WebSocketChannel channel;
 final  String token;
 final  bool isRefresh;




@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JoinEvent&&(identical(other.channel, channel) || other.channel == channel)&&(identical(other.token, token) || other.token == token)&&(identical(other.isRefresh, isRefresh) || other.isRefresh == isRefresh));
}


@override
int get hashCode => Object.hash(runtimeType,channel,token,isRefresh);

@override
String toString() {
  return 'ActiveUsersEvent.join(channel: $channel, token: $token, isRefresh: $isRefresh)';
}


}




/// @nodoc


class _RemoveUser extends ActiveUsersEvent {
  const _RemoveUser(this.channel): super._();
  

@override final  WebSocketChannel channel;




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
