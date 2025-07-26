import 'package:freezed_annotation/freezed_annotation.dart';

import 'serializers/datetime_converter.dart';
part 'user.freezed.dart';
part 'user.g.dart';

@freezed
abstract class User with _$User {
  const User._();
  const factory User({
    required String userId,
    required String name,
    required String email,
    @DateTimeConverter() required DateTime createdAt,
    @Default('') @JsonKey(includeToJson: false) String password,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
