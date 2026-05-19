import 'package:dto/dto.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

@freezed
abstract class User with _$User {
  const factory User({
    required UserId userId,
    required String email,
    required Role role,
    required DateTime createdAt,
    @Default(false) bool emailVerified,
    String? confirmationToken,
    @Default('') String password,
  }) = _User;
  const User._();

  UserDto toDto() {
    return UserDto(email: email, role: role, userId: userId.id);
  }
}
