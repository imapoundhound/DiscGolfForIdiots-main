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

  factory RoundChallenge.fromJson(Map<String, dynamic> json) {
    return RoundChallenge(
      id: json['id'] as String,
      roundId: json['roundId'] as String,
      index: json['index'] as int,
      teeChoice: json['teeChoice'] as String,
      basketChoice: json['basketChoice'] as String,
      throwConstraint: json['throwConstraint'] as String,
      challengeType: json['challengeType'] as String,
    );
  }

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
}
