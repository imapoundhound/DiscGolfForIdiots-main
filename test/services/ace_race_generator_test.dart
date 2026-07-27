import 'package:flutter_test/flutter_test.dart';
import 'package:disc_golf_for_idiots/services/ace_race_generator.dart';
import 'package:disc_golf_for_idiots/models/round_challenge.dart';

void main() {
  group('AceRaceGenerator', () {
    group('Challenge Generation', () {
      test('generateChallenges creates correct number of challenges', () {
        final challenges = AceRaceGenerator.generateChallenges(
          'round_123',
          9,
          {},
        );
        expect(challenges.length, 9);
      });

      test('generateChallenges creates challenges for 18 holes', () {
        final challenges = AceRaceGenerator.generateChallenges(
          'round_123',
          18,
          {},
        );
        expect(challenges.length, 18);
      });

      test('generateChallenges creates challenges for 6 holes', () {
        final challenges = AceRaceGenerator.generateChallenges(
          'round_123',
          6,
          {},
        );
        expect(challenges.length, 6);
      });

      test('generateChallenges creates challenges for 3 holes', () {
        final challenges = AceRaceGenerator.generateChallenges(
          'round_123',
          3,
          {},
        );
        expect(challenges.length, 3);
      });
    });

    group('Challenge Properties', () {
      test('All challenges belong to the same round', () {
        final roundId = 'round_123';
        final challenges = AceRaceGenerator.generateChallenges(
          roundId,
          9,
          {},
        );
        for (final challenge in challenges) {
          expect(challenge.roundId, roundId);
        }
      });

      test('Challenges have sequential indices', () {
        final challenges = AceRaceGenerator.generateChallenges(
          'round_123',
          9,
          {},
        );
        for (int i = 0; i < challenges.length; i++) {
          expect(challenges[i].index, i + 1);
        }
      });

      test('All challenges have unique IDs', () {
        final challenges = AceRaceGenerator.generateChallenges(
          'round_123',
          9,
          {},
        );
        final ids = challenges.map((c) => c.id).toList();
        final uniqueIds = ids.toSet();
        expect(ids.length, uniqueIds.length);
      });

      test('Challenges have valid challenge type', () {
        final challenges = AceRaceGenerator.generateChallenges(
          'round_123',
          9,
          {},
        );
        for (final challenge in challenges) {
          expect(
            ['standard', 'random', 'custom'],
            contains(challenge.challengeType),
          );
        }
      });

      test('Challenges have default values when no options', () {
        final challenges = AceRaceGenerator.generateChallenges(
          'round_123',
          3,
          {},
        );
        for (final challenge in challenges) {
          expect(challenge.teeChoice, isNotEmpty);
          expect(challenge.basketChoice, isNotEmpty);
          expect(challenge.throwConstraint, isNotEmpty);
        }
      });
    });

    group('Random Options', () {
      test('Random throw option affects challenge generation', () {
        final challengesWithoutRandom = AceRaceGenerator.generateChallenges(
          'round_123',
          3,
          {'randomThrow': false},
        );
        final challengesWithRandom = AceRaceGenerator.generateChallenges(
          'round_456',
          3,
          {'randomThrow': true},
        );

        // Both should generate valid challenges
        expect(challengesWithoutRandom.length, 3);
        expect(challengesWithRandom.length, 3);

        // All should have throw constraints
        for (final challenge in [...challengesWithoutRandom, ...challengesWithRandom]) {
          expect(challenge.throwConstraint, isNotEmpty);
        }
      });
    });

    group('Edge Cases', () {
      test('Handles minimum hole count (3)', () {
        final challenges = AceRaceGenerator.generateChallenges(
          'round_123',
          3,
          {},
        );
        expect(challenges.isNotEmpty, true);
        expect(challenges.length, 3);
      });

      test('Handles maximum hole count (18)', () {
        final challenges = AceRaceGenerator.generateChallenges(
          'round_123',
          18,
          {},
        );
        expect(challenges.isNotEmpty, true);
        expect(challenges.length, 18);
      });

      test('Empty options map is handled gracefully', () {
        final challenges = AceRaceGenerator.generateChallenges(
          'round_123',
          9,
          {},
        );
        expect(challenges.isNotEmpty, true);
        expect(challenges.length, 9);
      });

      test('Extra options are ignored', () {
        final challenges = AceRaceGenerator.generateChallenges(
          'round_123',
          9,
          {
            'randomThrow': true,
            'unknownOption': 'value',
            'anotherOption': 123,
          },
        );
        expect(challenges.length, 9);
      });
    });

    group('Randomization', () {
      test('Multiple generations produce different challenges', () {
        final challenges1 = AceRaceGenerator.generateChallenges(
          'round_1',
          9,
          {'randomThrow': true},
        );
        final challenges2 = AceRaceGenerator.generateChallenges(
          'round_2',
          9,
          {'randomThrow': true},
        );

        // At least some challenges should differ
        bool anyDifferent = false;
        for (int i = 0; i < challenges1.length; i++) {
          if (challenges1[i].throwConstraint != challenges2[i].throwConstraint ||
              challenges1[i].teeChoice != challenges2[i].teeChoice ||
              challenges1[i].basketChoice != challenges2[i].basketChoice) {
            anyDifferent = true;
            break;
          }
        }
        expect(anyDifferent, true);
      });
    });

    group('Model Validation', () {
      test('Generated challenges are valid RoundChallenge instances', () {
        final challenges = AceRaceGenerator.generateChallenges(
          'round_123',
          9,
          {},
        );
        for (final challenge in challenges) {
          expect(challenge, isA<RoundChallenge>());
          expect(challenge.id, isNotEmpty);
          expect(challenge.roundId, isNotEmpty);
          expect(challenge.index, greaterThan(0));
        }
      });

      test('Generated challenges can be serialized to JSON', () {
        final challenges = AceRaceGenerator.generateChallenges(
          'round_123',
          3,
          {},
        );
        for (final challenge in challenges) {
          final json = challenge.toJson();
          expect(json, isNotEmpty);
          expect(json['id'], challenge.id);
          expect(json['roundId'], challenge.roundId);
        }
      });

      test('Generated challenges can be deserialized from JSON', () {
        final originalChallenges = AceRaceGenerator.generateChallenges(
          'round_123',
          3,
          {},
        );
        for (final challenge in originalChallenges) {
          final json = challenge.toJson();
          final reconstructed = RoundChallenge.fromJson(json);
          expect(reconstructed.id, challenge.id);
          expect(reconstructed.roundId, challenge.roundId);
          expect(reconstructed.index, challenge.index);
        }
      });
    });
  });
}
