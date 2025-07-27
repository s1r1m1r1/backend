import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/app/router/routes.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/view/bloc/auth_cubit.dart';

GoRouter buildRouter(BuildContext context) {
  return GoRouter(
    debugLogDiagnostics: true,
    routes: $appRoutes,
    initialLocation: LoginRoute.path,

    /// that works because with ChangeNotifier mixin
    refreshListenable: context.read<AuthCubit>(),
    redirect: (context, state) {
      return null;
      // final authStatus = context.read<AuthCubit>().state;
      // debugPrint(
      //   '\n'
      //   'path: ${state.uri.path}',
      // );
      // if (authStatus == AuthStatus.loggedIn) {
      //   if (state.uri.path == LoginRoute.path) {
      //     return HomeRoute.path;
      //   }
      //   return null;
      // } else {
      //   return LoginRoute.path;
      // }
    },
  );
}
