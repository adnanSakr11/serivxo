import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:servixo/core/const/app_const.dart';
import 'package:servixo/features/auth/domain/entities/app_user.dart';
import 'package:servixo/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:servixo/features/auth/presentation/screens/email_verification_screen.dart';
import 'package:servixo/features/auth/presentation/widgets/auth_button.dart';
import 'package:servixo/features/auth/presentation/widgets/auth_text_field.dart';

const _countryCodes = ['+20', '+966', '+971', '+965', '+962', '+974'];

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  static const String id = 'SignUpId';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  UserRole _role = UserRole.customer;
  String _code = _countryCodes.first;
  bool _agreed = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  String get _normalizedPhone {
    final digits = _phoneCtrl.text.replaceAll(RegExp(r'\D'), '');
    return '$_code${digits.replaceFirst(RegExp(r'^0+'), '')}';
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ));
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    if (!_agreed) {
      _showError('Please accept the Terms of Service and Privacy Policy');
      return;
    }
    context.read<AuthCubit>().signUp(
          email: _emailCtrl.text.trim(),
          password: _passCtrl.text,
          displayName: _nameCtrl.text.trim(),
          phone: _normalizedPhone,
          role: _role,
        );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final gaps = Gaps(context);

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          // The datasource already sent the verification email.
          Navigator.pushNamedAndRemoveUntil(
            context,
            EmailVerificationScreen.id,
            (_) => false,
            arguments: false,
          );
        } else if (state is AuthError) {
          _showError(state.message);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: colors.onSurface),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(appLogo, height: 55, width: 55),
                      const SizedBox(width: 5),
                      Text('Servixo',
                          style: TextStyle(
                            color: colors.onSurface,
                            fontWeight: FontWeight.bold,
                            fontSize: 32,
                            fontFamily: fontFamily,
                          )),
                    ],
                  ),
                  Center(
                    child: Text(
                      'One platform, Every Home Solution',
                      style: TextStyle(
                        fontFamily: fontFamily,
                        color: colors.onSurface.withValues(alpha: 0.7),
                        fontSize: gaps.body,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text('Create An Account',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: fontFamily,
                        fontSize: 24,
                        color: colors.onSurface,
                      )),
                  const SizedBox(height: 14),
                  _RoleToggle(
                    selected: _role,
                    onChanged: (r) => setState(() => _role = r),
                  ),
                  const SizedBox(height: 18),
                  _label('Full Name', colors),
                  AppTextFormField(
                    controller: _nameCtrl,
                    width: double.infinity,
                    hintText: 'Full Name',
                    prefixIcon:
                        Icon(Icons.person_outline, color: colors.onSurface),
                    validator: (v) => (v == null || v.trim().length < 2)
                        ? 'Enter your name'
                        : null,
                  ),
                  const SizedBox(height: 14),
                  _label('Email Address', colors),
                  AppTextFormField(
                    controller: _emailCtrl,
                    width: double.infinity,
                    hintText: 'Email Address',
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon:
                        Icon(Icons.email_outlined, color: colors.onSurface),
                    validator: (v) {
                      final value = v?.trim() ?? '';
                      if (value.isEmpty) return 'Email is required';
                      if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                          .hasMatch(value)) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  _label('Phone Number', colors),
                  AppTextFormField(
                    controller: _phoneCtrl,
                    width: double.infinity,
                    hintText: 'Phone Number',
                    keyboardType: TextInputType.phone,
                    prefixIcon: _CountryCodePicker(
                      value: _code,
                      color: colors.onSurface,
                      onChanged: (c) => setState(() => _code = c),
                    ),
                    validator: (v) {
                      final digits = (v ?? '')
                          .replaceAll(RegExp(r'\D'), '')
                          .replaceFirst(RegExp(r'^0+'), '');
                      if (digits.isEmpty) return 'Phone number is required';
                      if (digits.length < 8 || digits.length > 10) {
                        return 'Enter a valid phone number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  _label('Password', colors),
                  AppTextFormField(
                    controller: _passCtrl,
                    width: double.infinity,
                    hintText: 'Password',
                    isPassword: true,
                    prefixIcon: Icon(Icons.lock_outline_rounded,
                        color: colors.onSurface),
                    validator: (v) => (v == null || v.length < 6)
                        ? 'At least 6 characters'
                        : null,
                  ),
                  const SizedBox(height: 14),
                  _label('Confirm Password', colors),
                  AppTextFormField(
                    controller: _confirmCtrl,
                    width: double.infinity,
                    hintText: 'Confirm Password',
                    isPassword: true,
                    prefixIcon: Icon(Icons.lock_outline_rounded,
                        color: colors.onSurface),
                    validator: (v) =>
                        v != _passCtrl.text ? 'Passwords do not match' : null,
                  ),
                  const SizedBox(height: 14),
                  _TermsRow(
                    value: _agreed,
                    onChanged: (v) => setState(() => _agreed = v),
                  ),
                  const SizedBox(height: 18),
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) => AuthButton(
                      text: 'Sign Up',
                      isLoading: state is AuthLoading,
                      onTap: _submit,
                      backgroundColor: colors.primary,
                      textColor: colors.surface,
                    ),
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
        padding: const EdgeInsets.only(left: 2, bottom: 4),
        child: Text(text,
            style: TextStyle(
              color: colors.onSurface,
              fontFamily: fontFamily,
              fontWeight: FontWeight.bold,
            )),
      );
}

class _RoleToggle extends StatelessWidget {
  const _RoleToggle({required this.selected, required this.onChanged});
  final UserRole selected;
  final ValueChanged<UserRole> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _RoleChip(
            label: 'Customer',
            icon: Icons.person_outline,
            active: selected == UserRole.customer,
            onTap: () => onChanged(UserRole.customer),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _RoleChip(
            label: 'Service Provider',
            icon: Icons.work_outline,
            active: selected == UserRole.provider,
            onTap: () => onChanged(UserRole.provider),
          ),
        ),
      ],
    );
  }
}

