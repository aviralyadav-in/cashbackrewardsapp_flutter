import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/product.dart';

class CategoryService {
  static const String _categoriesEndpoint =
      'https://dummyjson.com/products/categories';

  final http.Client _client;

  CategoryService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<String>> fetchCategories() async {
    final response = await _client.get(Uri.parse(_categoriesEndpoint));

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

  Future<List<Product>> fetchProductsByCategory(String category) async {
    final encodedCategory =
        category.trim().toLowerCase().replaceAll(' ', '-');

    final response = await _client.get(
      Uri.parse(
        'https://dummyjson.com/products/category/$encodedCategory',
      ),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load products for selected category');
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