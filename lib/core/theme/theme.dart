import 'package:flutter/material.dart';

class NeonColors {
  static const Color background = Color(0xFF0D0D0D);
  static const Color cyan = Colors.cyanAccent;
  static const Color pink = Colors.pinkAccent;
  static const Color gridLine = Color(0xFF333333);
}

// 1. Rename the class to AppTheme to match your main.dart
class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: NeonColors.background,
      primaryColor: NeonColors.cyan,
      
      // 2. Define the ColorScheme for the neon look
      colorScheme: const ColorScheme.dark(
        primary: NeonColors.cyan,
        secondary: NeonColors.pink,
        surface: NeonColors.background,
      ),

      // 3. Add default TextTheme with a glow-friendly white
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white70),
      ),

      // 4. Style the buttons to match the neon aesthetic
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: NeonColors.cyan,
          side: const BorderSide(color: NeonColors.cyan, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}