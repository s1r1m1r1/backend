import '../../../core/typedef.dart';

class ResponseTokenDto {
  final String accessToken;
  final String? refreshToken;
  final String email;

  ResponseTokenDto({required this.accessToken, this.refreshToken, required this.email});

  factory ResponseTokenDto.fromJson(Json json) =>
      ResponseTokenDto(accessToken: json['accessToken'], refreshToken: json['refreshToken'], email: json['email']);

  Json toJson() => {'accessToken': accessToken, 'refreshToken': refreshToken, 'email': email};
}
