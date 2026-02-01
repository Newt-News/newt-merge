import 'evolution_stage.dart';

/// Represents a single newt on the game board.
class Newt {
  /// The unique identifier for this newt instance.
  final String uuid;

  /// The current evolution stage of this newt.
  final EvolutionStage stage;

  const Newt({
    required this.uuid,
    required this.stage,
  });

  /// Whether this newt can merge with another newt.
  bool canMergeWith(Newt other) {
    // Cannot merge elders
    if (stage == EvolutionStage.elder) return false;
    // Can only merge same stages
    return stage == other.stage;
  }

  /// Creates a copy of this newt with optional overrides.
  Newt copyWith({
    String? uuid,
    EvolutionStage? stage,
  }) {
    return Newt(
      uuid: uuid ?? this.uuid,
      stage: stage ?? this.stage,
    );
  }

  /// Serializes this newt to JSON for persistence.
  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'stage': stage.index,
    };
  }

  /// Deserializes a newt from JSON.
  factory Newt.fromJson(Map<String, dynamic> json) {
    return Newt(
      uuid: json['uuid'] as String,
      stage: EvolutionStage.values[json['stage'] as int],
    );
  }

  @override
  String toString() => 'Newt(uuid: $uuid, stage: ${stage.displayName})';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Newt && other.uuid == uuid && other.stage == stage;
  }

  @override
  int get hashCode => uuid.hashCode ^ stage.hashCode;
}
