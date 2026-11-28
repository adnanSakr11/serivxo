import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:servixo/core/di/injection.dart';
import 'package:servixo/core/theme/app_theme.dart';
import 'package:servixo/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:servixo/features/auth/presentation/cubit/forgot_password_cubit.dart';
import 'package:servixo/features/auth/presentation/cubit/google_auth_cubit.dart';
import 'package:servixo/features/auth/presentation/screens/email_verification_screen.dart';
import 'package:servixo/features/auth/presentation/screens/forgot_password_page.dart';
import 'package:servixo/features/auth/presentation/screens/login_screen.dart';
import 'package:servixo/features/auth/presentation/screens/signup_screen.dart';
import 'package:servixo/shared/presentation/screens/splash_screen.dart';

import 'features/setup/presentation/screens/permissions_screen.dart';
import 'features/setup/presentation/screens/profile_photo_screen.dart';
import 'firebase_options.dart';
import 'features/home/presentation/home_screen.dart';

Future<void> main() async {
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
        BlocProvider<AuthCubit>(create: (_) => sl<AuthCubit>()),
        BlocProvider<GoogleAuthCubit>(create: (_) => sl<GoogleAuthCubit>()),
        BlocProvider<ForgotPasswordCubit>(
            create: (_) => sl<ForgotPasswordCubit>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        home: const SplashScreen(),
        routes: {
          LoginScreen.id: (_) => const LoginScreen(),
          SignUpScreen.id: (_) => const SignUpScreen(),
          ForgotPasswordPage.id: (_) => const ForgotPasswordPage(),
          HomeScreen.id: (_) => const HomeScreen(),
          EmailVerificationScreen.id: (ctx) => EmailVerificationScreen(
                sendOnOpen: ModalRoute.of(ctx)?.settings.arguments == true,
              ),
          PermissionsScreen.id: (_) => const PermissionsScreen(),
          ProfilePhotoScreen.id: (_) => const ProfilePhotoScreen(),
        },
      ),
    );
  }
}