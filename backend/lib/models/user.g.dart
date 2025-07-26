// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_User _$UserFromJson(Map<String, dynamic> json) => _User(
  userId: json['userId'] as String,
  name: json['name'] as String,
  email: json['email'] as String,
  createdAt: const DateTimeConverter().fromJson(json['createdAt']),
  password: json['password'] as String? ?? '',
);

Map<String, dynamic> _$UserToJson(_User instance) => <String, dynamic>{
  'userId': instance.userId,
  'name': instance.name,
  'email': instance.email,
  'createdAt': const DateTimeConverter().toJson(instance.createdAt),
};
