import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:servixo/core/const/app_const.dart';
import 'package:servixo/features/auth/presentation/screens/login_screen.dart';
import '../cubit/forgot_password_cubit.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_text_field.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});
  static const String id = 'forgot_password';

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  String? _email;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Forgot PassWord"),
        backgroundColor: Colors.white,
      ),
      backgroundColor: colors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 95),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors.primary.withOpacity(0.9),
                  ),
                  child: Icon(
                    Icons.lock_reset,
                    size: 55,
                    color: colors.surface,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Text(
                'Forgot Password',
                style: TextStyle(
                  color: colors.onSurface.withOpacity(0.8),
                  fontSize: 30,
                  fontFamily: fontFamily,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Don\'t worry! It happens. Enter your email address below to receive a password reset link.',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: fontFamily,
                  color: colors.onSurface,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 25),
              Text(
                'Enter your email',
                style: TextStyle(
                  color: colors.onSurface.withOpacity(0.8),
                  fontSize: 18,
                  fontFamily: fontFamily,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 10),
              AppTextFormField(
                width: double.infinity,
                hintText: 'name@example.com',
                prefixIcon: Icon(Icons.email_outlined, color: colors.onSurface),
                onChanged: (v) => _email = v,
                fillColor: colors.surface,
              ),
              const SizedBox(height: 25),
              BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
                listener: (context, state) {
                  if (state is ForgotPasswordSent) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => LoginScreen()),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Sign in with your new password',
                          style: TextStyle(
                            color: colors.onSurface,
                            fontFamily: fontFamily,
                          ),
                        ),
                        backgroundColor: colors.primary,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  } else if (state is ForgotPasswordError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  final isLoading = state is ForgotPasswordLoading;
                  return AuthButton(
                    textColor: colors.surface,
                    text: isLoading ? 'Sending...' : 'Send Reset Link',
                    isLoading: isLoading,
                    onTap: isLoading
                        ? null
                        : () {
                            if (_email == null || _email!.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Enter your email first!'),
                                  backgroundColor: Colors.red,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                              return;
                            }
                            context.read<ForgotPasswordCubit>().sendResetEmail(
                              _email!,
                            );
                          },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
