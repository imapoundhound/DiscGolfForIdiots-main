import 'package:flutter_test/flutter_test.dart';
import 'package:disc_golf_for_idiots/models/round.dart';
import 'package:disc_golf_for_idiots/services/auth_service.dart';

void main() {
  group('AuthService', () {
    group('Email Validation', () {
      test('_isValidEmail accepts valid emails', () {
        expect(AuthService.isValidEmail('user@example.com'), true);
        expect(AuthService.isValidEmail('test.email+tag@domain.co.uk'), true);
        expect(AuthService.isValidEmail('john.doe@company.org'), true);
      });

      test('_isValidEmail rejects invalid emails', () {
        expect(AuthService.isValidEmail('invalid'), false);
        expect(AuthService.isValidEmail('user@'), false);
        expect(AuthService.isValidEmail('@example.com'), false);
        expect(AuthService.isValidEmail('user @example.com'), false);
        expect(AuthService.isValidEmail(''), false);
      });
    });

    group('Error Message Mapping', () {
      test('Maps Firebase error codes to user-friendly messages', () {
        expect(
          AuthService.getFirebaseErrorMessage('user-not-found'),
          'No account found with this email address',
        );
        expect(
          AuthService.getFirebaseErrorMessage('wrong-password'),
          'Incorrect password. Please try again',
        );
        expect(
          AuthService.getFirebaseErrorMessage('email-already-in-use'),
          'An account already exists with this email',
        );
        expect(
          AuthService.getFirebaseErrorMessage('weak-password'),
          'Password is too weak. Use at least 6 characters',
        );
        expect(
          AuthService.getFirebaseErrorMessage('too-many-requests'),
          'Too many login attempts. Please try again later',
        );
      });

      test('Returns default message for unknown error codes', () {
        expect(
          AuthService.getFirebaseErrorMessage('unknown-code'),
          'An authentication error occurred. Please try again',
        );
      });
    });

    group('AuthException', () {
      test('AuthException formats message correctly', () {
        final exception = AuthException(
          message: 'Test error',
          code: 'test_code',
        );
        expect(exception.toString(), 'Test error');
        expect(exception.code, 'test_code');
      });
    });

    group('Input Validation', () {
      test('Validates empty email', () {
        expect(() {
          AuthService.validateSignInInputs('', 'password123');
        }, throwsA(isA<AuthException>().having(
          (e) => e.code,
          'code',
          'invalid_input',
        )));
      });

      test('Validates empty password', () {
        expect(() {
          AuthService.validateSignInInputs('user@example.com', '');
        }, throwsA(isA<AuthException>().having(
          (e) => e.code,
          'code',
          'invalid_input',
        )));
      });

      test('Validates weak password', () {
        expect(() {
          AuthService.validateSignInInputs('user@example.com', '12345');
        }, throwsA(isA<AuthException>().having(
          (e) => e.code,
          'code',
          'weak_password',
        )));
      });

      test('Validates invalid email format', () {
        expect(() {
          AuthService.validateSignInInputs('invalid-email', 'password123');
        }, throwsA(isA<AuthException>().having(
          (e) => e.code,
          'code',
          'invalid_email',
        )));
      });

      test('Accepts valid inputs', () {
        expect(
          () => AuthService.validateSignInInputs('user@example.com', 'password123'),
          returnsNormally,
        );
      });
    });
  });
}
