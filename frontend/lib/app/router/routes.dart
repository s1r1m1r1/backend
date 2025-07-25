import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'routes.g.dart';

@TypedGoRoute<HomeRoute>(path: HomeRoute.path)
class HomeRoute extends GoRouteData with _$HomeRoute {
  const HomeRoute();
  static const path = '/home';

  @override
  Widget build(context, state) => const HomePage();
}

@TypedGoRoute<SignInRoute>(path: SignInRoute.path)
class SignInRoute extends GoRouteData with _$SignInRoute {
  static const path = '/signin';
  const SignInRoute();

  @override
  Widget build(context, state) => SignInPage();
}
