part of 'arena.bloc.dart';

@freezed
abstract class ArenaState with _$ArenaState implements BroadcastState {
  const ArenaState._();

  const factory ArenaState({@Default([]) List<BattleRoom> rooms}) = _ArenaState;

  @override
  ToClient? toClient() => null;
}
