import 'package:flutter/foundation.dart';

import '../models/product.dart';
import '../models/universal_search_models.dart';
import '../services/recent_search_service.dart';
import '../services/search_service.dart';

enum SearchStatus { initial, loading, loaded, error }

class SearchProvider extends ChangeNotifier {
  final SearchService _service;
  final RecentSearchService _recentSearchService;

  // State
  List<Product> searchResults = [];
  UniversalSearchResult universalResult = UniversalSearchResult.empty();
  UniversalSearchType activeFilter = UniversalSearchType.all;
  SearchStatus status = SearchStatus.initial;
  String errorMessage = '';
  String query = '';

  List<String> recentSearches = [];
  final List<String> popularSearches = const [
    'Nike Air Max',
    'iPhone',
    'Myntra',
    'Amazon',
    'Sneakers',
    'Laptops',
    '50% off',
    'Smartphones',
  ];

  SearchProvider({
    SearchService? service,
    RecentSearchService? recentSearchService,
  })  : _service = service ?? SearchService(),
        _recentSearchService = recentSearchService ?? RecentSearchService() {
    loadRecentSearches();
  }

  Future<void> loadRecentSearches() async {
    recentSearches = await _recentSearchService.getRecentSearches();
    notifyListeners();
  }

  /// Sets active filter tab and re-runs search if query exists
  void selectFilter(UniversalSearchType filter) {
    if (activeFilter == filter) return;
    activeFilter = filter;
    if (query.isNotEmpty) {
      search(query, saveToRecent: false);
    } else {
      notifyListeners();
    }
  }

  /// Main search method with universal multi-type indexing
  Future<void> search(String value, {bool saveToRecent = true}) async {
    final trimmedValue = value.trim();
    query = trimmedValue;

    if (trimmedValue.isEmpty) {
      searchResults = [];
      universalResult = UniversalSearchResult.empty();
      status = SearchStatus.initial;
      errorMessage = '';
      notifyListeners();
      return;
    }

    status = SearchStatus.loading;
    errorMessage = '';
    notifyListeners();

    try {
      // 1. Fetch Universal multi-category results
      universalResult = await _service.searchUniversal(
        trimmedValue,
        type: activeFilter,
      );

      // 2. Map universal products to legacy Product list for backward compatibility
      searchResults = universalResult.products.map((p) {
        return Product(
          id: int.tryParse(p.id.replaceAll(RegExp(r'[^0-9]'), '')) ?? 1,
          title: p.title,
          description: p.description,
          price: p.bestEffectivePrice,
          discountPercentage: p.originalPrice > p.bestEffectivePrice
              ? ((p.originalPrice - p.bestEffectivePrice) / p.originalPrice) * 100
              : 0,
          thumbnail: p.imageUrl,
          brand: p.brand,
          category: p.category,
        );
      }).toList();

      status = SearchStatus.loaded;

      // 3. Save to recent searches if requested
      if (saveToRecent && trimmedValue.length >= 2) {
        await _recentSearchService.addRecentSearch(trimmedValue);
        recentSearches = await _recentSearchService.getRecentSearches();
      }
    } catch (e) {
      debugPrint('Error searching products: $e');
      status = SearchStatus.error;
      errorMessage = 'Unable to complete search. Please check connection and try again.';
    }

    notifyListeners();
  }

  Future<void> removeRecentSearch(String q) async {
    await _recentSearchService.removeRecentSearch(q);
    recentSearches = await _recentSearchService.getRecentSearches();
    notifyListeners();
  }

  Future<void> clearRecentSearches() async {
    await _recentSearchService.clearRecentSearches();
    recentSearches = [];
    notifyListeners();
  }

  void clearSearch() {
    query = '';
    searchResults = [];
    universalResult = UniversalSearchResult.empty();
    status = SearchStatus.initial;
    errorMessage = '';
    notifyListeners();
  }
}
