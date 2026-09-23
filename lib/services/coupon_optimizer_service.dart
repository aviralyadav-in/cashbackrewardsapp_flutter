import '../models/home_discovery_models.dart';

/// Single coupon evaluation result calculated by the optimizer
class OptimizedCouponResult {
  final HomeCouponModel coupon;
  final double originalCartValue;
  final double couponDiscountAmount;
  final double bankDiscountAmount;
  final double cashbackAmount;
  final double totalSavings;
  final double finalEffectivePrice;
  final bool isEligible;
  final double amountNeededToUnlock;
  final String savingsBreakdown;
  final String? bankOfferApplied;

  const OptimizedCouponResult({
    required this.coupon,
    required this.originalCartValue,
    required this.couponDiscountAmount,
    required this.bankDiscountAmount,
    required this.cashbackAmount,
    required this.totalSavings,
    required this.finalEffectivePrice,
    required this.isEligible,
    required this.amountNeededToUnlock,
    required this.savingsBreakdown,
    this.bankOfferApplied,
  });
}

/// Overall optimizer result containing the top recommendation and ranked coupons
class CouponOptimizationSummary {
  final String store;
  final double cartValue;
  final String? selectedBank;
  final OptimizedCouponResult? bestCoupon;
  final OptimizedCouponResult? runnerUpCoupon;
  final List<OptimizedCouponResult> eligibleCoupons;
  final List<OptimizedCouponResult> unlockableCoupons;
  final double maxPossibleSavings;
  final double bestFinalPrice;

  const CouponOptimizationSummary({
    required this.store,
    required this.cartValue,
    this.selectedBank,
    this.bestCoupon,
    this.runnerUpCoupon,
    required this.eligibleCoupons,
    required this.unlockableCoupons,
    required this.maxPossibleSavings,
    required this.bestFinalPrice,
  });
}

