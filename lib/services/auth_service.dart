import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  String? get displayName => _auth.currentUser?.displayName;
  String? get userEmail => _auth.currentUser?.email;

  Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    if (uid.trim().isEmpty) return null;
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return doc.data();
      }
    } catch (_) {}
    return null;
  }

  Future<Map<String, dynamic>?> getUserByPhone(String phoneNumber) async {
    final cleanPhone = phoneNumber.trim();
    if (cleanPhone.isEmpty) return null;
    final query = await _firestore
        .collection('users')
        .where('phoneNumber', isEqualTo: cleanPhone)
        .limit(1)
        .get();

    if (query.docs.isNotEmpty) {
      return query.docs.first.data();
    }
    return null;
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final cleanEmail = email.trim().toLowerCase();
    if (cleanEmail.isEmpty) return null;
    final query = await _firestore
        .collection('users')
        .where('email', isEqualTo: cleanEmail)
        .limit(1)
        .get();

    if (query.docs.isNotEmpty) {
      return query.docs.first.data();
    }
    return null;
  }

  Future<void> saveUserProfile({
    required String uid,
    required String fullName,
    required String email,
    required String phoneNumber,
  }) async {
    final cleanName = fullName.trim();
    final cleanEmail = email.trim().toLowerCase();
    final cleanPhone = phoneNumber.trim();

    await _firestore.collection('users').doc(uid).set({
      'uid': uid,
      'fullName': cleanName,
      'email': cleanEmail,
      'phoneNumber': cleanPhone,
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    final user = _auth.currentUser;
    if (user != null) {
      if (cleanName.isNotEmpty) {
        await user.updateDisplayName(cleanName);
      }
      if (cleanEmail.isNotEmpty && user.email == null) {
        try {
          await user.verifyBeforeUpdateEmail(cleanEmail);
        } catch (_) {}
      }
    }
  }

  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required PhoneVerificationCompleted verificationCompleted,
    required PhoneVerificationFailed verificationFailed,
    required PhoneCodeSent codeSent,
    required PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout,
    int? resendToken,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber.trim(),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      forceResendingToken: resendToken,
      timeout: const Duration(seconds: 60),
    );
  }

  Future<UserCredential> signInWithPhoneCredential(
    AuthCredential credential,
  ) async {
    return await _auth.signInWithCredential(credential);
  }

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

