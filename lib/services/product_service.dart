import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/product.dart';
// import 'dart:math';

class ProductService {
  static const String _endpoint = 'https://dummyjson.com/products';

  final http.Client _client;

  ProductService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<Product>> fetchProducts() async {
    final response = await _client.get(Uri.parse(_endpoint));

    if (response.statusCode != 200) {
      throw Exception('Failed to load products');
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
