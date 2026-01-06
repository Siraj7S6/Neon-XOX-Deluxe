import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../game/screens/menu_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    // Give Firebase a moment to initialize
    await Future.delayed(const Duration(seconds: 2));
    
    // Sign in anonymously if not already signed in
    if (FirebaseAuth.instance.currentUser == null) {
      await FirebaseAuth.instance.signInAnonymously();
    }

    if (mounted) {
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (context) => const MenuScreen())
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("NEON XOX", style: TextStyle(fontSize: 32, color: Colors.cyanAccent, fontWeight: FontWeight.bold)),
      ),
    );
  }
}