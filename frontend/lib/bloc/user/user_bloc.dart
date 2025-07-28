import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/models/user.dart';
import 'package:injectable/injectable.dart';
part 'user_event.dart';
part 'user_state.dart';

@injectable
class UserBloc extends Bloc<UserEvent, UserState> {
  // final ApiService _apiService;

  UserBloc() : super(UserLoading()) {
    on<LoadUsers>(_onLoadUsers);
    on<AddUser>(_onAddUser);
    on<DeleteUser>(_onDeleteUser);
    on<UpdateUser>(_onUpdateUser);
  }

  void _onLoadUsers(LoadUsers event, Emitter<UserState> emit) async {
    try {
      // final users = await _apiService.fetchUsers();
      // emit(UserLoaded(users));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  void _onAddUser(AddUser event, Emitter<UserState> emit) async {
    try {
      // await _apiService.createUser(event.user);
      add(LoadUsers()); // Reload users after adding
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  /// Handles the [DeleteUser] event by attempting to delete a user with the given ID
  /// from the API service. If successful, triggers a reload of the user list.
  /// Emits [UserError] state if an error occurs during the deletion process.

  void _onDeleteUser(DeleteUser event, Emitter<UserState> emit) async {
    try {
      // await _apiService.deleteUser(event.id);
      add(LoadUsers()); // Reload users after deleting
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  void _onUpdateUser(UpdateUser event, Emitter<UserState> emit) async {
    try {
      // await _apiService.updateUser(
      //   event.user.id,
      //   event.user,
      // ); // Assuming updateUser exists in ApiService and takes ID and user object
      add(LoadUsers()); // Reload users after updating
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }
}
