import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/product.dart';
import '../models/universal_search_models.dart';
import 'auth_service.dart';

class SearchService {
  static const String _dummyJsonEndpoint = 'https://dummyjson.com/products/search';

  final http.Client _client;

  SearchService({http.Client? client}) : _client = client ?? http.Client();

  /// Performs a Universal Search across Products, Stores, Categories, Offers, and Coupons.
  /// Hits backend GET /api/search?q=...&type=... with offline fallback dataset.
  Future<UniversalSearchResult> searchUniversal(
    String query, {
    UniversalSearchType type = UniversalSearchType.all,
  }) async {
    final trimmedQuery = query.trim();
    if (trimmedQuery.isEmpty) {
      return UniversalSearchResult.empty();
    }

    try {
      final uri = Uri.parse(
        '${AuthService.baseUrl}/search?q=${Uri.encodeQueryComponent(trimmedQuery)}&type=${type.apiKey}',
      );

      final response = await _client.get(uri).timeout(
            const Duration(seconds: 3),
          );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        if (body['success'] == true && body['data'] != null) {
          return UniversalSearchResult.fromJson(body['data'] as Map<String, dynamic>);
        }
      }
    } catch (e) {
      debugPrint('SearchService: Remote universal search unavailable, using offline index: $e');
    }

