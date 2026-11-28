import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:servixo/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:servixo/features/auth/presentation/screens/login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  static const String id = 'HomeId';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Servixo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await context.read<AuthCubit>().signOut();
              if (!context.mounted) return;
              Navigator.pushNamedAndRemoveUntil(
                  context, LoginScreen.id, (_) => false);
            },
          ),
        ],
      ),
      body: const Center(child: Text('Home')),
    );
  }
}