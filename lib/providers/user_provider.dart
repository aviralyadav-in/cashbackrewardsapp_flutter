import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';

class UserProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final AppStorageService _storageService = AppStorageService();

  UserModel? _user;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get user => _user;
  String get fullName => _user?.fullName ?? '';
  String get email => _user?.email ?? '';
  String get phoneNumber => _user?.phoneNumber ?? '';
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null || _authService.currentUser != null;

  UserProvider() {
    loadUserProfile();
  }

  /// Loads user profile from local cache first for instant UI response,
  /// then fetches updated data from Firestore.
  Future<void> loadUserProfile() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // 1. Try loading cached profile data
      final cachedJson = await _storageService.getUserProfileCache();
      if (cachedJson != null && cachedJson.isNotEmpty) {
        try {
          _user = UserModel.fromJson(cachedJson);
          notifyListeners();
        } catch (_) {}
      }

      // 2. Fetch remote user data from Firebase Auth / Firestore
      final authUser = _authService.currentUser;
      if (authUser != null) {
        final firestoreData = await _authService.getUserProfile(authUser.uid);
        if (firestoreData != null) {
          _user = UserModel.fromMap(firestoreData, defaultUid: authUser.uid);
        } else {
          // Fallback to Firebase Auth user properties if Firestore record doesn't exist yet
          _user = UserModel(
            uid: authUser.uid,
            fullName: authUser.displayName ?? _user?.fullName ?? '',
            email: authUser.email ?? _user?.email ?? '',
            phoneNumber: authUser.phoneNumber ?? _user?.phoneNumber ?? '',
          );
        }

        // Cache the refreshed model locally
        if (_user != null) {
          await _storageService.saveUserProfileCache(_user!.toJson());
        }
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Saves or updates the user profile data in Firestore (if available), updates local cache,
  /// and notifies all UI listeners immediately.
  Future<bool> updateUserProfile({
    required String fullName,
    required String email,
    required String phoneNumber,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final cleanName = fullName.trim();
    final cleanEmail = email.trim().toLowerCase();
    final cleanPhone = phoneNumber.trim();

    try {
      final authUser = _authService.currentUser;
      final uid = authUser?.uid ?? _user?.uid ?? 'user_${DateTime.now().millisecondsSinceEpoch}';

      if (authUser != null) {
        try {
          await _authService.saveUserProfile(
            uid: uid,
            fullName: cleanName,
            email: cleanEmail,
            phoneNumber: cleanPhone,
          );
        } catch (_) {}
      }

      // Update in-memory state
      _user = UserModel(
        uid: uid,
        fullName: cleanName,
        email: cleanEmail,
        phoneNumber: cleanPhone,
      );

      // Save to local cache
      await _storageService.saveUserProfileCache(_user!.toJson());

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to update profile: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Sets initial user profile data upon Login/Signup.
  Future<void> setInitialUserProfile({
    required String uid,
    required String fullName,
    required String email,
    required String phoneNumber,
  }) async {
    final cleanName = fullName.trim();
    final cleanEmail = email.trim().toLowerCase();
    final cleanPhone = phoneNumber.trim();

    _user = UserModel(
      uid: uid,
      fullName: cleanName,
      email: cleanEmail,
      phoneNumber: cleanPhone,
    );

    // Try saving to Firestore if Firebase user is authenticated
    if (uid.isNotEmpty) {
      try {
        await _authService.saveUserProfile(
          uid: uid,
          fullName: cleanName,
          email: cleanEmail,
          phoneNumber: cleanPhone,
        );
      } catch (_) {}
    }

    // Cache locally so profile data persists across restarts
    await _storageService.saveUserProfileCache(_user!.toJson());
    notifyListeners();
  }

  /// Clears user session data on logout.
  Future<void> clearUser() async {
    _user = null;
    _errorMessage = null;
    await _storageService.clearUserProfileCache();
    notifyListeners();
  }
}
