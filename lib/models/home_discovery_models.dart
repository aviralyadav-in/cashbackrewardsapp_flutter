
import '../core/utils/brand_asset_helper.dart';

/// Model representing user cashback summary for home screen
class CashbackSummaryModel {
  final double availableCashback;
  final double pendingCashback;
  final double totalSavings;

  const CashbackSummaryModel({
    required this.availableCashback,
    required this.pendingCashback,
    required this.totalSavings,
  });

  factory CashbackSummaryModel.fromJson(Map<String, dynamic> json) {
    double parse(dynamic val) {
      if (val == null) return 0.0;
      if (val is num) return val.toDouble();
      return double.tryParse(val.toString()) ?? 0.0;
    }

    return CashbackSummaryModel(
      availableCashback: parse(json['availableCashback']),
      pendingCashback: parse(json['pendingCashback']),
      totalSavings: parse(json['totalSavings']),
    );
  }

  Map<String, dynamic> toJson() => {
    'availableCashback': availableCashback,
    'pendingCashback': pendingCashback,
    'totalSavings': totalSavings,
  };
}

/// Model for Recommended Best Deals (🏆 Best Deals For You)
class BestDealModel {
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
  final String category;
  final List<String> storesAvailable;
  final List<StoreDealComparison> stores;

  const BestDealModel({
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
    required this.category,
    required this.storesAvailable,
    this.stores = const [],
  });