class CouponOptimizerService {
  /// Comprehensive catalog of active verified coupons across top Indian e-commerce stores
  static const List<HomeCouponModel> allOptimizerCoupons = [
    // --- MYNTRA ---
    HomeCouponModel(
      id: 'cp-myntra-1',
      code: 'MYNTRA500',
      store: 'Myntra',
      discount: '₹500 OFF',
      minOrder: 2499,
      cashback: 'Up to 12%',
      validity: 'Valid till 30 Sep',
      description: 'Flat ₹500 instant discount on orders above ₹2,499 across all footwear & apparel.',
      logoUrl: 'assets/cards/myntra.jpg',
      applicableOn: 'Apparel, Footwear & Accessories',
      successRate: '98% Success Rate',
      terms: ['Min order ₹2,499', 'Single use per user', 'Cashback tracks in 24h'],
    ),
    HomeCouponModel(
      id: 'cp-myntra-2',
      code: 'MYNTRA15',
      store: 'Myntra',
      discount: '15% OFF',
      minOrder: 1799,
      cashback: 'Up to 12%',
      validity: 'Valid till 15 Oct',
      description: '15% off up to ₹750 on fashion essentials for men, women & kids.',
      logoUrl: 'assets/cards/myntra.jpg',
      applicableOn: 'Men & Women Fashion',
      successRate: '94% Success Rate',
      terms: ['Min order ₹1,799', 'Max discount ₹750'],
    ),
    HomeCouponModel(
      id: 'cp-myntra-3',
      code: 'MYNTRANEW',
      store: 'Myntra',
      discount: '₹400 OFF',
      minOrder: 1499,
      cashback: 'Up to 12%',
      validity: 'Valid till 31 Oct',
      description: 'Special ₹400 instant voucher on all catalogs with free shipping.',
      logoUrl: 'assets/cards/myntra.jpg',
      applicableOn: 'All Categories',
      successRate: '97% Success Rate',
      terms: ['Min order ₹1,499', 'One redemption per account'],
    ),
    HomeCouponModel(
      id: 'cp-myntra-4',
      code: 'FESTIVE1000',
      store: 'Myntra',
      discount: '₹1,000 OFF',
      minOrder: 4999,
      cashback: 'Up to 14%',
      validity: 'Valid till 28 Oct',
      description: 'High cart celebration code: Flat ₹1,000 off on premium fashion & ethnic wear.',
      logoUrl: 'assets/cards/myntra.jpg',
      applicableOn: 'Ethnic & Western Wear',
      successRate: '99% Success Rate',
      terms: ['Min order ₹4,999', 'Extra 14% KashIQ cashback stacks'],
    ),

    // --- AJIO ---
    HomeCouponModel(
      id: 'cp-ajio-1',
      code: 'AJIOMAN10',
      store: 'AJIO',
      discount: '10% OFF',
      minOrder: 1999,
      cashback: 'Up to 10%',
      validity: 'Valid till 15 Oct',
      description: 'Extra 10% instant discount on premium fashion brands on AJIO.',
      logoUrl: 'assets/cards/ajio-coupons.jpg',
      applicableOn: 'AJIO Luxe & Trendsetter Catalog',
      successRate: '95% Success Rate',
      terms: ['Min order ₹1,999', 'Max discount ₹600'],
    ),
    HomeCouponModel(
      id: 'cp-ajio-2',
      code: 'TRENDS700',
      store: 'AJIO',
      discount: '₹700 OFF',
      minOrder: 3499,
      cashback: 'Up to 10%',
      validity: 'Valid till 20 Oct',
      description: 'Mega cart saver: Flat ₹700 off on footwear, streetwear & denim.',
      logoUrl: 'assets/cards/ajio-coupons.jpg',
      applicableOn: 'Footwear & Denim',
      successRate: '96% Success Rate',
      terms: ['Min order ₹3,499', 'Stacks with KashIQ 10% cashback'],
    ),
    HomeCouponModel(
      id: 'cp-ajio-3',
      code: 'FIRSTAJIO',
      store: 'AJIO',
      discount: '₹300 OFF',
      minOrder: 1299,
      cashback: 'Up to 10%',
      validity: 'Valid till 30 Nov',
      description: 'Flat ₹300 off on all trending styles.',
      logoUrl: 'assets/cards/ajio-coupons.jpg',
      applicableOn: 'Site-wide',
      successRate: '93% Success Rate',
      terms: ['Min order ₹1,299'],
    ),

    // --- FLIPKART ---
    HomeCouponModel(
      id: 'cp-flipkart-1',
      code: 'FKSPECIAL200',
      store: 'Flipkart',
      discount: '₹200 OFF',
      minOrder: 1499,
      cashback: 'Up to 8%',
      validity: 'Valid till 10 Oct',
      description: 'Instant ₹200 savings on electronics, lifestyle & small appliances.',
      logoUrl: 'assets/cards/flipkart-electronics.png',
      applicableOn: 'Electronics & Lifestyle',
      successRate: '96% Success Rate',
      terms: ['Min order ₹1,499'],
    ),
    HomeCouponModel(
      id: 'cp-flipkart-2',
      code: 'SUPERMEGA500',
      store: 'Flipkart',
      discount: '₹500 OFF',
      minOrder: 2999,
      cashback: 'Up to 9%',
      validity: 'Valid till 25 Oct',
      description: 'Save ₹500 instantly on home decor, smartphones & laptops.',
      logoUrl: 'assets/cards/flipkart-electronics.png',
      applicableOn: 'Home & Gadgets',
      successRate: '95% Success Rate',
      terms: ['Min order ₹2,999'],
    ),
    HomeCouponModel(
      id: 'cp-flipkart-3',
      code: 'FKFESTIVE1500',
      store: 'Flipkart',
      discount: '₹1,500 OFF',
      minOrder: 9999,
      cashback: 'Up to 9%',
      validity: 'Valid till 31 Oct',
      description: 'Big ticket appliances and TVs: Flat ₹1,500 instant discount voucher.',
      logoUrl: 'assets/cards/flipkart-electronics.png',
      applicableOn: 'Large Appliances & TVs',
      successRate: '98% Success Rate',
      terms: ['Min order ₹9,999', 'Applicable with bank offers'],
    ),

    // --- AMAZON ---
    HomeCouponModel(
      id: 'cp-amazon-1',
      code: 'AMZPRIME15',
      store: 'Amazon',
      discount: '15% OFF',
      minOrder: 1000,
      cashback: 'Up to 8%',
      validity: 'Valid till 31 Oct',
      description: 'Get 15% cashback up to ₹300 on grocery & daily essentials.',
      logoUrl: 'assets/cards/amazon.jpg',
      applicableOn: 'Fresh & Daily Pantry',
      successRate: '94% Success Rate',
      terms: ['Min order ₹1,000', 'Max discount ₹300'],
    ),
    HomeCouponModel(
      id: 'cp-amazon-2',
      code: 'AMZPAY400',
      store: 'Amazon',
      discount: '₹400 OFF',
      minOrder: 2499,
      cashback: 'Up to 8%',
      validity: 'Valid till 20 Oct',
      description: 'Flat ₹400 off on fashion, beauty & home products.',
      logoUrl: 'assets/cards/amazon.jpg',
      applicableOn: 'Fashion & Home',
      successRate: '97% Success Rate',
      terms: ['Min order ₹2,499'],
    ),

    // --- NYKAA ---
    HomeCouponModel(
      id: 'cp-nykaa-1',
      code: 'NYKBEAUTY20',
      store: 'Nykaa',
      discount: '20% OFF',
      minOrder: 1299,
      cashback: 'Up to 15%',
      validity: 'Valid till 15 Oct',
      description: 'Flat 20% off on skincare, makeup & fragrances up to ₹500.',
      logoUrl: 'assets/cards/nykaa.jpg',
      applicableOn: 'Beauty & Skincare',
      successRate: '96% Success Rate',
      terms: ['Min order ₹1,299', 'Max discount ₹500'],
    ),
    HomeCouponModel(
      id: 'cp-nykaa-2',
      code: 'GLOW500',
      store: 'Nykaa',
      discount: '₹500 OFF',
      minOrder: 2199,
      cashback: 'Up to 15%',
      validity: 'Valid till 25 Oct',
      description: 'Luxury beauty brands special: Flat ₹500 off on cart value above ₹2,199.',
      logoUrl: 'assets/cards/nykaa.jpg',
      applicableOn: 'Luxury Beauty',
      successRate: '98% Success Rate',
      terms: ['Min order ₹2,199', 'Extra 15% cashback'],
    ),

    // --- SWIGGY ---
    HomeCouponModel(
      id: 'cp-swiggy-1',
      code: 'SWIGGYIT120',
      store: 'Swiggy',
      discount: '₹120 OFF',
      minOrder: 399,
      cashback: 'Flat ₹40',
      validity: 'Valid till 30 Oct',
      description: 'Flat ₹120 off on gourmet food & restaurant delivery.',
      logoUrl: 'assets/logos/swiggy.svg',
      applicableOn: 'Food Delivery',
      successRate: '99% Success Rate',
      terms: ['Min order ₹399', 'Valid 2 times daily'],
    ),
    HomeCouponModel(
      id: 'cp-swiggy-2',
      code: 'SWIGGYPARTY',
      store: 'Swiggy',
      discount: '25% OFF',
      minOrder: 799,
      cashback: 'Flat ₹60',
      validity: 'Valid till 31 Oct',
      description: 'Group orders special: 25% off up to ₹250 on family meals.',
      logoUrl: 'assets/logos/swiggy.svg',
      applicableOn: 'Group Meals',
      successRate: '97% Success Rate',
      terms: ['Min order ₹799', 'Max discount ₹250'],
    ),
  ];

