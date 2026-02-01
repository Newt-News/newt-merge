import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_config.dart';
import '../providers/game_providers.dart';
import '../widgets/scoreboard.dart';
import '../widgets/creek_grid.dart';
import '../widgets/incubator_button.dart';
import '../widgets/ad_banner_slot.dart';
import '../widgets/game_over_dialog.dart';

/// The main game screen containing all game UI elements.
class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({super.key});

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  bool _dialogShown = false;

  @override
  Widget build(BuildContext context) {
    final boardState = ref.watch(boardProvider);
    final stats = ref.watch(playerStatsProvider);

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
