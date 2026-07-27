import 'package:uuid/uuid.dart';
import '../models/game_mode.dart';
import '../models/hole_configuration.dart';

/// Custom exception for hole randomizer errors
class HoleRandomizerException implements Exception {
  final String message;

  HoleRandomizerException(this.message);

  @override
  String toString() => message;
}

/// Service for generating and randomizing hole configurations
class HoleRandomizerService {
  static const _uuid = Uuid();

  /// Valid tee options
  static const teeOptions = ['short', 'long'];

  /// Valid basket options
  static const basketOptions = ['short', 'long'];

  /// Valid throw style options
  static const throwStyleOptions = ['forehand', 'backhand'];

  /// Valid throw hand options
  static const throwHandOptions = ['left', 'right', 'randomize'];

  /// Generate random hole configurations for a round
  static List<HoleConfiguration> generateHoleConfigurations({
    required String roundId,
    required int holeCount,
    required int defaultPar,
    String? throwStyleConstraint,
    String? throwHandConstraint,
  }) {
    try {
      if (holeCount <= 0) {
        throw HoleRandomizerException('Hole count must be positive');
      }

      final configurations = <HoleConfiguration>[];

      for (int i = 1; i <= holeCount; i++) {
        final config = _generateSingleHoleConfiguration(
          roundId: roundId,
          holeNumber: i,
          defaultPar: defaultPar,
          throwStyleConstraint: throwStyleConstraint,
          throwHandConstraint: throwHandConstraint,
        );
        configurations.add(config);
      }

      return configurations;
    } catch (e) {
      if (e is HoleRandomizerException) rethrow;
      throw HoleRandomizerException('Failed to generate hole configurations: $e');
    }
  }

  /// Generate a single hole configuration
  static HoleConfiguration _generateSingleHoleConfiguration({
    required String roundId,
    required int holeNumber,
    required int defaultPar,
    String? throwStyleConstraint,
    String? throwHandConstraint,
  }) {
    final randomTee = teeOptions[(DateTime.now().millisecondsSinceEpoch + holeNumber) % teeOptions.length];
    final randomBasket = basketOptions[(DateTime.now().millisecondsSinceEpoch + holeNumber * 2) % basketOptions.length];

    return HoleConfiguration(
      id: _uuid.v4(),
      roundId: roundId,
      holeNumber: holeNumber,
      teeSelected: randomTee,
      basketSelected: randomBasket,
      parValue: defaultPar,
      throwStyleConstraint: throwStyleConstraint,
      throwHandConstraint: throwHandConstraint,
    );
  }

  /// Randomize tee selection
  static String randomizeTee() {
    final index = DateTime.now().millisecondsSinceEpoch % teeOptions.length;
    return teeOptions[index];
  }

  /// Randomize basket selection
  static String randomizeBasket() {
    final index = (DateTime.now().millisecondsSinceEpoch + 1) % basketOptions.length;
    return basketOptions[index];
  }

  /// Randomize throw style
  static String randomizeThrowStyle() {
    final index = (DateTime.now().millisecondsSinceEpoch + 2) % throwStyleOptions.length;
    return throwStyleOptions[index];
  }

  /// Randomize throw hand
  static String randomizeThrowHand() {
    final index = (DateTime.now().millisecondsSinceEpoch + 3) % throwHandOptions.length;
    return throwHandOptions[index];
  }

  /// Validate tee selection
  static bool isValidTee(String tee) {
    return teeOptions.contains(tee.toLowerCase());
  }

  /// Validate basket selection
  static bool isValidBasket(String basket) {
    return basketOptions.contains(basket.toLowerCase());
  }

  /// Validate throw style constraint
  static bool isValidThrowStyle(String? throwStyle) {
    if (throwStyle == null) return true;
    return throwStyleOptions.contains(throwStyle.toLowerCase());
  }

  /// Validate throw hand constraint
  static bool isValidThrowHand(String? throwHand) {
    if (throwHand == null) return true;
    return throwHandOptions.contains(throwHand.toLowerCase());
  }
}
