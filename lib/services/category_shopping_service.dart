import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../data/category_catalog.dart';
import '../models/category_shopping_models.dart';
import 'auth_service.dart';

class CategoryShoppingService {
  final http.Client _client;

  CategoryShoppingService({http.Client? client})
      : _client = client ?? http.Client();

  /// GET /api/categories/:categoryId
  ///
  /// The hardcoded [CategoryCatalog] is the source of truth. Backend data is
  /// merged in only to *add* products/stores it has that the catalog lacks,
  /// so a shorter backend list can never hide catalog products.
  Future<CategoryDetailResponse> fetchCategoryDetail(String categoryId, {String? categoryTitle}) async {
    final canonicalId = CategoryCatalog.canonicalCategoryId(categoryId);
    final local = getFallbackCategoryDetail(canonicalId, categoryTitle: categoryTitle);

    try {
      final uri = Uri.parse('${AuthService.baseUrl}/categories/$canonicalId');
      final response = await _client.get(uri).timeout(const Duration(seconds: 3));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        if (data['success'] == true && data['data'] != null) {
          final remote = CategoryDetailResponse.fromJson(data['data'] as Map<String, dynamic>);
          if (CategoryCatalog.canonicalCategoryId(remote.category.id) == canonicalId) {
            return _mergeCategory(local, remote);
          }
          debugPrint('CategoryShoppingService: Category ID mismatch (${remote.category.id} != $canonicalId). Using catalog.');
        }
      }
    } catch (e) {
      debugPrint('CategoryShoppingService: Network error fetching category detail: $e');
    }

