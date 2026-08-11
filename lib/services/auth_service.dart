import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  String? get displayName => _auth.currentUser?.displayName;
  String? get userEmail => _auth.currentUser?.email;

  Future<UserCredential> signUpWithEmailAndPassword({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    final trimmedName = fullName.trim();
    if (trimmedName.isNotEmpty) {
      final user = credential.user;
      if (user != null) {
        await user.updateDisplayName(trimmedName);
        await user.reload();
      }
    }

    return credential;
  }

  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
