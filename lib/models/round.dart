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

  factory Round.fromJson(Map<String, dynamic> data) {
    return Round(
      id: data['id'] as String,
      ownerId: data['ownerId'] as String,
      mode: data['mode'] as String,
      courseName: data['courseName'] as String?,
      rules: Map<String, dynamic>.from(data['rules'] ?? {}),
      roundPlayers: Map<String, dynamic>.from(data['roundPlayers'] ?? {}),
      includeInStats: data['includeInStats'] as bool? ?? false,
      startedAt: DateTime.parse(data['startedAt'] as String),
      endedAt: data['endedAt'] != null ? DateTime.parse(data['endedAt'] as String) : null,
    );
  }

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
}
