import 'package:flutter/material.dart';
import 'package:servixo/core/const/app_const.dart';

class IntroScreen1 extends StatelessWidget {
  const IntroScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final gaps = Gaps(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: Center(child: Image.asset(craftsPic))),
        SizedBox(height: gaps.imageToTitle),
        Text(
          'All Your Home\nNeeds In One Place',
          style: TextStyle(
            fontFamily: fontFamily,
            color: colors.onSurface,
            fontSize: gaps.title,
          ),
        ),
        SizedBox(height: gaps.titleToDesc),
        Text(
          'From quick repairs to full renovations, Servixo connects you with trusted professionals. Fast and Easy',
          style: TextStyle(
            fontFamily: fontFamily,
            color: colors.onSurface,
            fontSize: gaps.body,
          ),
        ),
      ],
    );
  }
}