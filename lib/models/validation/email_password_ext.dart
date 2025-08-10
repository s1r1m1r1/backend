import 'package:sha_red/sha_red.dart';

import 'package:backend/core/new_api_exceptions.dart';

extension EmailCredentialDtoExt on EmailCredentialDto {
  bool onCreateValidated() {
    final errors = <String>[];

    if (!RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$",
    ).hasMatch(email)) {
      errors.add('Email is invalid');
    }

    if (!RegExp(r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{6,}$").hasMatch(password)) {
      errors.add(
        'Password must contain at least 6 characters, one uppercase letter, one lowercase letter and one number',
      );
    }

    if (errors.isEmpty) return true;
    throw ApiException.badRequest(errors: errors);
  }

  bool onLoginValidated() {
    final errors = <String>[];
    if (email.isEmpty) {
      errors.add('Email is required');
    }
    if (password.isEmpty) {
      errors.add('Password is required');
    }
    if (errors.isEmpty) return true;
    throw ApiException.badRequest(errors: errors);
  }

  EmailCredentialDto copyWith({String? email, String? password}) {
    return EmailCredentialDto(email: email ?? this.email, password: password ?? this.password);
  }
}
