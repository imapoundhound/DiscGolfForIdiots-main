import 'package:flutter_test/flutter_test.dart';
import 'package:disc_golf_for_idiots/models/round.dart';
import 'package:disc_golf_for_idiots/models/round_challenge.dart';
import 'package:disc_golf_for_idiots/models/score_event.dart';

void main() {
  group('Round Model', () {
    final testRoundJson = {
      'id': 'round_123',
      'ownerId': 'user_456',
      'mode': 'ace_race',
      'courseName': 'Wickham Park',
      'rules': {
        'acePoints': 5,
        'metalPoints': 1,
      },
      'roundPlayers': {
        'player_0': {'name': 'Alice', 'order': 1},
      },
      'includeInStats': true,
      'startedAt': '2026-07-27T14:00:00Z',
      'endedAt': null,
    };

    test('Creates Round from valid JSON', () {
      final round = Round.fromJson(testRoundJson);
      expect(round.id, 'round_123');
      expect(round.ownerId, 'user_456');
      expect(round.mode, 'ace_race');
      expect(round.courseName, 'Wickham Park');
      expect(round.includeInStats, true);
    });

    test('Converts Round to JSON correctly', () {
      final round = Round.fromJson(testRoundJson);
      final json = round.toJson();
      expect(json['id'], 'round_123');
      expect(json['ownerId'], 'user_456');
      expect(json['mode'], 'ace_race');
    });

    test('Throws on missing id', () {
      final invalidJson = {...testRoundJson};
      invalidJson.remove('id');
      expect(
        () => Round.fromJson(invalidJson),
        throwsA(isA<ModelParseException>()),
      );
    });

    test('Throws on missing ownerId', () {
      final invalidJson = {...testRoundJson};
      invalidJson.remove('ownerId');
      expect(
        () => Round.fromJson(invalidJson),
        throwsA(isA<ModelParseException>()),
      );
    });

    test('Throws on missing mode', () {
      final invalidJson = {...testRoundJson};
      invalidJson.remove('mode');
      expect(
        () => Round.fromJson(invalidJson),
        throwsA(isA<ModelParseException>()),
      );
    });

    test('Throws on missing startedAt', () {
      final invalidJson = {...testRoundJson};
      invalidJson.remove('startedAt');
      expect(
        () => Round.fromJson(invalidJson),
        throwsA(isA<ModelParseException>()),
      );
    });

    test('Throws on empty id', () {
      final invalidJson = {...testRoundJson, 'id': ''};
      expect(
        () => Round.fromJson(invalidJson),
        throwsA(isA<ModelParseException>()),
      );
    });

    test('Throws on invalid date format', () {
      final invalidJson = {...testRoundJson, 'startedAt': 'invalid-date'};
      expect(
        () => Round.fromJson(invalidJson),
        throwsA(isA<ModelParseException>()),
      );
    });

    test('Handles optional endedAt gracefully', () {
      final jsonWithEndedAt = {
        ...testRoundJson,
        'endedAt': '2026-07-27T15:00:00Z',
      };
      final round = Round.fromJson(jsonWithEndedAt);
      expect(round.endedAt, isNotNull);
    });

    test('Provides default values for optional fields', () {
      final minimalJson = {
        'id': 'round_123',
        'ownerId': 'user_456',
        'mode': 'ace_race',
        'startedAt': '2026-07-27T14:00:00Z',
      };
      final round = Round.fromJson(minimalJson);
      expect(round.courseName, isNull);
      expect(round.includeInStats, false);
      expect(round.rules, isEmpty);
      expect(round.roundPlayers, isEmpty);
    });

    test('copyWith creates new instance with updated fields', () {
      final round = Round.fromJson(testRoundJson);
      final updated = round.copyWith(
        courseName: 'New Course',
        includeInStats: false,
      );
      expect(updated.courseName, 'New Course');
      expect(updated.includeInStats, false);
      expect(updated.id, round.id);
      expect(updated.ownerId, round.ownerId);
    });

    test('toString provides readable format', () {
      final round = Round.fromJson(testRoundJson);
      final str = round.toString();
      expect(str, contains('round_123'));
      expect(str, contains('ace_race'));
      expect(str, contains('Wickham Park'));
    });
  });

  group('RoundChallenge Model', () {
    final testChallengeJson = {
      'id': 'challenge_123',
      'roundId': 'round_456',
      'index': 1,
      'teeChoice': 'short',
      'basketChoice': 'long',
      'throwConstraint': 'forehand',
      'challengeType': 'standard',
    };

    test('Creates RoundChallenge from valid JSON', () {
      final challenge = RoundChallenge.fromJson(testChallengeJson);
      expect(challenge.id, 'challenge_123');
      expect(challenge.roundId, 'round_456');
      expect(challenge.index, 1);
      expect(challenge.teeChoice, 'short');
    });

    test('Throws on missing id', () {
      final invalidJson = {...testChallengeJson};
      invalidJson.remove('id');
      expect(
        () => RoundChallenge.fromJson(invalidJson),
        throwsA(isA<ModelParseException>()),
      );
    });

    test('Throws on invalid index', () {
      final invalidJson = {...testChallengeJson, 'index': 0};
      expect(
        () => RoundChallenge.fromJson(invalidJson),
        throwsA(isA<ModelParseException>()),
      );
    });

    test('Provides default values for optional fields', () {
      final minimalJson = {
        'id': 'challenge_123',
        'roundId': 'round_456',
        'index': 1,
      };
      final challenge = RoundChallenge.fromJson(minimalJson);
      expect(challenge.teeChoice, 'none');
      expect(challenge.basketChoice, 'none');
      expect(challenge.throwConstraint, 'none');
      expect(challenge.challengeType, 'standard');
    });

    test('copyWith creates new instance', () {
      final challenge = RoundChallenge.fromJson(testChallengeJson);
      final updated = challenge.copyWith(teeChoice: 'long');
      expect(updated.teeChoice, 'long');
      expect(updated.basketChoice, challenge.basketChoice);
    });
  });

  group('ScoreEvent Model', () {
    final testEventJson = {
      'id': 'event_123',
      'roundId': 'round_456',
      'roundChallengeId': 'challenge_789',
      'userId': 'user_000',
      'attemptNumber': 1,
      'resultType': 'ace',
      'points': 5,
    };

    test('Creates ScoreEvent from valid JSON', () {
      final event = ScoreEvent.fromJson(testEventJson);
      expect(event.id, 'event_123');
      expect(event.roundId, 'round_456');
      expect(event.attemptNumber, 1);
      expect(event.points, 5);
    });

    test('Throws on missing id', () {
      final invalidJson = {...testEventJson};
      invalidJson.remove('id');
      expect(
        () => ScoreEvent.fromJson(invalidJson),
        throwsA(isA<ModelParseException>()),
      );
    });

    test('Throws on invalid attemptNumber', () {
      final invalidJson = {...testEventJson, 'attemptNumber': 0};
      expect(
        () => ScoreEvent.fromJson(invalidJson),
        throwsA(isA<ModelParseException>()),
      );
    });

    test('Throws on non-integer points', () {
      final invalidJson = {...testEventJson, 'points': 'five'};
      expect(
        () => ScoreEvent.fromJson(invalidJson),
        throwsA(isA<ModelParseException>()),
      );
    });

    test('Accepts negative points', () {
      final eventJson = {...testEventJson, 'points': -3};
      final event = ScoreEvent.fromJson(eventJson);
      expect(event.points, -3);
    });

    test('copyWith creates new instance', () {
      final event = ScoreEvent.fromJson(testEventJson);
      final updated = event.copyWith(points: 3, resultType: 'metal');
      expect(updated.points, 3);
      expect(updated.resultType, 'metal');
      expect(updated.id, event.id);
    });

    test('toString provides readable format', () {
      final event = ScoreEvent.fromJson(testEventJson);
      final str = event.toString();
      expect(str, contains('event_123'));
      expect(str, contains('ace'));
      expect(str, contains('5'));
    });
  });
}
