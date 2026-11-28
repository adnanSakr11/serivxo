import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:servixo/core/const/app_const.dart';
import 'package:servixo/core/di/injection.dart';
import 'package:servixo/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:servixo/features/auth/presentation/cubit/email_verification_cubit.dart';
import 'package:servixo/features/auth/presentation/screens/login_screen.dart';
import 'package:servixo/features/auth/presentation/widgets/auth_button.dart';
import '../../../../core/navigation/post_auth_route.dart';

class EmailVerificationScreen extends StatelessWidget {
  const EmailVerificationScreen({super.key, this.sendOnOpen = false});
  static const String id = 'email_verification';

  final bool sendOnOpen;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = sl<EmailVerificationCubit>()..startAutoPolling();
        sendOnOpen ? cubit.sendVerificationEmail() : cubit.startCooldown();
        return cubit;
      },
      child: const _VerificationView(),
    );
  }
}

class _VerificationView extends StatelessWidget {
  const _VerificationView();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return BlocConsumer<EmailVerificationCubit, EmailVerificationState>(
      listener: (context, state) async {
        if (state is EmailVerificationVerified) {
          final route = await resolvePostVerifiedRoute();
          if (!context.mounted) return;
          Navigator.pushNamedAndRemoveUntil(context, route, (_) => false);
        } else if (state is EmailVerificationError) {
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
        final cubit = context.read<EmailVerificationCubit>();
        final cooldown = state is EmailVerificationCooldown;
        final busy =
            state is EmailVerificationSending ||
            state is EmailVerificationChecking;

        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.mark_email_unread_outlined,
                    size: 80,
                    color: colors.primary,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Verify your email',
                    style: TextStyle(
                      fontFamily: fontFamily,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: colors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'We sent a verification link to your email. Open it, then come back — this page updates automatically.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: fontFamily,
                      fontSize: 16,
                      color: colors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 30),
                  AuthButton(
                    text: "I've verified",
                    isLoading: state is EmailVerificationChecking,
                    onTap: busy ? null : cubit.checkVerification,
                    backgroundColor: colors.primary,
                    textColor: colors.surface,
                  ),
                  const SizedBox(height: 14),
                  TextButton(
                    onPressed: (cooldown || busy)
                        ? null
                        : cubit.sendVerificationEmail,
                    child: Text(
                      cooldown
                          ? 'Resend in ${state.secondsRemaining}s'
                          : 'Resend email',
                      style: TextStyle(fontFamily: fontFamily, fontSize: 16),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      await context.read<AuthCubit>().signOut();
                      if (!context.mounted) return;
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        LoginScreen.id,
                        (_) => false,
                      );
                    },
                    child: Text(
                      'Use a different account',
                      style: TextStyle(
                        fontFamily: fontFamily,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
