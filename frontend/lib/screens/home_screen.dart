// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:frontend/app/router/routes.dart';
import 'package:frontend/l10n/xx_localization.dart';
import 'package:frontend/features/todo/domain/todo.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    // finla t = l.
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/users');
              },
              child: const Text('View Users'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                TodoListRoute().go(context);
              },
              child: const Text('View Todos'),
            ),
          ],
        ),
      ),
    );
  }
}
