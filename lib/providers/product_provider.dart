import 'package:flutter/foundation.dart';

import '../models/product.dart';
import '../services/product_service.dart';

enum ProductStatus { initial, loading, loaded, error }

class ProductProvider extends ChangeNotifier {
  final ProductService _service;

  List<Product> products = [];
  ProductStatus status = ProductStatus.initial;
  String errorMessage = '';

  ProductProvider({ProductService? service})
    : _service = service ?? ProductService();

  Future<void> fetchProducts() async {
    status = ProductStatus.loading;
    errorMessage = '';
    notifyListeners();

    try {
      final fetchedProducts = await _service.fetchProducts();

      products = fetchedProducts.take(30).toList();
      status = ProductStatus.loaded;
      debugPrint('Products fetched: ${products.length}');
    } catch (e) {
      debugPrint('Error fetching products: $e');
      status = ProductStatus.error;
      errorMessage = 'Unable to load offers. Please try again.';
    }

    notifyListeners();
  }
}
