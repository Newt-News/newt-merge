import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../domain/domain.dart';
import 'animation_providers.dart';
import 'persistence_providers.dart';

/// Notifier for the game board state.
/// Manages the list of newts on the grid and handles game actions.
class BoardNotifier extends StateNotifier<BoardState> {
  final Ref ref;
  final _uuid = const Uuid();
  final _random = Random();

  BoardNotifier(this.ref, {BoardState? initialState})
      : super(initialState ?? BoardState.initial());

  /// Saves the current state to persistence.
  void _saveState() {
    ref.read(persistenceServiceProvider).saveBoardState(state);
  }

  /// Spawns a new egg into a random empty slot.
  /// Returns true if spawn was successful, false if board is full.
  bool spawnNewt() {
    final emptyIndices = <int>[];
    for (int i = 0; i < state.board.length; i++) {
      if (state.board[i] == null) {
        emptyIndices.add(i);
      }
    }

    if (emptyIndices.isEmpty) return false;

    final targetIndex = emptyIndices[_random.nextInt(emptyIndices.length)];
    
    // Determine what stage to spawn based on highest discovered
    final stage = _determineSpawnStage();
    
    final newNewt = Newt(
      uuid: _uuid.v4(),
      stage: stage,
    );

    final newBoard = List<Newt?>.from(state.board);
    newBoard[targetIndex] = newNewt;

    state = state.copyWith(board: newBoard);
    _saveState();
    
    // Trigger spawn animation
    ref.read(animationEventProvider.notifier).triggerSpawn(targetIndex);
    
    // Check for game over after spawn
    _checkGameOver();
    
    return true;
  }

  /// Determines what stage to spawn based on progression.
  EvolutionStage _determineSpawnStage() {
    final stats = ref.read(playerStatsProvider);
    final highest = stats.highestStageDiscovered;
    
    // Base case: always can spawn egg
    if (highest == EvolutionStage.egg) {
      return EvolutionStage.egg;
    }
    
    // 10% chance to spawn larva if discovered
    if (highest.index >= EvolutionStage.larva.index && _random.nextDouble() < 0.1) {
      return EvolutionStage.larva;
    }
    
    // 5% chance to spawn larvaPlus if discovered
    if (highest.index >= EvolutionStage.larvaPlus.index && _random.nextDouble() < 0.05) {
      return EvolutionStage.larvaPlus;
    }
    
    return EvolutionStage.egg;
  }

  /// Moves a newt from source index to target index.
  /// Returns true if move was successful.
  bool moveNewt(int sourceIndex, int targetIndex) {
    if (sourceIndex == targetIndex) return false;
    if (sourceIndex < 0 || sourceIndex >= state.board.length) return false;
    if (targetIndex < 0 || targetIndex >= state.board.length) return false;

    final source = state.board[sourceIndex];
    final target = state.board[targetIndex];

    if (source == null) return false;

    // If target is empty, just move
    if (target == null) {
      final newBoard = List<Newt?>.from(state.board);
      newBoard[targetIndex] = source;
      newBoard[sourceIndex] = null;
      state = state.copyWith(board: newBoard);
      _saveState();
      return true;
    }

    // If target has same stage, try to merge
    if (source.canMergeWith(target)) {
      return _merge(sourceIndex, targetIndex);
    }

    return false;
  }

  /// Merges two newts of the same stage.
  bool _merge(int sourceIndex, int targetIndex) {
    final source = state.board[sourceIndex];
    final target = state.board[targetIndex];

    if (source == null || target == null) return false;
    if (!source.canMergeWith(target)) return false;

    final nextStage = source.stage.next;
    if (nextStage == null) return false; // Should not happen if canMergeWith is correct

    // Create evolved newt
    final evolvedNewt = Newt(
      uuid: _uuid.v4(),
      stage: nextStage,
    );

    // Update board
    final newBoard = List<Newt?>.from(state.board);
    newBoard[targetIndex] = evolvedNewt;
    newBoard[sourceIndex] = null;

    state = state.copyWith(board: newBoard);
    _saveState();

    // Trigger merge animation
    ref.read(animationEventProvider.notifier).triggerMerge(targetIndex, nextStage);

    // Award points and update stats (may trigger discovery)
    ref.read(playerStatsProvider.notifier).onMerge(nextStage);

    return true;
  }

  /// Removes a random newt from the board (second chance).
  bool removeRandomNewt() {
    final occupiedIndices = <int>[];
    for (int i = 0; i < state.board.length; i++) {
      if (state.board[i] != null) {
        occupiedIndices.add(i);
      }
    }

    if (occupiedIndices.isEmpty) return false;

    final targetIndex = occupiedIndices[_random.nextInt(occupiedIndices.length)];
    
    final newBoard = List<Newt?>.from(state.board);
    newBoard[targetIndex] = null;

    state = state.copyWith(
      board: newBoard,
      gameState: GameState.playing,
    );
    _saveState();

    return true;
  }

