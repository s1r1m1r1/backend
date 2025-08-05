part of 'admin_bloc.dart';

@Freezed(map: FreezedMapOptions.none, when: FreezedWhenOptions.none, copyWith: true)
sealed class AdminEvent with _$AdminEvent {
  const AdminEvent._();

  const factory AdminEvent.create() = _CreateAdminEvent;

  const factory AdminEvent.read() = _ReadAdminEvent;

  const factory AdminEvent.update() = _UpdateAdminEvent;

  const factory AdminEvent.delete() = _DeleteAdminEvent;
}
