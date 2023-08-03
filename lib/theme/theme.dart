import 'package:flutter/material.dart';

class ThemeClass {
  Color lightPrimaryColor = const Color.fromARGB(255, 39, 114, 131);
  Color darkPrimaryColor = const Color.fromARGB(255, 12, 47, 55);
  Color secondaryColor = const Color.fromARGB(255, 80, 71, 20);
  Color accentColor = const Color.fromARGB(255, 162, 144, 41);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    primaryColor: ThemeData.light().scaffoldBackgroundColor,
    colorScheme: const ColorScheme.light().copyWith(
        primary: _themeClass.lightPrimaryColor,
        secondary: _themeClass.secondaryColor),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    primaryColor: ThemeData.dark().scaffoldBackgroundColor,
    colorScheme: const ColorScheme.dark().copyWith(
      primary: _themeClass.darkPrimaryColor,
    ),
  );
}

ThemeClass _themeClass = ThemeClass();
