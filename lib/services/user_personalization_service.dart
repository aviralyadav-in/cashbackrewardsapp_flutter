import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/home_discovery_models.dart';

/// Intelligent User Personalization & Recommendation Engine
/// Handles:
/// 1. Cold-start recommendations for new users (top deal across every unique category).
/// 2. Behavioral personalization for returning users (based on search history, orders, and product views).
/// 3. "Similar Products" generation (category, brand, price-bracket matching, excluding current product).
/// 4. "Products You Might Like" recommendations (complementary categories and user affinity, non-overlapping).
class UserPersonalizationService {
  static final UserPersonalizationService _instance =
      UserPersonalizationService._internal();
  factory UserPersonalizationService() => _instance;
  UserPersonalizationService._internal();

  static const String _searchesKey = 'kashiq_user_searches_list';
  static const String _searchKeywordsKey = 'kashiq_search_keywords_map_v1';
  static const String _orderedCategoriesKey = 'kashiq_ordered_categories_v1';
  static const String _orderedStoresKey = 'kashiq_ordered_stores_v1';
  static const String _viewedCategoriesKey = 'kashiq_viewed_categories_v1';
  static const String _viewedBrandsKey = 'kashiq_viewed_brands_v1';
  static const String _viewedProductIdsKey = 'kashiq_viewed_product_ids_v1';
  static const String _clickedCategoriesKey = 'kashiq_clicked_categories_v1';
  static const String _clickedStoresKey = 'kashiq_clicked_stores_v1';
  static const String _clickedBrandsKey = 'kashiq_clicked_brands_v1';
  static const String _clickedProductIdsKey = 'kashiq_clicked_product_ids_v1';

  final List<String> _recentSearches = [];
  final Map<String, int> _searchKeywords = {};
  final Map<String, int> _orderedCategories = {};
  final Map<String, int> _orderedStores = {};
  final Map<String, int> _viewedCategories = {};
  final Map<String, int> _viewedBrands = {};
  final List<String> _viewedProductIds = [];
  final Map<String, int> _clickedCategories = {};
  final Map<String, int> _clickedStores = {};
  final Map<String, int> _clickedBrands = {};
  final List<String> _clickedProductIds = [];

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  /// Loads on-device behavioral signals from SharedPreferences
  Future<void> init() async {
    if (_isInitialized) return;
    try {
      final prefs = await SharedPreferences.getInstance();

      final searches = prefs.getStringList(_searchesKey) ?? [];
      _recentSearches.clear();
      _recentSearches.addAll(searches);

      _loadMap(prefs, _searchKeywordsKey, _searchKeywords);
      _loadMap(prefs, _orderedCategoriesKey, _orderedCategories);
      _loadMap(prefs, _orderedStoresKey, _orderedStores);
      _loadMap(prefs, _viewedCategoriesKey, _viewedCategories);
      _loadMap(prefs, _viewedBrandsKey, _viewedBrands);
      _loadMap(prefs, _clickedCategoriesKey, _clickedCategories);
      _loadMap(prefs, _clickedStoresKey, _clickedStores);
      _loadMap(prefs, _clickedBrandsKey, _clickedBrands);

      final viewedIds = prefs.getStringList(_viewedProductIdsKey) ?? [];
      _viewedProductIds.clear();
      _viewedProductIds.addAll(viewedIds);

      final clickedIds = prefs.getStringList(_clickedProductIdsKey) ?? [];
      _clickedProductIds.clear();
      _clickedProductIds.addAll(clickedIds);

      _isInitialized = true;
    } catch (e) {
      debugPrint('UserPersonalizationService.init error: $e');
    }
  }

