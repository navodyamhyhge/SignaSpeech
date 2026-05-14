// lib/services/auth_service.dart
// Handles all Firebase Authentication operations.
// Uses placeholder logic when Firebase is not yet configured.

import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // Singleton instance
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ── Stream ────────────────────────────────────────────────────────────────

  /// Stream that emits auth state changes (logged in / logged out)
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Currently logged-in user (null if not authenticated)
  User? get currentUser => _auth.currentUser;

  // ── Email / Password ──────────────────────────────────────────────────────

  /// Sign in with email and password.
  /// Returns the [UserCredential] or throws a [FirebaseAuthException].
  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  /// Create a new account with email and password.
  /// Also updates the display name if [displayName] is provided.
  Future<UserCredential> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    // Update display name in Firebase profile
    if (displayName != null && displayName.isNotEmpty) {
      await credential.user?.updateDisplayName(displayName);
    }

    return credential;
  }

  /// Sign out the current user.
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Send a password reset email.
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  /// Maps [FirebaseAuthException] codes to user-friendly messages.
  static String getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'weak-password':
        return 'Password must be at least 6 characters.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'network-request-failed':
        return 'Network error. Please check your connection.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      default:
        return e.message ?? 'An unexpected error occurred.';
    }
  }
}
