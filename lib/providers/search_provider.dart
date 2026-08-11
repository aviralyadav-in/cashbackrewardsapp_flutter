import 'package:flutter/foundation.dart';

import '../models/product.dart';
import '../services/search_service.dart';

enum SearchStatus { initial, loading, loaded, error }

class SearchProvider extends ChangeNotifier {
  final SearchService _service;

  List<Product> searchResults = [];
  SearchStatus status = SearchStatus.initial;
  String errorMessage = '';
  String query = '';

  SearchProvider({SearchService? service})
    : _service = service ?? SearchService();

  Future<void> search(String value) async {
    final trimmedValue = value.trim();
    query = trimmedValue;

    if (trimmedValue.isEmpty) {
      searchResults = [];
      status = SearchStatus.initial;
      errorMessage = '';
      notifyListeners();
      return;
    }

    status = SearchStatus.loading;
    errorMessage = '';
    notifyListeners();

    try {
      searchResults = await _service.searchProducts(trimmedValue);
      status = SearchStatus.loaded;
    } catch (e) {
      debugPrint('Error searching products: $e');
      status = SearchStatus.error;
      errorMessage = 'Unable to search products. Please try again.';
    }

    notifyListeners();
  }

  void clearSearch() {
    query = '';
    searchResults = [];
    status = SearchStatus.initial;
    errorMessage = '';
    notifyListeners();
  }
}
