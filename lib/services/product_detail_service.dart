import 'dart:convert';
import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;

import '../models/product_detail.dart';

class ProductDetailService {
  static const String _endpoint = 'https://dummyjson.com/products';

  final http.Client _client;

  ProductDetailService({http.Client? client})
    : _client = client ?? http.Client();

  Future<ProductDetail> fetchProductDetail(int id) async {
    final response = await _client.get(Uri.parse('$_endpoint/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to load product details');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    debugPrint('Product Detail Response loaded for ID $id');
    return ProductDetail.fromJson(body);
  }
}
