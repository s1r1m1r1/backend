import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared/shared.dart';

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
    @Default('') String password,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

@Freezed(fromJson: true, toJson: true, equal: false)
abstract class UserDto with _$UserDto {
  const UserDto._();
  const factory UserDto({required int userId, required String email}) = _UserDto;

  factory UserDto.fromJson(Map<String, dynamic> json) => _$UserDtoFromJson(json);

  factory UserDto.fromUser(User u) => UserDto(email: u.email, userId: u.userId);
}
