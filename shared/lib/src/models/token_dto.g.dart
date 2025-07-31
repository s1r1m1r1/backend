// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TokenDto _$TokenDtoFromJson(Map<String, dynamic> json) => TokenDto(
  accessToken: json['token'] as String,
  refreshToken: json['refreshToken'] as String,
);

Map<String, dynamic> _$TokenDtoToJson(TokenDto instance) => <String, dynamic>{
  'token': instance.accessToken,
  'refreshToken': instance.refreshToken,
};

RefreshDto _$RefreshDtoFromJson(Map<String, dynamic> json) =>
    RefreshDto(json['refreshToken'] as String);

Map<String, dynamic> _$RefreshDtoToJson(RefreshDto instance) =>
    <String, dynamic>{'refreshToken': instance.refreshToken};
