import 'package:bcrypt/bcrypt.dart';

class PasswordHasherService {
  const PasswordHasherService();

  String hashPassword(String password) {
    return BCrypt.hashpw(password, BCrypt.gensalt());
  }

  bool checkPassword({required String password, required String hashedPassword}) {
    return BCrypt.checkpw(password, hashedPassword);
  }
}
