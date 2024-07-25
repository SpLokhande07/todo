import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: const Color(0xFF171717), // Deep dark gray
  hintColor: const Color(0xFFE01A4F), // Hotstar's signature red
  textTheme: const TextTheme(
    bodyLarge: TextStyle(
      color: Color(0xFFE0E0E0), // Light gray
    ),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF171717), // Deep dark gray
    iconTheme: IconThemeData(color: Colors.white), // White icons
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: const Color(0xFFE01A4F), // White text on red buttons
    ),
  ),
);

ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
  useMaterial3: true,
);
