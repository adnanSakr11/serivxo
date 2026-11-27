import 'package:flutter/material.dart';

import '../../../../core/const/app_const.dart';

class IntroScreen3 extends StatelessWidget {
  const IntroScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final gaps = Gaps(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: Center(child: Image.asset(onBoardingPic3))),
        SizedBox(height: gaps.imageToTitle),
        Text(
          'Build Te Home You’ve Always Imagined',
          style: TextStyle(
            fontFamily: fontFamily,
            color: colors.onSurface,
            fontSize: gaps.title,
          ),
        ),
        SizedBox(height: gaps.titleToDesc),
        Text(
          'Describe your issue, and let AI guide you to the right service, the best professionals and the right estimate.',
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
