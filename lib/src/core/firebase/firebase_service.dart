import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ocdcoach/firebase_options.dart';

/// Firebase service
/// Handles Firebase initialization and authentication
class FirebaseService {
  static Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  static Future<User?> signInAnonymously() async {
    try {
      final userCredential = await FirebaseAuth.instance.signInAnonymously();
      return userCredential.user;
    } catch (e) {
      // Handle error silently for MVP
      return null;
    }
  }

  static User? get currentUser => FirebaseAuth.instance.currentUser;

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}

