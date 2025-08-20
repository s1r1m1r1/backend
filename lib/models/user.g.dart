// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_User _$UserFromJson(Map<String, dynamic> json) => _User(
  userId: (json['userId'] as num).toInt(),
  email: json['email'] as String,
  role: $enumDecode(_$RoleEnumMap, json['role']),
  createdAt: DateTime.parse(json['createdAt'] as String),
  emailVerified: json['emailVerified'] as bool? ?? false,
  confirmationToken: json['confirmationToken'] as String?,
  password: json['password'] as String? ?? '',
);

Map<String, dynamic> _$UserToJson(_User instance) => <String, dynamic>{
  'userId': instance.userId,
  'email': instance.email,
  'role': _$RoleEnumMap[instance.role]!,
  'createdAt': instance.createdAt.toIso8601String(),
  'emailVerified': instance.emailVerified,
  'confirmationToken': instance.confirmationToken,
  'password': instance.password,
};

const _$RoleEnumMap = {
  Role.admin: 'admin',
  Role.user: 'user',
  Role.tester: 'tester',
};
