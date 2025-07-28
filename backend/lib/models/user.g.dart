// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_User _$UserFromJson(Map<String, dynamic> json) => _User(
  userId: json['userId'] as String,
  email: json['email'] as String,
  createdAt: const DateTimeConverter().fromJson(json['createdAt']),
  password: json['password'] as String? ?? '',
);

Map<String, dynamic> _$UserToJson(_User instance) => <String, dynamic>{
  'userId': instance.userId,
  'email': instance.email,
  'createdAt': const DateTimeConverter().toJson(instance.createdAt),
  'password': instance.password,
};

_UserDto _$UserDtoFromJson(Map<String, dynamic> json) =>
    _UserDto(userId: json['userId'] as String, email: json['email'] as String);

Map<String, dynamic> _$UserDtoToJson(_UserDto instance) => <String, dynamic>{
  'userId': instance.userId,
  'email': instance.email,
};
