import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frontend/features/admin/_domain/admin_repository.dart';
import 'package:injectable/injectable.dart';

part 'admin_bloc.freezed.dart';
part 'admin_event.dart';
part 'admin_state.dart';

@injectable
class AdminBloc extends Bloc<AdminEvent, AdminState> {
  final AdminRepository _adminRepository;
  AdminBloc(this._adminRepository) : super(const AdminState()) {
    on<AdminEvent>((event, emitter) async {
      switch (event) {
        case _CreateAdminEvent():
          await _create(event, emitter);
        case _ReadAdminEvent():
          await _read(event, emitter);
        case _UpdateAdminEvent():
          await _update(event, emitter);
        case _DeleteAdminEvent():
          await _delete(event, emitter);
      }
    }, transformer: sequential());
  }

  Future<void> _create(_CreateAdminEvent event, Emitter<AdminState> emitter) async {
    _adminRepository.joinRoom();
    await emitter.onEach<int>(
      _adminRepository.connectionCount,
      onData: (i) => emitter(state.copyWith(connectionCount: i)),
    );
  }

  Future<void> _read(_ReadAdminEvent event, Emitter<AdminState> emitter) async {
    // ...
  }

  Future<void> _update(_UpdateAdminEvent event, Emitter<AdminState> emitter) async {
    // ...
  }

  Future<void> _delete(_DeleteAdminEvent event, Emitter<AdminState> emitter) async {
    // ...
  }
}