    return _getOfflineUniversalSearchResults(trimmedQuery, type);
  }

  /// Fetches Product Comparison and Smart Savings breakdown for a specific product.
  Future<ProductComparisonData> getProductComparison(String productId) async {
    try {
      final uri = Uri.parse(
        '${AuthService.baseUrl}/search/comparison/${Uri.encodeComponent(productId)}',
      );

      final response = await _client.get(uri).timeout(
            const Duration(seconds: 3),
          );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        if (body['success'] == true && body['data'] != null) {
          return ProductComparisonData.fromJson(body['data'] as Map<String, dynamic>);
        }
      }
    } catch (e) {
      debugPrint('SearchService: Remote comparison unavailable, using offline data: $e');
    }

    return _getOfflineComparison(productId);
  }

  /// Legacy method preserved for complete backward compatibility.
  Future<List<Product>> searchProducts(String query) async {
    final trimmedQuery = query.trim();

    if (trimmedQuery.isEmpty) {
      return [];
    }

    try {
      final uri = Uri.parse(
        '$_dummyJsonEndpoint?q=${Uri.encodeQueryComponent(trimmedQuery)}',
      );
      final response = await _client.get(uri);

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final productsJson = body['products'] as List<dynamic>?;

        if (productsJson != null) {
          return productsJson
              .map((item) => Product.fromJson(item as Map<String, dynamic>))
              .toList();
        }
      }
    } catch (e) {
      debugPrint('Legacy searchProducts error: $e');
    }

    return [];
  }

  // =========================================================================
  // OFFLINE UNIVERSAL SEARCH FALLBACK DATASET
  // =========================================================================

  static final List<SearchProductItem> _allProducts = [
    const SearchProductItem(
      id: 'prod-1',
      title: 'Nike Air Max 270 React',
      brand: 'Nike',
      category: 'Sports Shoes',
      imageUrl: 'assets/banners/sneaker_banner_16_9.jpg',
      availableAt: ['Amazon', 'Myntra', 'Flipkart'],
      bestEffectivePrice: 4650,
      originalPrice: 5999,
      cashbackAmount: 350,
      cashbackPercentage: 10,
      couponText: '₹500 OFF',
      couponDiscount: 500,
      badge: '🏆 Best Deal',
      bestStore: 'Myntra',
      description: 'Nike Air Max 270 offers all-day comfort with the largest Air Max heel unit yet.',
      stores: [
        StoreComparisonDetail(
          store: 'Amazon',
          price: 5600,
          storeDiscount: 399,
          cashback: 300,
          coupon: 200,
          effectivePrice: 5100,
          savings: 899,
          isBest: false,
        ),
        StoreComparisonDetail(
          store: 'Myntra',
          price: 5500,
          storeDiscount: 499,
          cashback: 350,
          coupon: 500,
          effectivePrice: 4650,
          savings: 1349,
          isBest: true,
        ),
        StoreComparisonDetail(
          store: 'Flipkart',
          price: 5400,
          storeDiscount: 599,
          cashback: 250,
          coupon: 300,
          effectivePrice: 4850,
          savings: 1149,
          isBest: false,
        ),
      ],
    ),
    const SearchProductItem(
      id: 'prod-2',
      title: 'Nike Revolution 6 Running Shoes',
      brand: 'Nike',
      category: 'Running Shoes',
      imageUrl: 'assets/banners/sneaker_banner_16_9.jpg',
      availableAt: ['AJIO', 'Myntra', 'Amazon'],
      bestEffectivePrice: 2749,
      originalPrice: 3999,
      cashbackAmount: 250,
      cashbackPercentage: 8,
      couponText: '₹300 OFF',
      couponDiscount: 300,
      badge: '🔥 Hot Pick',
      bestStore: 'AJIO',
      description: 'Simple and comfortable. Set the pace at the start of your running journey.',
      stores: [
        StoreComparisonDetail(
          store: 'AJIO',
          price: 3299,
          storeDiscount: 700,
          cashback: 250,
          coupon: 300,
          effectivePrice: 2749,
          savings: 1250,
          isBest: true,
        ),
        StoreComparisonDetail(
          store: 'Myntra',
          price: 3499,
          storeDiscount: 500,
          cashback: 200,
          coupon: 250,
          effectivePrice: 3049,
          savings: 950,
          isBest: false,
        ),
        StoreComparisonDetail(
          store: 'Amazon',
          price: 3599,
          storeDiscount: 400,
          cashback: 180,
          coupon: 200,
          effectivePrice: 3219,
          savings: 780,
          isBest: false,
        ),
      ],
    ),
    const SearchProductItem(
      id: 'prod-3',
      title: 'Nike Air Force 1 \'07',
      brand: 'Nike',
      category: 'Casual Shoes',
      imageUrl: 'assets/banners/sneaker_banner_16_9.jpg',
      availableAt: ['Nike India', 'Myntra'],
      bestEffectivePrice: 6995,
      originalPrice: 8495,
      cashbackAmount: 600,
      cashbackPercentage: 8,
      couponText: '₹400 OFF',
      couponDiscount: 400,
      badge: '🏆 Best Deal',
      bestStore: 'Myntra',
      description: 'The radiance lives on in the Nike Air Force 1 07, the basketball icon.',
      stores: [
        StoreComparisonDetail(
          store: 'Myntra',
          price: 7995,
          storeDiscount: 500,
          cashback: 600,
          coupon: 400,
          effectivePrice: 6995,
          savings: 1500,
          isBest: true,
        ),
        StoreComparisonDetail(
          store: 'Nike India',
          price: 8495,
          storeDiscount: 0,
          cashback: 400,
          coupon: 0,
          effectivePrice: 8095,
          savings: 400,
          isBest: false,
        ),
      ],
    ),
    const SearchProductItem(
      id: 'prod-4',
      title: 'Apple iPhone 15 (128 GB)',
      brand: 'Apple',
      category: 'Smartphones',
      imageUrl: 'assets/banners/phone_banner_16_9.jpg',
      availableAt: ['Flipkart', 'Amazon', 'Croma'],
      bestEffectivePrice: 66499,
      originalPrice: 79900,
      cashbackAmount: 2500,
      cashbackPercentage: 4,
      couponText: '₹2,000 Bank OFF',
      couponDiscount: 2000,
      badge: '🏆 Best Deal',
      bestStore: 'Flipkart',
      description: 'Dynamic Island, 48MP Main camera, and USB-C in an industry-leading design.',
      stores: [
        StoreComparisonDetail(
          store: 'Flipkart',
          price: 70999,
          storeDiscount: 8901,
          cashback: 2500,
          coupon: 2000,
          effectivePrice: 66499,
          savings: 13401,
          isBest: true,
        ),
        StoreComparisonDetail(
          store: 'Amazon',
          price: 71999,
          storeDiscount: 7901,
          cashback: 2000,
          coupon: 1500,
          effectivePrice: 68499,
          savings: 11401,
          isBest: false,
        ),
      ],
    ),
    const SearchProductItem(
      id: 'prod-5',
      title: 'Sony WH-1000XM5 ANC Headphones',
      brand: 'Sony',
      category: 'Electronics',
      imageUrl: 'assets/banners/headphone_banner_16_9.jpg',
      availableAt: ['Amazon', 'Croma', 'Flipkart'],
      bestEffectivePrice: 21690,
      originalPrice: 29990,
      cashbackAmount: 1800,
      cashbackPercentage: 7,
      couponText: '₹1,500 OFF',
      couponDiscount: 1500,
      badge: '🏆 Best Deal',
      bestStore: 'Amazon',
      description: 'Industry-leading noise cancellation with two processors and 8 microphones.',
      stores: [
        StoreComparisonDetail(
          store: 'Amazon',
          price: 24990,
          storeDiscount: 5000,
          cashback: 1800,
          coupon: 1500,
          effectivePrice: 21690,
          savings: 8300,
          isBest: true,
        ),
      ],
    ),
  ];

  static final List<SearchStoreItem> _allStores = [
    const SearchStoreItem(
      id: 'st-nike',
      name: 'Nike',
      logoUrl: 'assets/logos/nike.svg',
      cashbackRate: 'Up to 10%',
      availableOffers: '18+',
      availableCoupons: '8',
      websiteUrl: 'https://www.nike.com/in',
      category: 'Sports & Footwear',
    ),
    const SearchStoreItem(
      id: 'st-myntra',
      name: 'Myntra',
      logoUrl: 'assets/cards/myntra.jpg',
      cashbackRate: 'Up to 12%',
      availableOffers: '25+',
      availableCoupons: '12',
      websiteUrl: 'https://www.myntra.com',
      category: 'Fashion & Lifestyle',
    ),
    const SearchStoreItem(
      id: 'st-ajio',
      name: 'AJIO',
      logoUrl: 'assets/cards/ajio-coupons.jpg',
      cashbackRate: 'Up to 10%',
      availableOffers: '20+',
      availableCoupons: '9',
      websiteUrl: 'https://www.ajio.com',
      category: 'Fashion & Trends',
    ),
    const SearchStoreItem(
      id: 'st-amazon',
      name: 'Amazon',
      logoUrl: 'assets/cards/amazon.jpg',
      cashbackRate: 'Up to 8%',
      availableOffers: '50+',
      availableCoupons: '30',
      websiteUrl: 'https://www.amazon.in',
      category: 'All Retail',
    ),
    const SearchStoreItem(
      id: 'st-flipkart',
      name: 'Flipkart',
      logoUrl: 'assets/cards/flipkart-electronics.png',
      cashbackRate: 'Up to 6%',
      availableOffers: '40+',
      availableCoupons: '25',
      websiteUrl: 'https://www.flipkart.com',
      category: 'Electronics & Lifestyle',
    ),
  ];

  static final List<SearchCategoryItem> _allCategories = [
    const SearchCategoryItem(id: 'cat-1', name: 'Sports Shoes', icon: 'directions_run', queryKeyword: 'shoes'),
    const SearchCategoryItem(id: 'cat-2', name: 'Men\'s Shoes', icon: 'man', queryKeyword: 'shoes'),
    const SearchCategoryItem(id: 'cat-3', name: 'Running Shoes', icon: 'fitness_center', queryKeyword: 'shoes'),
    const SearchCategoryItem(id: 'cat-4', name: 'Casual Shoes', icon: 'ice_skating', queryKeyword: 'shoes'),
    const SearchCategoryItem(id: 'cat-5', name: 'Smartphones', icon: 'smartphone', queryKeyword: 'smartphones'),
    const SearchCategoryItem(id: 'cat-6', name: 'Fashion', icon: 'checkroom', queryKeyword: 'fashion'),
    const SearchCategoryItem(id: 'cat-7', name: 'Electronics', icon: 'devices', queryKeyword: 'electronics'),
    const SearchCategoryItem(id: 'cat-8', name: 'Laptops', icon: 'laptop', queryKeyword: 'laptops'),
  ];

  static final List<SearchOfferItem> _allOffers = [
    const SearchOfferItem(
      id: 'off-nike-1',
      store: 'Nike',
      title: 'Nike — Up to 40% OFF End of Season Sale',
      discount: 'Up to 40% OFF',
      cashback: 'Extra 10% Cashback',
      expiry: 'Valid till 30 Sep',
      category: 'Sports',
      imageUrl: 'assets/banners/sneaker_banner_16_9.jpg',
      ctaText: 'Shop Now',
    ),
    const SearchOfferItem(
      id: 'off-myntra-1',
      store: 'Myntra',
      title: 'Nike & Footwear Mania — Extra 20% OFF',
      discount: 'Extra 20% OFF',
      cashback: '12% Cashback',
      expiry: 'Ends in 2 days',
      category: 'Fashion',
      imageUrl: 'assets/cards/col_myntra.jpg',
      ctaText: 'Shop Now',
    ),
    const SearchOfferItem(
      id: 'off-ajio-1',
      store: 'AJIO',
      title: 'Sneakers Fest — Up to 50% OFF on Top Footwear',
      discount: 'Up to 50% OFF',
      cashback: '10% Cashback',
      expiry: 'Limited Time',
      category: 'Fashion',
      imageUrl: 'assets/cards/col_ajio.jpg',
      ctaText: 'Shop Now',
    ),
    const SearchOfferItem(
      id: 'off-amazon-1',
      store: 'Amazon',
      title: 'Amazon Tech Clearance — Flat ₹500 OFF + 8% Cashback',
      discount: 'Extra ₹500 OFF',
      cashback: '8% Cashback',
      expiry: 'Valid today only',
      category: 'Electronics',
      imageUrl: 'assets/banners/headphone_banner_16_9.jpg',
      ctaText: 'Shop Now',
    ),
  ];

  static final List<SearchCouponItem> _allCoupons = [
    const SearchCouponItem(
      id: 'cp-nike-1',
      code: 'NIKE500',
      store: 'Nike',
      discount: '₹500 OFF',
      minOrder: 2999,
      cashback: 'Up to 10%',
      validity: 'Valid till 30 Sep',
      description: 'Flat ₹500 instant discount on orders above ₹2,999 on Nike Official',
    ),
    const SearchCouponItem(
      id: 'cp-nike-2',
      code: 'NIKE10',
      store: 'Nike',
      discount: '10% OFF',
      minOrder: 1999,
      cashback: 'Up to 10%',
      validity: 'Valid till 15 Oct',
      description: '10% instant discount on newly arrived sports gear and sneakers',
    ),
    const SearchCouponItem(
      id: 'cp-myntra-1',
      code: 'MYNTRA500',
      store: 'Myntra',
      discount: '₹500 OFF',
      minOrder: 2499,
      cashback: 'Up to 12%',
      validity: 'Valid till 28 Sep',
      description: 'Applicable on orders above ₹2,499 across all footwear and apparel',
    ),
    const SearchCouponItem(
      id: 'cp-ajio-1',
      code: 'AJIO15',
      store: 'AJIO',
      discount: '15% OFF',
      minOrder: 2499,
      cashback: 'Up to 10%',
      validity: 'Valid this weekend',
      description: 'Flat 15% discount on top international apparel and sneakers',
    ),
  ];

  UniversalSearchResult _getOfflineUniversalSearchResults(
    String query,
    UniversalSearchType type,
  ) {
    final q = query.toLowerCase();

    final matchedProducts = _allProducts.where((p) {
      return p.title.toLowerCase().includes(q) ||
          p.brand.toLowerCase().includes(q) ||
          p.category.toLowerCase().includes(q) ||
          p.availableAt.any((s) => s.toLowerCase().includes(q));
    }).toList();

    final matchedStores = _allStores.where((s) {
      return s.name.toLowerCase().includes(q) || s.category.toLowerCase().includes(q);
    }).toList();

    final matchedCategories = _allCategories.where((c) {
      return c.name.toLowerCase().includes(q) ||
          c.queryKeyword.toLowerCase().includes(q) ||
          q.includes(c.queryKeyword.toLowerCase());
    }).toList();

    final matchedOffers = _allOffers.where((o) {
      return o.title.toLowerCase().includes(q) ||
          o.store.toLowerCase().includes(q) ||
          o.discount.toLowerCase().includes(q) ||
          o.category.toLowerCase().includes(q);
    }).toList();

    final matchedCoupons = _allCoupons.where((c) {
      return c.store.toLowerCase().includes(q) ||
          c.code.toLowerCase().includes(q) ||
          c.discount.toLowerCase().includes(q) ||
          c.description.toLowerCase().includes(q);
    }).toList();

    return UniversalSearchResult(
      products: (type == UniversalSearchType.all || type == UniversalSearchType.products)
          ? matchedProducts
          : [],
      stores: (type == UniversalSearchType.all || type == UniversalSearchType.stores)
          ? matchedStores
          : [],
      categories: (type == UniversalSearchType.all || type == UniversalSearchType.categories)
          ? matchedCategories
          : [],
      offers: (type == UniversalSearchType.all || type == UniversalSearchType.offers)
          ? matchedOffers
          : [],
      coupons: (type == UniversalSearchType.all || type == UniversalSearchType.coupons)
          ? matchedCoupons
          : [],
    );
  }

  ProductComparisonData _getOfflineComparison(String productId) {
    final prod = _allProducts.firstWhere(
      (p) => p.id == productId,
      orElse: () => _allProducts.first,
    );

    return ProductComparisonData(
      productId: prod.id,
      title: prod.title,
      brand: prod.brand,
      category: prod.category,
      imageUrl: prod.imageUrl,
      description: prod.description,
      bestStore: prod.bestStore,
      bestEffectivePrice: prod.bestEffectivePrice,
      stores: prod.stores,
      smartSavings: SmartSavingsBreakdown(
        productPrice: prod.originalPrice,
        storeDiscount: prod.stores.isNotEmpty ? prod.stores.first.storeDiscount : 500,
        couponDiscount: prod.couponDiscount,
        bankDiscount: 0,
        cashback: prod.cashbackAmount,
        totalSavings: prod.originalPrice - prod.bestEffectivePrice,
        effectivePrice: prod.bestEffectivePrice,
        isBestDeal: true,
      ),
    );
  }
}

extension StringCheckExtension on String {
  bool includes(String query) => contains(query);
}
