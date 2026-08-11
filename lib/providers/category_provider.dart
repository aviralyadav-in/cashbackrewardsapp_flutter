import 'package:flutter/foundation.dart';

import '../models/product.dart';
import '../services/category_service.dart';

enum CategoryStatus { initial, loading, loaded, error }

class CategoryProvider extends ChangeNotifier {
  final CategoryService _service;

  List<String> categories = [];
  List<Product> products = [];
  CategoryStatus categoriesStatus = CategoryStatus.initial;
  CategoryStatus productsStatus = CategoryStatus.initial;
  String errorMessage = '';
  String? selectedCategory;

  CategoryProvider({CategoryService? service})
    : _service = service ?? CategoryService();

  Future<void> fetchCategories() async {
    categoriesStatus = CategoryStatus.loading;
    errorMessage = '';
    notifyListeners();

    try {
      categories = await _service.fetchCategories();
      categoriesStatus = CategoryStatus.loaded;
      if (categories.isNotEmpty && selectedCategory == null) {
        await fetchProductsByCategory(categories.first);
        return;
      }
    } catch (e) {
      debugPrint('Error fetching categories: $e');
      categoriesStatus = CategoryStatus.error;
      errorMessage = 'Unable to load categories. Please try again.';
    }

    notifyListeners();
  }

  Future<void> fetchProductsByCategory(String category) async {
    selectedCategory = category;
    productsStatus = CategoryStatus.loading;
    errorMessage = '';
    notifyListeners();

    try {
      products = await _service.fetchProductsByCategory(category);
      productsStatus = CategoryStatus.loaded;
    } catch (e) {
      debugPrint('Error fetching category products: $e');
      productsStatus = CategoryStatus.error;
      errorMessage =
          'Unable to load products for this category. Please try again.';
    }

    notifyListeners();
  }

  void resetCategoryProducts() {
    products = [];
    selectedCategory = null;
    productsStatus = CategoryStatus.initial;
    notifyListeners();
  }
}
