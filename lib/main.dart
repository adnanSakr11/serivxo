import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:servixo/core/di/injection.dart';
import 'package:servixo/core/theme/app_theme.dart';
import 'package:servixo/features/auth/presentation/screens/forgot_password_page.dart';
import 'package:servixo/features/auth/presentation/screens/login_screen.dart';
import 'package:servixo/shared/presentation/screens/splash_screen.dart';

import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/auth/presentation/cubit/forgot_password_cubit.dart';
import 'features/auth/presentation/cubit/google_auth_cubit.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initDependencies();
  runApp(const Servixo());
}

class Servixo extends StatelessWidget {
  const Servixo({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<AuthCubit>()),
        BlocProvider(create: (_) => sl<GoogleAuthCubit>()),
        BlocProvider(create: (_) => sl<ForgotPasswordCubit>()),
      ],
      child: MaterialApp(
        routes:{
          LoginScreen.id : (contex)=> const LoginScreen(),
          ForgotPasswordPage.id : (context)=> const ForgotPasswordPage(),
        } ,
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        home: const SplashScreen(),
      ),
    );
  }
}
