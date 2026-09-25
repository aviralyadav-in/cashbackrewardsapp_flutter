import 'package:flutter/material.dart';

double _parseDouble(dynamic val) {
  if (val == null) return 0.0;
  if (val is num) return val.toDouble();
  return double.tryParse(val.toString()) ?? 0.0;
}

String _parseString(dynamic val, [String fallback = '']) =>
    val == null ? fallback : val.toString();

List<T> _parseList<T>(
  dynamic raw,
  T Function(Map<String, dynamic>) fromJson,
  List<T> fallback,
) {
  if (raw is! List) return fallback;
  return raw.whereType<Map<String, dynamic>>().map(fromJson).toList();
}

/// Maps backend icon names to Material icons for sections that render an icon.
IconData iconFromName(String name) {
  switch (name) {
    case 'credit_card':
      return Icons.credit_card_rounded;
    case 'shield':
      return Icons.shield_outlined;
    case 'running':
      return Icons.directions_run_rounded;
    case 'fitness':
      return Icons.fitness_center_rounded;
    case 'watch':
      return Icons.watch_rounded;
    case 'backpack':
      return Icons.backpack_rounded;
    default:
      return Icons.local_offer_outlined;
  }
}

/// Section: Highest Cashback Deals (product-level ₹ cashback)
class HighestCashbackDealModel {
  final String id;
  final String title;
  final String brand;
  final String store;
  final String imageUrl;
  final double currentPrice;
  final double originalPrice;
  final double cashbackAmount;
  final String cashbackHighlight;
  final String subtitle;
  final String websiteUrl;

  const HighestCashbackDealModel({
    required this.id,
    required this.title,
    required this.brand,
    required this.store,
    required this.imageUrl,
    required this.currentPrice,
    required this.originalPrice,
    required this.cashbackAmount,
    required this.cashbackHighlight,
    required this.subtitle,
    required this.websiteUrl,
  });

  factory HighestCashbackDealModel.fromJson(Map<String, dynamic> json) {
    return HighestCashbackDealModel(
      id: _parseString(json['id']),
      title: _parseString(json['title']),
      brand: _parseString(json['brand']),
      store: _parseString(json['store']),
      imageUrl: _parseString(json['imageUrl']),
      currentPrice: _parseDouble(json['currentPrice']),
      originalPrice: _parseDouble(json['originalPrice']),
      cashbackAmount: _parseDouble(json['cashbackAmount']),
      cashbackHighlight: _parseString(json['cashbackHighlight']),
      subtitle: _parseString(json['subtitle']),
      websiteUrl: _parseString(json['websiteUrl']),
    );
  }
}

/// Section: Best Product Deals (2-column grid)
class BestProductDealModel {
  final String id;
  final String title;
  final String brand;
  final String store;
  final String imageUrl;
  final double currentPrice;
  final double originalPrice;
  final double discountPercentage;
  final double cashbackAmount;
  final String websiteUrl;

  const BestProductDealModel({
    required this.id,
    required this.title,
    required this.brand,
    required this.store,
    required this.imageUrl,
    required this.currentPrice,
    required this.originalPrice,
    required this.discountPercentage,
    required this.cashbackAmount,
    required this.websiteUrl,
  });

  factory BestProductDealModel.fromJson(Map<String, dynamic> json) {
    return BestProductDealModel(
      id: _parseString(json['id']),
      title: _parseString(json['title']),
      brand: _parseString(json['brand']),
      store: _parseString(json['store']),
      imageUrl: _parseString(json['imageUrl']),
      currentPrice: _parseDouble(json['currentPrice']),
      originalPrice: _parseDouble(json['originalPrice']),
      discountPercentage: _parseDouble(json['discountPercentage']),
      cashbackAmount: _parseDouble(json['cashbackAmount']),
      websiteUrl: _parseString(json['websiteUrl']),
    );
  }
}

/// Section: Hotels & Stays
class HotelDealModel {
  final String title;
  final String cashbackText;
  final String discountTag;
  final String imageUrl;
  final String location;

  const HotelDealModel({
    required this.title,
    required this.cashbackText,
    required this.discountTag,
    required this.imageUrl,
    this.location = 'Domestic & International',
  });

  factory HotelDealModel.fromJson(Map<String, dynamic> json) {
    return HotelDealModel(
      title: _parseString(json['title']),
      cashbackText: _parseString(json['cashbackText']),
      discountTag: _parseString(json['discountTag']),
      imageUrl: _parseString(json['imageUrl']),
      location: _parseString(json['location'], 'Domestic & International'),
    );
  }
}