    return local;
  }

  /// GET /api/categories/:categoryId/subcategories/:subcategoryId
  Future<SubcategoryDetailResponse> fetchSubcategoryDetail(
    String categoryId,
    String subcategoryId, {
    String? filter,
    String? style,
  }) async {
    final canonicalCat = CategoryCatalog.canonicalCategoryId(categoryId);
    final canonicalSub = CategoryCatalog.canonicalSubcategoryId(subcategoryId) ?? 'all';
    final local = getFallbackSubcategoryDetail(canonicalCat, canonicalSub);

    try {
      // Filtering happens on-device against the full list, so request it unfiltered.
      final uri = Uri.parse('${AuthService.baseUrl}/categories/$canonicalCat/subcategories/$canonicalSub');
      final response = await _client.get(uri).timeout(const Duration(seconds: 3));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        if (data['success'] == true && data['data'] != null) {
          final remote = SubcategoryDetailResponse.fromJson(data['data'] as Map<String, dynamic>);
          final remoteCat = remote.subcategory.categoryId;
          if (remoteCat != null && CategoryCatalog.canonicalCategoryId(remoteCat) == canonicalCat) {
            return _mergeSubcategory(local, remote);
          }
        }
      }
    } catch (e) {
      debugPrint('CategoryShoppingService: Network error fetching subcategory detail: $e');
    }

    return local;
  }

  static CategoryDetailResponse _mergeCategory(
    CategoryDetailResponse local,
    CategoryDetailResponse remote,
  ) {
    return CategoryDetailResponse(
      category: local.category,
      subcategories: local.subcategories.isNotEmpty ? local.subcategories : remote.subcategories,
      popularStores: _mergeStores(local.popularStores, remote.popularStores),
      bestDeals: _mergeDeals(local.bestDeals, remote.bestDeals),
      offers: remote.offers,
      coupons: remote.coupons,
    );
  }

  static SubcategoryDetailResponse _mergeSubcategory(
    SubcategoryDetailResponse local,
    SubcategoryDetailResponse remote,
  ) {
    final products = _mergeDeals(local.products, remote.products);
    return SubcategoryDetailResponse(
      subcategory: local.subcategory,
      filters: _filtersFor(products),
      subFilters: _subFiltersFor(products),
      products: products,
      stores: _mergeStores(local.stores, remote.stores),
    );
  }

  static List<CategoryDealModel> _mergeDeals(
    List<CategoryDealModel> local,
    List<CategoryDealModel> remote,
  ) {
    final ids = local.map((d) => d.id).toSet();
    return [...local, ...remote.where((d) => !ids.contains(d.id))];
  }

  static List<CategoryStoreModel> _mergeStores(
    List<CategoryStoreModel> local,
    List<CategoryStoreModel> remote,
  ) {
    final names = local.map((st) => st.name.trim().toLowerCase()).toSet();
    return [
      ...local,
      ...remote.where((st) => !names.contains(st.name.trim().toLowerCase())),
    ];
  }

  /// Filter chips built from the products actually present, so every chip
  /// returns at least one product: genders first, then product types.
  static List<String> _filtersFor(List<CategoryDealModel> products) {
    final genders = <String>{};
    final types = <String>{};
    for (final p in products) {
      if (p.gender != null && p.gender!.isNotEmpty) genders.add(p.gender!);
      final type = p.productType ?? p.subcategoryId;
      if (type != null && type.isNotEmpty) types.add(_titleCase(type));
    }
    final chips = [...(genders.toList()..sort()), ...types];
    return chips.length > 1 ? ['All', ...chips] : ['All'];
  }

  /// Second-level style chips (e.g. Shirts -> Casual / Formal / Oversized).
  static Map<String, dynamic> _subFiltersFor(List<CategoryDealModel> products) {
    final styles = <String, Set<String>>{};
    for (final p in products) {
      final type = p.productType ?? p.subcategoryId;
      if (type == null || p.style == null || p.style!.isEmpty) continue;
      styles.putIfAbsent(_titleCase(type), () => <String>{}).add(p.style!);
    }
    return {
      for (final e in styles.entries)
        if (e.value.length > 1) e.key: ['All', ...e.value],
    };
  }

  static String _titleCase(String raw) {
    if (raw.isEmpty) return raw;
    if (raw != raw.toLowerCase()) return raw;
    return raw
        .split(RegExp(r'[_\s]+'))
        .where((w) => w.isNotEmpty)
        .map((w) => '${w[0].toUpperCase()}${w.substring(1)}')
        .join(' ');
  }

  /// GET /api/products/:productId/compare
  Future<SmartProductComparison> compareProduct(String productId) async {
    try {
      final uri = Uri.parse('${AuthService.baseUrl}/products/$productId/compare');
      final response = await _client.get(uri).timeout(const Duration(seconds: 3));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        if (data['success'] == true && data['data'] != null) {
          return SmartProductComparison.fromJson(data['data'] as Map<String, dynamic>);
        }
      }
    } catch (e) {
      debugPrint('CategoryShoppingService: Network error comparing product: $e');
    }

    return getFallbackProductComparison(productId);
  }

  /// Category page data from the hardcoded [CategoryCatalog].
  static CategoryDetailResponse getFallbackCategoryDetail(String categoryId, {String? categoryTitle}) {
    final canonicalId = CategoryCatalog.canonicalCategoryId(categoryId);
    final def = CategoryCatalog.definitionFor(canonicalId);

    if (def == null) {
      // Unknown category: show its own (empty) page instead of another category's products.
      final title = categoryTitle != null && categoryTitle.isNotEmpty
          ? categoryTitle
          : (canonicalId.isNotEmpty ? _titleCase(canonicalId) : 'Category');
      return CategoryDetailResponse(
        category: CategoryOverviewModel(
          id: canonicalId,
          name: title,
          description: 'Deals for $title are coming soon.',
        ),
        subcategories: const [],
        popularStores: const [],
        bestDeals: const [],
      );
    }

    return CategoryDetailResponse(
      category: def.overview,
      subcategories: def.subcategories,
      popularStores: def.popularStores,
      bestDeals: CategoryCatalog.productsFor(canonicalId),
    );
  }

  /// Subcategory page data: only products mapped to this category + subcategory.
  static SubcategoryDetailResponse getFallbackSubcategoryDetail(
    String categoryId,
    String subcategoryId, {
    String? filter,
    String? style,
  }) {
    final canonicalCat = CategoryCatalog.canonicalCategoryId(categoryId);
    final canonicalSub = CategoryCatalog.canonicalSubcategoryId(subcategoryId);
    final def = CategoryCatalog.definitionFor(canonicalCat);
    final products = CategoryCatalog.productsFor(canonicalCat, subcategoryId: canonicalSub);

    final subName = CategoryCatalog.subcategoryName(canonicalCat, canonicalSub) ??
        (canonicalSub != null ? _titleCase(canonicalSub) : (def?.overview.name ?? 'All Products'));

    return SubcategoryDetailResponse(
      subcategory: CategoryOverviewModel(
        id: canonicalSub ?? 'all',
        name: subName,
        description: 'Explore verified $subName deals with cashback and coupons.',
        categoryId: canonicalCat,
        categoryName: def?.overview.name,
      ),
      filters: _filtersFor(products),
      subFilters: _subFiltersFor(products),
      products: products,
      stores: def?.popularStores ?? const [],
    );
  }

  static SmartProductComparison getFallbackProductComparison(String productId) {
    if (productId == 'prod-shirt-2') {
      return const SmartProductComparison(
        productId: 'prod-shirt-2',
        title: 'Roadster Pure Cotton Casual Plaid Shirt',
        brand: 'Roadster',
        imageUrl: 'assets/cards/col_ajio.jpg',
        category: 'Fashion',
        subcategory: 'Shirts',
        originalPrice: 1999,
        stores: [
          StoreComparisonDetail(
            store: 'AJIO',
            logoUrl: 'assets/cards/ajio-coupons.jpg',
            productPrice: 1499,
            storeDiscount: 200,
            couponDiscount: 200,
            bankDiscount: 0,
            payNow: 1099,
            cashback: 104,
            effectiveCost: 995,
            totalSavings: 1004,
            isBestDeal: true,
            eligibility: 'All Payment Modes',
            shopUrl: 'https://www.ajio.com',
          ),
          StoreComparisonDetail(
            store: 'Myntra',
            logoUrl: 'assets/cards/myntra.jpg',
            productPrice: 1599,
            storeDiscount: 150,
            couponDiscount: 150,
            bankDiscount: 0,
            payNow: 1299,
            cashback: 100,
            effectiveCost: 1199,
            totalSavings: 800,
            isBestDeal: false,
            eligibility: 'All Payment Modes',
            shopUrl: 'https://www.myntra.com',
          ),
        ],
        bestDeal: BestDealSummary(
          store: 'AJIO',
          payNow: 1099,
          potentialCashback: 104,
          effectiveCost: 995,
          totalSavings: 1004,
        ),
        totalSavings: 1004,
      );
    }

    if (productId == 'prod-1') {
      return const SmartProductComparison(
        productId: 'prod-1',
        title: 'Nike Air Max 270 React Sneakers',
        brand: 'Nike',
        imageUrl: 'assets/banners/sneaker_banner_16_9.jpg',
        category: 'Shoes',
        subcategory: 'Footwear',
        originalPrice: 5999,
        stores: [
          StoreComparisonDetail(
            store: 'Myntra',
            logoUrl: 'assets/cards/myntra.jpg',
            productPrice: 5500,
            storeDiscount: 499,
            couponDiscount: 500,
            bankDiscount: 0,
            payNow: 5000,
            cashback: 350,
            effectiveCost: 4650,
            totalSavings: 1349,
            isBestDeal: true,
            eligibility: 'All Payments',
            shopUrl: 'https://www.myntra.com',
          ),
          StoreComparisonDetail(
            store: 'Flipkart',
            logoUrl: 'assets/cards/flipkart-electronics.png',
            productPrice: 5400,
            storeDiscount: 599,
            couponDiscount: 300,
            bankDiscount: 0,
            payNow: 5100,
            cashback: 250,
            effectiveCost: 4850,
            totalSavings: 1149,
            isBestDeal: false,
            eligibility: 'Axis Bank',
            shopUrl: 'https://www.flipkart.com',
          ),
          StoreComparisonDetail(
            store: 'Amazon',
            logoUrl: 'assets/cards/amazon.jpg',
            productPrice: 5600,
            storeDiscount: 399,
            couponDiscount: 200,
            bankDiscount: 0,
            payNow: 5400,
            cashback: 300,
            effectiveCost: 5100,
            totalSavings: 899,
            isBestDeal: false,
            eligibility: 'ICICI Amazon Pay',
            shopUrl: 'https://www.amazon.in',
          ),
        ],
        bestDeal: BestDealSummary(
          store: 'Myntra',
          payNow: 5000,
          potentialCashback: 350,
          effectiveCost: 4650,
          totalSavings: 1349,
        ),
        totalSavings: 1349,
      );
    }

    // Default to Levi's Regular Fit Shirt
    return const SmartProductComparison(
      productId: 'prod-shirt-1',
      title: "Levi's Regular Fit Denim & Casual Shirt",
      brand: "Levi's",
      imageUrl: 'assets/cards/col_myntra.jpg',
      category: 'Fashion',
      subcategory: 'Shirts',
      originalPrice: 2999,
      stores: [
        StoreComparisonDetail(
          store: 'Myntra',
          logoUrl: 'assets/cards/myntra.jpg',
          productPrice: 1999,
          storeDiscount: 200,
          couponDiscount: 300,
          bankDiscount: 0,
          payNow: 1499,
          cashback: 200,
          effectiveCost: 1299,
          totalSavings: 700,
          isBestDeal: true,
          eligibility: 'All Payment Modes',
          shopUrl: 'https://www.myntra.com',
        ),
        StoreComparisonDetail(
          store: 'AJIO',
          logoUrl: 'assets/cards/ajio-coupons.jpg',
          productPrice: 2099,
          storeDiscount: 200,
          couponDiscount: 250,
          bankDiscount: 0,
          payNow: 1649,
          cashback: 180,
          effectiveCost: 1469,
          totalSavings: 630,
          isBestDeal: false,
          eligibility: 'All Payment Modes',
          shopUrl: 'https://www.ajio.com',
        ),
        StoreComparisonDetail(
          store: 'Amazon',
          logoUrl: 'assets/cards/amazon.jpg',
          productPrice: 2199,
          storeDiscount: 150,
          couponDiscount: 200,
          bankDiscount: 0,
          payNow: 1849,
          cashback: 150,
          effectiveCost: 1699,
          totalSavings: 500,
          isBestDeal: false,
          eligibility: 'Prime Members',
          shopUrl: 'https://www.amazon.in',
        ),
      ],
      bestDeal: BestDealSummary(
        store: 'Myntra',
        payNow: 1499,
        potentialCashback: 200,
        effectiveCost: 1299,
        totalSavings: 700,
      ),
      totalSavings: 700,
    );
  }
}
