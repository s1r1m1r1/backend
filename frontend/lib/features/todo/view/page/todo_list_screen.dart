// lib/screens/todo_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/todo/view/todo/todo_bloc.dart';

import '../../domain/create_todo.dart';

class TodoListScreen extends StatelessWidget {
  const TodoListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todos')),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state is TodoLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TodoLoaded) {
            return ListView.builder(
              itemCount: state.todos.length,
              itemBuilder: (context, index) {
                final todo = state.todos[index];
                return ListTile(
                  title: Text(todo.title),
                  leading: Checkbox(
                    value: todo.completed,
                    onChanged: (bool? newValue) {
                      // BlocProvider.of<TodoBloc>(context).add(UpdateTodo(todo.copyWith(completed: newValue)));
                    },
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      BlocProvider.of<TodoBloc>(context).add(DeleteTodo(todo.id));
                    },
                  ),
                );
              },
            );
          } else if (state is TodoError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const Center(child: Text('Unknown state'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implement add todo functionality
          _showAddTodoDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddTodoDialog(BuildContext context) {
    final TextEditingController _todoTitleController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Todo'),
          content: TextField(
            controller: _todoTitleController,
            decoration: const InputDecoration(hintText: 'Todo title'),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                if (_todoTitleController.text.isNotEmpty) {
                  final newTodo = CreateTodo(title: _todoTitleController.text);
                  BlocProvider.of<TodoBloc>(context).add(AddTodo(newTodo));
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