/// Section: Flash Deals / Ending Soon
class FlashDealModel {
  final String id;
  final String title;
  final String brand;
  final String store;
  final String imageUrl;
  final double currentPrice;
  final double originalPrice;
  final double discountPercentage;
  final double cashbackAmount;
  final String endsInText;
  final double claimedPercentage;

  const FlashDealModel({
    required this.id,
    required this.title,
    required this.brand,
    required this.store,
    required this.imageUrl,
    required this.currentPrice,
    required this.originalPrice,
    required this.discountPercentage,
    required this.cashbackAmount,
    required this.endsInText,
    required this.claimedPercentage,
  });

  factory FlashDealModel.fromJson(Map<String, dynamic> json) {
    return FlashDealModel(
      id: _parseString(json['id']),
      title: _parseString(json['title']),
      brand: _parseString(json['brand']),
      store: _parseString(json['store']),
      imageUrl: _parseString(json['imageUrl']),
      currentPrice: _parseDouble(json['currentPrice']),
      originalPrice: _parseDouble(json['originalPrice']),
      discountPercentage: _parseDouble(json['discountPercentage']),
      cashbackAmount: _parseDouble(json['cashbackAmount']),
      endsInText: _parseString(json['endsInText']),
      claimedPercentage: _parseDouble(json['claimedPercentage']).clamp(0.0, 1.0),
    );
  }
}

/// Section: Banking & Financial Deals
class BankOfferModel {
  final String title;
  final String subtitle;
  final String statusText;
  final String iconName;
  final String buttonText;
  final bool isDarkIcon;

  const BankOfferModel({
    required this.title,
    required this.subtitle,
    required this.statusText,
    required this.iconName,
    required this.buttonText,
    this.isDarkIcon = false,
  });

  IconData get icon => iconFromName(iconName);

  factory BankOfferModel.fromJson(Map<String, dynamic> json) {
    return BankOfferModel(
      title: _parseString(json['title']),
      subtitle: _parseString(json['subtitle']),
      statusText: _parseString(json['statusText']),
      iconName: _parseString(json['icon']),
      buttonText: _parseString(json['buttonText'], 'Explore'),
      isDarkIcon: json['isDarkIcon'] == true,
    );
  }
}

/// Section: Biggest Discounts
class BiggestDiscountModel {
  final String id;
  final String title;
  final String brand;
  final String store;
  final String imageUrl;
  final double currentPrice;
  final double originalPrice;
  final double discountPercentage;
  final double cashbackAmount;

  const BiggestDiscountModel({
    required this.id,
    required this.title,
    required this.brand,
    required this.store,
    required this.imageUrl,
    required this.currentPrice,
    required this.originalPrice,
    required this.discountPercentage,
    required this.cashbackAmount,
  });

  factory BiggestDiscountModel.fromJson(Map<String, dynamic> json) {
    return BiggestDiscountModel(
      id: _parseString(json['id']),
      title: _parseString(json['title']),
      brand: _parseString(json['brand']),
      store: _parseString(json['store']),
      imageUrl: _parseString(json['imageUrl']),
      currentPrice: _parseDouble(json['currentPrice']),
      originalPrice: _parseDouble(json['originalPrice']),
      discountPercentage: _parseDouble(json['discountPercentage']),
      cashbackAmount: _parseDouble(json['cashbackAmount']),
    );
  }
}

/// Section: Deals You May Like (pill recommendations)
class RecommendationPillModel {
  final String title;
  final String subtitle;
  final String iconName;

  const RecommendationPillModel({
    required this.title,
    required this.subtitle,
    required this.iconName,
  });

  IconData get icon => iconFromName(iconName);

  factory RecommendationPillModel.fromJson(Map<String, dynamic> json) {
    return RecommendationPillModel(
      title: _parseString(json['title']),
      subtitle: _parseString(json['subtitle']),
      iconName: _parseString(json['icon']),
    );
  }
}

/// All curated lists shown on the Best Deals tab (GET /api/home → bestDealsPage).
/// Top Deals, Best Store Deals and Price Drops are derived from the shared
/// home feed (bestDeals / featuredStores / priceDrops) so both screens agree.
class BestDealsPageModel {
  final List<HighestCashbackDealModel> highestCashbackDeals;
  final List<BestProductDealModel> bestProductDeals;
  final List<HotelDealModel> hotelDeals;
  final List<FlashDealModel> flashDeals;
  final List<BankOfferModel> bankOffers;
  final List<BiggestDiscountModel> biggestDiscounts;
  final List<RecommendationPillModel> recommendationPills;

