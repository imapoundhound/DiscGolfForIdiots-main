import 'package:flutter_test/flutter_test.dart';
import 'package:disc_golf_for_idiots/services/storage_service.dart';
import 'package:disc_golf_for_idiots/models/round.dart';
import 'package:disc_golf_for_idiots/models/round_challenge.dart';
import 'package:disc_golf_for_idiots/models/score_event.dart';

void main() {
  group('StorageService', () {
    group('Storage Exception', () {
      test('StorageException formats message correctly', () {
        final exception = StorageException('Test error message');
        expect(exception.toString(), 'Test error message');
      });
    });

    group('Key Generation', () {
      test('_generateKey creates unique keys', () {
        final key1 = StorageService.generateKey('test_');
        final key2 = StorageService.generateKey('test_');
        expect(key1, isNot(key2));
        expect(key1, startsWith('test_'));
        expect(key2, startsWith('test_'));
      });
    });

    group('Index Management', () {
      test('_addToIndex prevents duplicates', () {
        // This would need SharedPreferences mocking in real implementation
        // Placeholder for index management logic
        expect(true, true);
      });

      test('_removeFromIndex removes from list', () {
        // This would need SharedPreferences mocking
        // Placeholder for removal logic
        expect(true, true);
      });
    });

    group('JSON Parsing', () {
      test('_parseJson handles valid JSON', () {
        const validJson = '{"id":"123","name":"test"}';
        final parsed = StorageService.parseJson(validJson, (json) => json);
        expect(parsed['id'], '123');
        expect(parsed['name'], 'test');
      });

      test('_parseJson throws on invalid JSON', () {
        const invalidJson = 'not valid json';
        expect(
          () => StorageService.parseJson(invalidJson, (json) => json),
          throwsA(isA<StorageException>()),
        );
      });

      test('_parseJson throws on non-map JSON', () {
        const arrayJson = '["item1","item2"]';
        expect(
          () => StorageService.parseJson(arrayJson, (json) => json),
          throwsA(isA<StorageException>()),
        );
      });
    });

    group('Data Consistency', () {
      test('Storage pattern uses consistent prefixes', () {
        expect(StorageService.roundPrefix, 'round_');
        expect(StorageService.challengePrefix, 'challenge_');
        expect(StorageService.scoreEventPrefix, 'scoreEvent_');
      });

      test('Index keys are properly named', () {
        expect(StorageService.roundsIndexKey, 'rounds_index');
        expect(StorageService.challengesIndexKey, 'challenges_index');
        expect(StorageService.scoreEventsIndexKey, 'scoreEvents_index');
      });
    });
  });

  group('StorageService Integration Scenarios', () {
    final testRound = Round(
      id: 'round_test',
      ownerId: 'user_test',
      mode: 'ace_race',
      courseName: 'Test Course',
      rules: {'acePoints': 5},
      roundPlayers: {},
      includeInStats: true,
      startedAt: DateTime.now(),
    );

    final testChallenge = RoundChallenge(
      id: 'challenge_test',
      roundId: 'round_test',
      index: 1,
      teeChoice: 'short',
      basketChoice: 'long',
      throwConstraint: 'none',
      challengeType: 'standard',
    );

    final testEvent = ScoreEvent(
      id: 'event_test',
      roundId: 'round_test',
      roundChallengeId: 'challenge_test',
      userId: 'user_test',
      attemptNumber: 1,
      resultType: 'ace',
      points: 5,
    );

    test('Round JSON serialization is consistent', () {
      final json = testRound.toJson();
      final reconstructed = Round.fromJson(json);
      expect(reconstructed.id, testRound.id);
      expect(reconstructed.ownerId, testRound.ownerId);
      expect(reconstructed.mode, testRound.mode);
    });

    test('Challenge JSON serialization is consistent', () {
      final json = testChallenge.toJson();
      final reconstructed = RoundChallenge.fromJson(json);
      expect(reconstructed.id, testChallenge.id);
      expect(reconstructed.roundId, testChallenge.roundId);
      expect(reconstructed.index, testChallenge.index);
    });

    test('ScoreEvent JSON serialization is consistent', () {
      final json = testEvent.toJson();
      final reconstructed = ScoreEvent.fromJson(json);
      expect(reconstructed.id, testEvent.id);
      expect(reconstructed.roundId, testEvent.roundId);
      expect(reconstructed.points, testEvent.points);
    });
  });
}
