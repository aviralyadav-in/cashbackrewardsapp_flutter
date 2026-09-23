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
  List<Map<String, dynamic>> _walletTransactions = [];

  UserModel? get user => _user;
  String get uid => _user?.uid ?? '';
  String get fullName => _user?.fullName ?? '';
  String get email => _user?.email ?? '';
  String get phoneNumber => _user?.phoneNumber ?? '';
  String get referralCode => _user?.referralCode ?? '';
  int get coins => _user?.coins ?? 0;
  double get walletBalance => _user?.walletBalance ?? 0.0;
  bool get hasShopped => _user?.hasShopped ?? false;
  double get confirmedCashback => _user?.confirmedCashback ?? 0.0;
  double get pendingCashback => _user?.pendingCashback ?? 0.0;
  double get referralEarnings => _user?.referralEarnings ?? 0.0;
  double get affiliateEarnings => _user?.affiliateEarnings ?? 0.0;
  List<Map<String, dynamic>> get walletTransactions => _walletTransactions;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null && _user!.uid.isNotEmpty;

  UserProvider() {
    loadUserProfile();
  }

  /// Fast local cache load (< 5ms) for instant, non-blocking UI rendering
  Future<void> loadCachedProfile() async {
    try {
      final cachedJson = await _storageService.getUserProfileCache();
      if (cachedJson != null && cachedJson.isNotEmpty) {
        _user = UserModel.fromJson(cachedJson);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('UserProvider: Error reading user profile from cache: $e');
    }
  }

  /// Loads user profile from local cache first for instant UI response,
  /// then refreshes the latest data from PostgreSQL via GET /api/users/:id.
  /// If [awaitRemoteSync] is false (default), the remote fetch runs in the background
  /// without delaying the UI or splash screen navigation.
  Future<void> loadUserProfile({bool awaitRemoteSync = false}) async {
    _isLoading = true;
    _errorMessage = null;

    try {
      // 1. Instant local cache load
      await loadCachedProfile();

      // 2. Fetch fresh user data from Node.js / PostgreSQL backend
      if (awaitRemoteSync) {
        await _syncRemoteUserData();
      } else {
        _syncRemoteUserData();
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Synchronizes user profile and wallet data in the background without blocking the UI
  Future<void> _syncRemoteUserData() async {
    try {
      final storedUserId = await _storageService.getUserId();
      final targetId = storedUserId ?? _user?.uid;

      if (targetId != null && targetId.isNotEmpty) {
        final remoteUser = await _authService.getUserProfile(targetId);
        if (remoteUser != null) {
          _user = remoteUser;
          await _storageService.saveUserId(remoteUser.uid);
          await _storageService.saveUserProfileCache(remoteUser.toJson());
          notifyListeners();
        }
        await loadWalletData();
      }
    } catch (e) {
      debugPrint('UserProvider: Background sync error: $e');
    }
  }

  /// Loads dynamic wallet balance, shopping stats, and transaction history from backend
  Future<void> loadWalletData() async {
    final targetId = _user?.uid ?? await _storageService.getUserId();
    if (targetId == null || targetId.isEmpty) return;

    try {
      final walletData = await _authService.getUserWallet(targetId);
      if (walletData != null) {
        double parseDouble(dynamic v) {
          if (v == null) return 0.0;
          if (v is double) return v;
          if (v is int) return v.toDouble();
          return double.tryParse(v.toString()) ?? 0.0;
        }

        final balance = parseDouble(walletData['balance']);
        final confirmed = parseDouble(walletData['confirmedCashback']);
        final pending = parseDouble(walletData['pendingCashback']);
        final referral = parseDouble(walletData['referralEarnings']);
        final affiliate = parseDouble(walletData['affiliateEarnings']);
        final shopped = walletData['hasShopped'] == true;

        if (_user != null) {
          _user = _user!.copyWith(
            walletBalance: balance,
            confirmedCashback: confirmed,
            pendingCashback: pending,
            referralEarnings: referral,
            affiliateEarnings: affiliate,
            hasShopped: shopped,
            coins: balance.round(),
          );
          await _storageService.saveUserProfileCache(_user!.toJson());
        }

        if (walletData['transactions'] is List) {
          _walletTransactions = (walletData['transactions'] as List)
              .map((e) => Map<String, dynamic>.from(e as Map))
              .toList();
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading wallet data: $e');
    }
  }

  /// Sets the active authenticated user profile in state and storage
  Future<void> setUser(UserModel user) async {
    _user = user;
    await _storageService.saveUserId(user.uid);
    await _storageService.saveUserProfileCache(user.toJson());
    notifyListeners();
    await loadWalletData();
  }

  /// Performs Login with PostgreSQL Backend using phone number, email, or identifier
  Future<Map<String, dynamic>> login({
    String? phoneNumber,
    String? email,
    String? identifier,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _authService.login(
        phoneNumber: phoneNumber,
        email: email,
        identifier: identifier,
      );
      if (result['success'] == true && result['user'] != null) {
        final loggedInUser = result['user'] as UserModel;
        await setUser(loggedInUser);
      }
      return result;
    } catch (e) {
      _errorMessage = e.toString();
      return {
        'success': false,
        'message': e.toString(),
      };
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Performs Google Sign-In with backend sync and optional referral code
  Future<Map<String, dynamic>> signInWithGoogle({String? referralCode}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _authService.signInWithGoogle(referralCode: referralCode);
      if (result['success'] == true && result['user'] != null) {
        final googleUser = result['user'] as UserModel;
        await setUser(googleUser);
      }
      return result;
    } catch (e) {
      _errorMessage = e.toString();
      return {
        'success': false,
        'message': e.toString(),
      };
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Registers user with Name, Email, Phone Number, and optional Referral Code in PostgreSQL Backend
  Future<Map<String, dynamic>> signup({
    required String name,
    String? email,
    String? phoneNumber,
    String? referralCode,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _authService.signup(
        name: name,
        email: email,
        phoneNumber: phoneNumber,
        referralCode: referralCode,
      );
      if (result['success'] == true && result['user'] != null) {
        final signedUpUser = result['user'] as UserModel;
        await setUser(signedUpUser);
      }
      return result;
    } catch (e) {
      _errorMessage = e.toString();
      return {
        'success': false,
        'message': e.toString(),
      };
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Fetches referral statistics and history for the active user
  Future<Map<String, dynamic>?> getUserReferrals() async {
    final targetId = _user?.uid ?? await _storageService.getUserId();
    if (targetId == null || targetId.isEmpty) return null;
    return await _authService.getUserReferrals(targetId);
  }

  /// Saves or updates the user profile data
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
      final currentUid = _user?.uid ?? await _storageService.getUserId() ?? '';

      if (currentUid.isNotEmpty) {
        final updatedRemote = await _authService.updateUserProfile(
          userId: currentUid,
          name: cleanName,
          email: cleanEmail,
          phoneNumber: cleanPhone,
        );
        if (updatedRemote != null) {
          _user = updatedRemote;
          await _storageService.saveUserProfileCache(_user!.toJson());
          _isLoading = false;
          notifyListeners();
          return true;
        }
      }

      // Update in-memory state
      _user = (_user ?? const UserModel(uid: '', fullName: '', email: '', phoneNumber: '')).copyWith(
        uid: currentUid,
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

  /// Sets initial user profile data
  Future<void> setInitialUserProfile({
    required String uid,
    required String fullName,
    required String email,
    required String phoneNumber,
  }) async {
    _user = UserModel(
      uid: uid,
      fullName: fullName.trim(),
      email: email.trim().toLowerCase(),
      phoneNumber: phoneNumber.trim(),
    );

    if (uid.isNotEmpty) {
      await _storageService.saveUserId(uid);
    }
    await _storageService.saveUserProfileCache(_user!.toJson());
    notifyListeners();
  }

  /// Clears user session data on logout.
  Future<void> clearUser() async {
    _user = null;
    _walletTransactions = [];
    _errorMessage = null;
    await _authService.signOut();
    notifyListeners();
  }
}
