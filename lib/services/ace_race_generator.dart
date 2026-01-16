import 'package:uuid/uuid.dart';
import '../models/round_challenge.dart';
import 'dart:math';

class AceRaceGenerator {
  static List<RoundChallenge> generateChallenges(
    String roundId,
    int holeCount,
    Map<String, dynamic> options,
  ) {
    final List<RoundChallenge> challenges = [];
    final random = Random();
    const uuid = Uuid();

    for (int i = 0; i < holeCount; i++) {
      final teeChoice = _randomChoice(
        ['short_tee', 'long_tee', 'none'],
        random,
      );
      final basketChoice = _randomChoice(
        ['short_basket', 'long_basket', 'none'],
        random,
      );
      final throwConstraint = options['randomThrow'] == true
          ? _randomChoice(['backhand', 'forehand', 'roller', 'none'], random)
          : 'none';

      challenges.add(
        RoundChallenge(
          id: uuid.v4(),
          roundId: roundId,
          index: i + 1,
          teeChoice: teeChoice,
          basketChoice: basketChoice,
          throwConstraint: throwConstraint,
          challengeType: 'standard',
        ),
      );
    }

    return challenges;
  }

  static String _randomChoice(List<String> choices, Random random) {
    return choices[random.nextInt(choices.length)];
  }
}
