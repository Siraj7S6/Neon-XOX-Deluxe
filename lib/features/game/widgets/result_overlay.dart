import 'package:flutter/material.dart';
import 'dart:ui'; // Required for the blur effect
import '../../../core/theme/theme.dart';

class ResultOverlay extends StatelessWidget {
  final String result; // Expects: "won", "lost", or "draw"
  final VoidCallback onRestart;

  const ResultOverlay({
    super.key, 
    required this.result, 
    required this.onRestart
  });

  @override
  Widget build(BuildContext context) {
    // 1. Dynamic logic for text and colors based on match result
    String message = result == "draw" ? "STALEMATE" : "YOU ${result.toUpperCase()}!";
    Color neonColor = result == "won" ? NeonColors.cyan : (result == "lost" ? NeonColors.pink : Colors.white);

    return BackdropFilter(
      // 2. Frosty glass effect to keep the board visible but un-interactable
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Container(
        color: Colors.black.withOpacity(0.7),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 3. Neon Pop Animation
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: 1),
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutBack,
              builder: (context, double value, child) {
                return Transform.scale(
                  scale: value,
                  child: Column(
                    children: [
                      Text(
                        message,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.w900,
                          color: neonColor,
                          letterSpacing: 2,
                          shadows: [
                            Shadow(blurRadius: 20, color: neonColor),
                            Shadow(blurRadius: 40, color: neonColor),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: 150,
                        height: 2,
                        decoration: BoxDecoration(
                          color: neonColor,
                          boxShadow: [BoxShadow(color: neonColor, blurRadius: 10)],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 60),

            // 4. RESTART BUTTON
            _buildActionButton(
              context: context,
              label: "REMATCH",
              color: neonColor,
              onPressed: onRestart,
            ),

            const SizedBox(height: 20),

            // 5. EXIT BUTTON
            _buildActionButton(
              context: context,
              label: "MAIN MENU",
              color: Colors.white60,
              onPressed: () {
                // Returns to the first screen (Menu) and clears navigation history
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget to maintain consistent Neon Button styling
  Widget _buildActionButton({
    required BuildContext context,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 220,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          border: Border.all(color: color, width: 2),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(color: color.withOpacity(0.2), blurRadius: 8, spreadRadius: 1),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}