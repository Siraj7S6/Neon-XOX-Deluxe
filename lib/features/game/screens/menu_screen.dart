import 'package:flutter/material.dart';
import 'matchmaking_screen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("MAIN MENU", style: TextStyle(fontSize: 40, color: Colors.pinkAccent)),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MatchmakingScreen())),
              child: const Text("PLAY ONLINE"),
            ),
          ],
        ),
      ),
    );
  }
}