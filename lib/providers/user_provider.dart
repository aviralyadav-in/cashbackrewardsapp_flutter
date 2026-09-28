import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';
import '../widgets/wallet/wallet_spending_graph_card.dart';

class UserProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final AppStorageService _storageService = AppStorageService();

  UserModel? _user;
  bool _isLoading = false;
  bool _isLoadingWallet = false;
  String? _errorMessage;
  List<Map<String, dynamic>> _walletTransactions = [];
  List<SpendingDataPoint> _dailySpending = [];
  List<SpendingDataPoint> _monthlySpending = [];
  double _totalSpendAllTime = 0.0;
  double _totalCashbackAllTime = 0.0;
  int _totalOrdersCount = 0;
  int _totalReferred = 0;
  int _purchasedUsersCount = 0;
  int _pendingPurchaseCount = 0;
  List<Map<String, dynamic>> _referredUsers = [];

  UserModel? get user => _user;
  String get uid => _user?.uid ?? '';
  String get fullName => _user?.fullName ?? '';
  String get email => _user?.email ?? '';
  String get phoneNumber => _user?.phoneNumber ?? '';
  String get avatarUrl => (_user?.avatarUrl != null && _user!.avatarUrl!.trim().isNotEmpty)
      ? _user!.avatarUrl!.trim()
      : 'assets/avatars/avatar.png';
  String get referralCode => _user?.referralCode ?? '';
  int get coins => _user?.coins ?? 0;
  double get walletBalance => _user?.walletBalance ?? 0.0;
  double get remainingBalance => _user?.remainingBalance ?? _user?.walletBalance ?? 0.0;
  bool get hasShopped => _user?.hasShopped ?? false;
  double get confirmedCashback => _user?.confirmedCashback ?? 0.0;
  double get pendingCashback => _user?.pendingCashback ?? 0.0;
  double get referralEarnings => _user?.referralEarnings ?? 0.0;
  double get affiliateEarnings => _user?.affiliateEarnings ?? 0.0;
  List<Map<String, dynamic>> get walletTransactions => _walletTransactions;
  List<SpendingDataPoint> get dailySpending => _dailySpending;
  List<SpendingDataPoint> get monthlySpending => _monthlySpending;
  double get totalSpendAllTime => _totalSpendAllTime;
  double get totalCashbackAllTime => _totalCashbackAllTime;
  int get totalOrdersCount => _totalOrdersCount;
  int get totalReferred => _totalReferred;
  int get purchasedUsersCount => _purchasedUsersCount;
  int get pendingPurchaseCount => _pendingPurchaseCount;
  List<Map<String, dynamic>> get referredUsers => _referredUsers;

  bool get isLoading => _isLoading;
  bool get isLoadingWallet => _isLoadingWallet;
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
        await getUserReferrals();
      }
    } catch (e) {
      debugPrint('UserProvider: Background sync error: $e');
    }
  }

  /// Loads dynamic wallet balance, shopping stats, and transaction history from backend
  Future<void> loadWalletData() async {
    final targetId = _user?.uid ?? await _storageService.getUserId();
    if (targetId == null || targetId.isEmpty) {
      final cachedProfile = await _storageService.getUserProfileCache();
      if (cachedProfile != null && cachedProfile.isNotEmpty) {
        try {
          final map = jsonDecode(cachedProfile);
          final cachedId = map['uid']?.toString();
          if (cachedId != null && cachedId.isNotEmpty) {
            _user = UserModel.fromJson(map);
            return loadWalletData();
          }
        } catch (_) {}
      }
      return;
    }

    _isLoadingWallet = true;
    notifyListeners();

    try {
      final walletData = await _authService.getUserWallet(targetId);
      if (walletData != null) {
        double parseDouble(dynamic v) {
          if (v == null) return 0.0;
          if (v is double) return v;
          if (v is int) return v.toDouble();
          return double.tryParse(v.toString()) ?? 0.0;
        }

        final balance = parseDouble(walletData['balance'] ?? walletData['walletBalance']);
        final remaining = parseDouble(walletData['remainingBalance'] ?? walletData['remaining_balance'] ?? balance);
        final confirmed = parseDouble(walletData['confirmedCashback']);
        final pending = parseDouble(walletData['pendingCashback']);
        final referral = parseDouble(walletData['referralEarnings']);
        final affiliate = parseDouble(walletData['affiliateEarnings']);
        final shopped = walletData['hasShopped'] == true;

        if (_user != null) {
          _user = _user!.copyWith(
            walletBalance: balance,
            remainingBalance: remaining,
            confirmedCashback: confirmed,
            pendingCashback: pending,
            referralEarnings: referral,
            affiliateEarnings: affiliate,
            hasShopped: shopped,
            coins: balance.round(),
          );
          await _storageService.saveUserProfileCache(_user!.toJson());
        } else {
          _user = UserModel(
            uid: targetId,
            fullName: '',
            email: '',
            phoneNumber: '',
            walletBalance: balance,
            remainingBalance: remaining,
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

        if (walletData['spendingAnalytics'] is Map) {
          final analytics = walletData['spendingAnalytics'] as Map;
          if (analytics['daily'] is List) {
            _dailySpending = (analytics['daily'] as List)
                .map((e) => SpendingDataPoint.fromMap(Map<String, dynamic>.from(e as Map)))
                .toList();
          }
          if (analytics['monthly'] is List) {
            _monthlySpending = (analytics['monthly'] as List)
                .map((e) => SpendingDataPoint.fromMap(Map<String, dynamic>.from(e as Map)))
                .toList();
          }
          _totalSpendAllTime = parseDouble(analytics['totalSpend']);
          _totalCashbackAllTime = parseDouble(analytics['totalCashback']);
          _totalOrdersCount = analytics['totalOrders'] is int
              ? analytics['totalOrders'] as int
              : int.tryParse(analytics['totalOrders']?.toString() ?? '0') ?? 0;
        } else {
          final analyticsData = await _authService.getSpendingAnalytics(targetId);
          if (analyticsData != null) {
            if (analyticsData['daily'] is List) {
              _dailySpending = (analyticsData['daily'] as List)
                  .map((e) => SpendingDataPoint.fromMap(Map<String, dynamic>.from(e as Map)))
                  .toList();
            }
            if (analyticsData['monthly'] is List) {
              _monthlySpending = (analyticsData['monthly'] as List)
                  .map((e) => SpendingDataPoint.fromMap(Map<String, dynamic>.from(e as Map)))
                  .toList();
            }
            _totalSpendAllTime = parseDouble(analyticsData['totalSpend']);
            _totalCashbackAllTime = parseDouble(analyticsData['totalCashback']);
            _totalOrdersCount = analyticsData['totalOrders'] is int
                ? analyticsData['totalOrders'] as int
                : int.tryParse(analyticsData['totalOrders']?.toString() ?? '0') ?? 0;
          }
        }
      }
    } catch (e) {
      debugPrint('Error loading wallet data: $e');
    } finally {
      _isLoadingWallet = false;
      notifyListeners();
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
    final res = await _authService.getUserReferrals(targetId);
    if (res != null && res['success'] == true) {
      _totalReferred = res['totalReferred'] is int
          ? res['totalReferred'] as int
          : int.tryParse(res['totalReferred']?.toString() ?? '0') ?? 0;
      _purchasedUsersCount = res['purchasedUsersCount'] is int
          ? res['purchasedUsersCount'] as int
          : int.tryParse(res['purchasedUsersCount']?.toString() ?? '0') ?? 0;
      _pendingPurchaseCount = res['pendingPurchaseCount'] is int
          ? res['pendingPurchaseCount'] as int
          : int.tryParse(res['pendingPurchaseCount']?.toString() ?? '0') ?? 0;
      _referredUsers = (res['referredUsers'] as List<dynamic>?)
              ?.map((e) => Map<String, dynamic>.from(e as Map))
              .toList() ??
          [];
      notifyListeners();
    }
    return res;
  }

  /// Saves or updates the user profile data
  Future<bool> updateUserProfile({
    required String fullName,
    required String email,
    required String phoneNumber,
    String? avatarUrl,
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
          avatarUrl: avatarUrl,
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
        avatarUrl: avatarUrl ?? _user?.avatarUrl,
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

  /// Uploads a new profile photo and updates avatar_url in DB.
  /// Caller passes pre-read [imageBytes] (from XFile.readAsBytes()) and [fileName].
  /// Returns the uploaded avatar URL on success, or null on failure.
  Future<String?> uploadAvatarImage({
    required List<int> imageBytes,
    required String mimeType,
    required String fileName,
  }) async {
    final currentUid = _user?.uid ?? await _storageService.getUserId() ?? '';
    if (currentUid.isEmpty) return null;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final url = await _authService.uploadAvatarImage(
        userId: currentUid,
        imageBytes: imageBytes,
        mimeType: mimeType,
        fileName: fileName,
      );
      if (url != null && url.isNotEmpty) {
        // Update local in-memory user with new avatar URL
        _user = _user?.copyWith(avatarUrl: url);
        if (_user != null) {
          await _storageService.saveUserProfileCache(_user!.toJson());
        }
        _isLoading = false;
        notifyListeners();
        return url;
      }
      _errorMessage = 'Avatar upload failed. Please try again.';
    } catch (e) {
      _errorMessage = 'Error uploading photo: ${e.toString()}';
    }
    _isLoading = false;
    notifyListeners();
    return null;
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
    _dailySpending = [];
    _monthlySpending = [];
    _totalSpendAllTime = 0.0;
    _totalCashbackAllTime = 0.0;
    _totalOrdersCount = 0;
    _errorMessage = null;
    await _authService.signOut();
    notifyListeners();
  }
}
