part of 'arena.bloc.dart';

@freezed
abstract class ArenaEvent with _$ArenaEvent {
  const factory ArenaEvent.join() = _JoinEvent;
  const factory ArenaEvent.createBattle() = _CreateBattleEvent;
  const factory ArenaEvent.joinBattle() = _JoinBattleEvent;
  const factory ArenaEvent.leaveBattle() = _LeaveBattleEvent;
}
