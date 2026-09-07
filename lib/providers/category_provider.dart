import 'package:flutter/foundation.dart';

import '../models/category_group_model.dart';
import '../models/product.dart';
import '../services/category_service.dart';

enum CategoryStatus { initial, loading, loaded, error }

class CategoryProvider extends ChangeNotifier {
  final CategoryService _service;

  // Legacy list of raw categories from DummyJSON
  List<String> categories = [];

  // Currently displayed products (filtered according to active subcategory or 'all')
  List<Product> products = [];

  // All products loaded for the current active category group
  List<Product> allGroupProducts = [];

  // Active Category Group (Department)
  CategoryGroup selectedGroup = CategoryGroup.fashion;

  // Active Subcategory Slug ('all' for View All, or specific slug like 'womens-dresses')
  String selectedSubcategorySlug = 'all';

  CategoryStatus categoriesStatus = CategoryStatus.initial;
  CategoryStatus productsStatus = CategoryStatus.initial;
  String errorMessage = '';
  String? selectedCategory;

  CategoryProvider({CategoryService? service})
      : _service = service ?? CategoryService();

  /// Returns all category groups with the currently selected group positioned at index 0
  List<CategoryGroup> get categoryGroups {
    final all = CategoryGroup.allGroups;
    final current = selectedGroup;
    return [
      current,
      ...all.where((g) => g.id != current.id),
    ];
  }

  /// Returns products filtered for the active subcategory
  List<Product> get displayedGroupProducts {
    if (selectedSubcategorySlug == 'all') {
      return allGroupProducts;
    }
    return allGroupProducts.where((p) {
      final pCat = (p.category ?? '').trim().toLowerCase();
      final target = selectedSubcategorySlug.trim().toLowerCase();
      return pCat == target;
    }).toList();
  }

  /// Sets the active subcategory filter instantly without network request
  void selectSubcategory(String slug) {
    if (selectedSubcategorySlug == slug) return;

    selectedSubcategorySlug = slug;
    products = displayedGroupProducts;
    notifyListeners();
  }

  /// Selects a CategoryGroup (e.g. Fashion, Electronics) and fetches/aggregates products
  Future<void> selectCategoryGroup(
    CategoryGroup group, {
    String subcategorySlug = 'all',
  }) async {
    selectedGroup = group;
    selectedSubcategorySlug = subcategorySlug;
    selectedCategory = group.title;

    productsStatus = CategoryStatus.loading;
    errorMessage = '';
    notifyListeners();

    try {
      // Aggregate all products across the group's subcategories
      allGroupProducts = await _service.fetchProductsBySlugs(group.allSlugs);
      products = displayedGroupProducts;
      productsStatus = CategoryStatus.loaded;
    } catch (e) {
      debugPrint('Error fetching category group products: $e');
      productsStatus = CategoryStatus.error;
      errorMessage = 'Unable to load products for ${group.title}. Please try again.';
    }

    notifyListeners();
  }

  /// Selects a group by ID (e.g. 'fashion', 'electronics')
  Future<void> selectGroupById(
    String groupId, {
    String subcategorySlug = 'all',
  }) async {
    final group = CategoryGroup.findById(groupId);
    await selectCategoryGroup(group, subcategorySlug: subcategorySlug);
  }

  /// Fetches raw categories list and initializes the default Fashion group
  Future<void> fetchCategories() async {
    categoriesStatus = CategoryStatus.loading;
    errorMessage = '';
    notifyListeners();

    try {
      categories = await _service.fetchCategories();
      categoriesStatus = CategoryStatus.loaded;

      if (allGroupProducts.isEmpty) {
        await selectCategoryGroup(selectedGroup, subcategorySlug: selectedSubcategorySlug);
        return;
      }
    } catch (e) {
      debugPrint('Error fetching categories: $e');
      categoriesStatus = CategoryStatus.error;
      errorMessage = 'Unable to load categories. Please try again.';
    }

    notifyListeners();
  }

  /// Legacy/compatibility support for fetching a single category or slug
  Future<void> fetchProductsByCategory(String category) async {
    final group = CategoryGroup.findGroupForSlug(category);
    final cleanCat = category.trim().toLowerCase().replaceAll(' ', '-');

    // Check if category matches a subcategory slug or the group itself
    final isSpecificSubcategory = group.subcategories.any((s) => s.slug == cleanCat);

    await selectCategoryGroup(
      group,
      subcategorySlug: isSpecificSubcategory ? cleanCat : 'all',
    );
  }

  void resetCategoryProducts() {
    products = [];
    allGroupProducts = [];
    selectedCategory = null;
    selectedSubcategorySlug = 'all';
    productsStatus = CategoryStatus.initial;
    notifyListeners();
  }
}

