import 'package:flutter/material.dart';

import '../domain/domain.dart';
import 'newt_view.dart';

/// A single cell in the game grid.
/// Can be locked (dimmed), empty (unlocked but no newt), or occupied (has newt).
class GridCell extends StatelessWidget {
  final int index;
  final GridSlot slot;
  final Newt? newt;
  final double cellSize;

  const GridCell({
    super.key,
    required this.index,
    required this.slot,
    required this.newt,
    required this.cellSize,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Locked slot - dimmed placeholder
    if (!slot.isUnlocked) {
      return Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
            width: 2,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
        ),
        child: Center(
          child: Icon(
            Icons.lock_outline,
            color: theme.colorScheme.outline.withValues(alpha: 0.3),
            size: cellSize * 0.3,
          ),
        ),
      );
    }

    // Unlocked slot (empty or with newt)
    // TODO: Wrap with DragTarget in Phase 3
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: newt != null
          ? NewtView(newt: newt!, size: cellSize * 0.8)
          : null,
    );
  }
}
