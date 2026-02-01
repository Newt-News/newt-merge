import 'package:flutter/material.dart';

/// Modal dialog shown when the game ends (board full, no valid merges).
class GameOverDialog extends StatelessWidget {
  final int finalScore;
  final int creekLevel;
  final VoidCallback onNewGame;
  final VoidCallback onSecondChance;
  final bool secondChanceAvailable;

  const GameOverDialog({
    super.key,
    required this.finalScore,
    required this.creekLevel,
    required this.onNewGame,
    required this.onSecondChance,
    this.secondChanceAvailable = true,
  });

  /// Shows the game over dialog as a modal.
  static Future<void> show(
    BuildContext context, {
    required int finalScore,
    required int creekLevel,
    required VoidCallback onNewGame,
    required VoidCallback onSecondChance,
    bool secondChanceAvailable = true,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => GameOverDialog(
        finalScore: finalScore,
        creekLevel: creekLevel,
        onNewGame: onNewGame,
        onSecondChance: onSecondChance,
        secondChanceAvailable: secondChanceAvailable,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Game Over Title
            Text(
              'Game Over',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.error,
              ),
            ),
            const SizedBox(height: 24),

            // Stats
            _StatRow(
              label: 'Creek Level',
              value: '$creekLevel',
              icon: Icons.water_drop,
              theme: theme,
            ),
            const SizedBox(height: 12),
            _StatRow(
              label: 'Final Score',
              value: '$finalScore',
              icon: Icons.star,
              theme: theme,
            ),
            const SizedBox(height: 32),

            // Second Chance Button
            if (secondChanceAvailable) ...[
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onSecondChance();
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Second Chance'),
                  style: FilledButton.styleFrom(
                    backgroundColor: theme.colorScheme.secondary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Watch an ad to remove one newt',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
              const SizedBox(height: 16),
            ],

            // New Game Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                  onNewGame();
                },
                icon: const Icon(Icons.play_arrow),
                label: const Text('New Game'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),

            // Future: Leaderboard hook
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                // TODO: Implement leaderboard in future phase
              },
              child: Text(
                'View Leaderboard',
                style: TextStyle(
                  color: theme.colorScheme.outline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final ThemeData theme;

  const _StatRow({
    required this.label,
    required this.value,
    required this.icon,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: theme.colorScheme.primary,
          size: 24,
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
        ),
      ],
    );
  }
}
