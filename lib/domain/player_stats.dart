import 'evolution_stage.dart';

/// Persistent player statistics and progression data.
class PlayerStats {
  /// Total accumulated points (never spent, like XP).
  final int points;

  /// Current creek level (determines grid unlocks).
  final int creekLevel;

  /// Highest evolution stage ever discovered.
  final EvolutionStage highestStageDiscovered;

  /// Number of times second chance has been used this game.
  final int secondChancesUsed;

  const PlayerStats({
    this.points = 0,
    this.creekLevel = 1,
    this.highestStageDiscovered = EvolutionStage.egg,
    this.secondChancesUsed = 0,
  });

  /// Returns the number of unlocked slots based on creek level.
  /// Level 1 = 4 slots (2x2)
  /// Each level adds 1 slot up to max 25 (5x5)
  int get unlockedSlots {
    // Level 1 = 4 slots, each level adds 1, max 25
    return (3 + creekLevel).clamp(4, 25);
  }

  /// Returns the current grid tier based on unlocked slots.
  /// Tiers: 4 (2x2), 9 (3x3), 16 (4x4), 25 (5x5)
  int get currentGridTier {
    final slots = unlockedSlots;
    if (slots <= 4) return 4;
    if (slots <= 9) return 9;
    if (slots <= 16) return 16;
    return 25;
  }

  /// Returns the grid dimension for the current tier.
  int get gridDimension {
    return switch (currentGridTier) {
      4 => 2,
      9 => 3,
      16 => 4,
      25 => 5,
      _ => 2,
    };
  }

  /// Points required to reach the next level.
  int get pointsForNextLevel {
    // Exponential scaling: 100, 250, 500, 1000, 2000, ...
    return (100 * (1.5 * creekLevel)).round();
  }

  /// Whether the player can level up with current points.
  bool get canLevelUp => points >= pointsForNextLevel && unlockedSlots < 25;

  PlayerStats copyWith({
    int? points,
    int? creekLevel,
    EvolutionStage? highestStageDiscovered,
    int? secondChancesUsed,
  }) {
    return PlayerStats(
      points: points ?? this.points,
      creekLevel: creekLevel ?? this.creekLevel,
      highestStageDiscovered:
          highestStageDiscovered ?? this.highestStageDiscovered,
      secondChancesUsed: secondChancesUsed ?? this.secondChancesUsed,
    );
  }

  /// Serializes to JSON for persistence.
  Map<String, dynamic> toJson() {
    return {
      'points': points,
      'creekLevel': creekLevel,
      'highestStageDiscovered': highestStageDiscovered.index,
      'secondChancesUsed': secondChancesUsed,
    };
  }

  /// Deserializes from JSON.
  factory PlayerStats.fromJson(Map<String, dynamic> json) {
    return PlayerStats(
      points: json['points'] as int? ?? 0,
      creekLevel: json['creekLevel'] as int? ?? 1,
      highestStageDiscovered: EvolutionStage
          .values[json['highestStageDiscovered'] as int? ?? 0],
      secondChancesUsed: json['secondChancesUsed'] as int? ?? 0,
    );
  }

  @override
  String toString() =>
      'PlayerStats(level: $creekLevel, points: $points, slots: $unlockedSlots)';
}
