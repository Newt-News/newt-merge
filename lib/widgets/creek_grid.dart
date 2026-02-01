import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/domain.dart';
import 'grid_cell.dart';

/// The main game grid representing the creek.
/// Displays a dynamic grid that shows both unlocked and locked slots.
class CreekGrid extends ConsumerWidget {
  const CreekGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Connect to BoardNotifier in Phase 3
    // For now, using placeholder values
    const unlockedSlots = 4;
    const gridTier = 4; // 2x2
    const gridDimension = 2;

    // Create grid slots
    final slots = List.generate(gridTier, (index) {
      return GridSlot(
        index: index,
        isUnlocked: index < unlockedSlots,
      );
    });

    // Placeholder board state (all null for now)
    final board = List<Newt?>.filled(unlockedSlots, null);

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
                final newt = slot.isUnlocked && index < board.length
                    ? board[index]
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
