import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Custom exception for authentication errors
class AuthException implements Exception {
  final String message;
  final String? code;

  AuthException({required this.message, this.code});

  @override
  String toString() => message;
}

/// Service for managing user authentication with Firebase
class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Get the currently authenticated user
  static User? get currentUser => _auth.currentUser;

  /// Stream of authentication state changes
  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Check if user is currently authenticated
  static bool get isAuthenticated => _auth.currentUser != null;

  /// Get current user ID safely
  static String? get currentUserId => _auth.currentUser?.uid;

  /// Sign in with email and password
  /// Throws [AuthException] on failure
  static Future<User?> signIn(String email, String password) async {
    try {
      // Validate inputs
      if (email.isEmpty || password.isEmpty) {
        throw AuthException(
          message: 'Email and password cannot be empty',
          code: 'invalid_input',
        );
      }

      if (!_isValidEmail(email)) {
        throw AuthException(
          message: 'Invalid email format',
          code: 'invalid_email',
        );
      }

      if (password.length < 6) {
        throw AuthException(
          message: 'Password must be at least 6 characters',
          code: 'weak_password',
        );
      }

      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      debugPrint('✅ Sign in successful for: ${credential.user?.email}');
      return credential.user;
    } on FirebaseAuthException catch (e) {
      final message = _getFirebaseErrorMessage(e.code);
      debugPrint('❌ Firebase Auth Error: ${e.code} - $message');
      throw AuthException(message: message, code: e.code);
    } catch (e) {
      debugPrint('❌ Sign in error: $e');
      throw AuthException(
        message: 'An unexpected error occurred during sign in',
        code: 'unknown_error',
      );
    }
  }

  /// Register a new user with email and password
  /// Throws [AuthException] on failure
  static Future<User?> register(String email, String password) async {
    try {
      // Validate inputs
      if (email.isEmpty || password.isEmpty) {
        throw AuthException(
          message: 'Email and password cannot be empty',
          code: 'invalid_input',
        );
      }

      if (!_isValidEmail(email)) {
        throw AuthException(
          message: 'Invalid email format',
          code: 'invalid_email',
        );
      }

      if (password.length < 6) {
        throw AuthException(
          message: 'Password must be at least 6 characters',
          code: 'weak_password',
        );
      }

      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      debugPrint('✅ Registration successful for: ${credential.user?.email}');
      return credential.user;
    } on FirebaseAuthException catch (e) {
      final message = _getFirebaseErrorMessage(e.code);
      debugPrint('❌ Firebase Auth Error: ${e.code} - $message');
      throw AuthException(message: message, code: e.code);
    } catch (e) {
      debugPrint('❌ Registration error: $e');
      throw AuthException(
        message: 'An unexpected error occurred during registration',
        code: 'unknown_error',
      );
    }
  }

  /// Sign out the current user
  /// Throws [AuthException] on failure
  static Future<void> signOut() async {
    try {
      await _auth.signOut();
      debugPrint('✅ Sign out successful');
    } catch (e) {
      debugPrint('❌ Sign out error: $e');
      throw AuthException(
        message: 'Failed to sign out',
        code: 'signout_error',
      );
    }
  }

  /// Send password reset email
  /// Throws [AuthException] on failure
  static Future<void> sendPasswordResetEmail(String email) async {
    try {
      if (email.isEmpty) {
        throw AuthException(
          message: 'Email cannot be empty',
          code: 'invalid_input',
        );
      }

      if (!_isValidEmail(email)) {
        throw AuthException(
          message: 'Invalid email format',
          code: 'invalid_email',
        );
      }

      await _auth.sendPasswordResetEmail(email: email.trim());
      debugPrint('✅ Password reset email sent to: $email');
    } on FirebaseAuthException catch (e) {
      final message = _getFirebaseErrorMessage(e.code);
      debugPrint('❌ Firebase Auth Error: ${e.code} - $message');
      throw AuthException(message: message, code: e.code);
    } catch (e) {
      debugPrint('❌ Password reset error: $e');
      throw AuthException(
        message: 'Failed to send password reset email',
        code: 'password_reset_error',
      );
    }
  }

  /// Update user email
  /// Throws [AuthException] on failure
  static Future<void> updateEmail(String newEmail) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw AuthException(
          message: 'No user is currently signed in',
          code: 'no_user',
        );
      }

      if (!_isValidEmail(newEmail)) {
        throw AuthException(
          message: 'Invalid email format',
          code: 'invalid_email',
        );
      }

      await user.verifyBeforeUpdateEmail(newEmail.trim());
      debugPrint('✅ Verification email sent for new email: $newEmail');
    } on FirebaseAuthException catch (e) {
      final message = _getFirebaseErrorMessage(e.code);
      debugPrint('❌ Firebase Auth Error: ${e.code} - $message');
      throw AuthException(message: message, code: e.code);
    } catch (e) {
      debugPrint('❌ Update email error: $e');
      throw AuthException(
        message: 'Failed to update email',
        code: 'update_email_error',
      );
    }
  }

  /// Update user password
  /// Throws [AuthException] on failure
  static Future<void> updatePassword(String newPassword) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw AuthException(
          message: 'No user is currently signed in',
          code: 'no_user',
        );
      }

      if (newPassword.isEmpty) {
        throw AuthException(
          message: 'Password cannot be empty',
          code: 'invalid_input',
        );
      }

      if (newPassword.length < 6) {
        throw AuthException(
          message: 'Password must be at least 6 characters',
          code: 'weak_password',
        );
      }

      await user.updatePassword(newPassword);
      debugPrint('✅ Password updated successfully');
    } on FirebaseAuthException catch (e) {
      final message = _getFirebaseErrorMessage(e.code);
      debugPrint('❌ Firebase Auth Error: ${e.code} - $message');
      throw AuthException(message: message, code: e.code);
    } catch (e) {
      debugPrint('❌ Update password error: $e');
      throw AuthException(
        message: 'Failed to update password',
        code: 'update_password_error',
      );
    }
  }

  /// Validate email format
  static bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  /// Convert Firebase error codes to user-friendly messages
  static String _getFirebaseErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No account found with this email address';
      case 'wrong-password':
        return 'Incorrect password. Please try again';
      case 'email-already-in-use':
        return 'An account already exists with this email';
      case 'invalid-email':
        return 'Invalid email address format';
      case 'operation-not-allowed':
        return 'Operation not allowed. Please contact support';
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters';
      case 'user-disabled':
        return 'This account has been disabled';
      case 'too-many-requests':
        return 'Too many login attempts. Please try again later';
      case 'invalid-credential':
        return 'Invalid email or password';
      case 'requires-recent-login':
        return 'Please sign in again to perform this action';
      case 'network-request-failed':
        return 'Network error. Please check your connection';
      default:
        return 'An authentication error occurred. Please try again';
    }
  }
}
