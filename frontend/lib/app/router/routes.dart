import 'package:flutter/material.dart';
import 'package:frontend/features/auth/view/pages/login_screen.dart';
import 'package:frontend/features/todo/view/page/todo_list_screen.dart';
import 'package:frontend/features/ws_counter/view/page/ws_counter_page.dart';
import 'package:go_router/go_router.dart';

import '../../features/admin/view/admin_page.dart';
import '../../features/auth/view/pages/signup_screen.dart';
import '../../features/letters/view/letters_page.dart';
import '../../features/screens/home_screen.dart';

part 'routes.g.dart';

@TypedGoRoute<HomeRoute>(path: HomeRoute.path)
class HomeRoute extends GoRouteData with _$HomeRoute {
  const HomeRoute();
  static const path = '/home';

  @override
  Widget build(_, _) => const HomeScreen();
}

@TypedGoRoute<LoginRoute>(path: LoginRoute.path)
class LoginRoute extends GoRouteData with _$LoginRoute {
  static const path = '/login';
  const LoginRoute();

  @override
  Widget build(_, _) => LoginScreen();
}

@TypedGoRoute<SignupRoute>(path: SignupRoute.path)
class SignupRoute extends GoRouteData with _$SignupRoute {
  static const path = '/signup';
  const SignupRoute();

  @override
  Widget build(_, _) => SignupScreen();
}

@TypedGoRoute<TodoListRoute>(path: TodoListRoute.path)
class TodoListRoute extends GoRouteData with _$TodoListRoute {
  static const path = '/todo-list';
  const TodoListRoute();

  @override
  Widget build(_, _) => TodoListScreen();
}

@TypedGoRoute<WSCounterRoute>(path: WSCounterRoute.path)
class WSCounterRoute extends GoRouteData with _$WSCounterRoute {
  static const path = '/ws-counter';
  const WSCounterRoute();

  @override
  Widget build(_, _) => CounterPage();
}

@TypedGoRoute<LettersRoute>(path: LettersRoute.path)
class LettersRoute extends GoRouteData with _$LettersRoute {
  static const path = '/letters';
  const LettersRoute();

  @override
  Widget build(_, _) => LettersPage();
}

@TypedGoRoute<AdminRoute>(path: AdminRoute.path)
class AdminRoute extends GoRouteData with _$AdminRoute {
  static const path = '/admin';
  const AdminRoute();

  @override
  Widget build(_, _) => AdminPage();
}
