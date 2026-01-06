import 'package:flutter/material.dart';

void main() {
  runApp(const NeonXOXApp());
}

class NeonXOXApp extends StatelessWidget {
  const NeonXOXApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Neon XOX Deluxe',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0D0D0D), // Deep "OLED" black
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.cyan,
          brightness: Brightness.dark,
          primary: Colors.cyanAccent,    // Neon Blue
          secondary: Colors.pinkAccent,  // Neon Pink
        ),
        // Neon text style baseline
        textTheme: const TextTheme(
          displayLarge: TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(color: Colors.white70),
        ),
      ),
      home: const Scaffold(
        body: Center(
          child: Text(
            'NEON XOX',
            style: TextStyle(
              fontSize: 48,
              color: Colors.cyanAccent,
              shadows: [
                Shadow(blurRadius: 20, color: Colors.cyanAccent),
              ],
            ),
          ),
        ),
      ),
    );
  }
}