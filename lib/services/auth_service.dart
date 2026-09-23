import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import 'storage_service.dart';

class AuthService {
  final AppStorageService _storageService = AppStorageService();
  bool _isGoogleInitialized = false;

  Future<void> _ensureGoogleInitialized() async {
    if (_isGoogleInitialized) return;
    try {
      await GoogleSignIn.instance.initialize();
      _isGoogleInitialized = true;
    } catch (e) {
      debugPrint('GoogleSignIn initialize note: $e');
    }
  }

  /// Default Wi-Fi / Local Area Network IP of the host PC.
  /// Run 'ipconfig' in your PC terminal to check/update your IPv4 address if your Wi-Fi changes.
  static const String defaultLocalIp = '192.168.29.221';
  static const int defaultPort = 5000;

  /// Resolves the backend base URL dynamically:
  /// 1. If passed via '--dart-define=API_URL=http://...', uses that directly.
  /// 2. If passed via '--dart-define=BACKEND_IP=192.168.x.x', uses that IP.
  /// 3. On Windows / macOS / Linux / Web (running on PC): connects to 127.0.0.1:5000.
  /// 4. On physical Android phone / mobile: connects to PC's LAN IP (default: 192.168.29.221:5000).
  static String get baseUrl {
    const customUrl = String.fromEnvironment('API_URL');
    if (customUrl.isNotEmpty) {
      return customUrl;
    }

    const customIp = String.fromEnvironment('BACKEND_IP');
    final host = customIp.isNotEmpty ? customIp : defaultLocalIp;

    // Running on PC / Desktop / Web: connect to local loopback
    if (kIsWeb ||
        defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.linux ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      return 'http://127.0.0.1:$defaultPort/api';
    }

    // Running on Android / iOS (Physical device or network testing)
    return 'http://$host:$defaultPort/api';
  }

  /// Public HTTPS domain used for sharing deals so WhatsApp makes it clickable
  /// and anyone outside local Wi-Fi can open it.
  static String get publicDealUrl {
    const customDealUrl = String.fromEnvironment('DEAL_URL');
    if (customDealUrl.isNotEmpty) {
      return customDealUrl;
    }
    return 'https://literature-shake-cure-helmet.trycloudflare.com';
  }

  /// Checks whether a phone number already exists in PostgreSQL.
  Future<Map<String, dynamic>> checkPhone(String phoneNumber) async {
    return checkIdentifier(phoneNumber);
  }

