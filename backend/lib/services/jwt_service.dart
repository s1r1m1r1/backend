import 'package:dotenv/dotenv.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class JWTService {
  const JWTService(this._env);

  final DotEnv _env;

  String sign(Map<String, dynamic> payload) {
    final secret = _env['JWT_SECRET']!;
    final jwt = JWT(payload);
    return jwt.sign(SecretKey(secret));
  }

  Map<String, dynamic> verify(String token) {
    final secret = _env['JWT_SECRET']!;
    final jwt = JWT.verify(token, SecretKey(secret));
    return jwt.payload as Map<String, dynamic>;
  }
}
