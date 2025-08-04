// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:frontend/app/router/routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Fixed: Use GoRouter instead of Navigator
                // Navigator.of(context).pushNamed('/users');
                // Since there's no UserListRoute defined, we should create one
                // For now, we'll comment this out
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

            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                WSCounterRoute().go(context);
              },
              child: const Text('View Ws Counter'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                LettersRoute().go(context);
              },
              child: const Text('Letters'),
            ),
          ],
        ),
      ),
    );
  }
}
