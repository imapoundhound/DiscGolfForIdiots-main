import 'package:cloud_firestore/cloud_firestore.dart';

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

  factory Round.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Round(
      id: doc.id,
      ownerId: data['ownerId'],
      mode: data['mode'],
      courseName: data['courseName'],
      rules: Map<String, dynamic>.from(data['rules'] ?? {}),
      roundPlayers: Map<String, dynamic>.from(data['roundPlayers'] ?? {}),
      includeInStats: data['includeInStats'] ?? false,
      startedAt: (data['startedAt'] as Timestamp).toDate(),
      endedAt: data['endedAt'] != null ? (data['endedAt'] as Timestamp).toDate() : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'ownerId': ownerId,
      'mode': mode,
      'courseName': courseName,
      'rules': rules,
      'roundPlayers': roundPlayers,
      'includeInStats': includeInStats,
      'startedAt': Timestamp.fromDate(startedAt),
      'endedAt': endedAt != null ? Timestamp.fromDate(endedAt!) : null,
    };
  }
}
