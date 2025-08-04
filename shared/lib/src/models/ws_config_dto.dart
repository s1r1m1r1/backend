import 'package:json_annotation/json_annotation.dart';

import '../enum/role.dart';

part 'ws_config_dto.g.dart';

@JsonSerializable()
class WsConfigDto {
  final String name;
  // enum string Role
  final Role role;
  final String lettersRoom;
  final String counterRoom;
  final int version;
  WsConfigDto({
    required this.name,
    required this.role,
    required this.lettersRoom,
    required this.counterRoom,
    required this.version,
  });

  factory WsConfigDto.fromJson(Map<String, dynamic> json) => _$WsConfigDtoFromJson(json);
  Map<String, dynamic> toJson() => _$WsConfigDtoToJson(this);
}
