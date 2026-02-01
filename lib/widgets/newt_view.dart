import 'package:flutter/material.dart';

import '../domain/domain.dart';

/// Displays a newt based on its evolution stage.
/// Maps each stage to its corresponding visual representation.
class NewtView extends StatelessWidget {
  final Newt newt;
  final double size;

  const NewtView({
    super.key,
    required this.newt,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with actual assets in Phase 6
    // For now, using colored placeholders
    return Center(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: _getStageColor(newt.stage),
          shape: newt.stage == EvolutionStage.egg
              ? BoxShape.circle
              : BoxShape.rectangle,
          borderRadius: newt.stage != EvolutionStage.egg
              ? BorderRadius.circular(size * 0.2)
              : null,
          boxShadow: [
            BoxShadow(
              color: _getStageColor(newt.stage).withValues(alpha: 0.5),
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Center(
          child: Text(
            _getStageEmoji(newt.stage),
            style: TextStyle(fontSize: size * 0.5),
          ),
        ),
      ),
    );
  }

  /// Returns a color representing the evolution stage.
  Color _getStageColor(EvolutionStage stage) {
    return switch (stage) {
      EvolutionStage.egg => const Color(0xFFF5E6D3), // Cream/speckled
      EvolutionStage.larva => const Color(0xFF8B7355), // Brown aquatic
      EvolutionStage.larvaPlus => const Color(0xFF996633), // Brown with legs
      EvolutionStage.eft => const Color(0xFFFF6B35), // Vibrant orange
      EvolutionStage.adult => const Color(0xFFB85C38), // Brownish-red
      EvolutionStage.elder => const Color(0xFF8B4513), // Deep brown with glow
    };
  }

  /// Returns an emoji placeholder for the stage.
  String _getStageEmoji(EvolutionStage stage) {
    return switch (stage) {
      EvolutionStage.egg => '🥚',
      EvolutionStage.larva => '🐛',
      EvolutionStage.larvaPlus => '🦎',
      EvolutionStage.eft => '🔶',
      EvolutionStage.adult => '🦎',
      EvolutionStage.elder => '👑',
    };
  }
}
