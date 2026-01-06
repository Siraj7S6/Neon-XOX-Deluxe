import 'package:flutter/material.dart';
import '../../multiplayer/services/matchmaking_service.dart';
import 'game_screen.dart';

class MatchmakingScreen extends StatefulWidget {
  const MatchmakingScreen({super.key});

  @override
  State<MatchmakingScreen> createState() => _MatchmakingScreenState();
}

class _MatchmakingScreenState extends State<MatchmakingScreen> {
  @override
  void initState() {
    super.initState();
    _startMatchmaking();
  }

  void _startMatchmaking() {
    MatchmakingService().findMatch((matchId, symbol, opponentUid) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => GameScreen(
              matchId: matchId,
              mySymbol: symbol,
              opponentUid: opponentUid,
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.cyanAccent),
            SizedBox(height: 20),
            Text("SEARCHING FOR OPPONENT...", style: TextStyle(color: Colors.cyanAccent)),
          ],
        ),
      ),
    );
  }
}