  /// Resets the board for a new game.
  void resetGame() {
    // Clear saved state
    ref.read(persistenceServiceProvider).clearAll();
    
    ref.read(playerStatsProvider.notifier).reset();
    state = BoardState.initial();
    _saveState();
  }

  /// Expands the board when player levels up.
  void expandBoard(int newSize) {
    if (newSize <= state.board.length) return;
    
    final newBoard = List<Newt?>.from(state.board);
    while (newBoard.length < newSize) {
      newBoard.add(null);
    }
    
    state = state.copyWith(board: newBoard);
    _saveState();
  }

  /// Checks if the game is over (board full, no valid merges).
  void _checkGameOver() {
    // Board not full = not game over
    if (state.board.any((newt) => newt == null)) return;

    // Count newts by stage (excluding elders which can't merge)
    final stageCounts = <EvolutionStage, int>{};
    
    for (final newt in state.board) {
      if (newt == null || newt.stage == EvolutionStage.elder) continue;
      stageCounts[newt.stage] = (stageCounts[newt.stage] ?? 0) + 1;
    }

    // If any stage has 2+ newts, there's a valid merge possible
    for (final count in stageCounts.values) {
      if (count >= 2) return; // Valid merge exists
    }

    // No valid merges found = game over
    state = state.copyWith(gameState: GameState.gameOver);
    _saveState();
  }

}

/// The state of the game board.
class BoardState {
  final List<Newt?> board;
  final GameState gameState;

  const BoardState({
    required this.board,
    required this.gameState,
  });

  factory BoardState.initial() {
    return BoardState(
      board: List<Newt?>.filled(4, null), // Start with 2x2
      gameState: GameState.playing,
    );
  }

  BoardState copyWith({
    List<Newt?>? board,
    GameState? gameState,
  }) {
    return BoardState(
      board: board ?? this.board,
      gameState: gameState ?? this.gameState,
    );
  }

  bool get isBoardFull => !board.any((newt) => newt == null);
  bool get isGameOver => gameState == GameState.gameOver;
}

/// Provider for the board state.
/// Loads from persistence on init.
final boardProvider = StateNotifierProvider<BoardNotifier, BoardState>((ref) {
  // Try to load saved state
  final persistence = ref.watch(persistenceServiceProvider);
  final savedState = persistence.loadBoardState();
  
  return BoardNotifier(ref, initialState: savedState);
});

/// Notifier for player statistics and progression.
class PlayerStatsNotifier extends StateNotifier<PlayerStats> {
  final Ref ref;

  PlayerStatsNotifier(this.ref, {PlayerStats? initialState})
      : super(initialState ?? const PlayerStats());

  /// Saves the current stats to persistence.
  void _saveStats() {
    ref.read(persistenceServiceProvider).savePlayerStats(state);
  }

  /// Called when a merge occurs to award points and update progression.
  void onMerge(EvolutionStage newStage) {
    final points = state.points + newStage.mergePoints;
    
    // Update highest stage if needed
    var highest = state.highestStageDiscovered;
    var isNewDiscovery = false;
    if (newStage.index > highest.index) {
      highest = newStage;
      isNewDiscovery = true;
    }

    var newState = state.copyWith(
      points: points,
      highestStageDiscovered: highest,
    );

    // Check for level up
    while (newState.canLevelUp) {
      newState = newState.copyWith(
        creekLevel: newState.creekLevel + 1,
      );
      
      // Trigger level-up animation
      ref.read(animationEventProvider.notifier).triggerLevelUp();
      
      // Expand the board
      ref.read(boardProvider.notifier).expandBoard(newState.unlockedSlots);
    }

    state = newState;

    // Trigger discovery celebration after state is updated
    if (isNewDiscovery) {
      ref.read(animationEventProvider.notifier).triggerNewDiscovery(newStage);
    }
    
    _saveStats();
  }

  /// Records a second chance use.
  void useSecondChance() {
    state = state.copyWith(
      secondChancesUsed: state.secondChancesUsed + 1,
    );
    _saveStats();
  }

  /// Resets stats for a new game.
  void reset() {
    state = const PlayerStats();
    _saveStats();
  }
}

/// Provider for player stats.
/// Loads from persistence on init.
final playerStatsProvider = StateNotifierProvider<PlayerStatsNotifier, PlayerStats>((ref) {
  // Try to load saved stats
  final persistence = ref.watch(persistenceServiceProvider);
  final savedStats = persistence.loadPlayerStats();
  
  return PlayerStatsNotifier(ref, initialState: savedStats);
});