  void _loadMap(SharedPreferences prefs, String key, Map<String, int> target) {
    target.clear();
    final raw = prefs.getString(key);
    if (raw == null || raw.isEmpty) return;
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      decoded.forEach((k, v) {
        if (v is num) target[k.toLowerCase().trim()] = v.toInt();
      });
    } catch (_) {}
  }

  Future<void> _saveMap(String key, Map<String, int> map) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, jsonEncode(map));
    } catch (e) {
      debugPrint('UserPersonalizationService saveMap error for $key: $e');
    }
  }

  // ─── USER STATE ─────────────────────────────────────────────────────────────

  /// True if user is new with no past searches, orders, or click/view activity.
  bool get isNewUser {
    final searchCount = _recentSearches.length;
    final orderCount = _orderedCategories.values.fold(0, (a, b) => a + b) +
        _orderedStores.values.fold(0, (a, b) => a + b);
    final viewCount = _viewedCategories.values.fold(0, (a, b) => a + b);
    final clickCount = _clickedCategories.values.fold(0, (a, b) => a + b) +
        _clickedStores.values.fold(0, (a, b) => a + b) +
        _clickedProductIds.length;
    return (searchCount + orderCount + viewCount + clickCount) == 0;
  }

  List<String> get recentSearches => List.unmodifiable(_recentSearches);
  Map<String, int> get orderedCategories => Map.unmodifiable(_orderedCategories);
  Map<String, int> get orderedStores => Map.unmodifiable(_orderedStores);
  Map<String, int> get viewedCategories => Map.unmodifiable(_viewedCategories);
  Map<String, int> get clickedCategories => Map.unmodifiable(_clickedCategories);
  Map<String, int> get clickedStores => Map.unmodifiable(_clickedStores);
  List<String> get clickedProductIds => List.unmodifiable(_clickedProductIds);

  // ─── RECORDING EVENTS ──────────────────────────────────────────────────────

  /// Records user search query & extracted keywords
  Future<void> recordSearch(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;

    final lower = trimmed.toLowerCase();
    _recentSearches.removeWhere((s) => s.toLowerCase() == lower);
    _recentSearches.insert(0, trimmed);
    if (_recentSearches.length > 15) {
      _recentSearches.removeRange(15, _recentSearches.length);
    }

    // Tokenize into keywords
    final tokens = lower.split(RegExp(r'[\s,._\-+/]+'));
    for (final token in tokens) {
      if (token.length >= 2) {
        _searchKeywords[token] = (_searchKeywords[token] ?? 0) + 1;
      }
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_searchesKey, _recentSearches);
      await _saveMap(_searchKeywordsKey, _searchKeywords);
    } catch (_) {}
  }

  /// Records a purchase/order conversion
  Future<void> recordOrder({
    required String store,
    required String category,
    String? brand,
  }) async {
    final sKey = store.trim().toLowerCase();
    final cKey = category.trim().toLowerCase();

    if (sKey.isNotEmpty) {
      _orderedStores[sKey] = (_orderedStores[sKey] ?? 0) + 1;
      await _saveMap(_orderedStoresKey, _orderedStores);
    }
    if (cKey.isNotEmpty) {
      _orderedCategories[cKey] = (_orderedCategories[cKey] ?? 0) + 1;
      await _saveMap(_orderedCategoriesKey, _orderedCategories);
    }
    if (brand != null && brand.trim().isNotEmpty) {
      final bKey = brand.trim().toLowerCase();
      _viewedBrands[bKey] = (_viewedBrands[bKey] ?? 0) + 2;
      await _saveMap(_viewedBrandsKey, _viewedBrands);
    }
  }

  /// Ingests a list of order objects (e.g. from PostgreSQL /api/users/:id/orders)
  Future<void> syncUserOrders(List<dynamic> orders) async {
    if (orders.isEmpty) return;
    for (final order in orders) {
      if (order is Map) {
        final storeName = order['store_name']?.toString() ??
            order['store']?.toString() ??
            '';
        final category = order['category']?.toString() ?? 'Affiliate Shopping';
        if (storeName.isNotEmpty) {
          final s = storeName.toLowerCase().trim();
          _orderedStores[s] = (_orderedStores[s] ?? 0) + 1;
        }
        if (category.isNotEmpty && category != 'Affiliate Shopping') {
          final c = category.toLowerCase().trim();
          _orderedCategories[c] = (_orderedCategories[c] ?? 0) + 1;
        }
      }
    }
    await _saveMap(_orderedStoresKey, _orderedStores);
    await _saveMap(_orderedCategoriesKey, _orderedCategories);
  }

  /// Records product detail browsing
  Future<void> recordProductView({
    required String id,
    required String category,
    required String brand,
    required String store,
  }) async {
    final cKey = category.trim().toLowerCase();
    final bKey = brand.trim().toLowerCase();
    final sKey = store.trim().toLowerCase();

    if (cKey.isNotEmpty && cKey != 'top recommendation') {
      _viewedCategories[cKey] = (_viewedCategories[cKey] ?? 0) + 1;
      await _saveMap(_viewedCategoriesKey, _viewedCategories);
    }
    if (bKey.isNotEmpty) {
      _viewedBrands[bKey] = (_viewedBrands[bKey] ?? 0) + 1;
      await _saveMap(_viewedBrandsKey, _viewedBrands);
    }
    if (sKey.isNotEmpty) {
      _orderedStores[sKey] = (_orderedStores[sKey] ?? 0);
    }

    if (id.isNotEmpty) {
      _viewedProductIds.remove(id);
      _viewedProductIds.insert(0, id);
      if (_viewedProductIds.length > 20) {
        _viewedProductIds.removeRange(20, _viewedProductIds.length);
      }
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setStringList(_viewedProductIdsKey, _viewedProductIds);
      } catch (_) {}
    }
  }

  /// Records user product click on home / deals card
  Future<void> recordProductClick({
    required String id,
    required String category,
    required String brand,
    required String store,
  }) async {
    final cKey = category.trim().toLowerCase();
    final bKey = brand.trim().toLowerCase();
    final sKey = store.trim().toLowerCase();

    if (cKey.isNotEmpty && cKey != 'top recommendation') {
      _clickedCategories[cKey] = (_clickedCategories[cKey] ?? 0) + 1;
      await _saveMap(_clickedCategoriesKey, _clickedCategories);
    }
    if (bKey.isNotEmpty) {
      _clickedBrands[bKey] = (_clickedBrands[bKey] ?? 0) + 1;
      await _saveMap(_clickedBrandsKey, _clickedBrands);
    }
    if (sKey.isNotEmpty) {
      _clickedStores[sKey] = (_clickedStores[sKey] ?? 0) + 1;
      await _saveMap(_clickedStoresKey, _clickedStores);
    }

    if (id.isNotEmpty) {
      _clickedProductIds.remove(id);
      _clickedProductIds.insert(0, id);
      if (_clickedProductIds.length > 25) {
        _clickedProductIds.removeRange(25, _clickedProductIds.length);
      }
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setStringList(_clickedProductIdsKey, _clickedProductIds);
      } catch (_) {}
    }
  }

  /// Syncs affiliate link clicks / shopping trips from backend
  Future<void> syncUserClicks(List<dynamic> clicks) async {
    if (clicks.isEmpty) return;
    for (final click in clicks) {
      if (click is Map) {
        final storeName = click['store_name']?.toString() ??
            click['store']?.toString() ??
            '';
        final category = click['category']?.toString() ?? '';
        if (storeName.isNotEmpty) {
          final s = storeName.toLowerCase().trim();
          _clickedStores[s] = (_clickedStores[s] ?? 0) + 1;
        }
        if (category.isNotEmpty) {
          final c = category.toLowerCase().trim();
          _clickedCategories[c] = (_clickedCategories[c] ?? 0) + 1;
        }
      }
    }
    await _saveMap(_clickedStoresKey, _clickedStores);
    await _saveMap(_clickedCategoriesKey, _clickedCategories);
  }

  // ─── ALGORITHMS ─────────────────────────────────────────────────────────────

  /// 1. COLD START RECOMMENDATIONS (FOR NEW USERS):
  /// "agr user new hai to hr ek category ke top deals wale product abhi dikhayenge"
  /// Picks the single best/highest-savings deal from each distinct category.
  List<BestDealModel> getColdStartDeals(List<BestDealModel> allDeals) {
    if (allDeals.isEmpty) return [];

    final Map<String, List<BestDealModel>> byCategory = {};
    for (final deal in allDeals) {
      final cat = deal.category.trim();
      final key = cat.isNotEmpty ? cat.toLowerCase() : 'other';
      byCategory.putIfAbsent(key, () => []).add(deal);
    }

    final List<BestDealModel> topCategoryDeals = [];

    byCategory.forEach((_, dealsInCategory) {
      // Sort within each category: highest savings percentage first, then lowest effectivePrice
      dealsInCategory.sort((a, b) {
        final savingsA = a.originalPrice > 0
            ? (a.effectiveSavings / a.originalPrice)
            : 0.0;
        final savingsB = b.originalPrice > 0
            ? (b.effectiveSavings / b.originalPrice)
            : 0.0;
        final diff = savingsB.compareTo(savingsA);
        return diff != 0 ? diff : a.effectivePrice.compareTo(b.effectivePrice);
      });
      topCategoryDeals.add(dealsInCategory.first);
    });

    // Sort the diversified categories so top overall discount appears first
    topCategoryDeals.sort((a, b) {
      final savingsA = a.originalPrice > 0
          ? (a.effectiveSavings / a.originalPrice)
          : 0.0;
      final savingsB = b.originalPrice > 0
          ? (b.effectiveSavings / b.originalPrice)
          : 0.0;
      return savingsB.compareTo(savingsA);
    });

    return topCategoryDeals;
  }

  @visibleForTesting
  void clearForTesting() {
    _recentSearches.clear();
    _searchKeywords.clear();
    _orderedCategories.clear();
    _orderedStores.clear();
    _viewedCategories.clear();
    _viewedBrands.clear();
    _viewedProductIds.clear();
    _clickedCategories.clear();
    _clickedStores.clear();
    _clickedBrands.clear();
    _clickedProductIds.clear();
  }

  /// 2. PERSONALIZED RECOMMENDATIONS (FOR RETURNING USERS):
  /// "jab user kaafi time se hmare appp ko use krta hai to hme pta hota hai ki usne kya kya order kiya hai
  /// aur usne kya kya search kiya h to uski pasand hme pta chal jati hai to is section me hm uski psnd ki cheeje dikha skte hai"
  List<BestDealModel> getPersonalizedBestDeals(List<BestDealModel> allDeals) {
    if (allDeals.isEmpty) return [];

    // If genuinely a new user, switch to Cold-Start category deals
    if (isNewUser) {
      return getColdStartDeals(allDeals);
    }

    final scoredDeals = allDeals.map((deal) {
      final score = _calculateAffinityScore(deal);
      return MapEntry(deal, score);
    }).toList();

    // Sort descending by calculated score; ties break on savings percentage
    scoredDeals.sort((a, b) {
      final scoreDiff = b.value.compareTo(a.value);
      if (scoreDiff != 0) return scoreDiff;

      final savingsA = a.key.originalPrice > 0
          ? (a.key.effectiveSavings / a.key.originalPrice)
          : 0.0;
      final savingsB = b.key.originalPrice > 0
          ? (b.key.effectiveSavings / b.key.originalPrice)
          : 0.0;
      return savingsB.compareTo(savingsA);
    });

    return scoredDeals.map((entry) => entry.key).toList();
  }

  /// Calculates dynamic affinity score for a deal
  double _calculateAffinityScore(BestDealModel deal) {
    double score = 0.0;
    final title = deal.title.toLowerCase();
    final brand = deal.brand.toLowerCase();
    final store = deal.store.toLowerCase();
    final category = deal.category.toLowerCase();

    // 1. Direct Product Click Match (+20.0 points)
    if (_clickedProductIds.contains(deal.id)) {
      score += 20.0;
    }

    // 2. Direct Category & Brand Click Signals
    final catClicks = _clickedCategories[category] ?? 0;
    if (catClicks > 0) {
      score += (catClicks * 16.0);
    }
    final brandClicks = _clickedBrands[brand] ?? 0;
    if (brandClicks > 0) {
      score += (brandClicks * 12.0);
    }
    final storeClicks = _clickedStores[store] ?? 0;
    if (storeClicks > 0) {
      score += (storeClicks * 8.0);
    }

    // 3. Search Query & Keyword Matching (Strong Signal: 18.0 per match)
    for (final search in _recentSearches) {
      final s = search.toLowerCase().trim();
      if (s.isEmpty) continue;

      if (title.contains(s) || brand.contains(s) || category.contains(s)) {
        score += 18.0;
      } else if (store.contains(s)) {
        score += 10.0;
      } else {
        final words = s.split(RegExp(r'\s+'));
        for (final w in words) {
          if (w.length >= 3 &&
              (title.contains(w) || category.contains(w) || brand.contains(w))) {
            score += 6.0;
          }
        }
      }
    }

    // Keyword map checks
    _searchKeywords.forEach((kw, count) {
      if (title.contains(kw) || category.contains(kw) || brand.contains(kw)) {
        score += (count * 3.5);
      }
    });

    // 4. Order History Matching (Highest Conversion Intent: 25.0 points)
    final catOrderCount = _orderedCategories[category] ?? 0;
    if (catOrderCount > 0) {
      score += (catOrderCount * 25.0);
    }

    final storeOrderCount = _orderedStores[store] ?? 0;
    if (storeOrderCount > 0) {
      score += (storeOrderCount * 14.0);
    }

    // 5. Browsing / Category Views (8.0 points)
    final catViews = _viewedCategories[category] ?? 0;
    if (catViews > 0) {
      score += (catViews * 8.0);
    }

    final brandViews = _viewedBrands[brand] ?? 0;
    if (brandViews > 0) {
      score += (brandViews * 12.0);
    }

    // 6. Intrinsic Deal Quality bonus (ensures highest value deals bubble up)
    if (deal.originalPrice > 0) {
      final savingsPercent = (deal.effectiveSavings / deal.originalPrice) * 100;
      score += (savingsPercent * 0.15);
    }

    return score;
  }

  /// 3. SIMILAR PRODUCTS ALGORITHM:
  /// Finds products that are genuinely similar:
  /// - Matches same category / subcategory
  /// - Matches same brand or related price-tier
  /// - Excludes current product (no self-reference)
  List<BestDealModel> getSimilarProducts({
    required String currentId,
    required String currentCategory,
    required String currentBrand,
    required double currentPrice,
    required List<BestDealModel> allDeals,
  }) {
    if (allDeals.isEmpty) return [];

    final cleanCat = currentCategory.trim().toLowerCase();
    final cleanBrand = currentBrand.trim().toLowerCase();

    // 1. Exclude currently viewed product
    final candidates = allDeals.where((d) {
      final idMatch = d.id.isNotEmpty && d.id == currentId;
      return !idMatch;
    }).toList();

    // 2. Score similarity
    final scored = candidates.map((deal) {
      double simScore = 0.0;
      final dealCat = deal.category.trim().toLowerCase();
      final dealBrand = deal.brand.trim().toLowerCase();

      // Exact category match
      if (dealCat.isNotEmpty && cleanCat.isNotEmpty) {
        if (dealCat == cleanCat) {
          simScore += 60.0;
        } else if (dealCat.contains(cleanCat) || cleanCat.contains(dealCat)) {
          simScore += 40.0;
        }
      }

      // Brand match
      if (dealBrand.isNotEmpty && cleanBrand.isNotEmpty && dealBrand == cleanBrand) {
        simScore += 30.0;
      }

      // Price bracket similarity (within 50% range)
      if (currentPrice > 0 && deal.discountedPrice > 0) {
        final ratio = deal.discountedPrice / currentPrice;
        if (ratio >= 0.5 && ratio <= 1.8) {
          simScore += 15.0;
        }
      }

      // Discount quality
      if (deal.discountPercentage > 20) {
        simScore += (deal.discountPercentage * 0.1);
      }

      return MapEntry(deal, simScore);
    }).toList();

    // Sort by similarity score descending
    scored.sort((a, b) => b.value.compareTo(a.value));

    // Return items that have a positive similarity score
    final results = scored
        .where((e) => e.value > 15.0)
        .map((e) => e.key)
        .take(8)
        .toList();

    // If few matching results, provide other deals from the pool excluding current
    if (results.length < 3) {
      final existingIds = results.map((r) => r.id).toSet();
      for (final c in candidates) {
        if (!existingIds.contains(c.id)) {
          results.add(c);
          if (results.length >= 6) break;
        }
      }
    }

    return results;
  }

  /// 4. PRODUCTS YOU MIGHT LIKE ALGORITHM:
  /// Personalizes recommendations based on:
  /// - Complementary categories (e.g. Phone -> Audio/Watch, Shoes -> Apparel)
  /// - User's search & order affinity
  /// - Excludes current product AND excludes products already shown in "Similar Products"
  List<BestDealModel> getProductsYouMightLike({
    required String currentId,
    required String currentCategory,
    required Set<String> excludedProductIds,
    required List<BestDealModel> allDeals,
  }) {
    if (allDeals.isEmpty) return [];

    final cleanCat = currentCategory.trim().toLowerCase();
    final complementary = _getComplementaryCategories(cleanCat);

    // Candidates must not be current product and must not be in excludedProductIds
    final candidates = allDeals.where((d) {
      if (d.id == currentId) return false;
      if (excludedProductIds.contains(d.id)) return false;
      return true;
    }).toList();

    final scored = candidates.map((deal) {
      double score = 0.0;
      final dealCat = deal.category.trim().toLowerCase();

      // Complementary category boost
      if (complementary.contains(dealCat)) {
        score += 35.0;
      }

      // User personal affinity boost
      score += _calculateAffinityScore(deal);

      return MapEntry(deal, score);
    }).toList();

    scored.sort((a, b) => b.value.compareTo(a.value));

    return scored.map((e) => e.key).take(8).toList();
  }

  /// Maps a category to its natural complementary categories
  Set<String> _getComplementaryCategories(String category) {
    if (category.contains('smartphones') || category.contains('mobile') || category.contains('phone')) {
      return {'audio', 'wearables', 'electronics'};
    }
    if (category.contains('laptop') || category.contains('computer')) {
      return {'audio', 'electronics', 'wearables'};
    }
    if (category.contains('footwear') || category.contains('shoe')) {
      return {'fashion', 'wearables', 'sports'};
    }
    if (category.contains('fashion') || category.contains('clothing')) {
      return {'footwear', 'beauty', 'wearables'};
    }
    if (category.contains('beauty') || category.contains('skincare')) {
      return {'fashion', 'personal care', 'wellness'};
    }
    if (category.contains('audio') || category.contains('headphone')) {
      return {'smartphones', 'laptops', 'wearables'};
    }
    if (category.contains('wearables') || category.contains('watch')) {
      return {'smartphones', 'footwear', 'audio'};
    }
    return {'smartphones', 'fashion', 'audio', 'beauty'};
  }
}
