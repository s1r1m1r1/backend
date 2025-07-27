// lib/screens/signup_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/app/router/routes.dart';
import 'package:frontend/features/auth/view/bloc/signup/signup_bloc.dart';
import 'package:go_router/go_router.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocListener<SignupBloc, SignupState>(
          listener: (context, state) {
            if (state is SignupSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
              // Navigate to login screen after successful signup

              GoRouter.of(context).pushReplacement(LoginRoute.path);
            } else if (state is SignupFailure) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Signup Failed: ${state.error}')));
            }
          },
          child: Column(
            children: [
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              BlocBuilder<SignupBloc, SignupState>(
                builder: (context, state) {
                  if (state is SignupLoading) {
                    return const CircularProgressIndicator();
                  }
                  return ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<SignupBloc>(
                        context,
                      ).add(SignupButtonPressed(email: _emailController.text, password: _passwordController.text));
                    },
                    child: const Text('Sign Up'),
                  );
                },
              ),
              TextButton(
                onPressed: () {
                  GoRouter.of(context).pushReplacement(LoginRoute.path);
                  // Navigator.of(context).pushReplacementNamed('/login');
                },
                child: const Text('Already have an account? Log In'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
