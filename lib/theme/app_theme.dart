import 'package:flutter/material.dart';
import 'package:finia_app/helper/colors.dart';

class AppTheme {
  static ThemeData theme = ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.blue,
      primaryColor: ColorSys.kPrimary,
      scaffoldBackgroundColor: ColorSys.kBackgroundColor,
      fontFamily: 'NetflixSans',
      textTheme: TextTheme(
        bodyLarge: TextStyle(
            color: ColorSys.kTextColor,
            fontFamily: "NetflixSans",
            fontWeight: FontWeight.bold),
        bodyMedium:
            TextStyle(color: ColorSys.kTextColor, fontFamily: "NetflixSans"),
      ));
}