  factory BestDealModel.fromJson(Map<String, dynamic> json) {
    double parse(dynamic val) {
      if (val == null) return 0.0;
      if (val is num) return val.toDouble();
      return double.tryParse(val.toString()) ?? 0.0;
    }

    final storesList = (json['storesAvailable'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];

    final comparisonStores = (json['stores'] as List<dynamic>?)
            ?.map((e) => StoreDealComparison.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    return BestDealModel(
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
      badge: json['badge'] as String? ?? '🏆 Best Deal',
      category: json['category'] as String? ?? '',
      storesAvailable: storesList,
      stores: comparisonStores,
    );
  }
}

/// Model for Promotional Offers (🔥 Offers)
class HomeOfferModel {
  final String id;
  final String store;
  final String storeLogo;
  final String title;
  final String discount;
  final String cashback;
  final double cashbackRate;
  final String validity;
  final String imageUrl;
  final String category;
  final String actionUrl;

  const HomeOfferModel({
    required this.id,
    required this.store,
    required this.storeLogo,
    required this.title,
    required this.discount,
    required this.cashback,
    required this.cashbackRate,
    required this.validity,
    required this.imageUrl,
    required this.category,
    required this.actionUrl,
  });

  factory HomeOfferModel.fromJson(Map<String, dynamic> json) {
    double parse(dynamic val) {
      if (val == null) return 0.0;
      if (val is num) return val.toDouble();
      return double.tryParse(val.toString()) ?? 0.0;
    }

    return HomeOfferModel(
      id: json['id'] as String? ?? '',
      store: json['store'] as String? ?? '',
      storeLogo: json['storeLogo'] as String? ?? '',
      title: json['title'] as String? ?? '',
      discount: json['discount'] as String? ?? '',
      cashback: json['cashback'] as String? ?? '',
      cashbackRate: parse(json['cashbackRate']),
      validity: json['validity'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      category: json['category'] as String? ?? '',
      actionUrl: json['actionUrl'] as String? ?? '',
    );
  }
}

/// Model for Coupons (🎟️ Coupons)
class HomeCouponModel {
  final String id;
  final String code;
  final String store;
  final String discount;
  final double minOrder;
  final String cashback;
  final String validity;
  final String description;
  final String logoUrl;
  final String applicableOn;
  final String successRate;
  final List<String> terms;

  const HomeCouponModel({
    required this.id,
    required this.code,
    required this.store,
    required this.discount,
    required this.minOrder,
    required this.cashback,
    required this.validity,
    required this.description,
    this.logoUrl = '',
    this.applicableOn = 'All Products & Categories',
    this.successRate = '98% Success Rate',
    this.terms = const [
      'Valid for all registered KashIQ members.',
      'Discount applies directly at the merchant checkout.',
      'Cannot be combined with other store promo codes unless specified.',
      'Cashback will be tracked and credited to your wallet within 24-48 hours.',
      'Standard merchant return and cancellation terms apply.',
    ],
  });

  /// Static helper to resolve crisp brand logo from local assets
  static String resolveLogo(String storeName, {String fallbackUrl = ''}) {
    return BrandAssetHelper.getBrandLogo(storeName, fallback: fallbackUrl);
  }

  factory HomeCouponModel.fromJson(Map<String, dynamic> json) {
    double parse(dynamic val) {
      if (val == null) return 0.0;
      if (val is num) return val.toDouble();
      return double.tryParse(val.toString()) ?? 0.0;
    }

    final termsList = (json['terms'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        const [
          'Valid for all registered KashIQ members.',
          'Discount applies directly at the merchant checkout.',
          'Cannot be combined with other store promo codes unless specified.',
          'Cashback will be tracked and credited to your wallet within 24-48 hours.',
          'Standard merchant return and cancellation terms apply.',
        ];

    final storeStr = json['store'] as String? ?? '';
    final rawLogo = json['logoUrl'] as String? ?? '';

    return HomeCouponModel(
      id: json['id'] as String? ?? '',
      code: json['code'] as String? ?? '',
      store: storeStr,
      discount: json['discount'] as String? ?? '',
      minOrder: parse(json['minOrder']),
      cashback: json['cashback'] as String? ?? '',
      validity: json['validity'] as String? ?? '',
      description: json['description'] as String? ?? '',
      logoUrl: rawLogo.isNotEmpty ? rawLogo : HomeCouponModel.resolveLogo(storeStr),
      applicableOn: json['applicableOn'] as String? ?? 'All Products & Categories',
      successRate: json['successRate'] as String? ?? '98% Success Rate',
      terms: termsList,
    );
  }
}

/// Store-level deal breakdown within Smart Savings
class StoreDealComparison {
  final String store;
  final double price;
  final double storeDiscount;
  final double cashback;
  final double coupon;
  final double effectivePrice;
  final double savings;
  final bool isBest;

  const StoreDealComparison({
    required this.store,
    required this.price,
    required this.storeDiscount,
    required this.cashback,
    required this.coupon,
    required this.effectivePrice,
    required this.savings,
    required this.isBest,
  });

  factory StoreDealComparison.fromJson(Map<String, dynamic> json) {
    double parse(dynamic val) {
      if (val == null) return 0.0;
      if (val is num) return val.toDouble();
      return double.tryParse(val.toString()) ?? 0.0;
    }

    return StoreDealComparison(
      store: json['store'] as String? ?? '',
      price: parse(json['price']),
      storeDiscount: parse(json['storeDiscount']),
      cashback: parse(json['cashback']),
      coupon: parse(json['coupon']),
      effectivePrice: parse(json['effectivePrice']),
      savings: parse(json['savings']),
      isBest: json['isBest'] == true,
    );
  }
}

/// Model for Smart Savings Preview (🧮 Smart Savings)
class SmartSavingsModel {
  final String id;
  final String productName;
  final String brand;
  final String imageUrl;
  final double productPrice;
  final double storeDiscount;
  final double couponDiscount;
  final double bankDiscount;
  final double cashback;
  final double totalSavings;
  final double effectivePrice;
  final bool isBestDeal;
  final String bestStore;
  final List<StoreDealComparison> stores;

  const SmartSavingsModel({
    required this.id,
    required this.productName,
    required this.brand,
    required this.imageUrl,
    required this.productPrice,
    required this.storeDiscount,
    required this.couponDiscount,
    required this.bankDiscount,
    required this.cashback,
    required this.totalSavings,
    required this.effectivePrice,
    required this.isBestDeal,
    required this.bestStore,
    required this.stores,
  });

  factory SmartSavingsModel.fromJson(Map<String, dynamic> json) {
    double parse(dynamic val) {
      if (val == null) return 0.0;
      if (val is num) return val.toDouble();
      return double.tryParse(val.toString()) ?? 0.0;
    }

    final storeList = (json['stores'] as List<dynamic>?)
            ?.map((e) => StoreDealComparison.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    return SmartSavingsModel(
      id: json['id'] as String? ?? '',
      productName: json['productName'] as String? ?? '',
      brand: json['brand'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      productPrice: parse(json['productPrice']),
      storeDiscount: parse(json['storeDiscount']),
      couponDiscount: parse(json['couponDiscount']),
      bankDiscount: parse(json['bankDiscount']),
      cashback: parse(json['cashback']),
      totalSavings: parse(json['totalSavings']),
      effectivePrice: parse(json['effectivePrice']),
      isBestDeal: json['isBestDeal'] == true,
      bestStore: json['bestStore'] as String? ?? '',
      stores: storeList,
    );
  }
}

/// Model for Featured Stores (⭐ Featured Stores)
class FeaturedStoreModel {
  final String id;
  final String name;
  final String logoUrl;
  final String cashbackRate;
  final double maxCashback;
  final String offerTag;
  final int totalOffers;
  final int totalCoupons;
  final String websiteUrl;

  const FeaturedStoreModel({
    required this.id,
    required this.name,
    required this.logoUrl,
    required this.cashbackRate,
    required this.maxCashback,
    required this.offerTag,
    required this.totalOffers,
    required this.totalCoupons,
    required this.websiteUrl,
  });

  factory FeaturedStoreModel.fromJson(Map<String, dynamic> json) {
    double parse(dynamic val) {
      if (val == null) return 0.0;
      if (val is num) return val.toDouble();
      return double.tryParse(val.toString()) ?? 0.0;
    }

    return FeaturedStoreModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      logoUrl: json['logoUrl'] as String? ?? '',
      cashbackRate: json['cashbackRate'] as String? ?? '',
      maxCashback: parse(json['maxCashback']),
      offerTag: json['offerTag'] as String? ?? '',
      totalOffers: (json['totalOffers'] as num? ?? 0).toInt(),
      totalCoupons: (json['totalCoupons'] as num? ?? 0).toInt(),
      websiteUrl: json['websiteUrl'] as String? ?? '',
    );
  }
}

/// Model for Trending Deals (🔥 Trending Deals)
class TrendingDealModel {
  final String id;
  final String brand;
  final String productName;
  final double price;
  final double originalPrice;
  final String discount;
  final String cashback;
  final double cashbackAmount;
  final String savingAmount;
  final String badge;
  final String urgency;
  final String imageUrl;
  final String store;

  const TrendingDealModel({
    required this.id,
    required this.brand,
    required this.productName,
    required this.price,
    required this.originalPrice,
    required this.discount,
    required this.cashback,
    required this.cashbackAmount,
    required this.savingAmount,
    required this.badge,
    required this.urgency,
    required this.imageUrl,
    required this.store,
  });

  factory TrendingDealModel.fromJson(Map<String, dynamic> json) {
    double parse(dynamic val) {
      if (val == null) return 0.0;
      if (val is num) return val.toDouble();
      return double.tryParse(val.toString()) ?? 0.0;
    }

    return TrendingDealModel(
      id: json['id'] as String? ?? '',
      brand: json['brand'] as String? ?? '',
      productName: json['productName'] as String? ?? '',
      price: parse(json['price']),
      originalPrice: parse(json['originalPrice']),
      discount: json['discount'] as String? ?? '',
      cashback: json['cashback'] as String? ?? '',
      cashbackAmount: parse(json['cashbackAmount']),
      savingAmount: json['savingAmount'] as String? ?? '',
      badge: json['badge'] as String? ?? '🔥 Trending',
      urgency: json['urgency'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      store: json['store'] as String? ?? '',
    );
  }
}

/// Model for Price Drops (📉 Price Drops)
class PriceDropModel {
  final String id;
  final String brand;
  final String productName;
  final double wasPrice;
  final double nowPrice;
  final double priceDropAmount;
  final String priceDropBadge;
  final String cashback;
  final double cashbackAmount;
  final String store;
  final String imageUrl;

  const PriceDropModel({
    required this.id,
    required this.brand,
    required this.productName,
    required this.wasPrice,
    required this.nowPrice,
    required this.priceDropAmount,
    required this.priceDropBadge,
    required this.cashback,
    required this.cashbackAmount,
    required this.store,
    required this.imageUrl,
  });

  factory PriceDropModel.fromJson(Map<String, dynamic> json) {
    double parse(dynamic val) {
      if (val == null) return 0.0;
      if (val is num) return val.toDouble();
      return double.tryParse(val.toString()) ?? 0.0;
    }

    return PriceDropModel(
      id: json['id'] as String? ?? '',
      brand: json['brand'] as String? ?? '',
      productName: json['productName'] as String? ?? '',
      wasPrice: parse(json['wasPrice']),
      nowPrice: parse(json['nowPrice']),
      priceDropAmount: parse(json['priceDropAmount']),
      priceDropBadge: json['priceDropBadge'] as String? ?? 'Price Drop',
      cashback: json['cashback'] as String? ?? '',
      cashbackAmount: parse(json['cashbackAmount']),
      store: json['store'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
    );
  }
}

/// Model for Cashback Increases (📈 Cashback Increased)
class CashbackIncreaseModel {
  final String id;
  final String store;
  final String logoUrl;
  final String previousRate;
  final String newRate;
  final String headline;
  final String badge;
  final String description;

  const CashbackIncreaseModel({
    required this.id,
    required this.store,
    required this.logoUrl,
    required this.previousRate,
    required this.newRate,
    required this.headline,
    required this.badge,
    required this.description,
  });

  factory CashbackIncreaseModel.fromJson(Map<String, dynamic> json) {
    return CashbackIncreaseModel(
      id: json['id'] as String? ?? '',
      store: json['store'] as String? ?? '',
      logoUrl: json['logoUrl'] as String? ?? '',
      previousRate: json['previousRate'] as String? ?? '',
      newRate: json['newRate'] as String? ?? '',
      headline: json['headline'] as String? ?? '',
      badge: json['badge'] as String? ?? '🔥 Limited-time increase',
      description: json['description'] as String? ?? '',
    );
  }
}

/// Aggregated response model for Home Screen
class HomeDataModel {
  final CashbackSummaryModel cashbackSummary;
  final List<BestDealModel> bestDeals;
  final List<HomeOfferModel> offers;
  final List<HomeCouponModel> coupons;
  final List<SmartSavingsModel> smartSavings;
  final List<FeaturedStoreModel> featuredStores;
  final List<TrendingDealModel> trendingDeals;
  final List<PriceDropModel> priceDrops;
  final List<CashbackIncreaseModel> cashbackIncreases;

  const HomeDataModel({
    required this.cashbackSummary,
    required this.bestDeals,
    required this.offers,
    required this.coupons,
    required this.smartSavings,
    required this.featuredStores,
    required this.trendingDeals,
    required this.priceDrops,
    required this.cashbackIncreases,
  });

  factory HomeDataModel.fromJson(Map<String, dynamic> json) {
    return HomeDataModel(
      cashbackSummary: CashbackSummaryModel.fromJson(
        json['cashbackSummary'] as Map<String, dynamic>? ?? {},
      ),
      bestDeals: (json['bestDeals'] as List<dynamic>?)
              ?.map((e) => BestDealModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      offers: (json['offers'] as List<dynamic>?)
              ?.map((e) => HomeOfferModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      coupons: (json['coupons'] as List<dynamic>?)
              ?.map((e) => HomeCouponModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      smartSavings: (json['smartSavings'] as List<dynamic>?)
              ?.map((e) => SmartSavingsModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      featuredStores: (json['featuredStores'] as List<dynamic>?)
              ?.map((e) => FeaturedStoreModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      trendingDeals: (json['trendingDeals'] as List<dynamic>?)
              ?.map((e) => TrendingDealModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      priceDrops: (json['priceDrops'] as List<dynamic>?)
              ?.map((e) => PriceDropModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      cashbackIncreases: (json['cashbackIncreases'] as List<dynamic>?)
              ?.map((e) =>
                  CashbackIncreaseModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
