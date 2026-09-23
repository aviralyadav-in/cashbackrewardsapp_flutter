
enum UniversalSearchType {
  all,
  products,
  stores,
  categories,
  offers,
  coupons,
}

extension UniversalSearchTypeExtension on UniversalSearchType {
  String get label {
    switch (this) {
      case UniversalSearchType.all:
        return 'All';
      case UniversalSearchType.products:
        return 'Products';
      case UniversalSearchType.stores:
        return 'Stores';
      case UniversalSearchType.categories:
        return 'Categories';
      case UniversalSearchType.offers:
        return 'Offers';
      case UniversalSearchType.coupons:
        return 'Coupons';
    }
  }

  String get apiKey {
    switch (this) {
      case UniversalSearchType.all:
        return 'all';
      case UniversalSearchType.products:
        return 'products';
      case UniversalSearchType.stores:
        return 'stores';
      case UniversalSearchType.categories:
        return 'categories';
      case UniversalSearchType.offers:
        return 'offers';
      case UniversalSearchType.coupons:
        return 'coupons';
    }
  }
}

class SearchProductItem {
  final String id;
  final String title;
  final String brand;
  final String category;
  final String imageUrl;
  final List<String> availableAt;
  final double bestEffectivePrice;
  final double originalPrice;
  final double cashbackAmount;
  final double cashbackPercentage;
  final String couponText;
  final double couponDiscount;
  final String badge;
  final String bestStore;
  final String description;
  final List<StoreComparisonDetail> stores;

  const SearchProductItem({
    required this.id,
    required this.title,
    required this.brand,
    required this.category,
    required this.imageUrl,
    required this.availableAt,
    required this.bestEffectivePrice,
    required this.originalPrice,
    required this.cashbackAmount,
    required this.cashbackPercentage,
    required this.couponText,
    required this.couponDiscount,
    required this.badge,
    required this.bestStore,
    required this.description,
    required this.stores,
  });

  factory SearchProductItem.fromJson(Map<String, dynamic> json) {
    double parse(dynamic v) {
      if (v == null) return 0.0;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString()) ?? 0.0;
    }

