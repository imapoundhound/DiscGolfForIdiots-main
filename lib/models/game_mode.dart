/// Enum representing the three game modes
enum GameMode {
  aceRace,
  pinTheTail,
  roundRandomizer;

  /// Get display name for UI
  String get displayName {
    switch (this) {
      case GameMode.aceRace:
        return 'Ace Race';
      case GameMode.pinTheTail:
        return 'Pin The Tail On The Birdie';
      case GameMode.roundRandomizer:
        return 'Round Randomizer';
    }
  }

  /// Get description for UI
  String get description {
    switch (this) {
      case GameMode.aceRace:
        return 'Fast-paced ace hunting - earn points for aces and metal hits';
      case GameMode.pinTheTail:
        return 'Blindfolded accuracy challenge - throw at where you think the basket is';
      case GameMode.roundRandomizer:
        return 'Random everything - when the group can\'t decide the format';
    }
  }

  /// Get icon name for UI
  String get iconName {
    switch (this) {
      case GameMode.aceRace:
        return 'star';
      case GameMode.pinTheTail:
        return 'remove_red_eye';
      case GameMode.roundRandomizer:
        return 'shuffle';
    }
  }

  /// Convert to string for storage
  String toStorageString() => name;

  /// Parse from stored string
  static GameMode fromStorageString(String value) {
    return GameMode.values.firstWhere(
      (mode) => mode.name == value,
      orElse: () => GameMode.aceRace,
    );
  }
}
