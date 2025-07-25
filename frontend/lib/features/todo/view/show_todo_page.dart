import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/di/injectable.dart';
import 'package:frontend/features/todo/view/bloc/show_todo_bloc.dart';

class ShowTodosPage extends StatelessWidget {
  const ShowTodosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => getIt<ShowTodosBloc>(), child: const ShowTodosView());
  }
}

class ShowTodosView extends StatelessWidget {
  const ShowTodosView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShowTodosBloc, ShowTodosState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('Todos')),
          floatingActionButton: FloatingActionButton(onPressed: state.handleTodo, child: const Icon(Icons.add)),
          body: Builder(
            builder: (context) {
              if (model.isBusy) {
                return const Center(child: CircularProgressIndicator());
              }
              if (model.hasError) {
                return Center(child: Text(model.modelError.toString()));
              }
              if (model.todos.isEmpty) {
                return Center(child: Text('No todos found!', style: Theme.of(context).textTheme.titleLarge));
              }
              return RefreshIndicator(
                onRefresh: model.refresh,
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse}),
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: model.todos.length,
                    itemBuilder: (context, index) => TodoListTile(todo: model.todos[index]),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
