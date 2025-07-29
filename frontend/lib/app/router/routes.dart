import 'package:flutter/material.dart';
import 'package:frontend/features/auth/view/pages/login_screen.dart';
import 'package:frontend/features/todo/view/page/todo_list_screen.dart';
import 'package:frontend/features/ws_counter/view/page/ws_counter_page.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/view/pages/signup_screen.dart';
import '../../screens/home_screen.dart';

part 'routes.g.dart';

@TypedGoRoute<HomeRoute>(path: HomeRoute.path)
class HomeRoute extends GoRouteData with _$HomeRoute {
  const HomeRoute();
  static const path = '/home';

  @override
  Widget build(context, state) => const HomeScreen();
}

@TypedGoRoute<LoginRoute>(path: LoginRoute.path)
class LoginRoute extends GoRouteData with _$LoginRoute {
  static const path = '/login';
  const LoginRoute();

  @override
  Widget build(context, state) => LoginScreen();
}

@TypedGoRoute<SignupRoute>(path: SignupRoute.path)
class SignupRoute extends GoRouteData with _$SignupRoute {
  static const path = '/signup';
  const SignupRoute();

  @override
  Widget build(context, state) => SignupScreen();
}

@TypedGoRoute<TodoListRoute>(path: TodoListRoute.path)
class TodoListRoute extends GoRouteData with _$TodoListRoute {
  static const path = '/todo-list';
  const TodoListRoute();

  @override
  Widget build(context, state) => TodoListScreen();
}

@TypedGoRoute<WSCounterRoute>(path: WSCounterRoute.path)
class WSCounterRoute extends GoRouteData with _$WSCounterRoute {
  static const path = '/ws-counter';
  const WSCounterRoute();

  @override
  Widget build(context, state) => CounterPage();
}