  const BestDealsPageModel({
    required this.highestCashbackDeals,
    required this.bestProductDeals,
    required this.hotelDeals,
    required this.flashDeals,
    required this.bankOffers,
    required this.biggestDiscounts,
    required this.recommendationPills,
  });

  factory BestDealsPageModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return fallback;
    return BestDealsPageModel(
      highestCashbackDeals: _parseList(json['highestCashbackDeals'],
          HighestCashbackDealModel.fromJson, fallback.highestCashbackDeals),
      bestProductDeals: _parseList(json['bestProductDeals'],
          BestProductDealModel.fromJson, fallback.bestProductDeals),
      hotelDeals: _parseList(
          json['hotelDeals'], HotelDealModel.fromJson, fallback.hotelDeals),
      flashDeals: _parseList(
          json['flashDeals'], FlashDealModel.fromJson, fallback.flashDeals),
      bankOffers: _parseList(
          json['bankOffers'], BankOfferModel.fromJson, fallback.bankOffers),
      biggestDiscounts: _parseList(json['biggestDiscounts'],
          BiggestDiscountModel.fromJson, fallback.biggestDiscounts),
      recommendationPills: _parseList(json['recommendationPills'],
          RecommendationPillModel.fromJson, fallback.recommendationPills),
    );
  }

  /// Offline dataset (mirrors backend HOME_DATA.bestDealsPage).
  static const BestDealsPageModel fallback = BestDealsPageModel(
    highestCashbackDeals: [
      HighestCashbackDealModel(
        id: 'hcb-samsung-s24',
        title: 'Samsung Galaxy S24 Ultra 5G (512GB)',
        brand: 'Samsung',
        store: 'Samsung Store',
        imageUrl: 'assets/banners/phone_banner_16_9.jpg',
        currentPrice: 129999,
        originalPrice: 144999,
        cashbackAmount: 6500,
        cashbackHighlight: '+ ₹6,500 CASHBACK',
        subtitle: 'Highest Cashback Today (Flat 5%)',
        websiteUrl: 'https://www.samsung.com/in',
      ),
      HighestCashbackDealModel(
        id: 'hcb-macbook-air',
        title: 'Apple MacBook Air M3 (16GB Unified RAM)',
        brand: 'Apple',
        store: 'Amazon',
        imageUrl: 'assets/banners/reliance_tech_3d.jpg',
        currentPrice: 114900,
        originalPrice: 124900,
        cashbackAmount: 5750,
        cashbackHighlight: '+ ₹5,750 CASHBACK',
        subtitle: 'Flat 5% Direct Account Credit',
        websiteUrl: 'https://www.amazon.in',
      ),
      HighestCashbackDealModel(
        id: 'hcb-sony-bravia',
        title: 'Sony Bravia 55" 4K Ultra HD Smart TV',
        brand: 'Sony',
        store: 'Flipkart',
        imageUrl: 'assets/banners/headphone_3d.jpg',
        currentPrice: 57990,
        originalPrice: 74900,
        cashbackAmount: 4600,
        cashbackHighlight: '+ ₹4,600 CASHBACK',
        subtitle: '8% Special Electronics Rate',
        websiteUrl: 'https://www.flipkart.com',
      ),
    ],
    bestProductDeals: [
      BestProductDealModel(
        id: 'bpd-boat-141',
        title: 'boAt Airdopes 141 ANC Earbuds',
        brand: 'BOAT',
        store: 'Amazon',
        imageUrl: 'assets/banners/headphone_3d.jpg',
        currentPrice: 1199,
        originalPrice: 4490,
        discountPercentage: 65,
        cashbackAmount: 150,
        websiteUrl: 'https://www.boat-lifestyle.com',
      ),
      BestProductDealModel(
        id: 'bpd-fastrack-revoltt',
        title: 'Fastrack Revoltt FS1 Smartwatch',
        brand: 'FASTRACK',
        store: 'Flipkart',
        imageUrl: 'assets/banners/watch_3d.jpg',
        currentPrice: 1399,
        originalPrice: 3995,
        discountPercentage: 65,
        cashbackAmount: 110,
        websiteUrl: 'https://www.flipkart.com',
      ),
      BestProductDealModel(
        id: 'bpd-nike-pegasus',
        title: 'Nike Air Zoom Pegasus 40',
        brand: 'NIKE',
        store: 'Myntra',
        imageUrl: 'assets/banners/nike_airmax_red.jpg',
        currentPrice: 6190,
        originalPrice: 10995,
        discountPercentage: 45,
        cashbackAmount: 350,
        websiteUrl: 'https://www.myntra.com',
      ),
      BestProductDealModel(
        id: 'bpd-philips-grooming',
        title: 'Philips Multi-Grooming Kit Series 5000',
        brand: 'PHILIPS',
        store: 'Amazon',
        imageUrl: 'assets/banners/reliance_tech_3d.jpg',
        currentPrice: 1599,
        originalPrice: 2295,
        discountPercentage: 35,
        cashbackAmount: 80,
        websiteUrl: 'https://www.amazon.in',
      ),
    ],
    hotelDeals: [
      HotelDealModel(
        title: 'The Grand Palace Resort & Spa',
        cashbackText: '+ ₹1,200 Cashback',
        discountTag: '15% OFF',
        imageUrl: 'assets/cards/col_travel.jpg',
        location: 'Udaipur, Rajasthan',
      ),
      HotelDealModel(
        title: 'Heritage Haveli Stay',
        cashbackText: '+ ₹1,100 Cashback',
        discountTag: '10% OFF',
        imageUrl: 'assets/cards/col_travel.jpg',
        location: 'Jaipur, Rajasthan',
      ),
    ],
    flashDeals: [
      FlashDealModel(
        id: 'fd-ambrane-10k',
        title: 'Ambrane 10,000mAh Magnetic Power Bank',
        brand: 'Ambrane',
        store: 'Amazon',
        imageUrl: 'assets/banners/headphone_banner_16_9.jpg',
        currentPrice: 1499,
        originalPrice: 3499,
        discountPercentage: 58,
        cashbackAmount: 90,
        endsInText: '01:34:12',
        claimedPercentage: 0.64,
      ),
      FlashDealModel(
        id: 'fd-inalsa-airfryer',
        title: 'Inalsa Dual-Zone 6L Air Fryer Oven',
        brand: 'Inalsa',
        store: 'Flipkart',
        imageUrl: 'assets/banners/shopsy_shopping_3d.jpg',
        currentPrice: 4599,
        originalPrice: 14995,
        discountPercentage: 70,
        cashbackAmount: 250,
        endsInText: '02:18:50',
        claimedPercentage: 0.85,
      ),
    ],
    bankOffers: [
      BankOfferModel(
        title: 'HDFC Regalia Gold Credit Card',
        subtitle:
            'Flat ₹2,500 Amazon Gift Voucher + 4 complimentary lounge visits',
        statusText: 'Instant Digital Approval',
        iconName: 'credit_card',
        buttonText: 'Explore Card',
        isDarkIcon: true,
      ),
      BankOfferModel(
        title: 'Tata AIA Term Life Insurance',
        subtitle: 'Zero Processing Fee with ₹1,500 Cashback on Policy',
        statusText: 'Guaranteed Cashback Credit',
        iconName: 'shield',
        buttonText: 'Get Plan',
      ),
    ],
    biggestDiscounts: [
      BiggestDiscountModel(
        id: 'bd-levis-trucker',
        title: "Levi's Classic Trucker Denim Jacket",
        brand: "LEVI'S",
        store: 'Myntra',
        imageUrl: 'assets/cards/col_myntra.jpg',
        currentPrice: 1249,
        originalPrice: 4999,
        discountPercentage: 75,
        cashbackAmount: 120,
      ),
      BiggestDiscountModel(
        id: 'bd-american-tourister',
        title: 'American Tourister Trolley Set',
        brand: 'AMERICAN TOURISTER',
        store: 'Flipkart',
        imageUrl: 'assets/banners/shopsy_shopping_3d.jpg',
        currentPrice: 1999,
        originalPrice: 9999,
        discountPercentage: 80,
        cashbackAmount: 150,
      ),
    ],
    recommendationPills: [
      RecommendationPillModel(
        title: 'Running Shoes',
        subtitle: 'From ₹1,499',
        iconName: 'running',
      ),
      RecommendationPillModel(
        title: 'Protein Supplements',
        subtitle: 'Up to 35% Off',
        iconName: 'fitness',
      ),
      RecommendationPillModel(
        title: 'Smart Bands',
        subtitle: 'From ₹1,199',
        iconName: 'watch',
      ),
      RecommendationPillModel(
        title: 'Travel Backpacks',
        subtitle: 'Under ₹999',
        iconName: 'backpack',
      ),
    ],
  );
}
