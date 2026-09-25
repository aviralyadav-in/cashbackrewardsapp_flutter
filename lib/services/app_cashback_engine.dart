/// Cashback that KashIQ itself pays the user, mirrored from
/// backend/src/services/smartDealEngine.js so hardcoded (offline) data shows
/// the same cashback the backend computes.
///
/// This is deliberately separate from a brand/store offer (e.g. "50% OFF",
/// "Up to 12% Reward"), which comes from the product/store data and is never
/// overwritten here.
class AppCashbackEngine {
  AppCashbackEngine._();

  static const double defaultRate = 5.0;

  /// Keys are normalised store names (lower-case letters and digits only).
  static const Map<String, double> _storeRates = {
    'myntra': 10.0,
    'ajio': 12.0,
    'amazon': 7.0,
    'flipkart': 6.0,
    'nykaa': 10.0,
    'croma': 5.0,
    'reliancedigital': 6.0,
    'tatacliq': 8.0,
    'puma': 9.0,
    'hm': 8.0,
    'meesho': 6.0,
    'dyson': 6.0,
    'samsung': 5.0,
    'apple': 4.0,
  };

  static String _key(String store) =>
      store.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');

  /// App cashback percentage for purchases made at [store].
  static double rateForStore(String store) =>
      _storeRates[_key(store)] ?? defaultRate;

  /// e.g. "10% Cashback" / "7.5% Cashback".
  static String cashbackLabel(String store) {
    final rate = rateForStore(store);
    final text = rate == rate.roundToDouble()
        ? rate.toInt().toString()
        : rate.toStringAsFixed(1);
    return '$text% Cashback';
  }

  /// Partner bank discount is 0.0 as KashIQ is a cashback & rewards platform,
  /// not a payment gateway. Bank card offers are not assumed on checkout.
  static double bankDiscount(double amount) => 0.0;

  /// Stacks store price, coupon discount, and app cashback to determine the
  /// guaranteed effective price.
  static AppCashbackResult calculate({
    required String store,
    required double originalPrice,
    required double storePrice,
    required double couponDiscount,
  }) {
    final price = storePrice > 0 ? storePrice : originalPrice;
    final afterCoupon = (price - couponDiscount).clamp(0, double.infinity).toDouble();
    final rate = rateForStore(store);
    final cashback = (afterCoupon * rate / 100).roundToDouble();
    final effective =
        (price - couponDiscount - cashback).clamp(0, double.infinity).roundToDouble();
    final savings = (originalPrice - effective).clamp(0, double.infinity).toDouble();

    return AppCashbackResult(
      cashbackPercentage: rate,
      cashbackAmount: cashback,
      bankDiscount: 0.0,
      effectivePrice: effective,
      effectiveSavings: savings,
    );
  }
}

class AppCashbackResult {
  final double cashbackPercentage;
  final double cashbackAmount;
  final double bankDiscount;
  final double effectivePrice;
  final double effectiveSavings;

  const AppCashbackResult({
    required this.cashbackPercentage,
    required this.cashbackAmount,
    required this.bankDiscount,
    required this.effectivePrice,
    required this.effectiveSavings,
  });
}

/// Store-level offer text ("Up to 12% Cashback" in the data) is the brand/store
/// offer, not KashIQ cashback, so it is shown as a reward/offer.
String storeOfferLabel(String rawOffer) {
  final text = rawOffer.trim();
  if (text.isEmpty) return text;
  final relabelled =
      text.replaceAll(RegExp(r'\s*cashback\b', caseSensitive: false), ' Reward').trim();
  final lower = relabelled.toLowerCase();
  if (lower.contains('reward') || lower.contains('off')) return relabelled;
  return '$relabelled Reward';
}
