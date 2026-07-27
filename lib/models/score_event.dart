import 'package:flutter/foundation.dart';

/// Custom exception for model parsing errors
class ModelParseException implements Exception {
  final String message;
  final String modelName;

  ModelParseException({required this.message, required this.modelName});

  @override
  String toString() => 'Failed to parse $modelName: $message';
}

/// Data model for a score event (individual throw result)
class ScoreEvent {
  final String id;
  final String roundId;
  final String roundChallengeId;
  final String userId;
  final int attemptNumber;
  final String resultType;
  final int points;

  ScoreEvent({
    required this.id,
    required this.roundId,
    required this.roundChallengeId,
    required this.userId,
    required this.attemptNumber,
    required this.resultType,
    required this.points,
  });

  /// Create a ScoreEvent from JSON with safe parsing
  factory ScoreEvent.fromJson(Map<String, dynamic> data) {
    try {
      // Validate required fields
      if (data['id'] == null) {
        throw ModelParseException(
          message: 'Missing required field: id',
          modelName: 'ScoreEvent',
        );
      }
      if (data['roundId'] == null) {
        throw ModelParseException(
          message: 'Missing required field: roundId',
          modelName: 'ScoreEvent',
        );
      }
      if (data['roundChallengeId'] == null) {
        throw ModelParseException(
          message: 'Missing required field: roundChallengeId',
          modelName: 'ScoreEvent',
        );
      }
      if (data['userId'] == null) {
        throw ModelParseException(
          message: 'Missing required field: userId',
          modelName: 'ScoreEvent',
        );
      }
      if (data['attemptNumber'] == null) {
        throw ModelParseException(
          message: 'Missing required field: attemptNumber',
          modelName: 'ScoreEvent',
        );
      }
      if (data['resultType'] == null) {
        throw ModelParseException(
          message: 'Missing required field: resultType',
          modelName: 'ScoreEvent',
        );
      }
      if (data['points'] == null) {
        throw ModelParseException(
          message: 'Missing required field: points',
          modelName: 'ScoreEvent',
        );
      }

      // Safe type casting with validation
      final id = data['id'] as String?;
      if (id == null || id.isEmpty) {
        throw ModelParseException(
          message: 'Invalid id: must be non-empty string',
          modelName: 'ScoreEvent',
        );
      }

      final roundId = data['roundId'] as String?;
      if (roundId == null || roundId.isEmpty) {
        throw ModelParseException(
          message: 'Invalid roundId: must be non-empty string',
          modelName: 'ScoreEvent',
        );
      }

      final roundChallengeId = data['roundChallengeId'] as String?;
      if (roundChallengeId == null || roundChallengeId.isEmpty) {
        throw ModelParseException(
          message: 'Invalid roundChallengeId: must be non-empty string',
          modelName: 'ScoreEvent',
        );
      }

      final userId = data['userId'] as String?;
      if (userId == null || userId.isEmpty) {
        throw ModelParseException(
          message: 'Invalid userId: must be non-empty string',
          modelName: 'ScoreEvent',
        );
      }

      final attemptNumber = data['attemptNumber'];
      if (attemptNumber is! int || attemptNumber <= 0) {
        throw ModelParseException(
          message: 'Invalid attemptNumber: must be positive integer',
          modelName: 'ScoreEvent',
        );
      }

      final resultType = data['resultType'] as String?;
      if (resultType == null || resultType.isEmpty) {
        throw ModelParseException(
          message: 'Invalid resultType: must be non-empty string',
          modelName: 'ScoreEvent',
        );
      }

      final points = data['points'];
      if (points is! int) {
        throw ModelParseException(
          message: 'Invalid points: must be integer',
          modelName: 'ScoreEvent',
        );
      }

      return ScoreEvent(
        id: id,
        roundId: roundId,
        roundChallengeId: roundChallengeId,
        userId: userId,
        attemptNumber: attemptNumber,
        resultType: resultType,
        points: points,
      );
    } on ModelParseException {
      rethrow;
    } catch (e) {
      throw ModelParseException(
        message: 'Unexpected error: $e',
        modelName: 'ScoreEvent',
      );
    }
  }

  /// Convert ScoreEvent to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'roundId': roundId,
      'roundChallengeId': roundChallengeId,
      'userId': userId,
      'attemptNumber': attemptNumber,
      'resultType': resultType,
      'points': points,
    };
  }

  /// Create a copy of this ScoreEvent with modified fields
  ScoreEvent copyWith({
    String? id,
    String? roundId,
    String? roundChallengeId,
    String? userId,
    int? attemptNumber,
    String? resultType,
    int? points,
  }) {
    return ScoreEvent(
      id: id ?? this.id,
      roundId: roundId ?? this.roundId,
      roundChallengeId: roundChallengeId ?? this.roundChallengeId,
      userId: userId ?? this.userId,
      attemptNumber: attemptNumber ?? this.attemptNumber,
      resultType: resultType ?? this.resultType,
      points: points ?? this.points,
    );
  }

  @override
  String toString() => 
    'ScoreEvent(id: $id, challenge: $roundChallengeId, result: $resultType, points: $points)';
}
