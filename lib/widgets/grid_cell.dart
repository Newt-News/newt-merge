import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/domain.dart';
import '../providers/game_providers.dart';
import 'newt_view.dart';

/// A single cell in the game grid.
/// Can be locked (dimmed), empty (unlocked but no newt), or occupied (has newt).
/// Supports drag-and-drop for moving and merging newts.
class GridCell extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
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

    // Unlocked slot - wrap with DragTarget
    return DragTarget<int>(
      onWillAcceptWithDetails: (details) {
        // Accept if dragging from a different cell
        return details.data != index;
      },
      onAcceptWithDetails: (details) {
        final sourceIndex = details.data;
        ref.read(boardProvider.notifier).moveNewt(sourceIndex, index);
      },
      builder: (context, candidateData, rejectedData) {
        final isDropTarget = candidateData.isNotEmpty;

        return Container(
          decoration: BoxDecoration(
            color: isDropTarget
                ? theme.colorScheme.primary.withValues(alpha: 0.3)
                : theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDropTarget
                  ? theme.colorScheme.primary
                  : theme.colorScheme.primary.withValues(alpha: 0.3),
              width: isDropTarget ? 3 : 2,
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
              ? _buildDraggableNewt(context, ref)
              : null,
        );
      },
    );
  }

  Widget _buildDraggableNewt(BuildContext context, WidgetRef ref) {
    return Draggable<int>(
      data: index,
      feedback: Material(
        color: Colors.transparent,
        child: Transform.scale(
          scale: 1.1,
          child: NewtView(newt: newt!, size: cellSize * 0.8),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: NewtView(newt: newt!, size: cellSize * 0.8),
      ),
      child: NewtView(newt: newt!, size: cellSize * 0.8),
    );
  }
}
