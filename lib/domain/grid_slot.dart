/// Represents a slot on the game grid.
/// Slots can be locked (not yet unlocked) or unlocked (can hold newts).
class GridSlot {
  /// The index of this slot on the grid (0-24 for max 5x5).
  final int index;

  /// Whether this slot is unlocked and can hold a newt.
  final bool isUnlocked;

  const GridSlot({
    required this.index,
    required this.isUnlocked,
  });

  GridSlot copyWith({
    int? index,
    bool? isUnlocked,
  }) {
    return GridSlot(
      index: index ?? this.index,
      isUnlocked: isUnlocked ?? this.isUnlocked,
    );
  }

  @override
  String toString() => 'GridSlot(index: $index, unlocked: $isUnlocked)';
}
