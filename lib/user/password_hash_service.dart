import '../core/new_api_exceptions.dart';
import 'package:bcrypt/bcrypt.dart';

class PasswordHasherService {
  const PasswordHasherService();

  String hashPassword(String password) {
    try {
      return BCrypt.hashpw(password, BCrypt.gensalt());
    } catch (e) {
      throw ApiException.internalServerError(message: 'hashing password failed');
    }
  }

  bool checkPassword({required String password, required String hashedPassword}) {
    try {
      return BCrypt.checkpw(password, hashedPassword);
    } catch (e) {
      throw ApiException.internalServerError(message: 'check failed');
    }
  }
}
