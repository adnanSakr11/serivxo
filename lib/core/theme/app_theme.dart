import 'package:flutter/material.dart';

import '../const/app_const.dart';

ThemeData appTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  fontFamily: fontFamily,
  colorScheme: ColorScheme.light(
    primary: Color(0xff173B56),
    secondary: Color(0xffFCF9F8), 
    surface: Color(0xffFCF9F8), 
    onSurface: Color(0xff093250),
  ),
);
