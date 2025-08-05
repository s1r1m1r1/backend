part of 'admin_bloc.dart';

@Freezed(map: FreezedMapOptions.none, when: FreezedWhenOptions.none, copyWith: true)
abstract class AdminState with _$AdminState {
  const AdminState._();
  const factory AdminState({@Default(0) int connectionCount}) = _AdminState;
}
