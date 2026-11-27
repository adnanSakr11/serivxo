import 'package:flutter/material.dart';
import 'package:servixo/core/theme/app_theme.dart';
import 'package:servixo/shared/presentation/screens/splash_screen.dart';

void main() {
  runApp(const Servixo());
}

class Servixo extends StatelessWidget {
  const Servixo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: const SplashScreen(),
    );
  }
}
