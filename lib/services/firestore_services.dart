import '../models/round.dart';
import '../models/round_challenge.dart';
import '../models/score_event.dart';
import 'storage_service.dart';

/// Service for managing game data with persistent storage
class FirestoreService {
  static Future<String> createRound(Round round) async {
    return await StorageService.saveRound(round);
  }

  static Future<void> createChallenge(RoundChallenge challenge) async {
    await StorageService.saveChallenge(challenge);
  }

  static Future<void> createScoreEvent(ScoreEvent event) async {
    await StorageService.saveScoreEvent(event);
  }

  static Future<List<Round>> getUserRounds(String userId) async {
    final rounds = await StorageService.getRounds();
    return rounds.values.where((r) => r.ownerId == userId).toList();
  }

  static Future<List<RoundChallenge>> getRoundChallenges(String roundId) async {
    return await StorageService.getChallengesByRound(roundId);
  }

  static Future<List<ScoreEvent>> getRoundScores(String roundId) async {
    return await StorageService.getScoreEventsByRound(roundId);
  }
}
