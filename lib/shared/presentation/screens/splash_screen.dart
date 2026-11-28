import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:servixo/core/const/app_const.dart';
import 'package:servixo/core/di/injection.dart';
import 'package:servixo/features/auth/presentation/screens/email_verification_screen.dart';
import '../../../core/navigation/post_auth_route.dart';
import 'onboarding/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 800),
  );
  late final Animation<double> _a = CurvedAnimation(
    parent: _c,
    curve: Curves.easeInOut,
  );

  @override
  void initState() {
    super.initState();
    _start();
  }

  Future<void> _start() async {
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    await _c.forward();
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    _navigate();
  }

  Future<void> _navigate() async {
    final user = sl<FirebaseAuth>().currentUser;

    if (user == null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
    } else if (!user.emailVerified) {
      Navigator.of(
        context,
      ).pushReplacementNamed(EmailVerificationScreen.id, arguments: false);
    } else {
      final route = await resolvePostVerifiedRoute();
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(route);
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: Center(
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: AnimatedBuilder(
            animation: _a,
            builder: (context, _) {
              final w = 190 - (190 - 100) * _a.value;
              final h = 153 - (153 - 80) * _a.value;
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(appLogo, width: w, height: h),
                  ClipRect(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      widthFactor: _a.value,
                      child: Opacity(
                        opacity: _a.value,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Servixo',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w500,
                                  color: colors.onSurface,
                                  fontFamily: fontFamily,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'For Home Services.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: colors.onSurface,
                                  fontFamily: fontFamily,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
