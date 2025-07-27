import '../../../core/typedef.dart';

class RequestEmailCredentialDto {
  final String email;
  final String password;

  const RequestEmailCredentialDto({required this.email, required this.password});

  Json toJson() {
    return {'email': email, 'password': password};
  }
}
