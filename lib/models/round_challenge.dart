import 'package:cloud_firestore/cloud_firestore.dart';

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

  factory RoundChallenge.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return RoundChallenge(
      id: doc.id,
      roundId: data['roundId'],
      index: data['index'],
      teeChoice: data['teeChoice'] ?? 'none',
      basketChoice: data['basketChoice'] ?? 'none',
      throwConstraint: data['throwConstraint'] ?? 'none',
      challengeType: data['challengeType'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'roundId': roundId,
      'index': index,
      'teeChoice': teeChoice,
      'basketChoice': basketChoice,
      'throwConstraint': throwConstraint,
      'challengeType': challengeType,
    };
  }
}
