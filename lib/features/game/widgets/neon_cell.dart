import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';

class NeonCell extends StatelessWidget {
  final String symbol;
  final VoidCallback onTap;

  const NeonCell({
    super.key, 
    required this.symbol, 
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // Keep your existing grid line decoration
        decoration: BoxDecoration(
          border: Border.all(color: NeonColors.gridLine, width: 0.5),
        ),
        child: Center(
          // We use AnimatedScale for the pulse/pop-in effect
          // It automatically animates when 'symbol' changes from "" to "X"/"O"
          child: AnimatedScale(
            scale: symbol == "" ? 0.0 : 1.0,
            duration: const Duration(milliseconds: 400),
            curve: Curves.elasticOut, // Gives it that bouncy "Neon" pop
            child: symbol == "" 
              ? const SizedBox.shrink() 
              : Text(
                  symbol,
                  style: TextStyle(
                    fontSize: 50, // Slightly reduced to ensure it fits during scale animation
                    fontWeight: FontWeight.bold,
                    color: symbol == "X" ? NeonColors.cyan : NeonColors.pink,
                    shadows: [
                      // Inner intense glow
                      Shadow(
                        blurRadius: 20,
                        color: symbol == "X" ? NeonColors.cyan : NeonColors.pink,
                      ),
                      // Outer soft aura glow
                      Shadow(
                        blurRadius: 40,
                        color: symbol == "X" ? NeonColors.cyan : NeonColors.pink,
                      ),
                    ],
                  ),
                ),
          ),
        ),
      ),
    );
  }
}