import 'package:flutter/foundation.dart';

/// Custom exception for hole configuration errors
class HoleConfigException implements Exception {
  final String message;

  HoleConfigException(this.message);

  @override
  String toString() => message;
}

/// Represents the configuration for a single hole in a game round
class HoleConfiguration {
  final String id;
  final String roundId;
  final int holeNumber;
  final String teeSelected; // 'short' or 'long'
  final String basketSelected; // 'short' or 'long'
  final int parValue;
  final String? throwStyleConstraint; // 'forehand', 'backhand', or null for 'any'
  final String? throwHandConstraint; // 'left', 'right', 'randomize', or null for 'any'

  HoleConfiguration({
    required this.id,
    required this.roundId,
    required this.holeNumber,
    required this.teeSelected,
    required this.basketSelected,
    required this.parValue,
    this.throwStyleConstraint,
    this.throwHandConstraint,
  });

  /// Create HoleConfiguration from JSON with safe parsing
  factory HoleConfiguration.fromJson(Map<String, dynamic> data) {
    try {
      // Validate required fields
      if (data['id'] == null) {
        throw HoleConfigException('Missing required field: id');
      }
      if (data['roundId'] == null) {
        throw HoleConfigException('Missing required field: roundId');
      }
      if (data['holeNumber'] == null) {
        throw HoleConfigException('Missing required field: holeNumber');
      }
      if (data['teeSelected'] == null) {
        throw HoleConfigException('Missing required field: teeSelected');
      }
      if (data['basketSelected'] == null) {
        throw HoleConfigException('Missing required field: basketSelected');
      }
      if (data['parValue'] == null) {
        throw HoleConfigException('Missing required field: parValue');
      }

      // Safe type casting with validation
      final id = data['id'] as String?;
      if (id == null || id.isEmpty) {
        throw HoleConfigException('Invalid id: must be non-empty string');
      }

      final roundId = data['roundId'] as String?;
      if (roundId == null || roundId.isEmpty) {
        throw HoleConfigException('Invalid roundId: must be non-empty string');
      }

      final holeNumber = data['holeNumber'];
      if (holeNumber is! int || holeNumber <= 0) {
        throw HoleConfigException('Invalid holeNumber: must be positive integer');
      }

      final teeSelected = data['teeSelected'] as String?;
      if (teeSelected == null || teeSelected.isEmpty) {
        throw HoleConfigException('Invalid teeSelected: must be non-empty string');
      }

      final basketSelected = data['basketSelected'] as String?;
      if (basketSelected == null || basketSelected.isEmpty) {
        throw HoleConfigException('Invalid basketSelected: must be non-empty string');
      }

      final parValue = data['parValue'];
      if (parValue is! int || parValue <= 0) {
        throw HoleConfigException('Invalid parValue: must be positive integer');
      }

      final throwStyleConstraint = data['throwStyleConstraint'] as String?;
      final throwHandConstraint = data['throwHandConstraint'] as String?;

      return HoleConfiguration(
        id: id,
        roundId: roundId,
        holeNumber: holeNumber,
        teeSelected: teeSelected,
        basketSelected: basketSelected,
        parValue: parValue,
        throwStyleConstraint: throwStyleConstraint,
        throwHandConstraint: throwHandConstraint,
      );
    } catch (e) {
      if (e is HoleConfigException) rethrow;
      throw HoleConfigException('Failed to parse HoleConfiguration: $e');
    }
  }

  /// Convert HoleConfiguration to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'roundId': roundId,
      'holeNumber': holeNumber,
      'teeSelected': teeSelected,
      'basketSelected': basketSelected,
      'parValue': parValue,
      'throwStyleConstraint': throwStyleConstraint,
      'throwHandConstraint': throwHandConstraint,
    };
  }

  /// Create a copy with modified fields
  HoleConfiguration copyWith({
    String? id,
    String? roundId,
    int? holeNumber,
    String? teeSelected,
    String? basketSelected,
    int? parValue,
    String? throwStyleConstraint,
    String? throwHandConstraint,
  }) {
    return HoleConfiguration(
      id: id ?? this.id,
      roundId: roundId ?? this.roundId,
      holeNumber: holeNumber ?? this.holeNumber,
      teeSelected: teeSelected ?? this.teeSelected,
      basketSelected: basketSelected ?? this.basketSelected,
      parValue: parValue ?? this.parValue,
      throwStyleConstraint: throwStyleConstraint ?? this.throwStyleConstraint,
      throwHandConstraint: throwHandConstraint ?? this.throwHandConstraint,
    );
  }

  @override
  String toString() => 
    'HoleConfiguration(hole: $holeNumber, tee: $teeSelected, basket: $basketSelected, par: $parValue)';
}
