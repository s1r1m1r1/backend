import 'package:dto/dto.dart';
import '../../../models/user.dart';

abstract class UserRepository {
  Future<User?> getUser({
    UserId? userId,
    String? email,
    String? confirmationToken,
  });

  Future<User> createUser(EmailCredentialDto createUserDto);
  Future<User> loginUser(EmailCredentialDto loginUserDto);
  Future<User> confirmEmail(String confirmationToken);
  Future<List<User>> getBots();
}
