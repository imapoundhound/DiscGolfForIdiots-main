import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/round.dart';
import '../models/round_challenge.dart';
import '../models/score_event.dart';

class FirestoreService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<String> createRound(Round round) async {
    final docRef = _firestore.collection('rounds').doc();
    await docRef.set(round.toFirestore());
    return docRef.id;
  }

  static Future<void> createChallenge(RoundChallenge challenge) async {
    final docRef = _firestore.collection('roundChallenges').doc();
    await docRef.set(challenge.toFirestore());
  }

  static Future<void> createScoreEvent(ScoreEvent event) async {
    final docRef = _firestore.collection('scoreEvents').doc();
    await docRef.set(event.toFirestore());
  }

  static Stream<List<Round>> getUserRounds(String userId) {
    return _firestore
        .collection('rounds')
        .where('ownerId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Round.fromFirestore(doc)).toList());
  }
}
