// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'login_user_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LoginUserDto {

 String get email; String get password;
/// Create a copy of LoginUserDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoginUserDtoCopyWith<LoginUserDto> get copyWith => _$LoginUserDtoCopyWithImpl<LoginUserDto>(this as LoginUserDto, _$identity);

  /// Serializes this LoginUserDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoginUserDto&&(identical(other.email, email) || other.email == email)&&(identical(other.password, password) || other.password == password));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,email,password);



}

/// @nodoc
abstract mixin class $LoginUserDtoCopyWith<$Res>  {
  factory $LoginUserDtoCopyWith(LoginUserDto value, $Res Function(LoginUserDto) _then) = _$LoginUserDtoCopyWithImpl;
@useResult
$Res call({
 String email, String password
});




}
/// @nodoc
class _$LoginUserDtoCopyWithImpl<$Res>
    implements $LoginUserDtoCopyWith<$Res> {
  _$LoginUserDtoCopyWithImpl(this._self, this._then);

  final LoginUserDto _self;
  final $Res Function(LoginUserDto) _then;

/// Create a copy of LoginUserDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? email = null,Object? password = null,}) {
  return _then(_self.copyWith(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}



/// @nodoc
@JsonSerializable()

class _LoginUserDto extends LoginUserDto {
  const _LoginUserDto({required this.email, required this.password}): super._();
  factory _LoginUserDto.fromJson(Map<String, dynamic> json) => _$LoginUserDtoFromJson(json);

@override final  String email;
@override final  String password;

/// Create a copy of LoginUserDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoginUserDtoCopyWith<_LoginUserDto> get copyWith => __$LoginUserDtoCopyWithImpl<_LoginUserDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LoginUserDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoginUserDto&&(identical(other.email, email) || other.email == email)&&(identical(other.password, password) || other.password == password));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,email,password);



}

/// @nodoc
abstract mixin class _$LoginUserDtoCopyWith<$Res> implements $LoginUserDtoCopyWith<$Res> {
  factory _$LoginUserDtoCopyWith(_LoginUserDto value, $Res Function(_LoginUserDto) _then) = __$LoginUserDtoCopyWithImpl;
@override @useResult
$Res call({
 String email, String password
});




}
/// @nodoc
class __$LoginUserDtoCopyWithImpl<$Res>
    implements _$LoginUserDtoCopyWith<$Res> {
  __$LoginUserDtoCopyWithImpl(this._self, this._then);

  final _LoginUserDto _self;
  final $Res Function(_LoginUserDto) _then;

/// Create a copy of LoginUserDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? email = null,Object? password = null,}) {
  return _then(_LoginUserDto(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
