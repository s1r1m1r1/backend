import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const _AppView(_router);
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
