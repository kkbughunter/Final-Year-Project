import 'package:flutter/material.dart';

class AppLightTheme {
  static ThemeData lightTheme = ThemeData(
    primaryColor: Colors.blue[900],
    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: Colors.blue[900],
      secondary: Colors.redAccent, // Background color
      surface: Colors.white, // Surface color (used in cards, etc.)
    ),
    textTheme:  const TextTheme(
      displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
      bodyLarge: TextStyle(fontSize: 16),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue[900],
      ),
    ),
    appBarTheme:  const AppBarTheme(
      backgroundColor: Colors.blueAccent,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    floatingActionButtonTheme:  const FloatingActionButtonThemeData(
      backgroundColor: Colors.blue,
    ),
  );
}
