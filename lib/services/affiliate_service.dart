import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class TrackedLinkResult {
  final bool success;
  final String clickId;
  final String subId;
  final String urlToOpen;
  final bool isFallback;
  final String? message;

  const TrackedLinkResult({
    required this.success,
    required this.clickId,
    required this.subId,
    required this.urlToOpen,
    this.isFallback = false,
    this.message,
  });
}

class TrackedCashbackOrder {
  final String id;
  final String? clickId;
  final String storeName;
  final double orderAmount;
  final double commissionAmount;
  final double cashbackAmount;
  final String status; // 'PENDING', 'CONFIRMED', 'REJECTED'
  final String? network;
  final DateTime createdAt;

  const TrackedCashbackOrder({
    required this.id,
    this.clickId,
    required this.storeName,
    required this.orderAmount,
    required this.commissionAmount,
    required this.cashbackAmount,
    required this.status,
    this.network,
    required this.createdAt,
  });

  factory TrackedCashbackOrder.fromMap(Map<String, dynamic> map) {
    double parseD(dynamic val) {
      if (val == null) return 0.0;
      if (val is num) return val.toDouble();
      return double.tryParse(val.toString()) ?? 0.0;
    }

    DateTime parseDt(dynamic val) {
      if (val == null) return DateTime.now();
      try {
        return DateTime.parse(val.toString());
      } catch (_) {
        return DateTime.now();
      }
    }

    return TrackedCashbackOrder(
      id: map['id']?.toString() ?? '',
      clickId: map['click_id']?.toString(),
      storeName: map['store_name']?.toString() ?? 'Partner Store',
      orderAmount: parseD(map['order_amount']),
      commissionAmount: parseD(map['commission_amount']),
      cashbackAmount: parseD(map['cashback_amount']),
      status: (map['status']?.toString() ?? 'PENDING').toUpperCase(),
      network: map['network']?.toString(),
      createdAt: parseDt(map['created_at']),
    );
  }
}

class AffiliateService {
  static final AffiliateService _instance = AffiliateService._internal();
  factory AffiliateService() => _instance;
  AffiliateService._internal();

  String get _baseUrl => AuthService.baseUrl;

  /// Generates a tracked affiliate link with unique Sub-ID for attribution.
  /// Logs the outbound shopping click event in PostgreSQL.
  /// If backend is unreachable, gracefully returns the target URL so user is never blocked.
  Future<TrackedLinkResult> generateTrackedLink({
    required String userId,
    required String storeName,
    required String targetUrl,
    String? storeId,
    String network = 'generic',
    String linkType = 'SELF_SHOPPING',
  }) async {
    final cleanUrl = targetUrl.trim();
    if (cleanUrl.isEmpty) {
      return const TrackedLinkResult(
        success: false,
        clickId: '',
        subId: '',
        urlToOpen: '',
        isFallback: true,
        message: 'Invalid store URL.',
      );
    }

    // If user is guest/unregistered, fallback cleanly with generic tracking param
    if (userId.trim().isEmpty) {
      final sep = cleanUrl.contains('?') ? '&' : '?';
      final guestUrl = '$cleanUrl${sep}utm_source=kashiq&utm_medium=app_guest';
      return TrackedLinkResult(
        success: true,
        clickId: 'guest',
        subId: 'guest',
        urlToOpen: guestUrl,
        isFallback: true,
      );
    }

    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl/affiliate/generate-link'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'userId': userId.trim(),
              'storeName': storeName.trim(),
              'storeId': storeId?.trim(),
              'targetUrl': cleanUrl,
              'network': network,
              'linkType': linkType,
            }),
          )
          .timeout(const Duration(seconds: 4));

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        if (data['success'] == true) {
          final affUrl = data['affiliateUrl']?.toString() ?? cleanUrl;
          final clickId = data['clickId']?.toString() ?? '';
          final subId = data['subId']?.toString() ?? '';
          return TrackedLinkResult(
            success: true,
            clickId: clickId,
            subId: subId,
            urlToOpen: affUrl,
          );
        }
      }
    } catch (e) {
      debugPrint('AffiliateService generateTrackedLink exception: $e');
    }

    // Graceful offline fallback: append subid parameter locally
    final localSubId = 'clk_${DateTime.now().millisecondsSinceEpoch}_local';
    final sep = cleanUrl.contains('?') ? '&' : '?';
    final fallbackUrl = '$cleanUrl${sep}subid=$localSubId&utm_source=kashiq&utm_medium=cashback';

    return TrackedLinkResult(
      success: true,
      clickId: localSubId,
      subId: localSubId,
      urlToOpen: fallbackUrl,
      isFallback: true,
    );
  }

  /// Fetches real tracked shopping orders / conversions for the user
  Future<List<TrackedCashbackOrder>> getUserOrders(String userId) async {
    if (userId.trim().isEmpty) return [];

    try {
      final response = await http
          .get(
            Uri.parse('$_baseUrl/users/${userId.trim()}/orders'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        if (data['success'] == true && data['orders'] is List) {
          return (data['orders'] as List)
              .map((e) => TrackedCashbackOrder.fromMap(Map<String, dynamic>.from(e as Map)))
              .toList();
        }
      }
    } catch (e) {
      debugPrint('Error fetching user cashback orders: $e');
    }
    return [];
  }

  /// Fetches user click history / shopping trips
  Future<List<Map<String, dynamic>>> getUserClicks(String userId) async {
    if (userId.trim().isEmpty) return [];

    try {
      final response = await http
          .get(
            Uri.parse('$_baseUrl/affiliate/clicks/${userId.trim()}'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        if (data['success'] == true && data['clicks'] is List) {
          return (data['clicks'] as List)
              .map((e) => Map<String, dynamic>.from(e as Map))
              .toList();
        }
      }
    } catch (e) {
      debugPrint('Error fetching user clicks: $e');
    }
    return [];
  }
}
