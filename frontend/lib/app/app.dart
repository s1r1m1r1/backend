import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/view/bloc/auth_cubit.dart';
import '../inject/inject.dart';
import '../l10n/app_localizations.dart';
import 'router/build_router.dart';

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'OpenAPI Flutter App',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       initialRoute: '/',
//       routes: {
//         '/': (context) => const HomeScreen(),
//         '/login': (context) => const LoginScreen(),
//         '/signup': (context) => const SignupScreen(),
//         '/users': (context) => const UserListScreen(),
//         '/todos': (context) => const TodoListScreen(),
//       },
//     );
//   }
// }
//   O    IT'S APPLICATION BRO
//  /|\
//  / \

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (_) => getIt<AuthCubit>()..subscribe())],
      child: Builder(
        builder: (context) {
          // buildRouter(context, YOU HAVE TO SEE IT, iT'S IMPORTANT PART
          return _AppView(buildRouter(context));
        },
      ),
    );
  }
}

class _AppView extends StatelessWidget {
  const _AppView(this._router);
  final GoRouter _router;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppLocalizations.delegate, // Your app's localization delegate
        GlobalMaterialLocalizations.delegate, // Material widgets localizations
        GlobalWidgetsLocalizations.delegate, // Basic widgets localizations
        GlobalCupertinoLocalizations.delegate, // Cupertino widgets localizations
      ],
      // Cupertino widgets localizations
      theme: ThemeData(primarySwatch: Colors.blue),
    );
  }
}
