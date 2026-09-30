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

  static String? _cachedBaseUrl;

  /// Default Wi-Fi / Local Area Network IP of the host PC.
  static const String defaultLocalIp = '192.168.29.221';
  static const String secondaryLocalIp = '192.168.1.61';
  static const int defaultPort = 5000;

  /// Fast asynchronous probe to select the best reachable backend endpoint.
  static Future<String> getWorkingBaseUrl() async {
    if (_cachedBaseUrl != null) return _cachedBaseUrl!;

    const customUrl = String.fromEnvironment('API_URL');
    if (customUrl.isNotEmpty) {
      _cachedBaseUrl = customUrl;
      return _cachedBaseUrl!;
    }

    const customIp = String.fromEnvironment('BACKEND_IP');
    if (customIp.isNotEmpty) {
      _cachedBaseUrl = 'http://$customIp:$defaultPort/api';
      return _cachedBaseUrl!;
    }

    if (kIsWeb ||
        defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.linux ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      _cachedBaseUrl = 'http://127.0.0.1:$defaultPort/api';
      return _cachedBaseUrl!;
    }

    // Probe 127.0.0.1 (USB adb reverse) first, then live host LAN Wi-Fi IPs, then Emulator
    final candidates = [
      'http://127.0.0.1:$defaultPort/api',
      'http://$defaultLocalIp:$defaultPort/api',
      'http://$secondaryLocalIp:$defaultPort/api',
      'http://192.168.1.40:$defaultPort/api',
      'http://10.0.2.2:$defaultPort/api',
    ];

    // Probe all candidate endpoints simultaneously in parallel for instant response
    final probeFutures = candidates.map((candidate) async {
      try {
        final res = await http
            .get(Uri.parse('$candidate/health'))
            .timeout(const Duration(milliseconds: 1500));
        if (res.statusCode == 200) {
          return candidate;
        }
      } catch (_) {}
      return null;
    });

    final results = await Future.wait(probeFutures);
    for (final candidate in candidates) {
      if (results.contains(candidate)) {
        debugPrint('[AuthService] Connected to backend at: $candidate');
        _cachedBaseUrl = candidate;
        return candidate;
      }
    }

    // Fallback to local Wi-Fi IP rather than loopback on mobile
    _cachedBaseUrl = 'http://$defaultLocalIp:$defaultPort/api';
    return _cachedBaseUrl!;
  }

  /// Synchronous fallback for baseUrl
  static String get baseUrl {
    if (_cachedBaseUrl != null) return _cachedBaseUrl!;
    if (kIsWeb ||
        defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.linux ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      return 'http://127.0.0.1:$defaultPort/api';
    }
    return 'http://$defaultLocalIp:$defaultPort/api';
  }

  /// Public HTTPS domain used for sharing deals so WhatsApp makes it clickable
  /// and anyone outside local Wi-Fi can open it.
  static String get publicDealUrl {
    const customDealUrl = String.fromEnvironment('DEAL_URL');
    if (customDealUrl.isNotEmpty) {
      return customDealUrl;
    }
    return 'https://ecological-contest-tested-valve.trycloudflare.com';
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
      final host = await getWorkingBaseUrl();
      final response = await http
          .post(
            Uri.parse('$host/auth/check-phone'),
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
      debugPrint('[AuthService] checkIdentifier error: $e');
      _cachedBaseUrl = null;
      final errStr = e.toString();
      String friendlyMessage = 'Failed to check account: $errStr';
      if (errStr.contains('Connection refused') || errStr.contains('SocketException')) {
        friendlyMessage = 'Server unreachable. Please verify backend is running on port 5000 or reconnect USB.';
      }
      return {
        'success': false,
        'message': friendlyMessage,
      };
    }
  }

  /// Sends a dummy 6-digit OTP to the specified phone number or email.
  Future<Map<String, dynamic>> sendOtp(String identifier) async {
    try {
      final clean = identifier.trim();
      final isEmail = clean.contains('@');
      final host = await getWorkingBaseUrl();
      final response = await http
          .post(
            Uri.parse('$host/auth/send-otp'),
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
      _cachedBaseUrl = null;
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
      final host = await getWorkingBaseUrl();
      final response = await http
          .post(
            Uri.parse('$host/auth/verify-otp'),
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
      _cachedBaseUrl = null;
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
      final host = await getWorkingBaseUrl();
      final response = await http
          .post(
            Uri.parse('$host/auth/signup'),
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
      _cachedBaseUrl = null;
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
      final host = await getWorkingBaseUrl();
      final response = await http
          .post(
            Uri.parse('$host/auth/login'),
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
          'message': data['message'] ?? 'Login successful',
          'user': user,
        };
      }

      return {
        'success': false,
        'message': data['message'] ?? 'Login failed',
      };
    } catch (e) {
      _cachedBaseUrl = null;
      return {
        'success': false,
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
      final host = await getWorkingBaseUrl();
      final response = await http
          .post(
            Uri.parse('$host/auth/google'),
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
      final host = await getWorkingBaseUrl();
      final response = await http
          .get(
            Uri.parse('$host/users/${userId.trim()}'),
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
    String? avatarUrl,
  }) async {
    if (userId.trim().isEmpty) return null;

    try {
      final host = await getWorkingBaseUrl();
      final response = await http
          .put(
            Uri.parse('$host/users/${userId.trim()}'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              if (name != null) 'name': name.trim(),
              if (email != null) 'email': email.trim().toLowerCase(),
              if (phoneNumber != null) 'phoneNumber': phoneNumber.trim(),
              if (avatarUrl != null) 'avatarUrl': avatarUrl.trim(),
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

  /// Uploads a profile photo via POST /api/users/:id/upload-avatar (multipart).
  /// Accepts pre-read [imageBytes] so dart:io is not required by this service.
  /// Returns the public URL string of the saved avatar, or null on failure.
  Future<String?> uploadAvatarImage({
    required String userId,
    required List<int> imageBytes,
    required String mimeType,
    required String fileName,
  }) async {
    if (userId.trim().isEmpty || imageBytes.isEmpty) return null;

    try {
      final host = await getWorkingBaseUrl();
      final uri = Uri.parse('$host/users/${userId.trim()}/upload-avatar');

      final request = http.MultipartRequest('POST', uri);
      request.files.add(
        http.MultipartFile.fromBytes(
          'avatar',
          imageBytes,
          filename: fileName,
          contentType: _parseMimeType(mimeType),
        ),
      );

      final streamedResponse =
          await request.send().timeout(const Duration(seconds: 15));
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        if (data['success'] == true && data['avatarUrl'] != null) {
          return data['avatarUrl'] as String;
        }
      }
      debugPrint('Avatar upload failed (${response.statusCode}): ${response.body}');
    } catch (e) {
      debugPrint('Error uploading avatar image: $e');
    }
    return null;
  }

  static http.MediaType _parseMimeType(String mime) {
    final parts = mime.split('/');
    return http.MediaType(
      parts.isNotEmpty ? parts[0] : 'image',
      parts.length > 1 ? parts[1] : 'jpeg',
    );
  }


  /// Fetches referral details & friend list via GET /api/users/:id/referrals
  Future<Map<String, dynamic>?> getUserReferrals(String userId) async {
    if (userId.trim().isEmpty) return null;

    try {
      final host = await getWorkingBaseUrl();
      final response = await http
          .get(
            Uri.parse('$host/users/${userId.trim()}/referrals'),
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
      final host = await getWorkingBaseUrl();
      final response = await http
          .get(
            Uri.parse('$host/users/${userId.trim()}/wallet'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 8));

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

  /// Fetches live spending & cashback graph analytics via GET /api/users/:id/spending-analytics
  Future<Map<String, dynamic>?> getSpendingAnalytics(String userId) async {
    if (userId.trim().isEmpty) return null;

    try {
      final host = await getWorkingBaseUrl();
      final response = await http
          .get(
            Uri.parse('$host/users/${userId.trim()}/spending-analytics'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        if (data['success'] == true && data['analytics'] != null) {
          return data['analytics'] as Map<String, dynamic>;
        }
      }
    } catch (e) {
      debugPrint('Error fetching spending analytics: $e');
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
      final host = await getWorkingBaseUrl();
      final response = await http
          .post(
            Uri.parse('$host/users/${userId.trim()}/withdraw'),
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

  /// Permanently deletes user account from PostgreSQL via DELETE /api/users/:id
  Future<Map<String, dynamic>> deleteAccount({
    required String userId,
    String? reason,
    String? feedback,
  }) async {
    if (userId.trim().isEmpty) {
      return {'success': false, 'message': 'User ID is missing.'};
    }

    try {
      final host = await getWorkingBaseUrl();
      final response = await http
          .delete(
            Uri.parse('$host/users/${userId.trim()}'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              if (reason != null && reason.trim().isNotEmpty) 'reason': reason.trim(),
              if (feedback != null && feedback.trim().isNotEmpty) 'feedback': feedback.trim(),
            }),
          )
          .timeout(const Duration(seconds: 12));

      if (response.statusCode == 200 || response.statusCode == 204) {
        await signOut();
        return {'success': true, 'message': 'Account deleted successfully.'};
      } else {
        try {
          final data = jsonDecode(response.body);
          return {
            'success': false,
            'message': data['message'] ?? 'Failed to delete account.',
          };
        } catch (_) {
          return {
            'success': false,
            'message': 'Server returned error (${response.statusCode})',
          };
        }
      }
    } catch (e) {
      debugPrint('Error deleting user account: $e');
      return {
        'success': false,
        'message': 'Failed to delete account: ${e.toString()}',
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
