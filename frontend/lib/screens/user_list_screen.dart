// lib/screens/user_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/user/user_bloc.dart';
import 'package:frontend/models/user.dart';

class UserListScreen extends StatelessWidget {
  const UserListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UserLoaded) {
            return ListView.builder(
              itemCount: state.users.length,
              itemBuilder: (context, index) {
                final user = state.users[index];
                return ListTile(
                  title: Text(user.username ?? 'No Username'),
                  subtitle: Text(user.email ?? 'No Email'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      BlocProvider.of<UserBloc>(context).add(DeleteUser(user.id));
                    },
                  ),
                );
              },
            );
          } else if (state is UserError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const Center(child: Text('Unknown state'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implement add user functionality, e.g., show a dialog or navigate to a form
          // For simplicity, adding a dummy user here
          final newUser = User(
            id: UniqueKey().toString(),
            username: 'NewUser${DateTime.now().millisecond}',
            email: 'new@example.com',
          );
          BlocProvider.of<UserBloc>(context).add(AddUser(newUser));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
