import 'package:flutter/foundation.dart';

/// Custom exception for model parsing errors
class ModelParseException implements Exception {
  final String message;
  final String modelName;

  ModelParseException({required this.message, required this.modelName});

  @override
  String toString() => 'Failed to parse $modelName: $message';
}

/// Data model for a round challenge (individual hole challenge)
class RoundChallenge {
  final String id;
  final String roundId;
  final int index;
  final String teeChoice;
  final String basketChoice;
  final String throwConstraint;
  final String challengeType;

  RoundChallenge({
    required this.id,
    required this.roundId,
    required this.index,
    required this.teeChoice,
    required this.basketChoice,
    required this.throwConstraint,
    required this.challengeType,
  });

  /// Create a RoundChallenge from JSON with safe parsing
  factory RoundChallenge.fromJson(Map<String, dynamic> json) {
    try {
      // Validate required fields
      if (json['id'] == null) {
        throw ModelParseException(
          message: 'Missing required field: id',
          modelName: 'RoundChallenge',
        );
      }
      if (json['roundId'] == null) {
        throw ModelParseException(
          message: 'Missing required field: roundId',
          modelName: 'RoundChallenge',
        );
      }
      if (json['index'] == null) {
        throw ModelParseException(
          message: 'Missing required field: index',
          modelName: 'RoundChallenge',
        );
      }

      // Safe type casting with validation
      final id = json['id'] as String?;
      if (id == null || id.isEmpty) {
        throw ModelParseException(
          message: 'Invalid id: must be non-empty string',
          modelName: 'RoundChallenge',
        );
      }

      final roundId = json['roundId'] as String?;
      if (roundId == null || roundId.isEmpty) {
        throw ModelParseException(
          message: 'Invalid roundId: must be non-empty string',
          modelName: 'RoundChallenge',
        );
      }

      final index = json['index'];
      if (index is! int || index <= 0) {
        throw ModelParseException(
          message: 'Invalid index: must be positive integer',
          modelName: 'RoundChallenge',
        );
      }

      return RoundChallenge(
        id: id,
        roundId: roundId,
        index: index,
        teeChoice: (json['teeChoice'] as String?) ?? 'none',
        basketChoice: (json['basketChoice'] as String?) ?? 'none',
        throwConstraint: (json['throwConstraint'] as String?) ?? 'none',
        challengeType: (json['challengeType'] as String?) ?? 'standard',
      );
    } on ModelParseException {
      rethrow;
    } catch (e) {
      throw ModelParseException(
        message: 'Unexpected error: $e',
        modelName: 'RoundChallenge',
      );
    }
  }

  /// Convert RoundChallenge to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'roundId': roundId,
      'index': index,
      'teeChoice': teeChoice,
      'basketChoice': basketChoice,
      'throwConstraint': throwConstraint,
      'challengeType': challengeType,
    };
  }

  /// Create a copy of this RoundChallenge with modified fields
  RoundChallenge copyWith({
    String? id,
    String? roundId,
    int? index,
    String? teeChoice,
    String? basketChoice,
    String? throwConstraint,
    String? challengeType,
  }) {
    return RoundChallenge(
      id: id ?? this.id,
      roundId: roundId ?? this.roundId,
      index: index ?? this.index,
      teeChoice: teeChoice ?? this.teeChoice,
      basketChoice: basketChoice ?? this.basketChoice,
      throwConstraint: throwConstraint ?? this.throwConstraint,
      challengeType: challengeType ?? this.challengeType,
    );
  }

  @override
  String toString() => 
    'RoundChallenge(id: $id, hole: $index, tee: $teeChoice, basket: $basketChoice)';
}
