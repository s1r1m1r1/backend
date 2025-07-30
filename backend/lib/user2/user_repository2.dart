import 'package:backend/session/hash_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// In memory database of users.
@visibleForTesting
Map<String, User2> userDb = {};

class User2 extends Equatable {
  const User2({required this.id, required this.name, required this.username, required this.password});

  final String id;

  final String name;

  final String username;

  /// The user's password, in a hashed form.
  final String password;

  @override
  List<Object?> get props => [id, name, username, password];
}

class UserRepository2 {
  /// Checks in the database for a user with the given [username] and
  /// [password].
  ///
  /// The received password should be in plain text, and will be hashed, so it
  /// can be compared to the stored password hash.
  ///
  Future<User2?> userFromCredentials(String username, String password) async {
    final hashedPassword = password.hashValue;

    final users = userDb.values.where((user) => user.username == username && user.password == hashedPassword);

    if (users.isNotEmpty) {
      return users.first;
    }

    return null;
  }

  /// Searches and return a user by its [id].
  Future<User2?> userFromId(String id) async {
    return userDb[id];
  }

  /// Creates a new user with the given [name], [username] and [password]
  /// (in raw format).
  Future<String> createUser({required String name, required String username, required String password}) {
    final id = username.hashValue;

    final user = User2(id: id, name: name, username: username, password: password.hashValue);

    userDb[id] = user;

    return Future.value(id);
  }

  /// Deletes the user with the given [id].
  Future<void> deleteUser(String id) async {
    userDb.remove(id);
  }

  /// Updates the user with the given [id] with the given [name], [username]
  /// and [password] (in raw format).
  Future<void> updateUser({
    required String id,
    required String? name,
    required String? username,
    required String? password,
  }) async {
    final currentUser = userDb[id];

    if (currentUser == null) {
      return Future.error(Exception('User not found'));
    }

    final user = User2(
      id: id,
      name: name ?? currentUser.name,
      username: username ?? currentUser.username,
      password: password?.hashValue ?? currentUser.password,
    );

    userDb[id] = user;
  }
}
