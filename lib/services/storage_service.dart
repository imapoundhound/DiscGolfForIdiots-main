import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/round.dart';
import '../models/round_challenge.dart';
import '../models/score_event.dart';

/// Service for managing persistent storage using SharedPreferences
class StorageService {
  static late SharedPreferences _prefs;

  static const String _roundsKey = 'rounds';

  /// Initialize SharedPreferences
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ===== ROUNDS =====

  /// Save a round to persistent storage
  static Future<String> saveRound(Round round) async {
    final rounds = await getRounds();
    rounds[round.id] = round;
    final jsonMap = rounds.map((k, v) => MapEntry(k, jsonEncode(v.toJson())));
    await _prefs.setStringList(
      _roundsKey,
      jsonMap.values.toList(),
    );
    // Also save a mapping for retrieval
    await _prefs.setString('round_${round.id}', jsonEncode(round.toJson()));
    return round.id;
  }

  /// Get all rounds as a map
  static Future<Map<String, Round>> getRounds() async {
    final keys = _prefs.getKeys();
    final roundMap = <String, Round>{};

    for (final key in keys) {
      if (key.startsWith('round_')) {
        final jsonStr = _prefs.getString(key);
        if (jsonStr != null) {
          final round = Round.fromJson(jsonDecode(jsonStr) as Map<String, dynamic>);
          roundMap[round.id] = round;
        }
      }
    }
    return roundMap;
  }

  // ===== CHALLENGES =====

  /// Save a challenge to persistent storage
  static Future<void> saveChallenge(RoundChallenge challenge) async {
    await _prefs.setString(
      'challenge_${challenge.id}',
      jsonEncode(challenge.toJson()),
    );
  }

  /// Get all challenges for a specific round
  static Future<List<RoundChallenge>> getChallengesByRound(String roundId) async {
    final keys = _prefs.getKeys();
    final challenges = <RoundChallenge>[];

    for (final key in keys) {
      if (key.startsWith('challenge_')) {
        final jsonStr = _prefs.getString(key);
        if (jsonStr != null) {
          final challenge =
              RoundChallenge.fromJson(jsonDecode(jsonStr) as Map<String, dynamic>);
          if (challenge.roundId == roundId) {
            challenges.add(challenge);
          }
        }
      }
    }
    return challenges;
  }

  // ===== SCORE EVENTS =====

  /// Save a score event to persistent storage
  static Future<void> saveScoreEvent(ScoreEvent event) async {
    await _prefs.setString(
      'scoreEvent_${event.id}',
      jsonEncode(event.toJson()),
    );
  }

  /// Get all score events for a specific round
  static Future<List<ScoreEvent>> getScoreEventsByRound(String roundId) async {
    final keys = _prefs.getKeys();
    final events = <ScoreEvent>[];

    for (final key in keys) {
      if (key.startsWith('scoreEvent_')) {
        final jsonStr = _prefs.getString(key);
        if (jsonStr != null) {
          final event =
              ScoreEvent.fromJson(jsonDecode(jsonStr) as Map<String, dynamic>);
          if (event.roundId == roundId) {
            events.add(event);
          }
        }
      }
    }
    return events;
  }

  /// Clear all stored data
  static Future<void> clearAll() async {
    await _prefs.clear();
  }
}
