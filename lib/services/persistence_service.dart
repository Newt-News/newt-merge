import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/domain.dart';
import '../providers/game_providers.dart';

/// Keys for shared_preferences storage.
class StorageKeys {
  static const String boardState = 'newt_merge_board';
  static const String playerStats = 'newt_merge_stats';
}

/// Service for persisting and loading game state.
class PersistenceService {
  final SharedPreferences _prefs;

  PersistenceService(this._prefs);

  /// Saves the board state to shared_preferences.
  Future<void> saveBoardState(BoardState state) async {
    final boardJson = state.board
        .map((newt) => newt?.toJson())
        .toList();
    
    final data = {
      'board': boardJson,
      'gameState': state.gameState.index,
    };
    
    await _prefs.setString(StorageKeys.boardState, jsonEncode(data));
  }

  /// Loads the board state from shared_preferences.
  BoardState? loadBoardState() {
    final jsonString = _prefs.getString(StorageKeys.boardState);
    if (jsonString == null) return null;

    try {
      final data = jsonDecode(jsonString) as Map<String, dynamic>;
      final boardJson = data['board'] as List<dynamic>;
      
      final board = boardJson.map<Newt?>((json) {
        if (json == null) return null;
        return Newt.fromJson(json as Map<String, dynamic>);
      }).toList();

      final gameState = GameState.values[data['gameState'] as int? ?? 0];

      return BoardState(
        board: board,
        gameState: gameState,
      );
    } catch (e) {
      // If parsing fails, return null to start fresh
      return null;
    }
  }

  /// Saves player stats to shared_preferences.
  Future<void> savePlayerStats(PlayerStats stats) async {
    await _prefs.setString(
      StorageKeys.playerStats, 
      jsonEncode(stats.toJson()),
    );
  }

  /// Loads player stats from shared_preferences.
  PlayerStats? loadPlayerStats() {
    final jsonString = _prefs.getString(StorageKeys.playerStats);
    if (jsonString == null) return null;

    try {
      final data = jsonDecode(jsonString) as Map<String, dynamic>;
      return PlayerStats.fromJson(data);
    } catch (e) {
      return null;
    }
  }

  /// Clears all saved game state.
  Future<void> clearAll() async {
    await _prefs.remove(StorageKeys.boardState);
    await _prefs.remove(StorageKeys.playerStats);
  }
}
