import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/round.dart';
import '../models/round_challenge.dart';
import '../models/score_event.dart';

/// Custom exception for storage errors
class StorageException implements Exception {
  final String message;

  StorageException(this.message);

  @override
  String toString() => message;
}

/// Service for managing persistent storage using SharedPreferences
/// Uses a consistent key-value pattern for all data types
class StorageService {
  static late SharedPreferences _prefs;

  // Storage key prefixes
  static const String _roundPrefix = 'round_';
  static const String _challengePrefix = 'challenge_';
  static const String _scoreEventPrefix = 'scoreEvent_';
  
  // Index keys for efficient retrieval
  static const String _roundsIndexKey = 'rounds_index';
  static const String _challengesIndexKey = 'challenges_index';
  static const String _scoreEventsIndexKey = 'scoreEvents_index';

  /// Initialize SharedPreferences
  /// Must be called before any other storage operations
  static Future<void> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
    } catch (e) {
      throw StorageException('Failed to initialize SharedPreferences: $e');
    }
  }

  // ===== HELPER METHODS =====

  /// Get the next available key for a given prefix
  static String _generateKey(String prefix) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = DateTime.now().microsecond;
    return '$prefix${timestamp}_$random';
  }

  /// Add an ID to the index for efficient retrieval
  static Future<void> _addToIndex(String indexKey, String id) async {
    try {
      final indexJson = _prefs.getString(indexKey) ?? '[]';
      final List<dynamic> index = jsonDecode(indexJson);
      if (!index.contains(id)) {
        index.add(id);
        await _prefs.setString(indexKey, jsonEncode(index));
      }
    } catch (e) {
      throw StorageException('Failed to update index: $e');
    }
  }

  /// Remove an ID from the index
  static Future<void> _removeFromIndex(String indexKey, String id) async {
    try {
      final indexJson = _prefs.getString(indexKey) ?? '[]';
      final List<dynamic> index = jsonDecode(indexJson);
      index.removeWhere((item) => item == id);
      await _prefs.setString(indexKey, jsonEncode(index));
    } catch (e) {
      throw StorageException('Failed to update index: $e');
    }
  }

  /// Get all IDs from an index
  static List<String> _getIndex(String indexKey) {
    try {
      final indexJson = _prefs.getString(indexKey) ?? '[]';
      final List<dynamic> index = jsonDecode(indexJson);
      return index.cast<String>();
    } catch (e) {
      throw StorageException('Failed to read index: $e');
    }
  }

  /// Safely parse JSON with error handling
  static T _parseJson<T>(String json, T Function(Map<String, dynamic>) fromJson) {
    try {
      final decoded = jsonDecode(json);
      if (decoded is! Map<String, dynamic>) {
        throw StorageException('Invalid data format');
      }
      return fromJson(decoded);
    } catch (e) {
      throw StorageException('Failed to parse JSON: $e');
    }
  }

  // ===== ROUNDS =====

  /// Save a round to persistent storage
  /// Returns the round ID
  static Future<String> saveRound(Round round) async {
    try {
      final key = '$_roundPrefix${round.id}';
      final jsonString = jsonEncode(round.toJson());
      
      await _prefs.setString(key, jsonString);
      await _addToIndex(_roundsIndexKey, round.id);
      
      return round.id;
    } catch (e) {
      throw StorageException('Failed to save round: $e');
    }
  }

  /// Get a round by ID
  /// Returns null if not found
  static Future<Round?> getRound(String roundId) async {
    try {
      final key = '$_roundPrefix$roundId';
      final jsonStr = _prefs.getString(key);
      
      if (jsonStr == null) return null;
      
      return _parseJson(jsonStr, (json) => Round.fromJson(json));
    } catch (e) {
      throw StorageException('Failed to get round: $e');
    }
  }

  /// Get all rounds as a map
  static Future<Map<String, Round>> getRounds() async {
    try {
      final roundIds = _getIndex(_roundsIndexKey);
      final roundMap = <String, Round>{};

      for (final id in roundIds) {
        final round = await getRound(id);
        if (round != null) {
          roundMap[id] = round;
        }
      }
      
      return roundMap;
    } catch (e) {
      throw StorageException('Failed to get rounds: $e');
    }
  }

  /// Get all rounds for a specific user
  static Future<List<Round>> getUserRounds(String userId) async {
    try {
      final rounds = await getRounds();
      return rounds.values
          .where((round) => round.ownerId == userId)
          .toList();
    } catch (e) {
      throw StorageException('Failed to get user rounds: $e');
    }
  }

  /// Delete a round by ID
  static Future<void> deleteRound(String roundId) async {
    try {
      final key = '$_roundPrefix$roundId';
      await _prefs.remove(key);
      await _removeFromIndex(_roundsIndexKey, roundId);
      
      // Also delete associated challenges and score events
      await _deleteChallengesByRound(roundId);
      await _deleteScoreEventsByRound(roundId);
    } catch (e) {
      throw StorageException('Failed to delete round: $e');
    }
  }

  // ===== CHALLENGES =====

  /// Save a challenge to persistent storage
  static Future<void> saveChallenge(RoundChallenge challenge) async {
    try {
      final key = '$_challengePrefix${challenge.id}';
      final jsonString = jsonEncode(challenge.toJson());
      
      await _prefs.setString(key, jsonString);
      await _addToIndex(_challengesIndexKey, challenge.id);
    } catch (e) {
      throw StorageException('Failed to save challenge: $e');
    }
  }

  /// Get a challenge by ID
  /// Returns null if not found
  static Future<RoundChallenge?> getChallenge(String challengeId) async {
    try {
      final key = '$_challengePrefix$challengeId';
      final jsonStr = _prefs.getString(key);
      
      if (jsonStr == null) return null;
      
      return _parseJson(jsonStr, (json) => RoundChallenge.fromJson(json));
    } catch (e) {
      throw StorageException('Failed to get challenge: $e');
    }
  }

  /// Get all challenges for a specific round
  static Future<List<RoundChallenge>> getChallengesByRound(String roundId) async {
    try {
      final challengeIds = _getIndex(_challengesIndexKey);
      final challenges = <RoundChallenge>[];

      for (final id in challengeIds) {
        final challenge = await getChallenge(id);
        if (challenge != null && challenge.roundId == roundId) {
          challenges.add(challenge);
        }
      }
      
      // Sort by hole index for consistent ordering
      challenges.sort((a, b) => a.index.compareTo(b.index));
      return challenges;
    } catch (e) {
      throw StorageException('Failed to get challenges: $e');
    }
  }

  /// Delete a challenge by ID
  static Future<void> deleteChallenge(String challengeId) async {
    try {
      final key = '$_challengePrefix$challengeId';
      await _prefs.remove(key);
      await _removeFromIndex(_challengesIndexKey, challengeId);
    } catch (e) {
      throw StorageException('Failed to delete challenge: $e');
    }
  }

  /// Delete all challenges for a round (internal use)
  static Future<void> _deleteChallengesByRound(String roundId) async {
    try {
      final challenges = await getChallengesByRound(roundId);
      for (final challenge in challenges) {
        await deleteChallenge(challenge.id);
      }
    } catch (e) {
      throw StorageException('Failed to delete challenges for round: $e');
    }
  }

  // ===== SCORE EVENTS =====

  /// Save a score event to persistent storage
  static Future<void> saveScoreEvent(ScoreEvent event) async {
    try {
      final key = '$_scoreEventPrefix${event.id}';
      final jsonString = jsonEncode(event.toJson());
      
      await _prefs.setString(key, jsonString);
      await _addToIndex(_scoreEventsIndexKey, event.id);
    } catch (e) {
      throw StorageException('Failed to save score event: $e');
    }
  }

  /// Get a score event by ID
  /// Returns null if not found
  static Future<ScoreEvent?> getScoreEvent(String eventId) async {
    try {
      final key = '$_scoreEventPrefix$eventId';
      final jsonStr = _prefs.getString(key);
      
      if (jsonStr == null) return null;
      
      return _parseJson(jsonStr, (json) => ScoreEvent.fromJson(json));
    } catch (e) {
      throw StorageException('Failed to get score event: $e');
    }
  }

  /// Get all score events for a specific round
  static Future<List<ScoreEvent>> getScoreEventsByRound(String roundId) async {
    try {
      final eventIds = _getIndex(_scoreEventsIndexKey);
      final events = <ScoreEvent>[];

      for (final id in eventIds) {
        final event = await getScoreEvent(id);
        if (event != null && event.roundId == roundId) {
          events.add(event);
        }
      }
      
      return events;
    } catch (e) {
      throw StorageException('Failed to get score events: $e');
    }
  }

  /// Get all score events for a specific challenge
  static Future<List<ScoreEvent>> getScoreEventsByChallenge(String challengeId) async {
    try {
      final eventIds = _getIndex(_scoreEventsIndexKey);
      final events = <ScoreEvent>[];

      for (final id in eventIds) {
        final event = await getScoreEvent(id);
        if (event != null && event.roundChallengeId == challengeId) {
          events.add(event);
        }
      }
      
      return events;
    } catch (e) {
      throw StorageException('Failed to get score events for challenge: $e');
    }
  }

  /// Delete a score event by ID
  static Future<void> deleteScoreEvent(String eventId) async {
    try {
      final key = '$_scoreEventPrefix$eventId';
      await _prefs.remove(key);
      await _removeFromIndex(_scoreEventsIndexKey, eventId);
    } catch (e) {
      throw StorageException('Failed to delete score event: $e');
    }
  }

  /// Delete all score events for a round (internal use)
  static Future<void> _deleteScoreEventsByRound(String roundId) async {
    try {
      final events = await getScoreEventsByRound(roundId);
      for (final event in events) {
        await deleteScoreEvent(event.id);
      }
    } catch (e) {
      throw StorageException('Failed to delete score events for round: $e');
    }
  }

  // ===== UTILITY METHODS =====

  /// Clear all stored data (use with caution!)
  static Future<void> clearAll() async {
    try {
      await _prefs.clear();
    } catch (e) {
      throw StorageException('Failed to clear all data: $e');
    }
  }

  /// Get storage statistics
  static Future<Map<String, int>> getStorageStats() async {
    try {
      final roundIds = _getIndex(_roundsIndexKey);
      final challengeIds = _getIndex(_challengesIndexKey);
      final eventIds = _getIndex(_scoreEventsIndexKey);

      return {
        'rounds': roundIds.length,
        'challenges': challengeIds.length,
        'scoreEvents': eventIds.length,
      };
    } catch (e) {
      throw StorageException('Failed to get storage stats: $e');
    }
  }

  /// Validate storage integrity and repair if needed
  static Future<void> validateAndRepair() async {
    try {
      // Verify all indexed items exist
      final roundIds = _getIndex(_roundsIndexKey);
      final validRoundIds = <String>[];

      for (final id in roundIds) {
        final key = '$_roundPrefix$id';
        if (_prefs.containsKey(key)) {
          validRoundIds.add(id);
        }
      }

      // Rebuild index if needed
      if (validRoundIds.length != roundIds.length) {
        await _prefs.setString(_roundsIndexKey, jsonEncode(validRoundIds));
      }

      // Same for challenges
      final challengeIds = _getIndex(_challengesIndexKey);
      final validChallengeIds = <String>[];

      for (final id in challengeIds) {
        final key = '$_challengePrefix$id';
        if (_prefs.containsKey(key)) {
          validChallengeIds.add(id);
        }
      }

      if (validChallengeIds.length != challengeIds.length) {
        await _prefs.setString(_challengesIndexKey, jsonEncode(validChallengeIds));
      }

      // Same for score events
      final eventIds = _getIndex(_scoreEventsIndexKey);
      final validEventIds = <String>[];

      for (final id in eventIds) {
        final key = '$_scoreEventPrefix$id';
        if (_prefs.containsKey(key)) {
          validEventIds.add(id);
        }
      }

      if (validEventIds.length != eventIds.length) {
        await _prefs.setString(_scoreEventsIndexKey, jsonEncode(validEventIds));
      }
    } catch (e) {
      throw StorageException('Failed to validate and repair storage: $e');
    }
  }
}
