import 'package:flutter/material.dart';
import 'package:servixo/core/const/app_const.dart';
import 'package:servixo/features/auth/presentation/widgets/auth_button.dart';
import 'package:servixo/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:servixo/features/auth/presentation/widgets/google_signin_button.dart';
import 'package:servixo/features/auth/presentation/widgets/or_divider.dart';

import 'forgot_password_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static String id = 'LoginId';
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _email;
  String? _password;
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Image.asset(craftsPic)),
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
                'Log in Your Account..',
                style: TextStyle(
                  fontFamily: fontFamily,
                  fontSize: 16,
                  color: colors.onSurface,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 10),
              _label('Email', colors),
              const SizedBox(height: 2),
              Form(
                key: _formKey,
                child: AppTextFormField(
                  width: double.infinity,
                  hintText: 'name@example.com',
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color: colors.onSurface,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (v) => _email = v,
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Email is required' : null,
                ),
              ),
              const SizedBox(height: 14),
              _label('Password', colors),
              const SizedBox(height: 2),
              AppTextFormField(
                width: double.infinity,
                hintText: 'Password',
                prefixIcon: Icon(
                  Icons.lock_outline_rounded,
                  color: colors.onSurface,
                ),
                isPassword: true,
                onChanged: (v) => _password = v,
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
              AuthButton(
                text: 'Login',
                backgroundColor: colors.primary,
                textColor: colors.surface,
              ),
              const SizedBox(height: 24),
              OrDivider(),
              const SizedBox(height: 24),
              // GoogleSigninButton(),
            ],
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
        color: colors.onSurface.withOpacity(0.8),
        fontFamily: fontFamily,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
