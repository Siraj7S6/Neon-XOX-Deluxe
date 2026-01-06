import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/game_provider.dart';
import 'neon_cell.dart';

class NeonBoard extends StatelessWidget {
  const NeonBoard({super.key});

  @override
  Widget build(BuildContext context) {
    // We use context.watch to rebuild the grid whenever a move is made
    final game = context.watch<GameProvider>();

    return AspectRatio(
      aspectRatio: 1, // Keeps the board perfectly square
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.cyanAccent.withOpacity(0.2), width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.cyanAccent.withOpacity(0.05),
              blurRadius: 15,
              spreadRadius: 5,
            )
          ],
        ),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(), // Board shouldn't scroll
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),
          itemCount: 9,
          itemBuilder: (context, index) {
            return NeonCell(
              symbol: game.board[index],
              onTap: () => game.makeMove(index),
            );
          },
        ),
      ),
    );
  }
}