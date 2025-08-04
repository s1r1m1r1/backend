import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/todo/view/bloc/todo_bloc.dart';

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
                      BlocProvider.of<TodoBloc>(
                        context,
                      ).add(UpdateTodoEvent(todo.copyWith(completed: newValue).toUpdateTodo()));
                    },
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      context.read<TodoBloc>().add(DeleteTodoEvent(todo.id));
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
    // Remove the underscore from variable name to follow Dart conventions

    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController todoTitleController = TextEditingController();
        return AlertDialog(
          title: const Text('Add New Todo'),
          content: TextField(
            controller: todoTitleController,
            decoration: const InputDecoration(hintText: 'Todo title'),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                if (todoTitleController.text.isNotEmpty) {
                  final newTodo = CreateTodo(title: todoTitleController.text);
                  BlocProvider.of<TodoBloc>(context).add(AddTodoEvent(newTodo));
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    ); // Dispose controller when dialog is closed
  }
}
