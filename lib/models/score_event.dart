import 'package:cloud_firestore/cloud_firestore.dart';

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

  factory ScoreEvent.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ScoreEvent(
      id: doc.id,
      roundId: data['roundId'],
      roundChallengeId: data['roundChallengeId'],
      userId: data['userId'],
      attemptNumber: data['attemptNumber'],
      resultType: data['resultType'],
      points: data['points'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'roundId': roundId,
      'roundChallengeId': roundChallengeId,
      'userId': userId,
      'attemptNumber': attemptNumber,
      'resultType': resultType,
      'points': points,
    };
  }
}