  /// Bank Card offer rules for smart stacking
  static const Map<String, Map<String, dynamic>> bankCardRules = {
    'HDFC Bank': {
      'rate': 0.10, // 10% instant discount
      'minSpend': 1500.0,
      'cap': 750.0,
      'name': 'HDFC Bank Credit/Debit 10% Instant Off',
    },
    'ICICI Bank': {
      'rate': 0.10,
      'minSpend': 2000.0,
      'cap': 800.0,
      'name': 'ICICI Bank Cards 10% Instant Off',
    },
    'SBI Card': {
      'rate': 0.075, // 7.5% instant discount
      'minSpend': 1200.0,
      'cap': 500.0,
      'name': 'SBI Card 7.5% Instant Off',
    },
    'Axis Bank': {
      'rate': 0.05, // 5% instant discount
      'minSpend': 1000.0,
      'cap': 500.0,
      'name': 'Axis Bank 5% Instant Off',
    },
  };

  /// Parses discount strings like "₹500 OFF" or "15% OFF" into actual numeric rupees saved
  static double calculateCouponDiscount(String discountText, double cartValue) {
    final clean = discountText.trim().toUpperCase();

    // Check for percentage discount
    if (clean.contains('%')) {
      final match = RegExp(r'(\d+(\.\d+)?)%').firstMatch(clean);
      if (match != null) {
        final pct = double.tryParse(match.group(1)!) ?? 0.0;
        final rawDiscount = cartValue * (pct / 100.0);

        // Standard caps on percentage coupons if not explicitly unlimited
        if (clean.contains('UP TO') || clean.contains('MAX')) {
          final capMatch = RegExp(r'(?:UP TO|MAX)\s*(?:₹|RS\.?)?\s*(\d+)').firstMatch(clean);
          if (capMatch != null) {
            final cap = double.tryParse(capMatch.group(1)!) ?? double.infinity;
            return rawDiscount > cap ? cap : rawDiscount;
          }
        }
        // Default safe cap of ₹1,000 on general percentage vouchers
        return rawDiscount > 1000 ? 1000 : rawDiscount;
      }
    }

    // Check for flat rupee discount (e.g. ₹500 OFF or 500 OFF)
    final flatMatch = RegExp(r'(?:₹|RS\.?)?\s*(\d+)').firstMatch(clean);
    if (flatMatch != null) {
      final flat = double.tryParse(flatMatch.group(1)!) ?? 0.0;
      // Cannot discount more than the cart value itself
      return flat > cartValue ? cartValue : flat;
    }

    return 0.0;
  }

