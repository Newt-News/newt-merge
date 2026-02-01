import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/domain.dart';
import '../providers/game_providers.dart';
import 'grid_cell.dart';

/// The main game grid representing the creek.
/// Displays a dynamic grid that shows both unlocked and locked slots.
class CreekGrid extends ConsumerWidget {
  const CreekGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boardState = ref.watch(boardProvider);
    final stats = ref.watch(playerStatsProvider);
    
    final unlockedSlots = stats.unlockedSlots;
    final gridTier = stats.currentGridTier;
    final gridDimension = stats.gridDimension;

    // Create grid slots
    final slots = List.generate(gridTier, (index) {
      return GridSlot(
        index: index,
        isUnlocked: index < unlockedSlots,
      );
    });

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate cell size to fit the grid
        final availableSize = constraints.maxWidth < constraints.maxHeight
            ? constraints.maxWidth
            : constraints.maxHeight;
        final cellSize = (availableSize - (gridDimension - 1) * 8) / gridDimension;

        return Center(
          child: SizedBox(
            width: availableSize,
            height: availableSize,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: gridDimension,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: gridTier,
              itemBuilder: (context, index) {
                final slot = slots[index];
                final newt = slot.isUnlocked && index < boardState.board.length
                    ? boardState.board[index]
                    : null;

                return GridCell(
                  index: index,
                  slot: slot,
                  newt: newt,
                  cellSize: cellSize,
                );
              },
            ),
          ),
        );
      },
    );
  }
}
