import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

GoRouter buildRouter(BuildContext context) {
  return GoRouter(
    debugLogDiagnostics: true,
    routes: $appRoutes,
    initialLocation: SignInRoute.path,

    /// that works because with ChangeNotifier mixin
    // refreshListenable: context.read<AuthCubit>(),
    redirect: (context, state) {
      // final authStatus = context.read<AuthCubit>().state;
      debugPrint(
        '\n'
        'path: ${state.uri.path}',
      );
      // if (authStatus == AuthStatus.loggedIn) {
      //   if (state.uri.path == SignInRoute.path) {
      //     return HomeRoute.path;
      //   }
      //   return null;
      // } else {
      //   return SignInRoute.path;
      // }
    },
  );
}