  /// Parses affiliate cashback string (e.g. "Up to 12%" or "Flat ₹40")
  static double calculateCashback(String cashbackText, double cartValue) {
    final clean = cashbackText.trim().toUpperCase();

    if (clean.contains('%')) {
      final match = RegExp(r'(\d+(\.\d+)?)%').firstMatch(clean);
      if (match != null) {
        final pct = double.tryParse(match.group(1)!) ?? 0.0;
        return (cartValue * (pct / 100.0)).roundToDouble();
      }
    }

    final flatMatch = RegExp(r'(?:₹|RS\.?)?\s*(\d+)').firstMatch(clean);
    if (flatMatch != null) {
      return double.tryParse(flatMatch.group(1)!) ?? 0.0;
    }

    return 0.0;
  }

  /// Core Optimization Engine: Takes store, cart value, and optional bank card,
  /// runs through all available coupons, ranks them by total savings, and highlights the winner.
  static CouponOptimizationSummary optimize({
    required String store,
    required double cartValue,
    String? bankCard,
    List<HomeCouponModel>? customCoupons,
  }) {
    final normalizedStore = store.trim().toLowerCase();
    final candidateCoupons = (customCoupons ?? allOptimizerCoupons).where((c) {
      final cStore = c.store.trim().toLowerCase();
      if (normalizedStore == 'all' || normalizedStore.isEmpty) return true;
      return cStore.contains(normalizedStore) || normalizedStore.contains(cStore);
    }).toList();

    // Fallback if specific store has no coupons: use top available coupons
    final couponsToTest = candidateCoupons.isNotEmpty
        ? candidateCoupons
        : allOptimizerCoupons.take(5).toList();

    final List<OptimizedCouponResult> eligible = [];
    final List<OptimizedCouponResult> unlockable = [];

    // Bank offer calculation
    double bankDiscount = 0.0;
    String? bankAppliedNote;
    if (bankCard != null && bankCardRules.containsKey(bankCard)) {
      final rule = bankCardRules[bankCard]!;
      final minSpend = rule['minSpend'] as double;
      if (cartValue >= minSpend) {
        final rate = rule['rate'] as double;
        final cap = rule['cap'] as double;
        bankDiscount = (cartValue * rate);
        if (bankDiscount > cap) bankDiscount = cap;
        bankAppliedNote = rule['name'] as String;
      }
    }

    for (final coupon in couponsToTest) {
      final isEligible = cartValue >= coupon.minOrder;
      final couponDisc = isEligible
          ? calculateCouponDiscount(coupon.discount, cartValue)
          : 0.0;

      final netAfterDiscounts = (cartValue - couponDisc - bankDiscount).clamp(0.0, double.infinity);
      final cashback = isEligible ? calculateCashback(coupon.cashback, netAfterDiscounts) : 0.0;
      final totalSavings = couponDisc + bankDiscount + cashback;
      final finalEffective = (cartValue - totalSavings).clamp(0.0, double.infinity);

      final needed = isEligible ? 0.0 : (coupon.minOrder - cartValue);

      final breakdown = isEligible
          ? 'Save ₹${couponDisc.toInt()} (Coupon) + ₹${bankDiscount.toInt()} (Bank) + ₹${cashback.toInt()} (Cashback)'
          : 'Min order ₹${coupon.minOrder.toInt()} required (Add ₹${needed.toInt()} more to cart)';

      final res = OptimizedCouponResult(
        coupon: coupon,
        originalCartValue: cartValue,
        couponDiscountAmount: couponDisc,
        bankDiscountAmount: bankDiscount,
        cashbackAmount: cashback,
        totalSavings: totalSavings,
        finalEffectivePrice: finalEffective,
        isEligible: isEligible,
        amountNeededToUnlock: needed,
        savingsBreakdown: breakdown,
        bankOfferApplied: bankDiscount > 0 ? bankAppliedNote : null,
      );

      if (isEligible) {
        eligible.add(res);
      } else {
        unlockable.add(res);
      }
    }

    // Sort eligible coupons by total savings descending
    eligible.sort((a, b) => b.totalSavings.compareTo(a.totalSavings));

    // Sort unlockable coupons by amount needed ascending (closest to unlock first)
    unlockable.sort((a, b) => a.amountNeededToUnlock.compareTo(b.amountNeededToUnlock));

    final best = eligible.isNotEmpty ? eligible.first : null;
    final runnerUp = eligible.length > 1 ? eligible[1] : null;

    final maxSavings = best?.totalSavings ?? bankDiscount;
    final bestPrice = best?.finalEffectivePrice ?? (cartValue - bankDiscount);

    return CouponOptimizationSummary(
      store: store,
      cartValue: cartValue,
      selectedBank: bankCard,
      bestCoupon: best,
      runnerUpCoupon: runnerUp,
      eligibleCoupons: eligible,
      unlockableCoupons: unlockable,
      maxPossibleSavings: maxSavings,
      bestFinalPrice: bestPrice,
    );
  }
}
