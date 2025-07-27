import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/app.dart';
import 'package:frontend/bloc/login/login_bloc.dart';
import 'package:frontend/bloc/signup/signup_bloc.dart';
import 'package:frontend/bloc/todo/todo_bloc.dart';
import 'package:frontend/bloc/user/user_bloc.dart';
import 'package:frontend/services/api_service.dart';

void main() {
  final ApiService apiService = ApiService();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<UserBloc>(create: (context) => UserBloc(apiService)..add(LoadUsers())),
        BlocProvider<LoginBloc>(create: (context) => LoginBloc(apiService)),
        BlocProvider<SignupBloc>(create: (context) => SignupBloc(apiService)),
        BlocProvider<TodoBloc>(create: (context) => TodoBloc(apiService)..add(LoadTodos())),
      ],
      child: const MyApp(),
    ),
  );
}
