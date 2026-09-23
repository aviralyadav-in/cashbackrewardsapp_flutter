/// Data models for Category Shopping Flow:
/// Category -> Subcategory -> Brands/Stores -> Products -> Smart Price Comparison
library;

class CategoryOverviewModel {
  final String id;
  final String name;
  final String description;
  final String? categoryId;
  final String? categoryName;

  const CategoryOverviewModel({
    required this.id,
    required this.name,
    required this.description,
    this.categoryId,
    this.categoryName,
  });

  factory CategoryOverviewModel.fromJson(Map<String, dynamic> json) {
    return CategoryOverviewModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      categoryId: json['categoryId'] as String?,
      categoryName: json['categoryName'] as String?,
    );
  }
}

class SubcategoryItemModel {
  final String id;
  final String name;
  final String icon;
  final String itemCount;

  const SubcategoryItemModel({
    required this.id,
    required this.name,
    required this.icon,
    this.itemCount = '',
  });

  factory SubcategoryItemModel.fromJson(Map<String, dynamic> json) {
    return SubcategoryItemModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      icon: json['icon'] as String? ?? '',
      itemCount: json['itemCount'] as String? ?? '',
    );
  }
}

class CategoryStoreModel {
  final String id;
  final String name;
  final String logoUrl;
  final String cashbackRate;
  final String offersCount;
  final bool hasCoupons;
  final String actionUrl;
  final String category;

  const CategoryStoreModel({
    required this.id,
    required this.name,
    required this.logoUrl,
    required this.cashbackRate,
    required this.offersCount,
    this.hasCoupons = false,
    this.actionUrl = '',
    this.category = '',
  });

  factory CategoryStoreModel.fromJson(Map<String, dynamic> json) {
    return CategoryStoreModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      logoUrl: json['logoUrl'] as String? ?? '',
      cashbackRate: json['cashbackRate'] as String? ?? '',
      offersCount: json['offersCount'] as String? ?? '',
      hasCoupons: json['hasCoupons'] == true,
      actionUrl: json['actionUrl'] as String? ?? '',
      category: json['category'] as String? ?? '',
    );
  }
}

class CategoryDealModel {
  final String id;
  final String title;
  final String brand;
  final String store;
  final String imageUrl;
  final double originalPrice;
  final double discountedPrice;
  final double discountPercentage;
  final double cashbackPercentage;
  final double cashbackAmount;
  final String couponCode;
  final double couponDiscount;
  final double effectiveSavings;
  final double effectivePrice;
  final bool isBestDeal;
  final String badge;
  final List<String> storesAvailable;

  final String? gender;
  final String? style;

  const CategoryDealModel({
    required this.id,
    required this.title,
    required this.brand,
    required this.store,
    required this.imageUrl,
    required this.originalPrice,
    required this.discountedPrice,
    required this.discountPercentage,
    required this.cashbackPercentage,
    required this.cashbackAmount,
    required this.couponCode,
    required this.couponDiscount,
    required this.effectiveSavings,
    required this.effectivePrice,
    required this.isBestDeal,
    required this.badge,
    this.storesAvailable = const [],
    this.gender,
    this.style,
  });

  factory CategoryDealModel.fromJson(Map<String, dynamic> json) {
    double parse(dynamic val) {
      if (val == null) return 0.0;
      if (val is num) return val.toDouble();
      return double.tryParse(val.toString()) ?? 0.0;
    }

    final stores = (json['storesAvailable'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];

    return CategoryDealModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      brand: json['brand'] as String? ?? '',
      store: json['store'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      originalPrice: parse(json['originalPrice']),
      discountedPrice: parse(json['discountedPrice']),
      discountPercentage: parse(json['discountPercentage']),
      cashbackPercentage: parse(json['cashbackPercentage']),
      cashbackAmount: parse(json['cashbackAmount']),
      couponCode: json['couponCode'] as String? ?? '',
      couponDiscount: parse(json['couponDiscount']),
      effectiveSavings: parse(json['effectiveSavings']),
      effectivePrice: parse(json['effectivePrice']),
      isBestDeal: json['isBestDeal'] == true,
      badge: json['badge'] as String? ?? '',
      storesAvailable: stores,
      gender: json['gender'] as String?,
      style: json['style'] as String?,
    );
  }
}

class CategoryDetailResponse {
  final CategoryOverviewModel category;
  final List<SubcategoryItemModel> subcategories;
  final List<CategoryStoreModel> popularStores;
  final List<CategoryDealModel> bestDeals;
  final List<dynamic> offers;
  final List<dynamic> coupons;

  const CategoryDetailResponse({
    required this.category,
    required this.subcategories,
    required this.popularStores,
    required this.bestDeals,
    this.offers = const [],
    this.coupons = const [],
  });

  factory CategoryDetailResponse.fromJson(Map<String, dynamic> json) {
    final catMap = json['category'] as Map<String, dynamic>? ?? {};
    final subcats = (json['subcategories'] as List<dynamic>?)
            ?.map((e) => SubcategoryItemModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];
    final stores = (json['popularStores'] as List<dynamic>?)
            ?.map((e) => CategoryStoreModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];
    final deals = (json['bestDeals'] as List<dynamic>?)
            ?.map((e) => CategoryDealModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    return CategoryDetailResponse(
      category: CategoryOverviewModel.fromJson(catMap),
      subcategories: subcats,
      popularStores: stores,
      bestDeals: deals,
      offers: json['offers'] as List<dynamic>? ?? [],
      coupons: json['coupons'] as List<dynamic>? ?? [],
    );
  }
}

class SubcategoryDetailResponse {
  final CategoryOverviewModel subcategory;
  final List<String> filters;
  final Map<String, dynamic> subFilters;
  final List<CategoryDealModel> products;
  final List<CategoryStoreModel> stores;

