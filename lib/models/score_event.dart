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

  factory ScoreEvent.fromJson(Map<String, dynamic> data) {
    return ScoreEvent(
      id: data['id'] as String,
      roundId: data['roundId'] as String,
      roundChallengeId: data['roundChallengeId'] as String,
      userId: data['userId'] as String,
      attemptNumber: data['attemptNumber'] as int,
      resultType: data['resultType'] as String,
      points: data['points'] as int,
    );
  }

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
}
