import 'package:ocdcoach/src/core/firebase/firebase_service.dart';

/// Authentication service
/// Handles anonymous authentication
class AuthService {
  /// Sign in anonymously
  /// Returns true if successful, false otherwise
  static Future<bool> signInAnonymously() async {
    try {
      final user = await FirebaseService.signInAnonymously();
      return user != null;
    } catch (e) {
      return false;
    }
  }

  /// Check if user is authenticated
  static bool get isAuthenticated => FirebaseService.currentUser != null;

  /// Get current user ID
  static String? get currentUserId => FirebaseService.currentUser?.uid;
}

