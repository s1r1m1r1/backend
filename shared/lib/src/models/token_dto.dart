import 'package:json_annotation/json_annotation.dart';

part 'token_dto.g.dart';

@JsonSerializable()
class TokenDto {
  @JsonKey(name: 'token')
  final String accessToken;

  @JsonKey(name: 'refreshToken')
  final String refreshToken;

  TokenDto({required this.accessToken, required this.refreshToken});

  factory TokenDto.fromJson(Map<String, dynamic> json) => _$TokenDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TokenDtoToJson(this);
}

@JsonSerializable()
class RefreshDto {
  @JsonKey(name: 'refreshToken')
  final String refreshToken;

  RefreshDto(this.refreshToken);

  factory RefreshDto.fromJson(Map<String, dynamic> json) => _$RefreshDtoFromJson(json);

  Map<String, dynamic> toJson() => _$RefreshDtoToJson(this);
}