    final availableList = (json['availableAt'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];

    final storeList = (json['stores'] as List<dynamic>?)
            ?.map((e) => StoreComparisonDetail.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    return SearchProductItem(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      brand: json['brand'] as String? ?? '',
      category: json['category'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      availableAt: availableList,
      bestEffectivePrice: parse(json['bestEffectivePrice']),
      originalPrice: parse(json['originalPrice']),
      cashbackAmount: parse(json['cashbackAmount']),
      cashbackPercentage: parse(json['cashbackPercentage']),
      couponText: json['couponText'] as String? ?? '',
      couponDiscount: parse(json['couponDiscount']),
      badge: json['badge'] as String? ?? '🏆 Best Deal',
      bestStore: json['bestStore'] as String? ?? '',
      description: json['description'] as String? ?? '',
      stores: storeList,
    );
  }
}

class SearchStoreItem {
  final String id;
  final String name;
  final String logoUrl;
  final String cashbackRate;
  final String availableOffers;
  final String availableCoupons;
  final String websiteUrl;
  final String category;

  const SearchStoreItem({
    required this.id,
    required this.name,
    required this.logoUrl,
    required this.cashbackRate,
    required this.availableOffers,
    required this.availableCoupons,
    required this.websiteUrl,
    required this.category,
  });

  factory SearchStoreItem.fromJson(Map<String, dynamic> json) {
    return SearchStoreItem(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      logoUrl: json['logoUrl'] as String? ?? '',
      cashbackRate: json['cashbackRate'] as String? ?? '',
      availableOffers: json['availableOffers'] as String? ?? '0',
      availableCoupons: json['availableCoupons'] as String? ?? '0',
      websiteUrl: json['websiteUrl'] as String? ?? '',
      category: json['category'] as String? ?? '',
    );
  }
}

class SearchCategoryItem {
  final String id;
  final String name;
  final String icon;
  final String queryKeyword;

  const SearchCategoryItem({
    required this.id,
    required this.name,
    required this.icon,
    required this.queryKeyword,
  });

  factory SearchCategoryItem.fromJson(Map<String, dynamic> json) {
    return SearchCategoryItem(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      icon: json['icon'] as String? ?? 'grid_view',
      queryKeyword: json['queryKeyword'] as String? ?? '',
    );
  }
}

class SearchOfferItem {
  final String id;
  final String store;
  final String title;
  final String discount;
  final String cashback;
  final String expiry;
  final String category;
  final String imageUrl;
  final String ctaText;

  const SearchOfferItem({
    required this.id,
    required this.store,
    required this.title,
    required this.discount,
    required this.cashback,
    required this.expiry,
    required this.category,
    required this.imageUrl,
    required this.ctaText,
  });

  factory SearchOfferItem.fromJson(Map<String, dynamic> json) {
    return SearchOfferItem(
      id: json['id'] as String? ?? '',
      store: json['store'] as String? ?? '',
      title: json['title'] as String? ?? '',
      discount: json['discount'] as String? ?? '',
      cashback: json['cashback'] as String? ?? '',
      expiry: json['expiry'] as String? ?? '',
      category: json['category'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      ctaText: json['ctaText'] as String? ?? 'Shop Now',
    );
  }
}

class SearchCouponItem {
  final String id;
  final String code;
  final String store;
  final String discount;
  final double minOrder;
  final String cashback;
  final String validity;
  final String description;

  const SearchCouponItem({
    required this.id,
    required this.code,
    required this.store,
    required this.discount,
    required this.minOrder,
    required this.cashback,
    required this.validity,
    required this.description,
  });

  factory SearchCouponItem.fromJson(Map<String, dynamic> json) {
    double parse(dynamic v) {
      if (v == null) return 0.0;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString()) ?? 0.0;
    }

    return SearchCouponItem(
      id: json['id'] as String? ?? '',
      code: json['code'] as String? ?? '',
      store: json['store'] as String? ?? '',
      discount: json['discount'] as String? ?? '',
      minOrder: parse(json['minOrder']),
      cashback: json['cashback'] as String? ?? '',
      validity: json['validity'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }
}

class UniversalSearchResult {
  final List<SearchProductItem> products;
  final List<SearchStoreItem> stores;
  final List<SearchCategoryItem> categories;
  final List<SearchOfferItem> offers;
  final List<SearchCouponItem> coupons;

  const UniversalSearchResult({
    required this.products,
    required this.stores,
    required this.categories,
    required this.offers,
    required this.coupons,
  });

  bool get isEmpty =>
      products.isEmpty &&
      stores.isEmpty &&
      categories.isEmpty &&
      offers.isEmpty &&
      coupons.isEmpty;

  factory UniversalSearchResult.empty() {
    return const UniversalSearchResult(
      products: [],
      stores: [],
      categories: [],
      offers: [],
      coupons: [],
    );
  }

  factory UniversalSearchResult.fromJson(Map<String, dynamic> json) {
    return UniversalSearchResult(
      products: (json['products'] as List<dynamic>?)
              ?.map((e) => SearchProductItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      stores: (json['stores'] as List<dynamic>?)
              ?.map((e) => SearchStoreItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      categories: (json['categories'] as List<dynamic>?)
              ?.map((e) => SearchCategoryItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      offers: (json['offers'] as List<dynamic>?)
              ?.map((e) => SearchOfferItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      coupons: (json['coupons'] as List<dynamic>?)
              ?.map((e) => SearchCouponItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class StoreComparisonDetail {
  final String store;
  final double price;
  final double storeDiscount;
  final double cashback;
  final double coupon;
  final double effectivePrice;
  final double savings;
  final bool isBest;
  final double bankDiscount;
  final double payNow;
  final String eligibility;
  final String shopUrl;

  const StoreComparisonDetail({
    required this.store,
    required this.price,
    required this.storeDiscount,
    required this.cashback,
    required this.coupon,
    required this.effectivePrice,
    required this.savings,
    required this.isBest,
    this.bankDiscount = 0.0,
    double? payNow,
    this.eligibility = '',
    this.shopUrl = '',
  }) : payNow = payNow ?? (price - storeDiscount - coupon);

  factory StoreComparisonDetail.fromJson(Map<String, dynamic> json) {
    double parse(dynamic v) {
      if (v == null) return 0.0;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString()) ?? 0.0;
    }

    final price = parse(json['price'] ?? json['productPrice']);
    final storeDiscount = parse(json['storeDiscount']);
    final coupon = parse(json['coupon'] ?? json['couponDiscount']);
    final bankDiscount = parse(json['bankDiscount']);
    final cashback = parse(json['cashback']);
    final effectivePrice = parse(json['effectivePrice'] ?? json['effectiveCost']);
    final savings = parse(json['savings'] ?? json['totalSavings']);
    final payNow = json['payNow'] != null
        ? parse(json['payNow'])
        : (price - storeDiscount - coupon - bankDiscount);

    return StoreComparisonDetail(
      store: json['store'] as String? ?? '',
      price: price,
      storeDiscount: storeDiscount,
      cashback: cashback,
      coupon: coupon,
      effectivePrice: effectivePrice > 0 ? effectivePrice : (payNow - cashback),
      savings: savings,
      isBest: json['isBest'] == true || json['isBestDeal'] == true,
      bankDiscount: bankDiscount,
      payNow: payNow,
      eligibility: json['eligibility'] as String? ?? '',
      shopUrl: json['shopUrl'] as String? ?? '',
    );
  }
}

class SmartSavingsBreakdown {
  final double productPrice;
  final double storeDiscount;
  final double couponDiscount;
  final double bankDiscount;
  final double cashback;
  final double totalSavings;
  final double effectivePrice;
  final bool isBestDeal;

  const SmartSavingsBreakdown({
    required this.productPrice,
    required this.storeDiscount,
    required this.couponDiscount,
    required this.bankDiscount,
    required this.cashback,
    required this.totalSavings,
    required this.effectivePrice,
    required this.isBestDeal,
  });

  factory SmartSavingsBreakdown.fromJson(Map<String, dynamic> json) {
    double parse(dynamic v) {
      if (v == null) return 0.0;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString()) ?? 0.0;
    }

    return SmartSavingsBreakdown(
      productPrice: parse(json['productPrice']),
      storeDiscount: parse(json['storeDiscount']),
      couponDiscount: parse(json['couponDiscount']),
      bankDiscount: parse(json['bankDiscount']),
      cashback: parse(json['cashback']),
      totalSavings: parse(json['totalSavings']),
      effectivePrice: parse(json['effectivePrice']),
      isBestDeal: json['isBestDeal'] == true,
    );
  }
}

class ProductComparisonData {
  final String productId;
  final String title;
  final String brand;
  final String category;
  final String imageUrl;
  final String description;
  final String bestStore;
  final double bestEffectivePrice;
  final List<StoreComparisonDetail> stores;
  final SmartSavingsBreakdown smartSavings;

  const ProductComparisonData({
    required this.productId,
    required this.title,
    required this.brand,
    required this.category,
    required this.imageUrl,
    required this.description,
    required this.bestStore,
    required this.bestEffectivePrice,
    required this.stores,
    required this.smartSavings,
  });

  factory ProductComparisonData.fromJson(Map<String, dynamic> json) {
    double parse(dynamic v) {
      if (v == null) return 0.0;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString()) ?? 0.0;
    }

    final storeList = (json['stores'] as List<dynamic>?)
            ?.map((e) => StoreComparisonDetail.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    return ProductComparisonData(
      productId: json['productId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      brand: json['brand'] as String? ?? '',
      category: json['category'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      description: json['description'] as String? ?? '',
      bestStore: json['bestStore'] as String? ?? '',
      bestEffectivePrice: parse(json['bestEffectivePrice']),
      stores: storeList,
      smartSavings: SmartSavingsBreakdown.fromJson(
        json['smartSavings'] as Map<String, dynamic>? ?? {},
      ),
    );
  }
}
