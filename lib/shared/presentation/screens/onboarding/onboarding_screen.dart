import 'package:flutter/material.dart';
import 'package:servixo/features/auth/presentation/screens/login_screen.dart';
import 'package:servixo/shared/presentation/screens/onboarding/intro_screen1.dart';
import 'package:servixo/shared/presentation/screens/onboarding/intro_screen2.dart';
import 'package:servixo/shared/presentation/screens/onboarding/intro_screen3.dart';
import 'package:servixo/shared/presentation/widgets/app_button.dart';
import 'package:servixo/core/const/app_const.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final List<Widget> _pages = const [
    IntroScreen1(),
    IntroScreen2(),
    IntroScreen3(),
  ];
  final _controller = PageController();
  int _index = 0;
  int get _count => _pages.length;
  bool get _isLast => _index == _count - 1;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goHome() {
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
  }

  void _next() {
    if (_isLast) {
      _goHome();
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _back() {
    _controller.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final gaps = Gaps(context);
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              SizedBox(
                height: gaps.header,
                child: Row(
                  children: [
                    if (_index > 0)
                      IconButton(
                        onPressed: _back,
                        icon: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: colors.onSurface,
                        ),
                      )
                    else
                      const SizedBox(width: 48),
                    const Spacer(),
                    TextButton(
                      onPressed: _goHome,
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          color: colors.onSurface,
                          fontSize: 16,
                          fontFamily: fontFamily,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: PageView(
                  controller: _controller,
                  onPageChanged: (i) => setState(() => _index = i),
                  children: _pages,
                ),
              ),
              SizedBox(height: gaps.contentToButton),

              AUthButton(
                onTap: _next,
                child: Center(
                  child: Text(
                    _isLast ? 'Get started' : 'Next',
                    style: TextStyle(
                      color: colors.onPrimary,
                      fontSize: 18,
                      fontFamily: fontFamily,
                    ),
                  ),
                ),
              ),
              SizedBox(height: gaps.buttonToDots),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_count, (i) {
                  final active = i == _index;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: active ? 10 : 7,
                    height: active ? 10 : 7,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: active
                          ? colors.primary
                          : colors.primary.withValues(alpha: 0.4),
                    ),
                  );
                }),
              ),
              SizedBox(height: gaps.dotsToBottom),
            ],
          ),
        ),
      ),
    );
  }
}
