import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_config.dart';
import '../domain/domain.dart';
import '../providers/animation_providers.dart';
import '../providers/game_providers.dart';
import '../widgets/scoreboard.dart';
import '../widgets/creek_grid.dart';
import '../widgets/incubator_button.dart';
import '../widgets/ad_banner_slot.dart';
import '../widgets/game_over_dialog.dart';
import '../widgets/discovery_celebration.dart';

/// The main game screen containing all game UI elements.
class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({super.key});

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  bool _dialogShown = false;
  bool _celebrationShown = false;

  @override
  Widget build(BuildContext context) {
    final boardState = ref.watch(boardProvider);
    final stats = ref.watch(playerStatsProvider);

    // Listen for animation events
    ref.listen<AnimationEvent?>(animationEventProvider, (previous, next) {
      if (next == null) return;

      switch (next.type) {
        case AnimationEventType.newDiscovery:
          if (next.stage != null && !_celebrationShown) {
            _celebrationShown = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _showDiscoveryCelebration(next.stage!);
            });
          }
          break;
        case AnimationEventType.levelUp:
          // Show a snackbar for level up
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.arrow_upward, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      'Level Up! Creek Level ${stats.creekLevel}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                backgroundColor: Theme.of(context).colorScheme.primary,
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 2),
              ),
            );
          });
          break;
        default:
          // Spawn and merge animations handled in GridCell
          break;
      }
    });

    // Show game over dialog when game ends
    if (boardState.isGameOver && !_dialogShown) {
      _dialogShown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showGameOverDialog(stats.points, stats.creekLevel);
      });
    } else if (!boardState.isGameOver) {
      _dialogShown = false;
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Scoreboard: Creek Level and Points
            const Scoreboard(),

            // The Creek: Main game grid
            const Expanded(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CreekGrid(),
              ),
            ),

            // Incubator button to spawn new eggs
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: IncubatorButton(),
            ),

            // Ad banner slot (only show when ads are enabled)
            if (AppConfig.showAds) const AdBannerSlot(),
          ],
        ),
      ),
    );
  }

  void _showDiscoveryCelebration(EvolutionStage stage) async {
    await DiscoveryCelebration.show(context, stage: stage);
    _celebrationShown = false;
    ref.read(animationEventProvider.notifier).clear();
  }

  void _showGameOverDialog(int finalScore, int creekLevel) {
    GameOverDialog.show(
      context,
      finalScore: finalScore,
      creekLevel: creekLevel,
      secondChanceAvailable: true, // Always available for now (free)
      onSecondChance: () {
        ref.read(playerStatsProvider.notifier).useSecondChance();
        ref.read(boardProvider.notifier).removeRandomNewt();
      },
      onNewGame: () {
        ref.read(boardProvider.notifier).resetGame();
      },
    );
  }
}
