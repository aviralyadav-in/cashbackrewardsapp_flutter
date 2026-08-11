import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/product.dart';

class SearchService {
  static const String _searchEndpoint = 'https://dummyjson.com/products/search';

  final http.Client _client;

  SearchService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<Product>> searchProducts(String query) async {
    final trimmedQuery = query.trim();

    if (trimmedQuery.isEmpty) {
      return [];
    }

    final uri = Uri.parse(
      '$_searchEndpoint?q=${Uri.encodeQueryComponent(trimmedQuery)}',
    );
    final response = await _client.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to search products');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final productsJson = body['products'] as List<dynamic>?;

    if (productsJson == null) {
      return [];
    }

    return productsJson
        .map((item) => Product.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
