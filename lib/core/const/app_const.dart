import 'package:flutter/material.dart';

const String fontFamily = 'Judson';
const String craftsPic = 'assets/images/crafts.png';
const String appLogo = 'assets/images/servixo logo.png';
const String aiRobot = 'assets/images/Friendly AI Home Assistant Robot 1.png';
const String onBoardingPic3 = 'assets/images/onboarding_pic_3.png';
const String googleIcon = 'assets/images/google.png';

class Gaps {
  final double h;
  Gaps(BuildContext context) : h = MediaQuery.sizeOf(context).height;

  double get header => h * 0.07;
  double get imageToTitle => h * 0.0;
  double get titleToDesc => h * 0.008;
  double get contentToButton => h * 0.04;
  double get buttonToDots => h * 0.025;
  double get dotsToBottom => h * 0.1;
  double get buttonHeight => (h * 0.065).clamp(46.0, 58.0);

  double get title => (h * 0.04).clamp(26.0, 36.0);
  double get body => (h * 0.02).clamp(14.0, 18.0);
}
