import 'package:flutter/material.dart';
import 'package:servixo/core/const/app_const.dart';

import 'intro_screen2.dart';

class IntroScreen1 extends StatelessWidget {
  const IntroScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Scaffold(
        appBar: AppBar(
          title: Align(
            alignment: AlignmentGeometry.topRight,
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const IntroScreen2()),
                );
              },
              child: Text(
                'Skip',
                style: TextStyle(
                  color: colors.onSurface,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontFamily: fontFamily,
                ),
              ),
            ),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Image.asset(craftsPic)),
            const SizedBox(height: 25),
            Text(
              'All Your Home\nNeeds In One Place',
              style: TextStyle(
                fontFamily: fontFamily,
                fontWeight: FontWeight.w400,
                color: colors.onSurface,
                fontSize: 32,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'From quick repairs to full renovations, Servixo connects you with trusted professionals. Fast and Easy',
              style: TextStyle(
                fontFamily: fontFamily,
                color: colors.onSurface,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
