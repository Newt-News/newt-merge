import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Button to spawn new eggs into the creek.
class IncubatorButton extends ConsumerWidget {
  const IncubatorButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Connect to BoardNotifier in Phase 3
    // Check if board is full to disable button
    const isBoardFull = false;

    final theme = Theme.of(context);

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: isBoardFull
            ? null
            : () {
                // TODO: Call spawnNewt() in Phase 4
                debugPrint('Spawn egg!');
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