class _RoleChip extends StatelessWidget {
  const _RoleChip({
    required this.label,
    required this.icon,
    required this.active,
    required this.onTap,
  });
  final String label;
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final fg = active ? Colors.white : colors.primary;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 48,
        decoration: BoxDecoration(
          color: active ? colors.primary : Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: fg),
            const SizedBox(width: 8),
            Flexible(
              child: Text(label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: fg,
                    fontFamily: fontFamily,
                    fontWeight: FontWeight.w600,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

class _CountryCodePicker extends StatelessWidget {
  const _CountryCodePicker({
    required this.value,
    required this.color,
    required this.onChanged,
  });
  final String value;
  final Color color;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(width: 12),
        Icon(Icons.phone_outlined, color: color),
        const SizedBox(width: 6),
        DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            isDense: true,
            icon: Icon(Icons.keyboard_arrow_down, color: color),
            style: TextStyle(color: color, fontFamily: fontFamily),
            items: _countryCodes
                .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                .toList(),
            onChanged: (c) {
              if (c != null) onChanged(c);
            },
          ),
        ),
        Container(
          width: 1,
          height: 24,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          color: color.withValues(alpha: 0.3),
        ),
      ],
    );
  }
}

class _TermsRow extends StatelessWidget {
  const _TermsRow({required this.value, required this.onChanged});
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final base = TextStyle(
      fontFamily: fontFamily,
      fontSize: 13,
      color: colors.onSurface,
    );
    final link = base.copyWith(
      color: Colors.blue.shade700,
      fontWeight: FontWeight.bold,
      decoration: TextDecoration.underline,
    );
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: (v) => onChanged(v ?? false),
          activeColor: colors.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        Expanded(
          child: Text.rich(
            TextSpan(style: base, children: [
              const TextSpan(text: 'I agree to the '),
              TextSpan(text: 'Terms of Service', style: link),
              const TextSpan(text: ' and '),
              TextSpan(text: 'Privacy Policy.', style: link),
            ]),
          ),
        ),
      ],
    );
  }
}