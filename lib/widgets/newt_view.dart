import 'package:flutter/material.dart';

import '../domain/domain.dart';

/// Displays a newt based on its evolution stage with optional animations.
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

/// Animated version of NewtView that plays entrance animations.
class AnimatedNewtView extends StatefulWidget {
  final Newt newt;
  final double size;
  final bool playSpawnAnimation;
  final bool playMergeAnimation;

  const AnimatedNewtView({
    super.key,
    required this.newt,
    required this.size,
    this.playSpawnAnimation = false,
    this.playMergeAnimation = false,
  });

  @override
  State<AnimatedNewtView> createState() => _AnimatedNewtViewState();
}

class _AnimatedNewtViewState extends State<AnimatedNewtView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: widget.playMergeAnimation ? 400 : 300,
      ),
    );

    if (widget.playSpawnAnimation) {
      // Spawn: fade in and scale up
      _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
      );
      _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeIn),
      );
      _controller.forward();
    } else if (widget.playMergeAnimation) {
      // Merge: pop/bounce effect
      _scaleAnimation = TweenSequence<double>([
        TweenSequenceItem(
          tween: Tween<double>(begin: 1.0, end: 1.3),
          weight: 30,
        ),
        TweenSequenceItem(
          tween: Tween<double>(begin: 1.3, end: 0.9),
          weight: 30,
        ),
        TweenSequenceItem(
          tween: Tween<double>(begin: 0.9, end: 1.0),
          weight: 40,
        ),
      ]).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
      );
      _opacityAnimation = const AlwaysStoppedAnimation(1.0);
      _controller.forward();
    } else {
      // No animation
      _scaleAnimation = const AlwaysStoppedAnimation(1.0);
      _opacityAnimation = const AlwaysStoppedAnimation(1.0);
    }
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
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: NewtView(newt: widget.newt, size: widget.size),
          ),
        );
      },
    );
  }
}
