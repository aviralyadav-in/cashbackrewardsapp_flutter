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

  void _moveSelectedCategoryToFirst(String category) {
    if (categories.isEmpty) return;

    final lowerQuery = category.trim().toLowerCase().replaceAll(' ', '-');
    final index = categories.indexWhere(
      (cat) =>
          cat.toLowerCase().replaceAll(' ', '-') == lowerQuery ||
          cat.toLowerCase().contains(lowerQuery) ||
          lowerQuery.contains(cat.toLowerCase().replaceAll(' ', '-')),
    );

    if (index > 0) {
      final selectedItem = categories.removeAt(index);
      categories.insert(0, selectedItem);
      selectedCategory = selectedItem;
    } else if (index == 0) {
      selectedCategory = categories[0];
    } else {
      selectedCategory = category;
    }
  }

  Future<void> fetchCategories() async {
    categoriesStatus = CategoryStatus.loading;
    errorMessage = '';
    notifyListeners();

    try {
      categories = await _service.fetchCategories();
      categoriesStatus = CategoryStatus.loaded;
      if (selectedCategory != null) {
        _moveSelectedCategoryToFirst(selectedCategory!);
      } else if (categories.isNotEmpty) {
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
    _moveSelectedCategoryToFirst(category);

    productsStatus = CategoryStatus.loading;
    errorMessage = '';
    notifyListeners();

    try {
      products = await _service.fetchProductsByCategory(selectedCategory ?? category);
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
