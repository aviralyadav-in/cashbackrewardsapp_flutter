import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/home_discovery_models.dart';
import '../services/home_service.dart';

enum HomeStatus { initial, loading, loaded, error }

class HomeProvider extends ChangeNotifier {
  final HomeService _homeService;

  HomeDataModel? _homeData;
  HomeStatus _status = HomeStatus.initial;
  String _errorMessage = '';

  /// How many times the user opened a deal in each category (lower-cased).
  /// Stored on-device and used to rank "For You" sections.
  final Map<String, int> _categoryInterest = {};
  static const String _interestPrefsKey = 'home_category_interest_v1';

  /// Number of deals shown in the home "Best Deals For You" carousel.
  static const int homeBestDealsCount = 5;

  HomeProvider({HomeService? homeService})
      : _homeService = homeService ?? HomeService() {
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

  int _interestFor(String category) =>
      _categoryInterest[category.trim().toLowerCase()] ?? 0;

  /// All best deals, categories the user opens most often first. Ties keep the
  /// backend ranking (highest net savings first).
  List<BestDealModel> get personalizedBestDeals {
    final deals = List<BestDealModel>.of(bestDeals);
    if (_categoryInterest.isEmpty) return deals;
    final rank = {for (var i = 0; i < deals.length; i++) deals[i].id: i};
    deals.sort((a, b) {
      final byInterest = _interestFor(b.category).compareTo(_interestFor(a.category));
      return byInterest != 0 ? byInterest : rank[a.id]!.compareTo(rank[b.id]!);
    });
    return deals;
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
  Future<void> fetchHomeData() async {
    _status = HomeStatus.loading;
    _errorMessage = '';
    notifyListeners();

    try {
      _homeData = await _homeService.fetchHomeData();
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
