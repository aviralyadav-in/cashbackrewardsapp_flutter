import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoriteService {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  FavoriteService({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  bool get isUserLoggedIn => _auth.currentUser != null;

  // Get the currently logged-in user's Firebase UID
  String? get currentUserId => _auth.currentUser?.uid;
  String? get _userId => currentUserId;

  // Get this user's favorites collection
  CollectionReference<Map<String, dynamic>>? get _favoritesCollection {
    final uid = _userId;
    if (uid == null) return null;
    return _firestore.collection('users').doc(uid).collection('favorites');
  }

  // Get all favorite product IDs
  Future<Set<int>> getFavoriteProductIds() async {
    final collection = _favoritesCollection;
    if (collection == null) return {};

    try {
      final snapshot = await collection.get();

      return snapshot.docs
          .map((doc) => int.tryParse(doc.id))
          .whereType<int>()
          .toSet();
    } catch (e) {
      debugPrint('Error getting favorite product IDs from Firestore: $e');
      return {};
    }
  }

  // Add a product to favorites
  Future<void> addFavorite(int productId) async {
    final collection = _favoritesCollection;
    if (collection == null) return;

    try {
      await collection.doc(productId.toString()).set({
        'productId': productId,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error adding favorite to Firestore: $e');
    }
  }

  // Remove a product from favorites
  Future<void> removeFavorite(int productId) async {
    final collection = _favoritesCollection;
    if (collection == null) return;

    try {
      await collection.doc(productId.toString()).delete();
    } catch (e) {
      debugPrint('Error removing favorite from Firestore: $e');
    }
  }
}