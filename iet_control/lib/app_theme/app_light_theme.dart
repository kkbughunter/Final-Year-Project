import 'package:flutter/material.dart';

class AppLightTheme {
  static ThemeData lightTheme = ThemeData(
    primaryColor: Colors.blue[900],
    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: Colors.blue[900],
      secondary: Colors.redAccent, // Secondary color
      background: Colors.grey[200], // Background color
      surface: Colors.white, // Surface color (used in cards, etc.)
    ),
    textTheme:  TextTheme(
      displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
      bodyLarge: TextStyle(fontSize: 16),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue[900],
      ),
    ),
    appBarTheme:  AppBarTheme(
      backgroundColor: Colors.blueAccent,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    floatingActionButtonTheme:  FloatingActionButtonThemeData(
      backgroundColor: Colors.blue,
    ),
  );
}
