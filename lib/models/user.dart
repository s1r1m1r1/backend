import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sha_red/sha_red.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@Freezed(fromJson: true, toJson: true, equal: false)
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

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  UserDto toDto() {
    return UserDto(email: email, role: role, userId: userId);
  }
}
