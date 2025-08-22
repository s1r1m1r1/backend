import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sha_red/sha_red.dart';

part 'user.freezed.dart';

@freezed
abstract class User with _$User {
  const User._();
  const factory User({
    required int userId,
    required String email,
    required Role role,
    required DateTime createdAt,
    @Default(false) bool emailVerified,
    String? confirmationToken,
    @Default('') String password,
  }) = _User;

  UserDto toDto() {
    return UserDto(email: email, role: role, userId: userId);
  }
}
