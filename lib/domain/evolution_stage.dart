/// Evolution stages for newts in the game.
/// Each stage can merge with the same stage to produce the next stage.
enum EvolutionStage {
  egg,
  larva,
  larvaPlus,
  eft,
  adult,
  elder;

  /// Returns the next evolution stage, or null if already at max (elder).
  EvolutionStage? get next {
    final currentIndex = index;
    if (currentIndex >= EvolutionStage.values.length - 1) {
      return null; // Elder cannot evolve further
    }
    return EvolutionStage.values[currentIndex + 1];
  }

  /// Points awarded when merging to create this stage.
  int get mergePoints {
    return switch (this) {
      EvolutionStage.egg => 0, // Eggs are spawned, not merged into
      EvolutionStage.larva => 10,
      EvolutionStage.larvaPlus => 20,
      EvolutionStage.eft => 40,
      EvolutionStage.adult => 80,
      EvolutionStage.elder => 160,
    };
  }

  /// Display name for the stage.
  String get displayName {
    return switch (this) {
      EvolutionStage.egg => 'Egg',
      EvolutionStage.larva => 'Larva',
      EvolutionStage.larvaPlus => 'Larva+',
      EvolutionStage.eft => 'Eft',
      EvolutionStage.adult => 'Adult',
      EvolutionStage.elder => 'Elder',
    };
  }
}
