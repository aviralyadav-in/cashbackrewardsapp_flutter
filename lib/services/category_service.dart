import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/product.dart';

class CategoryService {
  static const String _categoriesEndpoint =
      'https://dummyjson.com/products/categories';

  final http.Client _client;
  final Map<String, List<Product>> _cache = {};

  CategoryService({http.Client? client}) : _client = client ?? http.Client();

  /// Fetches raw categories list from DummyJSON
  Future<List<String>> fetchCategories() async {
    final response = await _client.get(
      Uri.parse(_categoriesEndpoint),
      headers: {'User-Agent': 'Mozilla/5.0'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load categories');
    }

    final body = jsonDecode(response.body);

    if (body is! List) {
      return [];
    }

    return body
        .whereType<Map<String, dynamic>>()
        .map((item) => item['name']?.toString() ?? '')
        .where((name) => name.isNotEmpty)
        .toList();
  }

  /// Fetches products for a single category slug, using cache when available
  Future<List<Product>> fetchProductsByCategory(String category) async {
    final encodedCategory =
        category.trim().toLowerCase().replaceAll(' ', '-');

    if (_cache.containsKey(encodedCategory) && _cache[encodedCategory]!.isNotEmpty) {
      return _cache[encodedCategory]!;
    }

    final response = await _client.get(
      Uri.parse('https://dummyjson.com/products/category/$encodedCategory'),
      headers: {'User-Agent': 'Mozilla/5.0'},
    );

    if (response.statusCode != 200) {
      if (_cache.containsKey(encodedCategory)) {
        return _cache[encodedCategory]!;
      }
      throw Exception('Failed to load products for selected category: $encodedCategory');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final productsJson = body['products'] as List<dynamic>?;

    if (productsJson == null) {
      return [];
    }

    final products = productsJson
        .map((item) => Product.fromJson(item as Map<String, dynamic>))
        .toList();

    _cache[encodedCategory] = products;
    return products;
  }

  /// Aggregates products across multiple category slugs (for "View All" in departments)
  Future<List<Product>> fetchProductsBySlugs(List<String> slugs) async {
    final List<Product> aggregated = [];
    final Set<int> seenIds = {};

    for (final slug in slugs) {
      try {
        final prods = await fetchProductsByCategory(slug);
        for (final p in prods) {
          if (seenIds.add(p.id)) {
            aggregated.add(p);
          }
        }
      } catch (e) {
        debugPrint('Error fetching subcategory $slug: $e');
      }
    }

    return aggregated;
  }
}