  /// Checks whether a phone number or email already exists in PostgreSQL.
  Future<Map<String, dynamic>> checkIdentifier(String identifier) async {
    try {
      final clean = identifier.trim();
      final isEmail = clean.contains('@');
      final response = await http
          .post(
            Uri.parse('$baseUrl/auth/check-phone'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              if (isEmail) 'email': clean.toLowerCase() else 'phoneNumber': clean,
              'identifier': clean,
            }),
          )
          .timeout(const Duration(seconds: 4));

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return data;
    } catch (e) {
      return {
        'success': false,
        'message': 'Failed to check account: ${e.toString()}',
      };
    }
  }

  /// Sends a dummy 6-digit OTP to the specified phone number or email.
  Future<Map<String, dynamic>> sendOtp(String identifier) async {
    try {
      final clean = identifier.trim();
      final isEmail = clean.contains('@');
      final response = await http
          .post(
            Uri.parse('$baseUrl/auth/send-otp'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              if (isEmail) 'email': clean.toLowerCase() else 'phoneNumber': clean,
              'identifier': clean,
            }),
          )
          .timeout(const Duration(seconds: 4));

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return data;
    } catch (e) {
      return {
        'success': false,
        'message': 'Failed to connect to backend: ${e.toString()}',
      };
    }
  }

  /// Verifies the 6-digit OTP.
  Future<Map<String, dynamic>> verifyOtp({
    String? phoneNumber,
    String? identifier,
    required String otp,
  }) async {
    final target = (identifier ?? phoneNumber ?? '').trim();
    try {
      final isEmail = target.contains('@');
      final response = await http
          .post(
            Uri.parse('$baseUrl/auth/verify-otp'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              if (isEmail) 'email': target.toLowerCase() else 'phoneNumber': target,
              'identifier': target,
              'otp': otp.trim(),
            }),
          )
          .timeout(const Duration(seconds: 4));

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return data;
    } catch (e) {
      return {
        'success': false,
        'message': 'Failed to verify OTP: ${e.toString()}',
      };
    }
  }

  /// Registers a new user with Name, Email, Phone Number, and optional Referral Code.
  Future<Map<String, dynamic>> signup({
    required String name,
    String? email,
    String? phoneNumber,
    String? referralCode,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/auth/signup'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'name': name.trim(),
              if (email != null && email.trim().isNotEmpty)
                'email': email.trim().toLowerCase(),
              if (phoneNumber != null && phoneNumber.trim().isNotEmpty)
                'phoneNumber': phoneNumber.trim(),
              if (referralCode != null && referralCode.trim().isNotEmpty)
                'referralCode': referralCode.trim(),
            }),
          )
          .timeout(const Duration(seconds: 5));

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 201 && data['success'] == true) {
        final userData = data['user'] as Map<String, dynamic>;
        final user = UserModel.fromMap(userData);
        await _storageService.saveUserId(user.uid);
        await _storageService.saveUserProfileCache(user.toJson());
        return {
          'success': true,
          'message': data['message'] ?? 'Signup successful',
          'user': user,
        };
      }

      return {
        'success': false,
        'message': data['message'] ?? 'Failed to sign up',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error signing up: ${e.toString()}',
      };
    }
  }

  /// Logs in an existing user with their phone number or email.
  Future<Map<String, dynamic>> login({
    String? phoneNumber,
    String? email,
    String? identifier,
  }) async {
    final target = (identifier ?? phoneNumber ?? email ?? '').trim();
    final isEmail = target.contains('@');

    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/auth/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              if (isEmail) 'email': target.toLowerCase() else 'phoneNumber': target,
              'identifier': target,
            }),
          )
          .timeout(const Duration(seconds: 5));

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 && data['success'] == true) {
        final userData = data['user'] as Map<String, dynamic>;
        final user = UserModel.fromMap(userData);
        await _storageService.saveUserId(user.uid);
        await _storageService.saveUserProfileCache(user.toJson());
        return {
          'success': true,
          'isRegistered': true,
          'message': data['message'] ?? 'Login successful',
          'user': user,
        };
      }

      return {
        'success': false,
        'isRegistered': data['isRegistered'] ?? false,
        'message': data['message'] ?? 'User not found. Please complete signup.',
      };
    } catch (e) {
      return {
        'success': false,
        'isRegistered': false,
        'message': 'Error logging in: ${e.toString()}',
      };
    }
  }

  /// Communicates with backend POST /api/auth/google for Google Sign-In or Sign-Up
  Future<Map<String, dynamic>> googleAuthBackend({
    required String email,
    String? name,
    String? googleId,
    String? photoUrl,
    String? referralCode,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/auth/google'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'email': email.trim().toLowerCase(),
              if (name != null && name.trim().isNotEmpty) 'name': name.trim(),
              if (googleId != null && googleId.trim().isNotEmpty) 'googleId': googleId.trim(),
              if (photoUrl != null && photoUrl.trim().isNotEmpty) 'photoUrl': photoUrl.trim(),
              if (referralCode != null && referralCode.trim().isNotEmpty)
                'referralCode': referralCode.trim(),
            }),
          )
          .timeout(const Duration(seconds: 5));

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if ((response.statusCode == 200 || response.statusCode == 201) && data['success'] == true) {
        final userData = data['user'] as Map<String, dynamic>;
        final user = UserModel.fromMap(userData);
        await _storageService.saveUserId(user.uid);
        await _storageService.saveUserProfileCache(user.toJson());
        return {
          'success': true,
          'isNewUser': data['isNewUser'] == true,
          'message': data['message'] ?? 'Google authentication successful',
          'user': user,
        };
      }

      return {
        'success': false,
        'message': data['message'] ?? 'Google authentication failed',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error connecting to Google auth service: ${e.toString()}',
      };
    }
  }

  /// Initiates interactive Google Sign-In and communicates with backend
  Future<Map<String, dynamic>> signInWithGoogle({String? referralCode}) async {
    try {
      await _ensureGoogleInitialized();
      final GoogleSignInAccount account = await GoogleSignIn.instance.authenticate();

      return await googleAuthBackend(
        email: account.email,
        name: account.displayName,
        googleId: account.id,
        photoUrl: account.photoUrl,
        referralCode: referralCode,
      );
    } catch (e) {
      debugPrint('Google Sign-In exception: $e');
      final errStr = e.toString();
      if (errStr.contains('canceled') || errStr.contains('cancelled') || errStr.contains('CANCELED')) {
        return {
          'success': false,
          'cancelled': true,
          'message': 'Google Sign-In was cancelled.',
        };
      }
      return {
        'success': false,
        'message': 'Google Sign-In failed: $errStr',
      };
    }
  }

  /// Fetches the user profile from PostgreSQL via GET /api/users/:id
  Future<UserModel?> getUserProfile(String userId) async {
    if (userId.trim().isEmpty) return null;

    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/users/${userId.trim()}'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 3));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        if (data['success'] == true && data['user'] != null) {
          final user = UserModel.fromMap(data['user'] as Map<String, dynamic>);
          await _storageService.saveUserProfileCache(user.toJson());
          return user;
        }
      }
    } catch (e) {
      debugPrint('Error fetching user profile: $e');
    }
    return null;
  }

  /// Updates user profile in PostgreSQL via PUT /api/users/:id
  Future<UserModel?> updateUserProfile({
    required String userId,
    String? name,
    String? email,
    String? phoneNumber,
  }) async {
    if (userId.trim().isEmpty) return null;

    try {
      final response = await http
          .put(
            Uri.parse('$baseUrl/users/${userId.trim()}'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              if (name != null) 'name': name.trim(),
              if (email != null) 'email': email.trim().toLowerCase(),
              if (phoneNumber != null) 'phoneNumber': phoneNumber.trim(),
            }),
          )
          .timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        if (data['success'] == true && data['user'] != null) {
          final user = UserModel.fromMap(data['user'] as Map<String, dynamic>);
          await _storageService.saveUserProfileCache(user.toJson());
          return user;
        }
      }
    } catch (e) {
      debugPrint('Error updating user profile: $e');
    }
    return null;
  }

  /// Fetches referral details & friend list via GET /api/users/:id/referrals
  Future<Map<String, dynamic>?> getUserReferrals(String userId) async {
    if (userId.trim().isEmpty) return null;

    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/users/${userId.trim()}/referrals'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 3));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        if (data['success'] == true) {
          return data;
        }
      }
    } catch (e) {
      debugPrint('Error fetching user referrals: $e');
    }
    return null;
  }

  /// Fetches live wallet details & transaction history via GET /api/users/:id/wallet
  Future<Map<String, dynamic>?> getUserWallet(String userId) async {
    if (userId.trim().isEmpty) return null;

    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/users/${userId.trim()}/wallet'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 3));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        if (data['success'] == true && data['wallet'] != null) {
          return data['wallet'] as Map<String, dynamic>;
        }
      }
    } catch (e) {
      debugPrint('Error fetching user wallet: $e');
    }
    return null;
  }

  /// Requests cash withdrawal via POST /api/users/:id/withdraw
  Future<Map<String, dynamic>> requestWithdrawal({
    required String userId,
    required double amount,
    String method = 'UPI',
    String? paymentDetails,
  }) async {
    if (userId.trim().isEmpty) {
      return {'success': false, 'message': 'User ID is required'};
    }

    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/users/${userId.trim()}/withdraw'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'amount': amount,
              'method': method,
              'paymentDetails': paymentDetails ?? '',
            }),
          )
          .timeout(const Duration(seconds: 5));

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return data;
    } catch (e) {
      debugPrint('Error requesting withdrawal: $e');
      return {
        'success': false,
        'message': 'Failed to submit withdrawal: ${e.toString()}',
      };
    }
  }

  /// Clears stored user session upon logout.
  Future<void> signOut() async {
    try {
      await GoogleSignIn.instance.signOut();
    } catch (_) {}
    await _storageService.clearUserId();
    await _storageService.clearUserProfileCache();
  }
}

