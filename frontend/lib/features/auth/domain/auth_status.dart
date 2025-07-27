enum AuthStatus { loggedIn, loggedOut }

extension AuthStatusExtension on AuthStatus {
  /// Checks if the current authentication status is 'loggedIn'.
  /// Throws an [Exception] if the status is 'loggedOut'.
  ///
  /// This method can be used to enforce that certain operations
  /// are only performed when a user is logged in.
  void ensureLoggedIn() {
    if (this == AuthStatus.loggedOut) {
      throw Exception('User is logged out. Cannot perform this operation.');
    }
    // If the status is loggedIn, do nothing (or return true/void based on need)
    // If you had other states like 'loading', you might also throw an error
    // or handle them differently here.
  }

  /// A simple getter to check if the user is logged in.
  bool get isLoggedIn => this == AuthStatus.loggedIn;
}
