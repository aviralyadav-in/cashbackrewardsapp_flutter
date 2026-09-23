import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/category_detail_screen.dart';
import '../screens/my_earnings_screen.dart';
import '../screens/my_order_details_screen.dart';
import '../screens/payments_screen.dart';
import '../screens/product_detail_screen.dart';
import '../screens/signup_screen.dart';
import '../screens/store_detail_screen.dart';

class DeepLinkService {
  static final DeepLinkService _instance = DeepLinkService._internal();
  factory DeepLinkService() => _instance;
  DeepLinkService._internal();

  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _sub;
  GlobalKey<NavigatorState>? _navigatorKey;

  /// Initializes deep linking listeners for cold launch and background resume
  Future<void> init(GlobalKey<NavigatorState> navigatorKey) async {
    _navigatorKey = navigatorKey;

    try {
      // 1. Handle cold-start link (when app opened from completely closed state)
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        debugPrint('[DEEP LINK] Cold launch URI: $initialUri');
        // Give the UI a frame to mount before navigating
        WidgetsBinding.instance.addPostFrameCallback((_) {
          handleUri(initialUri);
        });
      }

      // 2. Handle background / foreground link events
      _sub = _appLinks.uriLinkStream.listen(
        (uri) {
          debugPrint('[DEEP LINK] Incoming URI stream: $uri');
          handleUri(uri);
        },
        onError: (err) {
          debugPrint('[DEEP LINK] Error in URI stream: $err');
        },
      );
    } catch (e) {
      debugPrint('[DEEP LINK] Initialization failed: $e');
    }
  }

  /// Parses and navigates to the target screen based on incoming URI
  void handleUri(Uri uri) {
    final nav = _navigatorKey?.currentState;
    if (nav == null) {
      debugPrint('[DEEP LINK] Navigator state is null. Cannot navigate.');
      return;
    }

    final host = uri.host.toLowerCase();
    final path = uri.path.toLowerCase();
    final queryParams = uri.queryParameters;

    debugPrint('[DEEP LINK] Handling host="$host", path="$path", params=$queryParams');

    // Pattern 0: Shared Deal link from Hybrid Web landing page: kashiq://deal?referrerId=...&productId=...
    if (host == 'deal' || path.contains('/deal')) {
      final referrerId = queryParams['referrerId'] ?? queryParams['ref'] ?? '';
      final productId = queryParams['productId'] ?? queryParams['pid'] ?? '';
      final storeName = queryParams['store'] ?? queryParams['storeName'] ?? '';
      final title = queryParams['title'] ?? queryParams['productName'] ?? '';

      // Persist referrer ID for attribution when user creates an account
      if (referrerId.isNotEmpty) {
        SharedPreferences.getInstance().then((prefs) {
          prefs.setString('pending_referrer_id', referrerId);
          debugPrint('[DEEP LINK] Saved pending referrer ID: $referrerId');
        });
      }

      if (productId.isNotEmpty || title.isNotEmpty) {
        nav.push(
          MaterialPageRoute(
            builder: (_) => ProductDetailScreen(
              productId: productId.isNotEmpty ? productId : null,
              customTitle: title.isNotEmpty ? title : null,
              customBrandName: storeName.isNotEmpty ? storeName : null,
            ),
          ),
        );
      } else if (referrerId.isNotEmpty) {
        nav.push(
          MaterialPageRoute(
            builder: (_) => SignupScreen(initialReferralCode: referrerId),
          ),
        );
      }
      return;
    }

    // Pattern 1: Referral link: kashiq://referral?code=ABC1234
    if (host == 'referral' || path.contains('/referral')) {
      final code = queryParams['code'] ?? '';
      nav.push(
        MaterialPageRoute(
          builder: (_) => SignupScreen(initialReferralCode: code),
        ),
      );
      return;
    }

    // Pattern 2: Store link: kashiq://store?id=amazon OR kashiq://store/amazon
    if (host == 'store' || path.startsWith('/store')) {
      String storeId = queryParams['id'] ?? '';
      if (storeId.isEmpty && uri.pathSegments.isNotEmpty) {
        storeId = uri.pathSegments.last;
      }
      final cleanStoreName = storeId.isEmpty ? 'Store' : storeId[0].toUpperCase() + storeId.substring(1);

      nav.push(
        MaterialPageRoute(
          builder: (_) => StoreDetailScreen(
            storeName: cleanStoreName,
            category: queryParams['category'],
          ),
        ),
      );
      return;
    }

    // Pattern 3: Category link: kashiq://category?id=fashion OR kashiq://category/fashion
    if (host == 'category' || path.startsWith('/category')) {
      String catId = queryParams['id'] ?? '';
      if (catId.isEmpty && uri.pathSegments.isNotEmpty) {
        catId = uri.pathSegments.last;
      }
      if (catId.isEmpty) catId = 'fashion';

      nav.push(
        MaterialPageRoute(
          builder: (_) => CategoryDetailScreen(
            categoryId: catId,
            categoryTitle: queryParams['title'],
          ),
        ),
      );
      return;
    }

    // Pattern 4: Earnings / Wallet: kashiq://earnings
    if (host == 'earnings' || path.contains('/earnings')) {
      nav.push(
        MaterialPageRoute(
          builder: (_) => const MyEarningsScreen(),
        ),
      );
      return;
    }

    // Pattern 5: Orders / Transactions: kashiq://orders
    if (host == 'orders' || path.contains('/orders')) {
      nav.push(
        MaterialPageRoute(
          builder: (_) => const MyOrderDetailsScreen(),
        ),
      );
      return;
    }

    // Pattern 6: Payments / Withdraw: kashiq://wallet
    if (host == 'wallet' || path.contains('/wallet')) {
      nav.push(
        MaterialPageRoute(
          builder: (_) => const PaymentsScreen(),
        ),
      );
      return;
    }

    debugPrint('[DEEP LINK] Unhandled deep link route: $uri');
  }

  void dispose() {
    _sub?.cancel();
  }
}
