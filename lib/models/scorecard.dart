import 'package:flutter/foundation.dart';
import 'game_mode.dart';

/// Custom exception for scorecard errors
class ScorecardException implements Exception {
  final String message;

  ScorecardException(this.message);

  @override
  String toString() => message;
}

/// Represents a player in the scorecard
class ScorecardPlayer {
  final String userId;
  final String name;
  final int order;

  ScorecardPlayer({
    required this.userId,
    required this.name,
    required this.order,
  });

  factory ScorecardPlayer.fromJson(Map<String, dynamic> data) {
    try {
      final userId = data['userId'] as String?;
      if (userId == null || userId.isEmpty) {
        throw ScorecardException('Invalid userId');
      }

      final name = data['name'] as String?;
      if (name == null || name.isEmpty) {
        throw ScorecardException('Invalid name');
      }

      final order = data['order'];
      if (order is! int || order <= 0) {
        throw ScorecardException('Invalid order');
      }

      return ScorecardPlayer(
        userId: userId,
        name: name,
        order: order,
      );
    } catch (e) {
      if (e is ScorecardException) rethrow;
      throw ScorecardException('Failed to parse ScorecardPlayer: $e');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'order': order,
    };
  }
}

/// Represents the complete scorecard for a game round
class Scorecard {
  final String id;
  final String roundId;
  final GameMode gameMode;
  final String courseName;
  final int holeCount;
  final List<ScorecardPlayer> players;
  final Map<String, List<int>> scores; // playerId -> list of scores per hole
  final Map<String, dynamic>? accuracyMetrics; // For pin the tail mode
  final String? winnerId;
  final DateTime createdAt;
  final DateTime? completedAt;

  Scorecard({
    required this.id,
    required this.roundId,
    required this.gameMode,
    required this.courseName,
    required this.holeCount,
    required this.players,
    required this.scores,
    this.accuracyMetrics,
    this.winnerId,
    required this.createdAt,
    this.completedAt,
  });

  /// Create Scorecard from JSON with safe parsing
  factory Scorecard.fromJson(Map<String, dynamic> data) {
    try {
      // Validate required fields
      if (data['id'] == null) {
        throw ScorecardException('Missing required field: id');
      }
      if (data['roundId'] == null) {
        throw ScorecardException('Missing required field: roundId');
      }
      if (data['gameMode'] == null) {
        throw ScorecardException('Missing required field: gameMode');
      }
      if (data['courseName'] == null) {
        throw ScorecardException('Missing required field: courseName');
      }
      if (data['holeCount'] == null) {
        throw ScorecardException('Missing required field: holeCount');
      }
      if (data['players'] == null) {
        throw ScorecardException('Missing required field: players');
      }
      if (data['scores'] == null) {
        throw ScorecardException('Missing required field: scores');
      }
      if (data['createdAt'] == null) {
        throw ScorecardException('Missing required field: createdAt');
      }

      // Safe type casting
      final id = data['id'] as String?;
      if (id == null || id.isEmpty) {
        throw ScorecardException('Invalid id: must be non-empty string');
      }

      final roundId = data['roundId'] as String?;
      if (roundId == null || roundId.isEmpty) {
        throw ScorecardException('Invalid roundId: must be non-empty string');
      }

      final gameMode = GameMode.fromStorageString(data['gameMode'] as String);

      final courseName = data['courseName'] as String?;
      if (courseName == null || courseName.isEmpty) {
        throw ScorecardException('Invalid courseName: must be non-empty string');
      }

      final holeCount = data['holeCount'];
      if (holeCount is! int || holeCount <= 0) {
        throw ScorecardException('Invalid holeCount: must be positive integer');
      }

      // Parse players
      final playersList = data['players'] as List?;
      if (playersList == null || playersList.isEmpty) {
        throw ScorecardException('Invalid players: must be non-empty list');
      }
      final players = playersList
          .map((p) => ScorecardPlayer.fromJson(p as Map<String, dynamic>))
          .toList();

      // Parse scores
      final scoresMap = data['scores'] as Map?;
      if (scoresMap == null) {
        throw ScorecardException('Invalid scores');
      }
      final scores = <String, List<int>>{};
      scoresMap.forEach((key, value) {
        if (value is List) {
          scores[key as String] = List<int>.from(value.cast<int>());
        }
      });

      // Parse dates
      DateTime parsedCreatedAt;
      try {
        final createdAtStr = data['createdAt'] as String?;
        if (createdAtStr == null) {
          throw ScorecardException('createdAt cannot be null');
        }
        parsedCreatedAt = DateTime.parse(createdAtStr);
      } catch (e) {
        throw ScorecardException('Invalid createdAt format: $e');
      }

      DateTime? parsedCompletedAt;
      if (data['completedAt'] != null) {
        try {
          parsedCompletedAt = DateTime.parse(data['completedAt'] as String);
        } catch (e) {
          debugPrint('Warning: Invalid completedAt format: $e');
          parsedCompletedAt = null;
        }
      }

      return Scorecard(
        id: id,
        roundId: roundId,
        gameMode: gameMode,
        courseName: courseName,
        holeCount: holeCount,
        players: players,
        scores: scores,
        accuracyMetrics: data['accuracyMetrics'] as Map<String, dynamic>?,
        winnerId: data['winnerId'] as String?,
        createdAt: parsedCreatedAt,
        completedAt: parsedCompletedAt,
      );
    } catch (e) {
      if (e is ScorecardException) rethrow;
      throw ScorecardException('Failed to parse Scorecard: $e');
    }
  }

  /// Convert Scorecard to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'roundId': roundId,
      'gameMode': gameMode.toStorageString(),
      'courseName': courseName,
      'holeCount': holeCount,
      'players': players.map((p) => p.toJson()).toList(),
      'scores': scores,
      'accuracyMetrics': accuracyMetrics,
      'winnerId': winnerId,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  /// Get total score for a player
  int? getTotalScore(String playerId) {
    final playerScores = scores[playerId];
    if (playerScores == null || playerScores.isEmpty) return null;
    return playerScores.reduce((a, b) => a + b);
  }

  /// Get score for a player on a specific hole
  int? getHoleScore(String playerId, int holeNumber) {
    final playerScores = scores[playerId];
    if (playerScores == null || holeNumber < 1 || holeNumber > playerScores.length) {
      return null;
    }
    return playerScores[holeNumber - 1];
  }

  /// Add or update a score for a player on a hole
  void updateHoleScore(String playerId, int holeNumber, int score) {
    if (!scores.containsKey(playerId)) {
      scores[playerId] = List.filled(holeCount, 0);
    }
    if (holeNumber >= 1 && holeNumber <= holeCount) {
      scores[playerId]![holeNumber - 1] = score;
    }
  }

  /// Create a copy with modified fields
  Scorecard copyWith({
    String? id,
    String? roundId,
    GameMode? gameMode,
    String? courseName,
    int? holeCount,
    List<ScorecardPlayer>? players,
    Map<String, List<int>>? scores,
    Map<String, dynamic>? accuracyMetrics,
    String? winnerId,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return Scorecard(
      id: id ?? this.id,
      roundId: roundId ?? this.roundId,
      gameMode: gameMode ?? this.gameMode,
      courseName: courseName ?? this.courseName,
      holeCount: holeCount ?? this.holeCount,
      players: players ?? this.players,
      scores: scores ?? this.scores,
      accuracyMetrics: accuracyMetrics ?? this.accuracyMetrics,
      winnerId: winnerId ?? this.winnerId,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  String toString() =>
      'Scorecard(id: $id, mode: ${gameMode.displayName}, course: $courseName, holes: $holeCount)';
}
