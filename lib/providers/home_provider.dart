import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/home_discovery_models.dart';
import '../services/home_service.dart';
import '../services/user_personalization_service.dart';

enum HomeStatus { initial, loading, loaded, error }

class HomeProvider extends ChangeNotifier {
  final HomeService _homeService;
  final UserPersonalizationService _personalizationService =
      UserPersonalizationService();

  HomeDataModel? _homeData;
  HomeStatus _status = HomeStatus.initial;
  String _errorMessage = '';

  /// How many times the user opened a deal in each category (lower-cased).
  /// Stored on-device and used to rank "For You" sections.
  final Map<String, int> _categoryInterest = {};
  static const String _interestPrefsKey = 'home_category_interest_v1';

  /// Number of deals shown in the home "Best Deals For You" carousel.
  static const int homeBestDealsCount = 6;

  HomeProvider({HomeService? homeService})
      : _homeService = homeService ?? HomeService() {
    _personalizationService.init();
    _loadCategoryInterest();
    fetchHomeData();
  }

  HomeDataModel? get homeData => _homeData;
  HomeStatus get status => _status;
  bool get isLoading => _status == HomeStatus.loading;
  String get errorMessage => _errorMessage;

  CashbackSummaryModel? get cashbackSummary => _homeData?.cashbackSummary;
  List<BestDealModel> get bestDeals => _homeData?.bestDeals ?? [];
  List<HomeOfferModel> get offers => _homeData?.offers ?? [];
  List<HomeCouponModel> get coupons => _homeData?.coupons ?? [];
  List<SmartSavingsModel> get smartSavings => _homeData?.smartSavings ?? [];
  List<FeaturedStoreModel> get featuredStores => _homeData?.featuredStores ?? [];
  List<TrendingDealModel> get trendingDeals => _homeData?.trendingDeals ?? [];
  List<PriceDropModel> get priceDrops => _homeData?.priceDrops ?? [];
  List<CashbackIncreaseModel> get cashbackIncreases =>
      _homeData?.cashbackIncreases ?? [];
  BestDealsPageModel get bestDealsPage =>
      _homeData?.bestDealsPage ?? BestDealsPageModel.fallback;

  /// Exposes personalization engine instance
  UserPersonalizationService get personalizationService => _personalizationService;

  /// Whether current user is new (cold start mode)
  bool get isNewUser => _personalizationService.isNewUser;

  /// Returns interaction count for a specific category
  int getCategoryInterest(String category) =>
      _categoryInterest[category.trim().toLowerCase()] ?? 0;

  /// All best deals ranked according to user preferences:
  /// - For New Users: Distributes top deal from each unique category!
  /// - For Returning Users: Scores deals against user's search queries, orders, and viewed categories.
  List<BestDealModel> get personalizedBestDeals {
    if (bestDeals.isEmpty) return [];

    if (_personalizationService.isNewUser) {
      return _personalizationService.getColdStartDeals(bestDeals);
    }

    return _personalizationService.getPersonalizedBestDeals(bestDeals);
  }

  /// Deals shown in the home "Best Deals For You" carousel.
  List<BestDealModel> get homeBestDeals =>
      personalizedBestDeals.take(homeBestDealsCount).toList();

  /// Best Deals tab "Top Deals For You": the best remaining deal per category,
  /// skipping deals already shown on home so the two sections never repeat.
  List<BestDealModel> get topDealsByCategory {
    final shownOnHome = homeBestDeals.map((d) => d.id).toSet();
    final remaining =
        personalizedBestDeals.where((d) => !shownOnHome.contains(d.id)).toList();
    final source = remaining.isNotEmpty ? remaining : personalizedBestDeals;

    final seenCategories = <String>{};
    return source
        .where((d) => seenCategories.add(d.category.trim().toLowerCase()))
        .toList();
  }

  /// Best Deals tab "Best Store Deals": same store records as Featured Stores,
  /// so cashback rates always match between the two screens.
  List<FeaturedStoreModel> get topCashbackStores {
    final stores = List<FeaturedStoreModel>.of(featuredStores)
      ..sort((a, b) => b.maxCashback.compareTo(a.maxCashback));
    return stores.take(3).toList();
  }

  /// Records that the user searched for something and updates ranking
  Future<void> recordSearch(String query) async {
    await _personalizationService.recordSearch(query);
    notifyListeners();
  }

  /// Records an order placed or tracked by the user
  Future<void> recordOrder({
    required String store,
    required String category,
    String? brand,
  }) async {
    await _personalizationService.recordOrder(
      store: store,
      category: category,
      brand: brand,
    );
    notifyListeners();
  }

  /// Ingests user orders list (from database / profile)
  Future<void> syncUserOrders(List<dynamic> orders) async {
    await _personalizationService.syncUserOrders(orders);
    notifyListeners();
  }

  /// Records that the user viewed a product detail screen
  Future<void> recordProductView({
    required String id,
    required String category,
    required String brand,
    required String store,
  }) async {
    await _personalizationService.recordProductView(
      id: id,
      category: category,
      brand: brand,
      store: store,
    );
    await recordCategoryInterest(category);
  }

  /// Records a product click event (from Home cards / Best Deals)
  Future<void> recordProductClick({
    required String id,
    required String category,
    required String brand,
    required String store,
  }) async {
    await _personalizationService.recordProductClick(
      id: id,
      category: category,
      brand: brand,
      store: store,
    );
    await recordCategoryInterest(category);
    notifyListeners();
  }

  /// Syncs affiliate link clicks / shopping trips
  Future<void> syncUserClicks(List<dynamic> clicks) async {
    await _personalizationService.syncUserClicks(clicks);
    notifyListeners();
  }

  /// Records that the user opened a deal in [category] and re-ranks "For You".
  Future<void> recordCategoryInterest(String category) async {
    final key = category.trim().toLowerCase();
    final isKnownCategory =
        bestDeals.any((d) => d.category.trim().toLowerCase() == key);
    if (key.isEmpty || !isKnownCategory) return;

    _categoryInterest[key] = (_categoryInterest[key] ?? 0) + 1;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_interestPrefsKey, jsonEncode(_categoryInterest));
    } catch (e) {
      debugPrint('HomeProvider: could not save category interest: $e');
    }
  }

  Future<void> _loadCategoryInterest() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_interestPrefsKey);
      if (raw == null) return;
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      decoded.forEach((k, v) {
        if (v is num) _categoryInterest[k] = v.toInt();
      });
      notifyListeners();
    } catch (e) {
      debugPrint('HomeProvider: could not load category interest: $e');
    }
  }

  /// Fetches structured home discovery feed
  Future<void> fetchHomeData({String? userId}) async {
    _status = HomeStatus.loading;
    _errorMessage = '';
    notifyListeners();

    try {
      _homeData = await _homeService.fetchHomeData(userId: userId);
      _status = HomeStatus.loaded;
    } catch (e) {
      debugPrint('Error loading home data: $e');
      _errorMessage = 'Couldn\'t load deals. Please tap to retry.';
      // Fallback safely to offline data so screen is never empty
      _homeData = HomeService.getFallbackHomeData();
      _status = HomeStatus.loaded;
    }

    notifyListeners();
  }
}
