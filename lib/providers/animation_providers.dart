import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/domain.dart';

/// Types of animation events that can occur in the game.
enum AnimationEventType {
  spawn,
  merge,
  levelUp,
  newDiscovery,
}

/// An animation event that occurred in the game.
class AnimationEvent {
  final AnimationEventType type;
  final int? cellIndex;
  final EvolutionStage? stage;
  final DateTime timestamp;

  AnimationEvent({
    required this.type,
    this.cellIndex,
    this.stage,
  }) : timestamp = DateTime.now();

  @override
  String toString() => 'AnimationEvent($type, cell: $cellIndex, stage: $stage)';
}

/// Notifier for animation events.
/// UI components listen to this to trigger animations.
class AnimationEventNotifier extends StateNotifier<AnimationEvent?> {
  AnimationEventNotifier() : super(null);

  /// Triggers a spawn animation at the given cell index.
  void triggerSpawn(int cellIndex) {
    state = AnimationEvent(
      type: AnimationEventType.spawn,
      cellIndex: cellIndex,
    );
  }

  /// Triggers a merge animation at the given cell index.
  void triggerMerge(int cellIndex, EvolutionStage newStage) {
    state = AnimationEvent(
      type: AnimationEventType.merge,
      cellIndex: cellIndex,
      stage: newStage,
    );
  }

  /// Triggers a level-up animation.
  void triggerLevelUp() {
    state = AnimationEvent(type: AnimationEventType.levelUp);
  }

  /// Triggers a new discovery celebration.
  void triggerNewDiscovery(EvolutionStage stage) {
    state = AnimationEvent(
      type: AnimationEventType.newDiscovery,
      stage: stage,
    );
  }

  /// Clears the current animation event.
  void clear() {
    state = null;
  }
}

/// Provider for animation events.
final animationEventProvider =
    StateNotifierProvider<AnimationEventNotifier, AnimationEvent?>((ref) {
  return AnimationEventNotifier();
});
