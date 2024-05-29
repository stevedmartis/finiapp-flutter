import 'package:flutter/material.dart';
import 'package:finia_app/helper/colors.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    primaryColor: ColorSys.kPrimary,
    scaffoldBackgroundColor: ColorSys.kBackgroundColor,
    fontFamily: 'NetflixSans',
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: ColorSys.kTextColor),
      bodyMedium: TextStyle(color: ColorSys.kTextColor),
    ),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
    primaryColor: ColorSys.kPrimary,
    scaffoldBackgroundColor: ColorSys.kBackgroundColor,
    fontFamily: 'NetflixSans',
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: ColorSys.kTextColor),
      bodyMedium: TextStyle(color: ColorSys.kTextColor),
    ),
  );
}
