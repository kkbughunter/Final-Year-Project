import 'package:flutter/material.dart';

class AppDarkTheme {
  static ThemeData darkTheme = ThemeData(
    primaryColor:  const Color(0xFF180161), // Dark purple
    colorScheme: ColorScheme.fromSwatch(brightness: Brightness.dark).copyWith(
      primary:  const Color(0xFF180161), // Dark purple
      secondary:  const Color(0xFF4F1787), // Dark background
      surface:  const Color(0xFF1E1E1E), // Surface color for cards
      onPrimary: Colors.white, // Text/icons on primary color
      onSecondary: Colors.white, // Text/icons on secondary color
    ),
    textTheme:  const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.white, // White text for titles
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: Colors.grey, // Grey text for body
      ),
    ),
    appBarTheme:  const AppBarTheme(
      backgroundColor: Color(0xFF180161), // AppBar color (dark purple)
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white, // White text for AppBar title
      ),
    ),
    floatingActionButtonTheme:  const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFFEB3678), // Bright pink for FAB
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor:  const Color(0xFFFB773C), // Bright orange for buttons
        foregroundColor: Colors.white, // White button text
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors.white, // Text color for TextButton
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        side: const BorderSide(color: Colors.white), // Border color
      ),
    ),
    iconTheme:  const IconThemeData(
      color: Color(0xFFEB3678), // Bright pink for icons
    ),
    cardColor:  const Color(0xFF1E1E1E), // Card background color
    dividerColor:  const Color(0xFFFB773C), // Divider color (orange)
    scaffoldBackgroundColor:
         const Color(0xFF121212), // Dark background for scaffold
    switchTheme: SwitchThemeData(
      thumbColor:
          WidgetStateProperty.all(const Color(0xFFEB3678)), // Pink switch thumb
      trackColor: WidgetStateProperty.all(const Color(0xFFFB773C)), // Orange track
    ),
  );
}
