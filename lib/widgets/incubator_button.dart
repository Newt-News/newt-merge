import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/game_providers.dart';

/// Button to spawn new eggs into the creek.
class IncubatorButton extends ConsumerWidget {
  const IncubatorButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boardState = ref.watch(boardProvider);
    final isBoardFull = boardState.isBoardFull;

    final theme = Theme.of(context);

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: isBoardFull
            ? null
            : () {
                ref.read(boardProvider.notifier).spawnNewt();
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          disabledBackgroundColor: theme.colorScheme.surfaceContainerHighest,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
        ),
        icon: const Icon(Icons.egg_outlined, size: 28),
        label: Text(
          isBoardFull ? 'Creek is Full!' : 'Incubate Egg',
          style: theme.textTheme.titleMedium?.copyWith(
            color: isBoardFull ? theme.colorScheme.outline : null,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
