import 'package:freezed_annotation/freezed_annotation.dart';
part 'battle_room.freezed.dart';

@freezed
abstract class BattleRoom with _$BattleRoom {
  const factory BattleRoom({
    required int id,
    @Default([]) List<int> unitIds,
    required DateTime createdAt,
    DateTime? battleStartIn,
    @Default(false) bool isFighting,
  }) = _BattleRoom;
}
