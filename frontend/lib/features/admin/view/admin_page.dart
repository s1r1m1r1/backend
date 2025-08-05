import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/admin/bloc/admin_bloc.dart';

import '../../../inject/inject.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => getIt<AdminBloc>()..add(const AdminEvent.create()), child: _AdminView());
  }
}

class _AdminView extends StatelessWidget {
  const _AdminView();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: true),
      body: BlocBuilder<AdminBloc, AdminState>(
        builder: (context, state) {
          return Center(child: Text('connect ${state.connectionCount}'));
        },
      ),
    );
  }
}
