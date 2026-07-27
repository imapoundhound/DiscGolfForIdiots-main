import 'package:flutter/foundation.dart';

/// Custom exception for model parsing errors
class ModelParseException implements Exception {
  final String message;
  final String modelName;

  ModelParseException({required this.message, required this.modelName});

  @override
  String toString() => 'Failed to parse $modelName: $message';
}

/// Data model for a disc golf round
class Round {
  final String id;
  final String ownerId;
  final String mode;
  final String? courseName;
  final Map<String, dynamic> rules;
  final Map<String, dynamic> roundPlayers;
  final bool includeInStats;
  final DateTime startedAt;
  final DateTime? endedAt;

  Round({
    required this.id,
    required this.ownerId,
    required this.mode,
    this.courseName,
    required this.rules,
    required this.roundPlayers,
    required this.includeInStats,
    required this.startedAt,
    this.endedAt,
  });

  /// Create a Round from JSON with safe parsing
  factory Round.fromJson(Map<String, dynamic> data) {
    try {
      // Validate required fields
      if (data['id'] == null) {
        throw ModelParseException(
          message: 'Missing required field: id',
          modelName: 'Round',
        );
      }
      if (data['ownerId'] == null) {
        throw ModelParseException(
          message: 'Missing required field: ownerId',
          modelName: 'Round',
        );
      }
      if (data['mode'] == null) {
        throw ModelParseException(
          message: 'Missing required field: mode',
          modelName: 'Round',
        );
      }
      if (data['startedAt'] == null) {
        throw ModelParseException(
          message: 'Missing required field: startedAt',
          modelName: 'Round',
        );
      }

      // Safe type casting with validation
      final id = data['id'] as String?;
      if (id == null || id.isEmpty) {
        throw ModelParseException(
          message: 'Invalid id: must be non-empty string',
          modelName: 'Round',
        );
      }

      final ownerId = data['ownerId'] as String?;
      if (ownerId == null || ownerId.isEmpty) {
        throw ModelParseException(
          message: 'Invalid ownerId: must be non-empty string',
          modelName: 'Round',
        );
      }

      final mode = data['mode'] as String?;
      if (mode == null || mode.isEmpty) {
        throw ModelParseException(
          message: 'Invalid mode: must be non-empty string',
          modelName: 'Round',
        );
      }

      // Parse dates safely
      DateTime parsedStartedAt;
      try {
        final startedAtStr = data['startedAt'] as String?;
        if (startedAtStr == null) {
          throw ModelParseException(
            message: 'startedAt cannot be null',
            modelName: 'Round',
          );
        }
        parsedStartedAt = DateTime.parse(startedAtStr);
      } catch (e) {
        throw ModelParseException(
          message: 'Invalid startedAt format: $e',
          modelName: 'Round',
        );
      }

      DateTime? parsedEndedAt;
      if (data['endedAt'] != null) {
        try {
          parsedEndedAt = DateTime.parse(data['endedAt'] as String);
        } catch (e) {
          debugPrint('Warning: Invalid endedAt format: $e');
          parsedEndedAt = null;
        }
      }

      return Round(
        id: id,
        ownerId: ownerId,
        mode: mode,
        courseName: data['courseName'] as String?,
        rules: Map<String, dynamic>.from(data['rules'] ?? {}),
        roundPlayers: Map<String, dynamic>.from(data['roundPlayers'] ?? {}),
        includeInStats: data['includeInStats'] as bool? ?? false,
        startedAt: parsedStartedAt,
        endedAt: parsedEndedAt,
      );
    } on ModelParseException {
      rethrow;
    } catch (e) {
      throw ModelParseException(
        message: 'Unexpected error: $e',
        modelName: 'Round',
      );
    }
  }

  /// Convert Round to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ownerId': ownerId,
      'mode': mode,
      'courseName': courseName,
      'rules': rules,
      'roundPlayers': roundPlayers,
      'includeInStats': includeInStats,
      'startedAt': startedAt.toIso8601String(),
      'endedAt': endedAt?.toIso8601String(),
    };
  }

  /// Create a copy of this Round with modified fields
  Round copyWith({
    String? id,
    String? ownerId,
    String? mode,
    String? courseName,
    Map<String, dynamic>? rules,
    Map<String, dynamic>? roundPlayers,
    bool? includeInStats,
    DateTime? startedAt,
    DateTime? endedAt,
  }) {
    return Round(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      mode: mode ?? this.mode,
      courseName: courseName ?? this.courseName,
      rules: rules ?? this.rules,
      roundPlayers: roundPlayers ?? this.roundPlayers,
      includeInStats: includeInStats ?? this.includeInStats,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
    );
  }

  @override
  String toString() => 'Round(id: $id, mode: $mode, courseName: $courseName)';
}
