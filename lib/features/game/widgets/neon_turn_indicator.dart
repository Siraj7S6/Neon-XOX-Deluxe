import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart'; // Correct relative path to your theme

class NeonTurnIndicator extends StatefulWidget {
  final bool isMyTurn;
  const NeonTurnIndicator({super.key, required this.isMyTurn});

  @override
  State<NeonTurnIndicator> createState() => _NeonTurnIndicatorState();
}

class _NeonTurnIndicatorState extends State<NeonTurnIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // This controller drives the "breathing" neon effect
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            // The border glows based on the animation controller
            border: Border.all(
              color: widget.isMyTurn 
                  ? NeonColors.cyan.withOpacity(0.2 + (_controller.value * 0.5)) 
                  : Colors.white10,
              width: 2,
            ),
          ),
          child: Text(
            widget.isMyTurn ? "YOUR TURN" : "OPPONENT'S TURN",
            style: TextStyle(
              color: widget.isMyTurn ? NeonColors.cyan : Colors.white38,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
              shadows: widget.isMyTurn ? [
                Shadow(
                  blurRadius: 10 + (_controller.value * 10),
                  color: NeonColors.cyan,
                ),
              ] : [],
            ),
          ),
        );
      },
    );
  }
}