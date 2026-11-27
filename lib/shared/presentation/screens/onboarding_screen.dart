import 'package:flutter/material.dart';
import 'package:servixo/shared/presentation/screens/home_screen.dart';
import 'package:servixo/shared/presentation/screens/intro_screen1.dart';
import 'package:servixo/shared/presentation/screens/intro_screen2.dart';
import 'package:servixo/shared/presentation/widgets/app_button.dart';
import '../screens/intro_screen3.dart';

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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap() {
    if (_index == _count - 1) {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      children: [
        PageView(
          controller: _controller,
          onPageChanged: (i) => setState(() => _index = i),
          children: _pages,
        ),
        AppButton(
          onTap: _onTap,
          child: Text(_index == _count - 1 ? 'Get started' : 'Next'),
        ),
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
                    : colors.primary.withOpacity(0.4),
              ),
            );
          }),
        ),
      ],
    );
  }
}
