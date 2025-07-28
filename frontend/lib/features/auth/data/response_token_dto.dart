import '../../../core/typedef.dart';

class ResponseTokenDto {
  final String accessToken;
  final String? userId;
  final String? email;

  ResponseTokenDto({required this.accessToken, this.userId, required this.email});

  factory ResponseTokenDto.fromJson(Json json) =>
      ResponseTokenDto(accessToken: json['token'], userId: json['user']['userId'], email: json['user']['email']);
}
