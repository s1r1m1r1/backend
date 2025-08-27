import 'package:backend/core/broadcast_bloc.dart';
import 'package:backend/features/arena/arena_repository.dart';
import 'package:backend/features/arena/battle_room.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sha_red/sha_red.dart';
part 'arena.event.dart';
part 'arena.state.dart';
part 'arena.bloc.freezed.dart';

class ArenaBloc extends BroadcastBloc<ArenaEvent, ArenaState> {
  final ArenaRepository _arenaRepository;

  ArenaBloc(this._arenaRepository) : super(const ArenaState());
}
