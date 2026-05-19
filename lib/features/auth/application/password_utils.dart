import 'package:bcrypt/bcrypt.dart';

import '../../../core/api_exceptions.dart';

abstract class PasswordUtils {
  static String hashPassword(String password) {
    try {
      return BCrypt.hashpw(password, BCrypt.gensalt());
    } catch (e) {
      throw const ApiException.internal(message: 'hashing password failed');
    }
  }

  static bool checkPassword({
    required String password,
    required String hashedPassword,
  }) {
    try {
      return BCrypt.checkpw(password, hashedPassword);
    } catch (e) {
      throw const ApiException.internal(message: 'check failed');
    }
  }
}
