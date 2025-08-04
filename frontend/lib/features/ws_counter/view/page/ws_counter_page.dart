import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../inject/inject.dart';
import '../bloc/counter_bloc.dart'; // Adjust import path as needed

class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Counter App')),
      body: BlocProvider(
        // Provide the CounterBloc here. You'll likely inject CounterRepository
        // via a dependency injection system or pass it from a parent widget.
        lazy: false,
        create: (_) =>
            getIt<CounterBloc>()..add(CounterEvent.started()), // Dispatch CounterStarted when the BLoC is created
        child: const CounterView(),
      ),
    );
  }
}

class CounterView extends StatelessWidget {
  const CounterView({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the CounterBloc instance
    final counterBloc = context.read<CounterBloc>();

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display connection status
            BlocBuilder<CounterBloc, CounterState>(
              buildWhen: (previous, current) => previous.status != current.status,
              builder: (context, state) {
                final color = state.status == CounterStatus.connected ? Colors.green : Colors.red;
                final text = state.status == CounterStatus.connected ? 'Connected' : 'Disconnected';
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
            BlocBuilder<CounterBloc, CounterState>(
              buildWhen: (previous, current) => previous.count != current.count,
              builder: (context, state) {
                return Text('Count: ${state.count}', style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold));
              },
            ),
            const SizedBox(height: 40),
            // Increment and Decrement Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  onPressed: () => counterBloc.add(const CounterEvent.decrementPressed()),
                  heroTag: 'decrement', // Unique tag for hero animation
                  child: const Icon(Icons.remove),
                ),
                FloatingActionButton(
                  onPressed: () => counterBloc.add(const CounterEvent.incrementPressed()),
                  heroTag: 'increment', // Unique tag for hero animation
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
