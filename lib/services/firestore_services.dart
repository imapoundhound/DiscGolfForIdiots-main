import '../models/round.dart';
import '../models/round_challenge.dart';
import '../models/score_event.dart';

class FirestoreService {
  static final Map<String, Round> _rounds = {};
  static final List<RoundChallenge> _challenges = [];
  static final List<ScoreEvent> _scoreEvents = [];

  static Future<String> createRound(Round round) async {
    _rounds[round.id] = round;
    return round.id;
  }

  static Future<void> createChallenge(RoundChallenge challenge) async {
    _challenges.add(challenge);
  }

  static Future<void> createScoreEvent(ScoreEvent event) async {
    _scoreEvents.add(event);
  }

  static Future<List<Round>> getUserRounds(String userId) async {
    return _rounds.values.where((r) => r.ownerId == userId).toList();
  }
}
