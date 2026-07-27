import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';
import '../services/firestore_services.dart';
import '../models/round.dart';
import '../models/round_challenge.dart';
import '../models/score_event.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// ============================================
/// AUTH PROVIDERS
/// ============================================

/// Provider for current Firebase user
final currentUserProvider = StreamProvider<User?>((ref) {
  return AuthService.authStateChanges;
});

/// Provider for authentication service
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

/// Future provider for sign in
final signInProvider = FutureProvider.family<bool, (String, String)>((ref, credentials) async {
  final (email, password) = credentials;
  final result = await AuthService.signIn(email, password);
  return result != null;
});

/// Future provider for registration
final registerProvider = FutureProvider.family<bool, (String, String)>((ref, credentials) async {
  final (email, password) = credentials;
  final result = await AuthService.register(email, password);
  return result != null;
});

/// ============================================
/// STORAGE PROVIDERS
/// ============================================

/// Provider for storage service
final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});

/// Future provider for all rounds
final allRoundsProvider = FutureProvider<Map<String, Round>>((ref) async {
  return await StorageService.getRounds();
});

/// Future provider for user's rounds
final userRoundsProvider = FutureProvider.family<List<Round>, String>((ref, userId) async {
  final rounds = await StorageService.getRounds();
  return rounds.values.where((r) => r.ownerId == userId).toList();
});

/// Future provider for round challenges
final roundChallengesProvider = FutureProvider.family<List<RoundChallenge>, String>((ref, roundId) async {
  return await StorageService.getChallengesByRound(roundId);
});

/// Future provider for score events
final scoreEventsProvider = FutureProvider.family<List<ScoreEvent>, String>((ref, roundId) async {
  return await StorageService.getScoreEventsByRound(roundId);
});

/// ============================================
/// FIRESTORE PROVIDERS
/// ============================================

/// Provider for Firestore service
final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService();
});

/// Future provider for creating a round
final createRoundProvider = FutureProvider.family<String, Round>((ref, round) async {
  return await FirestoreService.createRound(round);
});

/// Future provider for creating a challenge
final createChallengeProvider = FutureProvider.family<void, RoundChallenge>((ref, challenge) async {
  await FirestoreService.createChallenge(challenge);
});

/// Future provider for creating a score event
final createScoreEventProvider = FutureProvider.family<void, ScoreEvent>((ref, event) async {
  await FirestoreService.createScoreEvent(event);
});

/// ============================================
/// STATE NOTIFIER PROVIDERS (for mutable state)
/// ============================================

/// State notifier for managing selected round
class SelectedRoundNotifier extends StateNotifier<Round?> {
  SelectedRoundNotifier() : super(null);

  void selectRound(Round round) {
    state = round;
  }

  void clearSelection() {
    state = null;
  }
}

final selectedRoundProvider = StateNotifierProvider<SelectedRoundNotifier, Round?>((ref) {
  return SelectedRoundNotifier();
});

/// State notifier for managing current player
class CurrentPlayerNotifier extends StateNotifier<String?> {
  CurrentPlayerNotifier() : super(null);

  void setCurrentPlayer(String playerId) {
    state = playerId;
  }

  void clearCurrentPlayer() {
    state = null;
  }
}

final currentPlayerProvider = StateNotifierProvider<CurrentPlayerNotifier, String?>((ref) {
  return CurrentPlayerNotifier();
});

/// State notifier for managing rounds list
class RoundsNotifier extends StateNotifier<List<Round>> {
  RoundsNotifier() : super([]);

  Future<void> loadRounds(String userId) async {
    final rounds = await StorageService.getRounds();
    state = rounds.values.where((r) => r.ownerId == userId).toList();
  }

  void addRound(Round round) {
    state = [...state, round];
  }

  void removeRound(String roundId) {
    state = state.where((r) => r.id != roundId).toList();
  }
}

final roundsNotifierProvider = StateNotifierProvider<RoundsNotifier, List<Round>>((ref) {
  return RoundsNotifier();
});
