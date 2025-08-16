part of 'letter.bloc.dart';

mixin LetterBlocGuard on _LetterBloc {
  bool hasAccess(Role role) {
    return Role.user == role || Role.admin == role || roomId == 'public';
  }
}
