import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static User? get currentUser => _auth.currentUser;

  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  static Future<UserCredential?> signIn(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      debugPrint('Sign in error: $e');
      return null;
    }
  }

  static Future<UserCredential?> register(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      debugPrint('Register error: $e');
      return null;
    }
  }

  static Future<void> signOut() async {
    await _auth.signOut();
  }
}
