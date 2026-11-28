import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:servixo/core/const/app_const.dart';
import 'package:servixo/features/auth/domain/entities/app_user.dart';
import 'package:servixo/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:servixo/features/auth/presentation/cubit/google_auth_cubit.dart';
import 'package:servixo/features/auth/presentation/screens/email_verification_screen.dart';
import 'package:servixo/features/auth/presentation/screens/signup_screen.dart';
import 'package:servixo/features/auth/presentation/widgets/auth_button.dart';
import 'package:servixo/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:servixo/features/auth/presentation/widgets/google_signin_button.dart';
import 'package:servixo/features/auth/presentation/widgets/or_divider.dart';
import '../../../../core/navigation/post_auth_route.dart';
import 'forgot_password_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const String id = 'LoginId';
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthCubit>().signIn(
      email: _emailCtrl.text.trim(),
      password: _passCtrl.text,
    );
  }

  Future<void> _onAuthenticated(AppUser user) async {
    if (!user.emailVerified) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        EmailVerificationScreen.id,
        (_) => false,
        arguments: true,
      );
      return;
    }
    final route = await resolvePostVerifiedRoute();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, route, (_) => false);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return MultiBlocListener(
      listeners: [
        BlocListener<AuthCubit, AuthState>(
          listener: (_, state) {
            if (state is AuthSuccess) _onAuthenticated(state.user);
            if (state is AuthError) _showError(state.message);
          },
        ),
        BlocListener<GoogleAuthCubit, GoogleAuthState>(
          listener: (_, state) {
            if (state is GoogleAuthSuccess) _onAuthenticated(state.user);
            if (state is GoogleAuthError &&
                !state.message.toLowerCase().contains('cancelled')) {
              _showError(state.message);
            }
          },
        ),
      ],
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: Image.asset(craftsPic),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Welcome Back',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: fontFamily,
                      fontSize: 24,
                      color: colors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Log in to your account',
                    style: TextStyle(
                      fontFamily: fontFamily,
                      fontSize: 16,
                      color: colors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _label('Email', colors),
                  const SizedBox(height: 2),
                  AppTextFormField(
                    controller: _emailCtrl,
                    width: double.infinity,
                    hintText: 'name@example.com',
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: colors.onSurface,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) {
                      final value = v?.trim() ?? '';
                      if (value.isEmpty) return 'Email is required';
                      if (!RegExp(
                        r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                      ).hasMatch(value)) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  _label('Password', colors),
                  const SizedBox(height: 2),
                  AppTextFormField(
                    controller: _passCtrl,
                    width: double.infinity,
                    hintText: 'Password',
                    prefixIcon: Icon(
                      Icons.lock_outline_rounded,
                      color: colors.onSurface,
                    ),
                    isPassword: true,
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Password is required' : null,
                  ),
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () =>
                          Navigator.pushNamed(context, ForgotPasswordPage.id),
                      child: Text(
                        'Forgot Password ?',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                          fontFamily: fontFamily,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) => AuthButton(
                      text: 'Login',
                      isLoading: state is AuthLoading,
                      onTap: _submit,
                      backgroundColor: colors.primary,
                      textColor: colors.surface,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const OrDivider(),
                  const SizedBox(height: 24),
                  const GoogleSigninButton(),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: TextStyle(
                          fontFamily: fontFamily,
                          color: colors.onSurface,
                        ),
                      ),
                      GestureDetector(
                        onTap: () =>
                            Navigator.pushNamed(context, SignUpScreen.id),
                        child: Text(
                          'Sign up',
                          style: TextStyle(
                            fontFamily: fontFamily,
                            color: colors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text, ColorScheme colors) => Padding(
    padding: const EdgeInsets.only(left: 2),
    child: Text(
      text,
      style: TextStyle(
        color: colors.onSurface.withValues(alpha: 0.8),
        fontFamily: fontFamily,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
