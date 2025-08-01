import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../inject/inject.dart';
import '../bloc/letters_bloc.dart';

class LettersPage extends StatelessWidget {
  const LettersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Counter App')),
      body: BlocProvider(
        lazy: false,
        create: (_) =>
            getIt<LettersBloc>()..add(const LettersStarted()), // Dispatch CounterStarted when the BLoC is created
        child: const LetterView(),
      ),
    );
  }
}

class LetterView extends StatelessWidget {
  const LetterView({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the CounterBloc instance
    final counterBloc = context.read<LettersBloc>();

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display connection status
            BlocBuilder<LettersBloc, LettersState>(
              buildWhen: (previous, current) => previous.status != current.status,
              builder: (context, state) {
                final color = state.status == LettersStatus.connected ? Colors.green : Colors.red;
                final text = state.status == LettersStatus.connected ? 'Connected' : 'Disconnected';
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.circle, color: color, size: 16.0),
                    const SizedBox(width: 8.0),
                    Text('Status: $text', style: const TextStyle(fontSize: 18)),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
            // Display the current count
            BlocBuilder<LettersBloc, LettersState>(
              builder: (context, state) {
                return Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      final letter = state.letters[index];
                      return ListTile(
                        title: Text(letter.content),
                        subtitle: Text('From: ${letter.senderId}'),
                        trailing: (letter.id != null)
                            ? IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => counterBloc.add(LettersDeleteMessagePressed(letter.id!)),
                              )
                            : null,
                      );
                    },
                    itemCount: state.letters.length,
                  ),
                );
              },
            ),
            const SizedBox(height: 40),
            // Increment and Decrement Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  onPressed: () => counterBloc.add(
                    LettersNewPressed('New Letter ${context.read<LettersBloc>().state.letters.length + 1}'),
                  ),
                  heroTag: 'new letter', // Unique tag for hero animation
                  child: const Icon(Icons.new_label),
                ),
                // FloatingActionButton(
                //   onPressed: () => counterBloc.add(
                //     LettersCorrectLetterPressed(
                //       'Updated Letter ${context.read<LettersBloc>().state.letters.length + 1}',
                //     ),
                //   ),
                //   heroTag: 'update', // Unique tag for hero animation
                //   child: const Icon(Icons.add),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