  const SubcategoryDetailResponse({
    required this.subcategory,
    required this.filters,
    required this.subFilters,
    required this.products,
    required this.stores,
  });

  factory SubcategoryDetailResponse.fromJson(Map<String, dynamic> json) {
    final subMap = json['subcategory'] as Map<String, dynamic>? ?? {};
    final filtersList = (json['filters'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];
    final subFiltersMap = json['subFilters'] as Map<String, dynamic>? ?? {};
    final prodList = (json['products'] as List<dynamic>?)
            ?.map((e) => CategoryDealModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];
    final storeList = (json['stores'] as List<dynamic>?)
            ?.map((e) => CategoryStoreModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    return SubcategoryDetailResponse(
      subcategory: CategoryOverviewModel.fromJson(subMap),
      filters: filtersList,
      subFilters: subFiltersMap,
      products: prodList,
      stores: storeList,
    );
  }
}

class StoreComparisonDetail {
  final String store;
  final String logoUrl;
  final double productPrice;
  final double storeDiscount;
  final double couponDiscount;
  final double bankDiscount;
  final double payNow;
  final double cashback;
  final double effectiveCost;
  final double totalSavings;
  final bool isBestDeal;
  final String eligibility;
  final String shopUrl;

  const StoreComparisonDetail({
    required this.store,
    required this.logoUrl,
    required this.productPrice,
    required this.storeDiscount,
    required this.couponDiscount,
    required this.bankDiscount,
    required this.payNow,
    required this.cashback,
    required this.effectiveCost,
    required this.totalSavings,
    required this.isBestDeal,
    required this.eligibility,
    required this.shopUrl,
  });

  factory StoreComparisonDetail.fromJson(Map<String, dynamic> json) {
    double parse(dynamic val) {
      if (val == null) return 0.0;
      if (val is num) return val.toDouble();
      return double.tryParse(val.toString()) ?? 0.0;
    }

    return StoreComparisonDetail(
      store: json['store'] as String? ?? '',
      logoUrl: json['logoUrl'] as String? ?? '',
      productPrice: parse(json['productPrice']),
      storeDiscount: parse(json['storeDiscount']),
      couponDiscount: parse(json['couponDiscount']),
      bankDiscount: parse(json['bankDiscount']),
      payNow: parse(json['payNow']),
      cashback: parse(json['cashback']),
      effectiveCost: parse(json['effectiveCost']),
      totalSavings: parse(json['totalSavings']),
      isBestDeal: json['isBestDeal'] == true,
      eligibility: json['eligibility'] as String? ?? '',
      shopUrl: json['shopUrl'] as String? ?? '',
    );
  }
}

class BestDealSummary {
  final String store;
  final double payNow;
  final double potentialCashback;
  final double effectiveCost;
  final double totalSavings;

  const BestDealSummary({
    required this.store,
    required this.payNow,
    required this.potentialCashback,
    required this.effectiveCost,
    required this.totalSavings,
  });

  factory BestDealSummary.fromJson(Map<String, dynamic> json) {
    double parse(dynamic val) {
      if (val == null) return 0.0;
      if (val is num) return val.toDouble();
      return double.tryParse(val.toString()) ?? 0.0;
    }

    return BestDealSummary(
      store: json['store'] as String? ?? '',
      payNow: parse(json['payNow']),
      potentialCashback: parse(json['potentialCashback'] ?? json['cashback']),
      effectiveCost: parse(json['effectiveCost']),
      totalSavings: parse(json['totalSavings']),
    );
  }
}

class SmartProductComparison {
  final String productId;
  final String title;
  final String brand;
  final String imageUrl;
  final String category;
  final String subcategory;
  final double originalPrice;
  final List<StoreComparisonDetail> stores;
  final BestDealSummary bestDeal;
  final double totalSavings;

  const SmartProductComparison({
    required this.productId,
    required this.title,
    required this.brand,
    required this.imageUrl,
    required this.category,
    required this.subcategory,
    required this.originalPrice,
    required this.stores,
    required this.bestDeal,
    required this.totalSavings,
  });

  factory SmartProductComparison.fromJson(Map<String, dynamic> json) {
    double parse(dynamic val) {
      if (val == null) return 0.0;
      if (val is num) return val.toDouble();
      return double.tryParse(val.toString()) ?? 0.0;
    }

    final pMap = json['product'] as Map<String, dynamic>? ?? {};
    final storeList = (json['stores'] as List<dynamic>?)
            ?.map((e) => StoreComparisonDetail.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];
    final bMap = json['bestDeal'] as Map<String, dynamic>? ?? {};

    return SmartProductComparison(
      productId: pMap['id'] as String? ?? json['productId'] as String? ?? '',
      title: pMap['title'] as String? ?? json['title'] as String? ?? '',
      brand: pMap['brand'] as String? ?? json['brand'] as String? ?? '',
      imageUrl: pMap['imageUrl'] as String? ?? json['imageUrl'] as String? ?? '',
      category: pMap['category'] as String? ?? '',
      subcategory: pMap['subcategory'] as String? ?? '',
      originalPrice: parse(pMap['originalPrice']),
      stores: storeList,
      bestDeal: BestDealSummary.fromJson(bMap),
      totalSavings: parse(json['totalSavings']),
    );
  }
}
