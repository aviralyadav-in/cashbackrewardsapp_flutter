import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';

import '../../models/amazon_deal_model.dart';
import '../../models/brand_model.dart';
import '../../models/category_shopping_models.dart';
import '../../models/home_discovery_models.dart';
import '../../models/product.dart';
import '../deals/offer_section_screen.dart';
import '../../services/url_launcher_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common/network_image_with_skeleton.dart';
import 'package:provider/provider.dart';
import '../../providers/home_provider.dart';
import '../../providers/user_provider.dart';
import '../../services/affiliate_service.dart';
import '../../services/auth_service.dart';


class ProductDetailScreen extends StatefulWidget {
  static const String routeName = '/product-detail';

  final Product? product;
  final BrandModel? brand;
  final AmazonDealItemData? amazonDeal;
  final OfferSectionItem? offerItem;
  final CategoryDealModel? categoryDeal;
  final BestDealModel? bestDeal;
  final TrendingDealModel? trendingDeal;
  final HomeOfferModel? homeOffer;
  final PriceDropModel? priceDrop;
  final CashbackIncreaseModel? cashbackIncrease;
  final FeaturedStoreModel? featuredStore;
  final String? compareId;
  final String? productId;

  // Custom generic attributes for maximum flexibility
  final String? customTitle;
  final String? customBrandName;
  final String? customCategory;
  final String? customOriginalPrice;
  final String? customDiscountedPrice;
  final String? customDiscountTag;
  final String? customCashbackTag;
  final String? customFinalPrice;
  final String? customDescription;
  final String? customImageUrl;
  final List<String>? customImages;
  final String? customWebsiteUrl;
  final String? customOriginalUrl;
  final String? customAffiliateUrl;
  final double? customRating;
  final int? customStock;

  const ProductDetailScreen({
    super.key,
    this.product,
    this.brand,
    this.amazonDeal,
    this.offerItem,
    this.categoryDeal,
    this.bestDeal,
    this.trendingDeal,
    this.homeOffer,
    this.priceDrop,
    this.cashbackIncrease,
    this.featuredStore,
    this.compareId,
    this.productId,
    this.customTitle,
    this.customBrandName,
    this.customCategory,
    this.customOriginalPrice,
    this.customDiscountedPrice,
    this.customDiscountTag,
    this.customCashbackTag,
    this.customFinalPrice,
    this.customDescription,
    this.customImageUrl,
    this.customImages,
    this.customWebsiteUrl,
    this.customOriginalUrl,
    this.customAffiliateUrl,
    this.customRating,
    this.customStock,
  });

  static final RegExp _emojiRegExp = RegExp(
    r'[\u{1F300}-\u{1F9FF}\u{2600}-\u{26FF}\u{2700}-\u{27BF}\u{1F600}-\u{1F64F}\u{1F680}-\u{1F6FF}\u{1F1E0}-\u{1F1FF}]',
    unicode: true,
  );

  /// Strips emojis from titles and section headings to ensure a clean theme appearance.
  static String cleanTitle(String text) {
    return text.replaceAll(_emojiRegExp, '').trim();
  }

  /// Factory for CategoryDealModel (from Category/Subcategory shopping journey)
  factory ProductDetailScreen.fromCategoryDeal(
    CategoryDealModel deal, {
    Key? key,
    String? categoryName,
  }) {
    return ProductDetailScreen(
      key: key,
      categoryDeal: deal,
      compareId: deal.id,
      customTitle: deal.title,
      customBrandName: deal.brand,
      customCategory: categoryName ?? 'Fashion',
      customOriginalPrice: '₹${deal.originalPrice.toInt()}',
      customDiscountedPrice: '₹${deal.discountedPrice.toInt()}',
      customDiscountTag: '${deal.discountPercentage.toInt()}% OFF',
      customCashbackTag: '${deal.cashbackPercentage.toInt()}% Cashback',
      customFinalPrice: '₹${deal.effectivePrice.toInt()}',
      customDescription:
          '${deal.title} by ${deal.brand}. Recommended deal with verified store discounts and KashIQ extra cashback.',
      customImageUrl: deal.imageUrl,
      customImages: [deal.imageUrl],
      customWebsiteUrl: resolveStoreUrl(deal.store),
    );
  }

  /// Factory for OfferSectionItem (Flipkart, Meesho, etc.)
  factory ProductDetailScreen.fromOfferItem(
    OfferSectionItem item, {
    Key? key,
  }) {
    return ProductDetailScreen(
      key: key,
      offerItem: item,
      customTitle: item.title,
      customBrandName: item.storeName,
      customCategory: item.storeName,
      customDiscountedPrice: item.priceOrRate,
      customCashbackTag: item.cashbackTag,
      customDescription: item.description,
      customImageUrl: item.imageUrl,
      customWebsiteUrl: resolveStoreUrl(item.storeName),
    );
  }

  /// Factory for AmazonDealItemData
  factory ProductDetailScreen.fromAmazonDeal(
    AmazonDealItemData deal, {
    Key? key,
  }) {
    final originalPriceStr = '₹${_formatCurrency(deal.actualPrice.round())}';
    final discountedPriceStr = '₹${_formatCurrency(deal.actualPrice.round())}';
    final rewardTag = 'Flat ${deal.rewardPercentage.toInt()}% Reward';
    final finalPriceStr = '₹${_formatCurrency(deal.finalPrice)}';

    return ProductDetailScreen(
      key: key,
      amazonDeal: deal,
      customTitle: deal.productName,
      customBrandName: deal.brandName.isNotEmpty ? deal.brandName : 'Amazon',
      customCategory: 'Amazon Top Deals',
      customOriginalPrice: originalPriceStr,
      customDiscountedPrice: discountedPriceStr,
      customDiscountTag: 'Flat ${deal.rewardPercentage.toInt()}% Reward',
      customCashbackTag: rewardTag,
      customFinalPrice: finalPriceStr,
      customDescription:
          'Special promotional pricing on Amazon with extra cashback rewards automatically credited to your KashIQ wallet after delivery.',
      customImageUrl: deal.imageUrl,
      customWebsiteUrl: deal.productUrl.isNotEmpty
          ? deal.productUrl
          : 'https://www.amazon.in',
    );
  }

  /// Factory for BrandModel
  factory ProductDetailScreen.fromBrand(
    BrandModel brand, {
    Key? key,
  }) {
    return ProductDetailScreen(
      key: key,
      brand: brand,
      customTitle: '${brand.name} Cashback & Offers',
      customBrandName: brand.name,
      customCategory: brand.category,
      customDiscountTag: brand.offerText,
      customCashbackTag: brand.cashbackPercentage,
      customDescription:
          'Shop online at ${brand.name} to earn up to ${brand.cashbackPercentage} cashback on your purchase. All transactions are securely tracked.',
      customImageUrl: brand.bannerUrl.isNotEmpty ? brand.bannerUrl : brand.logoUrl,
      customWebsiteUrl: (brand.websiteUrl.isNotEmpty && !brand.websiteUrl.contains('KashIQ.com'))
          ? brand.websiteUrl
          : resolveStoreUrl(brand.name),
    );
  }

  /// Factory for BestDealModel (Best Deals For You)
  factory ProductDetailScreen.fromBestDeal(
    BestDealModel deal, {
    Key? key,
  }) {
    return ProductDetailScreen(
      key: key,
      bestDeal: deal,
      compareId: deal.id,
      customTitle: deal.title,
      customBrandName: deal.brand.isNotEmpty ? deal.brand : deal.store,
      customCategory: deal.category.isNotEmpty ? deal.category : 'Top Recommendation',
      customOriginalPrice: deal.originalPrice > 0 ? '₹${deal.originalPrice.toInt()}' : null,
      customDiscountedPrice: '₹${deal.discountedPrice.toInt()}',
      customDiscountTag: '${deal.discountPercentage.toInt()}% OFF',
      customCashbackTag: '${deal.cashbackPercentage.toInt()}% Cashback',
      customFinalPrice: '₹${deal.effectivePrice.toInt()}',
      customDescription:
          '${deal.title} by ${deal.brand}. Verified deal on ${deal.store} with extra ₹${deal.cashbackAmount.toInt()} cashback and ₹${deal.couponDiscount.toInt()} coupon savings.',
      customImageUrl: deal.imageUrl,
      customImages: [deal.imageUrl],
      customWebsiteUrl: resolveStoreUrl(deal.store),
    );
  }

  /// Factory for TrendingDealModel (Trending Deals)
  factory ProductDetailScreen.fromTrendingDeal(
    TrendingDealModel deal, {
    Key? key,
  }) {
    final effectivePriceNum = deal.cashbackAmount > 0
        ? (deal.price - deal.cashbackAmount).toInt()
        : deal.price.toInt();
    return ProductDetailScreen(
      key: key,
      trendingDeal: deal,
      compareId: deal.id,
      customTitle: deal.productName,
      customBrandName: deal.brand.isNotEmpty ? deal.brand : deal.store,
      customCategory: 'Trending Deals',
      customOriginalPrice: deal.originalPrice > 0 ? '₹${deal.originalPrice.toInt()}' : null,
      customDiscountedPrice: '₹${deal.price.toInt()}',
      customDiscountTag: deal.discount.isNotEmpty ? deal.discount : null,
      customCashbackTag: deal.cashback.isNotEmpty ? deal.cashback : 'KashIQ Cashback',
      customFinalPrice: '₹$effectivePriceNum',
      customDescription:
          '${deal.productName} by ${deal.brand}. Trending deal on ${deal.store} with ${deal.discount} and guaranteed extra ${deal.cashback}.',
      customImageUrl: deal.imageUrl,
      customImages: [deal.imageUrl],
      customWebsiteUrl: resolveStoreUrl(deal.store),
    );
  }

  /// Factory for HomeOfferModel (Offers)
  factory ProductDetailScreen.fromHomeOffer(
    HomeOfferModel offer, {
    Key? key,
  }) {
    return ProductDetailScreen(
      key: key,
      homeOffer: offer,
      compareId: offer.id,
      customTitle: offer.title,
      customBrandName: offer.store,
      customCategory: offer.category.isNotEmpty ? offer.category : 'Hot Offers',
      customDiscountedPrice: offer.discount,
      customDiscountTag: offer.discount,
      customCashbackTag: offer.cashback,
      customDescription:
          'Exclusive deal on ${offer.store}. Enjoy ${offer.discount} with ${offer.cashback} credited to your KashIQ account. ${offer.validity.isNotEmpty ? "Valid until ${offer.validity}." : ""}',
      customImageUrl: offer.imageUrl.isNotEmpty ? offer.imageUrl : offer.storeLogo,
      customImages: [offer.imageUrl.isNotEmpty ? offer.imageUrl : offer.storeLogo],
      customWebsiteUrl: offer.actionUrl.isNotEmpty && !offer.actionUrl.contains('KashIQ.com')
          ? offer.actionUrl
          : resolveStoreUrl(offer.store),
    );
  }

  /// Factory for PriceDropModel (Price Drops)
  factory ProductDetailScreen.fromPriceDrop(
    PriceDropModel item, {
    Key? key,
  }) {
    final discountPercent = item.wasPrice > 0
        ? (((item.wasPrice - item.nowPrice) / item.wasPrice) * 100).round()
        : 0;
    final effectivePriceNum = item.cashbackAmount > 0
        ? (item.nowPrice - item.cashbackAmount).toInt()
        : item.nowPrice.toInt();
    return ProductDetailScreen(
      key: key,
      priceDrop: item,
      compareId: item.id,
      customTitle: item.productName,
      customBrandName: item.brand.isNotEmpty ? item.brand : item.store,
      customCategory: 'Price Drop Alert',
      customOriginalPrice: '₹${item.wasPrice.toInt()}',
      customDiscountedPrice: '₹${item.nowPrice.toInt()}',
      customDiscountTag: item.priceDropBadge.isNotEmpty
          ? item.priceDropBadge
          : (discountPercent > 0 ? '$discountPercent% OFF' : 'Price Drop'),
      customCashbackTag: item.cashback.isNotEmpty ? item.cashback : 'Extra Cashback',
      customFinalPrice: '₹$effectivePriceNum',
      customDescription:
          '${item.productName} by ${item.brand} dropped in price by ₹${item.priceDropAmount.toInt()}! Now only ₹${item.nowPrice.toInt()} on ${item.store} with extra ${item.cashback}.',
      customImageUrl: item.imageUrl,
      customImages: [item.imageUrl],
      customWebsiteUrl: resolveStoreUrl(item.store),
    );
  }

  /// Factory for CashbackIncreaseModel (Cashback Increased)
  factory ProductDetailScreen.fromCashbackIncrease(
    CashbackIncreaseModel item, {
    Key? key,
  }) {
    return ProductDetailScreen(
      key: key,
      cashbackIncrease: item,
      compareId: item.id,
      customTitle: item.headline.isNotEmpty ? item.headline : '${item.store} Cashback Boosted!',
      customBrandName: item.store,
      customCategory: 'Cashback Increased',
      customDiscountTag: item.badge,
      customCashbackTag: item.newRate,
      customDescription: item.description.isNotEmpty
          ? item.description
          : 'Cashback rate at ${item.store} increased from ${item.previousRate} to ${item.newRate} for a limited time!',
      customImageUrl: item.logoUrl,
      customImages: [item.logoUrl],
      customWebsiteUrl: resolveStoreUrl(item.store),
    );
  }

  /// Factory for FeaturedStoreModel (⭐ Featured Stores)
  factory ProductDetailScreen.fromFeaturedStore(
    FeaturedStoreModel store, {
    Key? key,
  }) {
    return ProductDetailScreen(
      key: key,
      featuredStore: store,
      compareId: store.id,
      customTitle: '${store.name} Cashback & Deals',
      customBrandName: store.name,
      customCategory: store.offerTag.isNotEmpty ? store.offerTag : 'Featured Store',
      customDiscountTag: store.offerTag,
      customCashbackTag: store.cashbackRate,
      customDescription:
          'Shop at ${store.name} through KashIQ to earn up to ${store.cashbackRate} cashback. Access ${store.totalOffers} live offers and ${store.totalCoupons} verified coupons.',
      customImageUrl: store.logoUrl,
      customImages: [store.logoUrl],
      customWebsiteUrl: (store.websiteUrl.isNotEmpty && !store.websiteUrl.contains('KashIQ.com'))
          ? store.websiteUrl
          : resolveStoreUrl(store.name),
    );
  }

  static String _formatCurrency(num amount) {
    final str = amount.round().toString();
    final reg = RegExp(r'(\d+?)(?=(\d{3})+(?!\d))');
    return str.replaceAllMapped(reg, (Match m) => '${m[1]},');
  }

  static String resolveStoreUrl(String storeOrBrand) {
    final target = storeOrBrand.toLowerCase();

    // Banks & Financial Institutions (Credit Cards & Loans)
    if (target.contains('sbi')) return 'https://www.sbicard.com';
    if (target.contains('hdfc')) return 'https://www.hdfcbank.com';
    if (target.contains('axis')) return 'https://www.axisbank.com';
    if (target.contains('icici')) return 'https://www.icicibank.com';
    if (target.contains('hsbc')) return 'https://www.hsbc.co.in';
    if (target.contains('kotak')) return 'https://www.kotak.com';
    if (target.contains('idfc')) return 'https://www.idfcfirstbank.com';
    if (target.contains('bobcard') || target.contains('baroda')) return 'https://www.bobcard.co.in';
    if (target.contains('yes bank') || target.contains('yes')) return 'https://www.yesbank.in';
    if (target.contains('indusind')) return 'https://www.indusind.com';
    if (target.contains('rbl')) return 'https://www.rblbank.com';
    if (target.contains('scapia')) return 'https://www.scapia.cards';
    if (target.contains('uni')) return 'https://www.uni.cards';
    if (target.contains('tata neu')) return 'https://www.tataneu.com';
    if (target.contains('tata capital') || target.contains('tata')) return 'https://www.tatacapital.com';
    if (target.contains('bajaj')) return 'https://www.bajajfinserv.in';
    if (target.contains('poonawalla')) return 'https://www.poonawallafincorp.com';
    if (target.contains('money view') || target.contains('moneyview')) return 'https://moneyview.in';
    if (target.contains('fibe')) return 'https://www.fibe.in';
    if (target.contains('kiwi')) return 'https://gokiwi.in';
    if (target.contains('salaryse')) return 'https://salaryse.com';
    if (target.contains('ram fincorp')) return 'https://ramfincorp.com';
    if (target.contains('zapcash')) return 'https://zapcash.in';
    if (target.contains('prefr')) return 'https://prefr.com';
    if (target.contains('olyv') || target.contains('smartcoin')) return 'https://olyv.com';
    if (target.contains('mpokket')) return 'https://mpokket.in';
    if (target.contains('zype')) return 'https://getzype.com';
    if (target.contains('creditsea')) return 'https://creditsea.com';
    if (target.contains('bankkaro')) return 'https://bankkaro.com';

    // Top E-commerce & Shopping Brands
    if (target.contains('flipkart')) return 'https://www.flipkart.com';
    if (target.contains('meesho')) return 'https://www.meesho.com';
    if (target.contains('amazon')) return 'https://www.amazon.in';
    if (target.contains('myntra')) return 'https://www.myntra.com';
    if (target.contains('nykaa')) return 'https://www.nykaa.com';
    if (target.contains('ajio')) return 'https://www.ajio.com';
    if (target.contains('croma')) return 'https://www.croma.com';
    if (target.contains('reliance')) return 'https://www.reliancedigital.in';
    if (target.contains('jiomart')) return 'https://www.jiomart.com';
    if (target.contains('zara')) return 'https://www.zara.com/in';
    if (target.contains('h&m') || target.contains('hm')) return 'https://www2.hm.com/en_in';
    if (target.contains('nike')) return 'https://www.nike.com/in';
    if (target.contains('adidas')) return 'https://www.adidas.co.in';
    if (target.contains('puma')) return 'https://in.puma.com';
    if (target.contains('samsung')) return 'https://www.samsung.com/in';
    if (target.contains('apple')) return 'https://www.apple.com/in';
    if (target.contains('sony')) return 'https://www.sony.co.in';
    if (target.contains('boat')) return 'https://www.boat-lifestyle.com';
    if (target.contains('noise')) return 'https://www.gonoise.com';
    if (target.contains('dyson')) return 'https://www.dyson.in';
    if (target.contains('realme')) return 'https://www.realme.com/in';
    if (target.contains('swiggy')) return 'https://www.swiggy.com';
    if (target.contains('zomato')) return 'https://www.zomato.com';
    if (target.contains('blinkit')) return 'https://blinkit.com';
    if (target.contains('zepto')) return 'https://www.zeptonow.com';
    if (target.contains('makemytrip')) return 'https://www.makemytrip.com';
    if (target.contains('goibibo')) return 'https://www.goibibo.com';
    if (target.contains('cleartrip')) return 'https://www.cleartrip.com';
    if (target.contains('1mg')) return 'https://www.1mg.com';
    if (target.contains('pharmeasy')) return 'https://pharmeasy.in';
    if (target.contains('netmeds')) return 'https://www.netmeds.com';
    if (target.contains('apollo')) return 'https://www.apollopharmacy.in';

    return 'https://www.google.com/search?q=${Uri.encodeComponent(storeOrBrand)}';
  }

  static String _extractBankName(String name) {
    if (name.contains('SBI')) return 'SBI';
    if (name.contains('HDFC')) return 'HDFC Bank';
    if (name.contains('Axis')) return 'Axis Bank';
    if (name.contains('ICICI')) return 'ICICI Bank';
    if (name.contains('HSBC')) return 'HSBC';
    if (name.contains('Kotak')) return 'Kotak';
    if (name.contains('IDFC')) return 'IDFC FIRST';
    if (name.contains('BOBCARD') || name.contains('Bank of Baroda')) return 'BOBCARD';
    if (name.contains('Yes Bank') || name.contains('YES BANK')) return 'Yes Bank';
    if (name.contains('IndusInd') || name.contains('Indusind')) return 'IndusInd';
    if (name.contains('RBL')) return 'RBL Bank';
    if (name.contains('Federal') || name.contains('Scapia')) return 'Scapia';
    if (name.contains('Uni')) return 'Uni';
    if (name.contains('Tata Neu')) return 'Tata Neu';
    if (name.contains('Tata Capital') || name.contains('Tata')) return 'Tata';
    if (name.contains('Bajaj')) return 'Bajaj Finserv';
    if (name.contains('Poonawalla')) return 'Poonawalla';
    if (name.contains('Money View') || name.contains('MoneyView')) return 'Money View';
    if (name.contains('Fibe')) return 'Fibe';
    if (name.contains('KIWI') || name.contains('Kiwi')) return 'Kiwi';
    if (name.contains('SalarySe')) return 'SalarySe';
    if (name.contains('Ram Fincorp')) return 'Ram Fincorp';
    if (name.contains('ZapCash')) return 'ZapCash';
    if (name.contains('Prefr')) return 'Prefr';
    if (name.contains('Olyv') || name.contains('SmartCoin')) return 'Olyv';
    if (name.contains('Mpokket') || name.contains('mPokket')) return 'mPokket';
    if (name.contains('Zype')) return 'Zype';
    if (name.contains('CreditSea')) return 'CreditSea';
    if (name.contains('BankKaro')) return 'BankKaro';

    final words = name.split(RegExp(r'\s+'));
    return words.length > 2 ? '${words[0]} ${words[1]}' : name;
  }

  static bool isCreditCard(String name, String category) {
    final lowerName = name.toLowerCase();
    final lowerCat = category.toLowerCase();
    return lowerCat.contains('card') ||
        lowerName.contains('card') ||
        lowerName.contains('credit');
  }

  static bool isLoan(String name, String category) {
    final lowerName = name.toLowerCase();
    final lowerCat = category.toLowerCase();
    return lowerCat.contains('loan') || lowerName.contains('loan');
  }

  static String getButtonLabel(String brandOrStoreName, String category) {
    if (isCreditCard(brandOrStoreName, category)) {
      final bank = _extractBankName(brandOrStoreName);
      return 'Visit $bank Card';
    }

    if (isLoan(brandOrStoreName, category)) {
      final bank = _extractBankName(brandOrStoreName);
      return 'Visit $bank Loan';
    }

    return 'Shop Now on ${brandOrStoreName.toUpperCase()}';
  }

  static IconData getButtonIcon(String brandOrStoreName, String category) {
    if (isCreditCard(brandOrStoreName, category)) {
      return Icons.credit_card_rounded;
    }
    if (isLoan(brandOrStoreName, category)) {
      return Icons.account_balance_wallet_rounded;
    }
    return Icons.shopping_bag_outlined;
  }

  static double _parseNumericPrice(String? priceStr, {double fallback = 0.0}) {
    if (priceStr == null || priceStr.isEmpty) return fallback;
    final trimmed = priceStr.trim();
    if (trimmed.contains('%') ||
        trimmed.toLowerCase().contains('off') ||
        trimmed.toLowerCase().contains('free') ||
        trimmed.toLowerCase().contains('buy') ||
        trimmed.toLowerCase().contains('p.a.')) {
      return fallback;
    }
    final cleaned = priceStr.replaceAll(RegExp(r'[^0-9.]'), '');
    return double.tryParse(cleaned) ?? fallback;
  }

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class StoreDealOption {
  final String storeName;
  final double storePrice;
  final double couponDiscount;
  final String couponCode;
  final double cashbackRate;
  final String badgeText;
  final bool isBestDeal;
  final String targetUrl;
  final double? exactCashbackAmount;
  final double? storeDiscount;
  final bool isOutOfStock;

  const StoreDealOption({
    required this.storeName,
    required this.storePrice,
    required this.couponDiscount,
    required this.couponCode,
    required this.cashbackRate,
    required this.badgeText,
    required this.isBestDeal,
    required this.targetUrl,
    this.exactCashbackAmount,
    this.storeDiscount,
    this.isOutOfStock = false,
  });
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _currentImageIndex = 0;
  final int _selectedStoreIndex = 0;
  bool _isCouponApplied = true;
  final Map<String, bool> _storeCouponApplied = {};
  static const double minSpendThreshold = 500.0;

  @override
  void initState() {
    super.initState();
    // Feed on-device personalisation for "Best Deals For You" / "Top Deals For You".
    final category = widget.customCategory;
    if (category != null && category.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        context.read<HomeProvider>().recordCategoryInterest(category);
      });
    }
  }

  bool _isCouponActiveForStore(String storeName) {
    return _storeCouponApplied[storeName] ?? _isCouponApplied;
  }

  void _toggleCouponForStore(String storeName) {
    setState(() {
      final current = _isCouponActiveForStore(storeName);
      _storeCouponApplied[storeName] = !current;
      _isCouponApplied = !current;
    });
  }

  String _selectedColor = 'Blue';
  final List<String> _availableColors = ['Blue', 'Black', 'Olive', 'Navy'];
  bool _isKeyFeaturesExpanded = true;
  bool _isSimilarExpanded = false;
  bool _isYouMightLikeExpanded = false;

  List<StoreDealOption> _buildStoreOptions({
    required CategoryDealModel? categoryDeal,
    required BestDealModel? bestDeal,
    required TrendingDealModel? trendingDeal,
    required PriceDropModel? priceDrop,
    required HomeOfferModel? homeOffer,
    required CashbackIncreaseModel? cashbackIncrease,
    required Product? product,
    required AmazonDealItemData? amazonDeal,
    required OfferSectionItem? offerItem,
    required BrandModel? brand,
    required String displayStoreName,
    required double defaultBasePrice,
    required double defaultCoupon,
    required String defaultCouponCode,
    required double defaultCbRate,
    double? exactCashbackAmount,
  }) {
    if (bestDeal != null) {
      if (bestDeal.stores.isNotEmpty) {
        return bestDeal.stores.map((s) {
          final isBest = s.isBest;
          final code = s.coupon > 0
              ? (bestDeal.couponCode.isNotEmpty ? bestDeal.couponCode : '${s.store.toUpperCase()}${s.coupon.toInt()}')
              : '';
          final cbRate = (s.price > 0 && s.cashback > 0)
              ? ((s.cashback / s.price) * 100).roundToDouble().clamp(1.0, 25.0)
              : bestDeal.cashbackPercentage;

          return StoreDealOption(
            storeName: s.store,
            storePrice: s.price,
            couponDiscount: s.coupon,
            couponCode: code,
            cashbackRate: cbRate,
            exactCashbackAmount: s.cashback,
            storeDiscount: s.storeDiscount > 0
                ? s.storeDiscount
                : (bestDeal.originalPrice > s.price ? bestDeal.originalPrice - s.price : 0.0),
            badgeText: isBest ? 'Lowest Price' : 'Verified Store',
            isBestDeal: isBest,
            targetUrl: ProductDetailScreen.resolveStoreUrl(s.store),
          );
        }).toList();
      }

      final basePrice = bestDeal.discountedPrice;
      final primaryStore = bestDeal.store.isNotEmpty ? bestDeal.store : 'Myntra';
      final altStore = primaryStore.toLowerCase() == 'ajio'
          ? 'Myntra'
          : (primaryStore.toLowerCase() == 'flipkart' ? 'Amazon' : 'Flipkart');
      final coupon = bestDeal.couponDiscount;
      final code = bestDeal.couponCode.isNotEmpty ? bestDeal.couponCode : (coupon > 0 ? 'BESTDEAL' : '');
      final cb = bestDeal.cashbackPercentage > 0 ? bestDeal.cashbackPercentage : 10.0;
      final storeDisc = bestDeal.originalPrice > basePrice ? bestDeal.originalPrice - basePrice : 0.0;

      return [
        StoreDealOption(
          storeName: primaryStore,
          storePrice: basePrice,
          couponDiscount: coupon,
          couponCode: code,
          cashbackRate: cb,
          exactCashbackAmount: bestDeal.cashbackAmount > 0 ? bestDeal.cashbackAmount : null,
          storeDiscount: storeDisc,
          badgeText: 'Lowest Price',
          isBestDeal: true,
          targetUrl: ProductDetailScreen.resolveStoreUrl(primaryStore),
        ),
        StoreDealOption(
          storeName: altStore,
          storePrice: (basePrice * 1.05).roundToDouble(),
          couponDiscount: (coupon * 0.7).roundToDouble(),
          couponCode: coupon > 0 ? 'STORE${(coupon * 0.7).toInt()}' : '',
          cashbackRate: (cb * 0.8).roundToDouble(),
          exactCashbackAmount: null,
          storeDiscount: storeDisc > 0 ? (storeDisc * 0.8).roundToDouble() : 0.0,
          badgeText: 'Verified Store',
          isBestDeal: false,
          targetUrl: ProductDetailScreen.resolveStoreUrl(altStore),
        ),
        StoreDealOption(
          storeName: 'Amazon',
          storePrice: (basePrice * 1.08).roundToDouble(),
          couponDiscount: 0.0,
          couponCode: '',
          cashbackRate: 5.0,
          exactCashbackAmount: null,
          storeDiscount: storeDisc > 0 ? (storeDisc * 0.5).roundToDouble() : 0.0,
          badgeText: 'Fast Delivery',
          isBestDeal: false,
          targetUrl: 'https://www.amazon.in',
        ),
        StoreDealOption(
          storeName: 'Flipkart',
          storePrice: (basePrice * 1.10).roundToDouble(),
          couponDiscount: 0.0,
          couponCode: '',
          cashbackRate: 4.0,
          exactCashbackAmount: null,
          storeDiscount: storeDisc > 0 ? (storeDisc * 0.4).roundToDouble() : 0.0,
          badgeText: 'Popular',
          isBestDeal: false,
          targetUrl: 'https://www.flipkart.com',
        ),
      ];
    }

    if (trendingDeal != null) {
      final basePrice = trendingDeal.price;
      final primaryStore = trendingDeal.store.isNotEmpty ? trendingDeal.store : 'Amazon';
      final altStore = primaryStore.toLowerCase() == 'flipkart' ? 'Amazon' : 'Flipkart';
      final cbRate = trendingDeal.cashbackAmount > 0 && basePrice > 0
          ? ((trendingDeal.cashbackAmount / basePrice) * 100).roundToDouble().clamp(1.0, 30.0)
          : 8.0;
      final storeDisc = trendingDeal.originalPrice > basePrice
          ? (trendingDeal.originalPrice - basePrice)
          : 0.0;

      return [
        StoreDealOption(
          storeName: primaryStore,
          storePrice: basePrice,
          couponDiscount: 0.0,
          couponCode: '',
          cashbackRate: cbRate,
          exactCashbackAmount: trendingDeal.cashbackAmount > 0 ? trendingDeal.cashbackAmount : exactCashbackAmount,
          storeDiscount: storeDisc,
          badgeText: 'Lowest Price',
          isBestDeal: true,
          targetUrl: ProductDetailScreen.resolveStoreUrl(primaryStore),
        ),
        StoreDealOption(
          storeName: altStore,
          storePrice: (basePrice * 1.05).roundToDouble(),
          couponDiscount: 0.0,
          couponCode: '',
          cashbackRate: (cbRate * 0.8).roundToDouble(),
          exactCashbackAmount: null,
          storeDiscount: storeDisc > 0 ? (storeDisc * 0.8).roundToDouble() : 0.0,
          badgeText: 'Alternative',
          isBestDeal: false,
          targetUrl: ProductDetailScreen.resolveStoreUrl(altStore),
        ),
        StoreDealOption(
          storeName: 'Myntra',
          storePrice: (basePrice * 1.08).roundToDouble(),
          couponDiscount: 0.0,
          couponCode: '',
          cashbackRate: (cbRate * 0.7).roundToDouble(),
          exactCashbackAmount: null,
          storeDiscount: storeDisc > 0 ? (storeDisc * 0.7).roundToDouble() : 0.0,
          badgeText: 'Official Store',
          isBestDeal: false,
          targetUrl: 'https://www.myntra.com',
        ),
      ];
    }

    if (priceDrop != null) {
      final basePrice = priceDrop.nowPrice;
      final primaryStore = priceDrop.store.isNotEmpty ? priceDrop.store : 'Flipkart';
      final altStore = primaryStore.toLowerCase() == 'amazon' ? 'Flipkart' : 'Amazon';
      final cbRate = priceDrop.cashbackAmount > 0 && basePrice > 0
          ? ((priceDrop.cashbackAmount / basePrice) * 100).roundToDouble().clamp(1.0, 30.0)
          : 6.0;
      final storeDisc = priceDrop.priceDropAmount > 0
          ? priceDrop.priceDropAmount
          : (priceDrop.wasPrice > basePrice ? priceDrop.wasPrice - basePrice : 0.0);

      return [
        StoreDealOption(
          storeName: primaryStore,
          storePrice: basePrice,
          couponDiscount: 0.0,
          couponCode: '',
          cashbackRate: cbRate,
          exactCashbackAmount: priceDrop.cashbackAmount > 0 ? priceDrop.cashbackAmount : exactCashbackAmount,
          storeDiscount: storeDisc,
          badgeText: 'Dropped Price',
          isBestDeal: true,
          targetUrl: ProductDetailScreen.resolveStoreUrl(primaryStore),
        ),
        StoreDealOption(
          storeName: altStore,
          storePrice: (basePrice * 1.05).roundToDouble(),
          couponDiscount: 0.0,
          couponCode: '',
          cashbackRate: (cbRate * 0.8).roundToDouble(),
          exactCashbackAmount: null,
          storeDiscount: storeDisc > 0 ? (storeDisc * 0.7).roundToDouble() : 0.0,
          badgeText: 'Standard Price',
          isBestDeal: false,
          targetUrl: ProductDetailScreen.resolveStoreUrl(altStore),
        ),
        StoreDealOption(
          storeName: 'Reliance Digital',
          storePrice: (basePrice * 1.08).roundToDouble(),
          couponDiscount: 0.0,
          couponCode: '',
          cashbackRate: 4.0,
          exactCashbackAmount: null,
          storeDiscount: storeDisc > 0 ? (storeDisc * 0.5).roundToDouble() : 0.0,
          badgeText: 'Retail Store',
          isBestDeal: false,
          targetUrl: 'https://www.reliancedigital.in',
        ),
      ];
    }

    if (categoryDeal != null) {
      final basePrice = categoryDeal.discountedPrice;
      final primaryStore = categoryDeal.store.isNotEmpty ? categoryDeal.store : 'Myntra';
      final altStore = primaryStore.toLowerCase() == 'ajio' ? 'Myntra' : 'AJIO';
      final coupon = categoryDeal.couponDiscount;
      final code = categoryDeal.couponCode.isNotEmpty
          ? categoryDeal.couponCode
          : (coupon > 0 ? 'FASHION${coupon.toInt()}' : '');
      final cb = categoryDeal.cashbackPercentage > 0 ? categoryDeal.cashbackPercentage : 10.0;
      final storeDisc = categoryDeal.originalPrice > basePrice ? categoryDeal.originalPrice - basePrice : 0.0;

      return [
        StoreDealOption(
          storeName: primaryStore,
          storePrice: basePrice,
          couponDiscount: coupon,
          couponCode: code,
          cashbackRate: cb,
          exactCashbackAmount: exactCashbackAmount,
          storeDiscount: storeDisc,
          badgeText: 'Lowest Price',
          isBestDeal: true,
          targetUrl: ProductDetailScreen.resolveStoreUrl(primaryStore),
        ),
        StoreDealOption(
          storeName: altStore,
          storePrice: (basePrice * 1.06).roundToDouble(),
          couponDiscount: (coupon * 0.7).roundToDouble(),
          couponCode: coupon > 0 ? 'STORE${(coupon * 0.7).toInt()}' : '',
          cashbackRate: (cb * 0.8).roundToDouble(),
          exactCashbackAmount: null,
          storeDiscount: storeDisc > 0 ? (storeDisc * 0.8).roundToDouble() : 0.0,
          badgeText: 'Official Store',
          isBestDeal: false,
          targetUrl: ProductDetailScreen.resolveStoreUrl(altStore),
        ),
        StoreDealOption(
          storeName: 'Amazon',
          storePrice: (basePrice * 1.12).roundToDouble(),
          couponDiscount: 0.0,
          couponCode: '',
          cashbackRate: 6.0,
          exactCashbackAmount: null,
          storeDiscount: storeDisc > 0 ? (storeDisc * 0.5).roundToDouble() : 0.0,
          badgeText: 'Fast Delivery',
          isBestDeal: false,
          targetUrl: 'https://www.amazon.in',
        ),
        StoreDealOption(
          storeName: 'Flipkart',
          storePrice: (basePrice * 1.15).roundToDouble(),
          couponDiscount: 0.0,
          couponCode: '',
          cashbackRate: 5.0,
          exactCashbackAmount: null,
          storeDiscount: storeDisc > 0 ? (storeDisc * 0.4).roundToDouble() : 0.0,
          badgeText: 'Popular',
          isBestDeal: false,
          targetUrl: 'https://www.flipkart.com',
        ),
      ];
    }

    if (amazonDeal != null) {
      final basePrice = amazonDeal.actualPrice.toDouble();
      final exactReward = (amazonDeal.actualPrice - amazonDeal.finalPrice).roundToDouble();
      return [
        StoreDealOption(
          storeName: 'Amazon',
          storePrice: basePrice,
          couponDiscount: 0.0,
          couponCode: '',
          cashbackRate: amazonDeal.rewardPercentage > 0 ? amazonDeal.rewardPercentage : 8.0,
          exactCashbackAmount: exactReward > 0 ? exactReward : null,
          storeDiscount: 0.0,
          badgeText: 'Lowest Price',
          isBestDeal: true,
          targetUrl: amazonDeal.productUrl.isNotEmpty ? amazonDeal.productUrl : 'https://www.amazon.in',
        ),
        StoreDealOption(
          storeName: 'Flipkart',
          storePrice: (basePrice * 1.05).roundToDouble(),
          couponDiscount: 0.0,
          couponCode: '',
          cashbackRate: 5.0,
          exactCashbackAmount: null,
          storeDiscount: 0.0,
          badgeText: 'Alternative',
          isBestDeal: false,
          targetUrl: 'https://www.flipkart.com',
        ),
      ];
    }

    if (homeOffer != null) {
      return <StoreDealOption>[];
    }

    if (offerItem != null) {
      final primaryStore = offerItem.storeName.isNotEmpty ? offerItem.storeName : 'Store';
      final cbMatch = RegExp(r'(\d+)%').firstMatch(offerItem.cashbackTag);
      final cbRate = cbMatch != null ? (double.tryParse(cbMatch.group(1)!) ?? defaultCbRate) : defaultCbRate;
      final cbRupeeMatch = RegExp(r'₹(\d+)').firstMatch(offerItem.cashbackTag);
      final exactCb = cbRupeeMatch != null ? double.tryParse(cbRupeeMatch.group(1)!) : exactCashbackAmount;
      return [
        StoreDealOption(
          storeName: primaryStore,
          storePrice: defaultBasePrice > 0 ? defaultBasePrice : 999.0,
          couponDiscount: 0.0,
          couponCode: '',
          cashbackRate: cbRate,
          exactCashbackAmount: exactCb,
          storeDiscount: null,
          badgeText: 'Verified Store',
          isBestDeal: true,
          targetUrl: ProductDetailScreen.resolveStoreUrl(primaryStore),
        ),
      ];
    }

    // Product or general custom deal item
    final basePrice = defaultBasePrice > 0 ? defaultBasePrice : 999.0;
    final primaryStore = displayStoreName.isNotEmpty && displayStoreName != 'Store' ? displayStoreName : 'Myntra';
    final altStore = primaryStore.toLowerCase() == 'ajio'
        ? 'Myntra'
        : (primaryStore.toLowerCase() == 'myntra' ? 'AJIO' : 'Amazon');

    return [
      StoreDealOption(
        storeName: primaryStore,
        storePrice: basePrice,
        couponDiscount: defaultCoupon,
        couponCode: defaultCouponCode,
        cashbackRate: defaultCbRate,
        exactCashbackAmount: exactCashbackAmount,
        storeDiscount: null,
        badgeText: 'Lowest Price',
        isBestDeal: true,
        targetUrl: ProductDetailScreen.resolveStoreUrl(primaryStore),
      ),
      StoreDealOption(
        storeName: altStore,
        storePrice: (basePrice * 1.06).roundToDouble(),
        couponDiscount: (defaultCoupon * 0.7).roundToDouble(),
        couponCode: defaultCoupon > 0 ? 'SAVE${(defaultCoupon * 0.7).toInt()}' : '',
        cashbackRate: (defaultCbRate * 0.8).roundToDouble(),
        exactCashbackAmount: null,
        storeDiscount: null,
        badgeText: 'Official Store',
        isBestDeal: false,
        targetUrl: ProductDetailScreen.resolveStoreUrl(altStore),
      ),
      StoreDealOption(
        storeName: 'Amazon',
        storePrice: (basePrice * 1.12).roundToDouble(),
        couponDiscount: 0.0,
        couponCode: '',
        cashbackRate: 5.0,
        exactCashbackAmount: null,
        storeDiscount: null,
        badgeText: 'Fast Delivery',
        isBestDeal: false,
        targetUrl: 'https://www.amazon.in',
      ),
      StoreDealOption(
        storeName: 'Flipkart',
        storePrice: (basePrice * 1.15).roundToDouble(),
        couponDiscount: 0.0,
        couponCode: '',
        cashbackRate: 4.0,
        exactCashbackAmount: null,
        storeDiscount: null,
        badgeText: 'Popular',
        isBestDeal: false,
        targetUrl: 'https://www.flipkart.com',
      ),
    ];
  }

  Future<void> _handleShopNow(String targetUrl, String storeName) async {
    var urlToOpen = targetUrl.trim();
    if (urlToOpen.isEmpty || urlToOpen.contains('KashIQ.com')) {
      urlToOpen = ProductDetailScreen.resolveStoreUrl(storeName);
    }

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final activeUid = userProvider.uid;

    try {
      final tracked = await AffiliateService().generateTrackedLink(
        userId: activeUid,
        storeName: storeName,
        targetUrl: urlToOpen,
        storeId: storeName.toLowerCase().replaceAll(RegExp(r'\s+'), '_'),
        linkType: 'SELF_SHOPPING',
      );
      if (tracked.urlToOpen.isNotEmpty) {
        urlToOpen = tracked.urlToOpen;
      }
    } catch (e) {
      debugPrint('Affiliate link tracking generation note: $e');
    }

    var success = await UrlLauncherService.openUrl(urlToOpen);

    // If primary URL fails (e.g., tracking redirect block), fallback directly to official store website
    if (!success) {
      final fallbackUrl = ProductDetailScreen.resolveStoreUrl(storeName);
      if (fallbackUrl != urlToOpen) {
        success = await UrlLauncherService.openUrl(fallbackUrl);
      }
    }

    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not open $storeName website. Please check your internet connection.'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _handleShareAndEarn({
    required String? affiliateUrl,
    required String productTitle,
    String storeName = 'Partner Store',
    String? targetUrl,
    double? storePrice,
    double? effectivePrice,
    double? cashbackAmount,
    String? productId,
    String? imageUrl,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final activeUid = userProvider.uid;

    var baseLink = (affiliateUrl != null && affiliateUrl.trim().isNotEmpty)
        ? affiliateUrl.trim()
        : (targetUrl?.trim() ?? '');
    if (baseLink.isEmpty || baseLink.contains('KashIQ.com')) {
      baseLink = ProductDetailScreen.resolveStoreUrl(storeName);
    }

    String merchantAffiliateLink = baseLink;
    try {
      final tracked = await AffiliateService().generateTrackedLink(
        userId: activeUid,
        storeName: storeName,
        targetUrl: baseLink,
        storeId: storeName.toLowerCase().replaceAll(RegExp(r'\s+'), '_'),
        linkType: 'SHARE_AND_EARN',
      );
      if (tracked.urlToOpen.isNotEmpty) {
        merchantAffiliateLink = tracked.urlToOpen;
      }
    } catch (e) {
      debugPrint('Error generating tracked share link: $e');
    }

    // Build the Hybrid Web Landing Page URL
    String shareLink;
    try {
      final webUri = Uri.parse('${AuthService.publicDealUrl}/deal').replace(
        queryParameters: {
          'title': productTitle.trim(),
          'store': storeName.trim(),
          if (storePrice != null && storePrice > 0) 'price': storePrice.toStringAsFixed(0),
          if (cashbackAmount != null && cashbackAmount > 0) 'cashback': cashbackAmount.toStringAsFixed(0),
          if (imageUrl != null && imageUrl.trim().isNotEmpty) 'img': imageUrl.trim(),
          if (productId != null && productId.trim().isNotEmpty) 'pid': productId.trim(),
          if (activeUid.trim().isNotEmpty) 'ref': activeUid.trim(),
          if (merchantAffiliateLink.isNotEmpty) 'affUrl': merchantAffiliateLink,
        },
      );
      shareLink = webUri.toString();
    } catch (e) {
      debugPrint('Error building hybrid deal link: $e');
      shareLink = merchantAffiliateLink;
    }

    final priceSection = (storePrice != null && effectivePrice != null && cashbackAmount != null && effectivePrice > 0)
        ? '\n💰 Store Price: ₹${storePrice.toStringAsFixed(0)}\n🎁 KashIQ Cashback: ₹${cashbackAmount.toStringAsFixed(0)}\n✨ *Effective Price: ₹${effectivePrice.toStringAsFixed(0)} Only!*\n'
        : '';

    final shareText = '''
🔥 *Hot Deal on $storeName via KashIQ!* 🔥
*${productTitle.trim()}*
$priceSection
👉 View deal, buy now, or grab extra cashback here:
$shareLink
'''.trim();

    try {
      await SharePlus.instance.share(
        ShareParams(
          text: shareText,
          subject: 'Deal on $productTitle - Save on KashIQ!',
        ),
      );
    } catch (e) {
      debugPrint('Error sharing via native share sheet: $e');
      await Clipboard.setData(ClipboardData(text: shareLink));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Expanded(
                child: Text('Deal link copied to clipboard!'),
              ),
            ],
          ),
          backgroundColor: AppColors.primaryBrown,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Widget _buildBottomActionBar({
    required BuildContext context,
    required bool isDark,
    required String title,
    required String displayStoreName,
    required String resolvedOriginalUrl,
    required String? resolvedAffiliateUrl,
    double? storePrice,
    double? effectivePrice,
    double? cashbackAmount,
    String? productId,
    String? imageUrl,
  }) {
    final primaryAccent = isDark ? const Color(0xFF2563EB) : AppColors.primaryBrown;
    final buttonTextColor = isDark ? const Color(0xFF0F172A) : Colors.white;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? const Color(0xFF1E3A8A) : const Color(0xFFE2E8F0),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              // Secondary CTA: Share & Earn
              Expanded(
                flex: 1,
                child: SizedBox(
                  height: 48,
                  child: OutlinedButton(
                    onPressed: () => _handleShareAndEarn(
                      affiliateUrl: resolvedAffiliateUrl,
                      productTitle: title,
                      storeName: displayStoreName,
                      targetUrl: resolvedOriginalUrl,
                      storePrice: storePrice,
                      effectivePrice: effectivePrice,
                      cashbackAmount: cashbackAmount,
                      productId: productId,
                      imageUrl: imageUrl,
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: primaryAccent,
                      side: BorderSide(
                        color: primaryAccent,
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: primaryAccent.withValues(alpha: 0.06),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.share_outlined,
                          size: 18,
                          color: primaryAccent,
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            'Share & Earn',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Primary CTA: Shop Now
              Expanded(
                flex: 1,
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => _handleShopNow(resolvedOriginalUrl, displayStoreName),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryAccent,
                      foregroundColor: buttonTextColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_bag_outlined,
                          size: 18,
                          color: buttonTextColor,
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            'Shop Now',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.2,
                              color: buttonTextColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 16,
                          color: buttonTextColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Resolve details dynamically from Product object, route arguments, or custom attributes
    final routeArgs = ModalRoute.of(context)?.settings.arguments;
    Product? product = widget.product;
    BrandModel? brand = widget.brand;
    AmazonDealItemData? amazonDeal = widget.amazonDeal;
    OfferSectionItem? offerItem = widget.offerItem;
    CategoryDealModel? categoryDeal = widget.categoryDeal;
    BestDealModel? bestDeal = widget.bestDeal;
    TrendingDealModel? trendingDeal = widget.trendingDeal;
    HomeOfferModel? homeOffer = widget.homeOffer;
    PriceDropModel? priceDrop = widget.priceDrop;
    CashbackIncreaseModel? cashbackIncrease = widget.cashbackIncrease;
    FeaturedStoreModel? featuredStore = widget.featuredStore;

    if (routeArgs != null) {
      if (routeArgs is Product) {
        product = routeArgs;
      } else if (routeArgs is BrandModel) {
        brand = routeArgs;
      } else if (routeArgs is AmazonDealItemData) {
        amazonDeal = routeArgs;
      } else if (routeArgs is OfferSectionItem) {
        offerItem = routeArgs;
      } else if (routeArgs is CategoryDealModel) {
        categoryDeal = routeArgs;
      } else if (routeArgs is BestDealModel) {
        bestDeal = routeArgs;
      } else if (routeArgs is TrendingDealModel) {
        trendingDeal = routeArgs;
      } else if (routeArgs is HomeOfferModel) {
        homeOffer = routeArgs;
      } else if (routeArgs is PriceDropModel) {
        priceDrop = routeArgs;
      } else if (routeArgs is CashbackIncreaseModel) {
        cashbackIncrease = routeArgs;
      } else if (routeArgs is FeaturedStoreModel) {
        featuredStore = routeArgs;
      }
    }

    final title = widget.customTitle ??
        bestDeal?.title ??
        trendingDeal?.productName ??
        priceDrop?.productName ??
        homeOffer?.title ??
        cashbackIncrease?.headline ??
        featuredStore?.name ??
        product?.title ??
        brand?.name ??
        amazonDeal?.productName ??
        offerItem?.title ??
        'Product Details';

    final brandName = widget.customBrandName ??
        bestDeal?.brand ??
        trendingDeal?.brand ??
        priceDrop?.brand ??
        homeOffer?.store ??
        cashbackIncrease?.store ??
        featuredStore?.name ??
        product?.brand ??
        brand?.name ??
        amazonDeal?.brandName ??
        offerItem?.storeName ??
        '';

    final category = widget.customCategory ??
        bestDeal?.category ??
        trendingDeal?.store ??
        priceDrop?.store ??
        homeOffer?.category ??
        featuredStore?.offerTag ??
        product?.category ??
        brand?.category ??
        (amazonDeal != null ? 'Amazon Top Deals' : (offerItem?.storeName ?? ''));

    final rating = widget.customRating ?? product?.rating;
    final stock = widget.customStock ?? product?.stock;
    final description = widget.customDescription ??
        product?.description ??
        (bestDeal != null
            ? '${bestDeal.title} by ${bestDeal.brand}. Recommended deal with verified store discounts and KashIQ extra cashback.'
            : (trendingDeal != null
                ? '${trendingDeal.productName} by ${trendingDeal.brand}. Trending deal with ${trendingDeal.discount} and guaranteed extra cashback.'
                : (priceDrop != null
                    ? '${priceDrop.productName} by ${priceDrop.brand}. Price dropped to ₹${priceDrop.nowPrice.toInt()} with extra ${priceDrop.cashback}.'
                    : (homeOffer != null
                        ? 'Exclusive deal on ${homeOffer.store}. Enjoy ${homeOffer.discount} with ${homeOffer.cashback} cashback.'
                        : (brand != null
                            ? 'Shop online at ${brand.name} through KashIQ to enjoy exclusive voucher discounts and guaranteed cashback rewards on your orders.'
                            : (amazonDeal != null
                                ? 'Special promotional pricing on Amazon with extra cashback rewards automatically credited to your KashIQ wallet after delivery.'
                                : (offerItem?.description ??
                                    'Shop this deal via KashIQ to earn guaranteed cashback rewards credited to your account.')))))));

    // Image list resolution
    List<String> imageList = [];
    if (widget.customImages != null && widget.customImages!.isNotEmpty) {
      imageList = List.from(widget.customImages!);
    } else if (widget.customImageUrl != null && widget.customImageUrl!.isNotEmpty) {
      imageList = [widget.customImageUrl!];
    } else if (bestDeal != null && bestDeal.imageUrl.isNotEmpty) {
      imageList = [bestDeal.imageUrl];
    } else if (trendingDeal != null && trendingDeal.imageUrl.isNotEmpty) {
      imageList = [trendingDeal.imageUrl];
    } else if (priceDrop != null && priceDrop.imageUrl.isNotEmpty) {
      imageList = [priceDrop.imageUrl];
    } else if (homeOffer != null && homeOffer.imageUrl.isNotEmpty) {
      imageList = [homeOffer.imageUrl];
    } else if (cashbackIncrease != null && cashbackIncrease.logoUrl.isNotEmpty) {
      imageList = [cashbackIncrease.logoUrl];
    } else if (featuredStore != null && featuredStore.logoUrl.isNotEmpty) {
      imageList = [featuredStore.logoUrl];
    } else if (product != null) {
      if (product.images != null && product.images!.isNotEmpty) {
        imageList = List.from(product.images!);
      } else if (product.thumbnail.isNotEmpty) {
        imageList = [product.thumbnail];
      }
    } else if (brand != null) {
      if (brand.bannerUrl.isNotEmpty) imageList.add(brand.bannerUrl);
      if (brand.logoUrl.isNotEmpty && brand.logoUrl != brand.bannerUrl) {
        imageList.add(brand.logoUrl);
      }
    } else if (amazonDeal != null && amazonDeal.imageUrl.isNotEmpty) {
      imageList = [amazonDeal.imageUrl];
    } else if (offerItem != null && offerItem.imageUrl.isNotEmpty) {
      imageList = [offerItem.imageUrl];
    }

    // Pricing resolution
    final discountedPrice = widget.customDiscountedPrice ??
        (bestDeal != null
            ? '₹${bestDeal.discountedPrice.toInt()}'
            : (trendingDeal != null
                ? '₹${trendingDeal.price.toInt()}'
                : (priceDrop != null
                    ? '₹${priceDrop.nowPrice.toInt()}'
                    : (product != null
                        ? '₹${ProductDetailScreen._formatCurrency((product.finalPrice * 83).round())}'
                        : (amazonDeal != null
                            ? '₹${ProductDetailScreen._formatCurrency(amazonDeal.finalPrice)}'
                            : offerItem?.priceOrRate)))));

    final originalPrice = widget.customOriginalPrice ??
        (bestDeal != null && bestDeal.originalPrice > 0
            ? '₹${bestDeal.originalPrice.toInt()}'
            : (trendingDeal != null && trendingDeal.originalPrice > 0
                ? '₹${trendingDeal.originalPrice.toInt()}'
                : (priceDrop != null && priceDrop.wasPrice > 0
                    ? '₹${priceDrop.wasPrice.toInt()}'
                    : (product != null && product.discountPercentage > 0
                        ? '₹${ProductDetailScreen._formatCurrency((product.originalPrice * 83).round())}'
                        : (amazonDeal != null
                            ? '₹${ProductDetailScreen._formatCurrency(amazonDeal.actualPrice.round())}'
                            : null)))));

    final discountTag = widget.customDiscountTag ??
        (bestDeal != null && bestDeal.discountPercentage > 0
            ? '${bestDeal.discountPercentage.toInt()}% OFF'
            : (trendingDeal != null && trendingDeal.discount.isNotEmpty
                ? trendingDeal.discount
                : (priceDrop != null && priceDrop.priceDropBadge.isNotEmpty
                    ? priceDrop.priceDropBadge
                    : (product != null && product.discountPercentage > 0
                        ? '${product.discountPercentage.toStringAsFixed(0)}% OFF'
                        : (brand?.offerText ??
                            (amazonDeal != null
                                ? '${amazonDeal.rewardPercentage.toStringAsFixed(0)}% OFF'
                                : null))))));

    final displayStoreName = brandName.isNotEmpty
        ? brandName
        : (category.isNotEmpty ? category : 'Store');

    final isCard = ProductDetailScreen.isCreditCard(displayStoreName, category);
    final isLoan = ProductDetailScreen.isLoan(displayStoreName, category);
    final isFinancialProduct = isCard || isLoan;

    double baseStorePrice = 0.0;
    double rawOriginalPrice = 0.0;
    double defaultCouponDiscount = 0.0;
    double defaultCashbackRate = 10.0;
    String defaultCouponCode = '';
    double? exactCustomCashback;

    if (bestDeal != null) {
      baseStorePrice = bestDeal.discountedPrice;
      rawOriginalPrice = bestDeal.originalPrice;
      defaultCouponDiscount = bestDeal.couponDiscount;
      defaultCouponCode = bestDeal.couponCode.isNotEmpty
          ? bestDeal.couponCode
          : (defaultCouponDiscount > 0 ? 'SAVE${defaultCouponDiscount.toInt()}' : '');
      defaultCashbackRate = bestDeal.cashbackPercentage > 0 ? bestDeal.cashbackPercentage : 10.0;
      exactCustomCashback = bestDeal.cashbackAmount > 0 ? bestDeal.cashbackAmount : null;
    } else if (categoryDeal != null) {
      baseStorePrice = categoryDeal.discountedPrice;
      rawOriginalPrice = categoryDeal.originalPrice;
      defaultCouponDiscount = categoryDeal.couponDiscount;
      defaultCouponCode = categoryDeal.couponCode.isNotEmpty
          ? categoryDeal.couponCode
          : (defaultCouponDiscount > 0 ? 'FASHION${defaultCouponDiscount.toInt()}' : '');
      defaultCashbackRate = categoryDeal.cashbackPercentage > 0 ? categoryDeal.cashbackPercentage : 10.0;
      if (categoryDeal.cashbackAmount > 0) {
        exactCustomCashback = categoryDeal.cashbackAmount;
      }
    } else if (trendingDeal != null) {
      baseStorePrice = trendingDeal.price;
      rawOriginalPrice = trendingDeal.originalPrice > 0 ? trendingDeal.originalPrice : trendingDeal.price;
      defaultCouponDiscount = 0.0;
      defaultCouponCode = '';
      defaultCashbackRate = trendingDeal.cashbackAmount > 0 && trendingDeal.price > 0
          ? ((trendingDeal.cashbackAmount / trendingDeal.price) * 100).roundToDouble().clamp(1.0, 30.0)
          : 8.0;
      exactCustomCashback = trendingDeal.cashbackAmount > 0 ? trendingDeal.cashbackAmount : null;
    } else if (priceDrop != null) {
      baseStorePrice = priceDrop.nowPrice;
      rawOriginalPrice = priceDrop.wasPrice;
      defaultCouponDiscount = 0.0;
      defaultCouponCode = '';
      defaultCashbackRate = priceDrop.cashbackAmount > 0 && priceDrop.nowPrice > 0
          ? ((priceDrop.cashbackAmount / priceDrop.nowPrice) * 100).roundToDouble().clamp(1.0, 30.0)
          : 6.0;
      exactCustomCashback = priceDrop.cashbackAmount > 0 ? priceDrop.cashbackAmount : null;
    } else if (homeOffer != null) {
      baseStorePrice = 0.0;
      rawOriginalPrice = 0.0;
      defaultCouponDiscount = 0.0;
      defaultCouponCode = '';
      defaultCashbackRate = homeOffer.cashbackRate > 0 ? homeOffer.cashbackRate : 8.0;
      final cbMatch = RegExp(r'₹(\d+)').firstMatch(homeOffer.cashback);
      if (cbMatch != null) {
        exactCustomCashback = double.tryParse(cbMatch.group(1)!);
      }
    } else if (offerItem != null) {
      baseStorePrice = ProductDetailScreen._parseNumericPrice(discountedPrice, fallback: 999.0);
      rawOriginalPrice = ProductDetailScreen._parseNumericPrice(originalPrice, fallback: baseStorePrice);
      defaultCouponDiscount = 0.0;
      defaultCouponCode = '';
      final cbMatch = RegExp(r'(\d+)%').firstMatch(offerItem.cashbackTag);
      defaultCashbackRate = cbMatch != null ? (double.tryParse(cbMatch.group(1)!) ?? 8.0) : 8.0;
      final cbRupeeMatch = RegExp(r'₹(\d+)').firstMatch(offerItem.cashbackTag);
      if (cbRupeeMatch != null) {
        exactCustomCashback = double.tryParse(cbRupeeMatch.group(1)!);
      }
    } else if (product != null) {
      baseStorePrice = (product.finalPrice * 83).toDouble();
      rawOriginalPrice = (product.originalPrice * 83).toDouble();
      defaultCouponDiscount = 0.0;
      defaultCouponCode = '';
      defaultCashbackRate = product.discountPercentage > 0 ? product.discountPercentage : 10.0;
    } else if (amazonDeal != null) {
      baseStorePrice = amazonDeal.actualPrice.toDouble();
      rawOriginalPrice = amazonDeal.actualPrice.toDouble();
      defaultCouponDiscount = 0.0;
      defaultCouponCode = '';
      defaultCashbackRate = amazonDeal.rewardPercentage > 0 ? amazonDeal.rewardPercentage : 8.0;
      exactCustomCashback = (amazonDeal.actualPrice - amazonDeal.finalPrice).roundToDouble();
    } else {
      baseStorePrice = ProductDetailScreen._parseNumericPrice(discountedPrice, fallback: 999.0);
      rawOriginalPrice = ProductDetailScreen._parseNumericPrice(originalPrice, fallback: baseStorePrice);
      defaultCouponDiscount = 0.0;
      defaultCouponCode = '';
      defaultCashbackRate = 10.0;
    }

    if (widget.customFinalPrice != null) {
      final customFinalNum = ProductDetailScreen._parseNumericPrice(widget.customFinalPrice, fallback: 0.0);
      if (customFinalNum > 0 && baseStorePrice > customFinalNum) {
        exactCustomCashback = (baseStorePrice - customFinalNum - defaultCouponDiscount).clamp(0.0, baseStorePrice);
      }
    }

    // Build the verified store options (for multi-store comparison & selection)
    final storeOptions = isFinancialProduct
        ? <StoreDealOption>[]
        : _buildStoreOptions(
            categoryDeal: categoryDeal,
            bestDeal: bestDeal,
            trendingDeal: trendingDeal,
            priceDrop: priceDrop,
            homeOffer: homeOffer,
            cashbackIncrease: cashbackIncrease,
            product: product,
            amazonDeal: amazonDeal,
            offerItem: offerItem,
            brand: brand,
            displayStoreName: displayStoreName,
            defaultBasePrice: baseStorePrice,
            defaultCoupon: defaultCouponDiscount,
            defaultCouponCode: defaultCouponCode,
            defaultCbRate: defaultCashbackRate,
            exactCashbackAmount: exactCustomCashback,
          );

    final selectedIndex = (storeOptions.isNotEmpty &&
            _selectedStoreIndex >= 0 &&
            _selectedStoreIndex < storeOptions.length)
        ? _selectedStoreIndex
        : 0;

    final selectedStore = storeOptions.isNotEmpty ? storeOptions[selectedIndex] : null;

    // Active price and offer attributes from selected store (or default for cards/loans)
    final rawStorePrice = selectedStore != null ? selectedStore.storePrice : baseStorePrice;
    final couponCode = selectedStore != null ? selectedStore.couponCode : defaultCouponCode;

    final double storeDiscount = selectedStore?.storeDiscount ??
        (rawOriginalPrice > rawStorePrice ? (rawOriginalPrice - rawStorePrice) : 0.0);

    final lowestStore = storeOptions.isNotEmpty
        ? (storeOptions.firstWhere((s) => s.isBestDeal, orElse: () => storeOptions.first))
        : null;

    final baseOtherStores = storeOptions.where((s) => s != lowestStore).toList();
    final List<StoreDealOption> displayOtherStores;
    if (baseOtherStores.isNotEmpty) {
      displayOtherStores = baseOtherStores;
    } else if (!isFinancialProduct && homeOffer == null && rawStorePrice > 0) {
      final sName = (lowestStore?.storeName.toLowerCase().contains('amazon') ?? false) ? 'Flipkart' : 'Amazon';
      final sPrice = ((lowestStore?.storePrice ?? rawStorePrice) * 1.08).roundToDouble();
      displayOtherStores = [
        StoreDealOption(
          storeName: sName,
          storePrice: sPrice,
          couponDiscount: 0.0,
          couponCode: '',
          cashbackRate: 5.0,
          badgeText: 'Verified Store',
          isBestDeal: false,
          targetUrl: ProductDetailScreen.resolveStoreUrl(sName),
          isOutOfStock: true,
        ),
      ];
    } else {
      displayOtherStores = [];
    }

    final int discountPercent = rawOriginalPrice > rawStorePrice
        ? (((rawOriginalPrice - rawStorePrice) / rawOriginalPrice) * 100).round()
        : (discountTag != null && discountTag.contains('%')
            ? (int.tryParse(RegExp(r'\d+').firstMatch(discountTag)?.group(0) ?? '0') ?? 0)
            : 0);

    final String resolvedOriginalUrl = widget.customOriginalUrl ??
        product?.originalUrl ??
        widget.customWebsiteUrl ??
        lowestStore?.targetUrl ??
        selectedStore?.targetUrl ??
        ProductDetailScreen.resolveStoreUrl(displayStoreName);

    final String? resolvedAffiliateUrl = widget.customAffiliateUrl ??
        product?.affiliateUrl;

    final textDark = isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A);
    final textMuted = isDark ? AppColors.darkTextSecondary : const Color(0xFF64748B);
    final primaryAccent = isDark ? const Color(0xFF2563EB) : AppColors.primaryBrown;
    final borderColor = isDark ? const Color(0xFF1E3A8A) : const Color(0xFFE2E8F0);
    final double activeStorePrice = lowestStore?.storePrice ?? rawStorePrice;
    final bool isLowestEligible = (lowestStore?.exactCashbackAmount != null && lowestStore!.exactCashbackAmount! > 0) ||
        (exactCustomCashback != null && exactCustomCashback > 0) ||
        activeStorePrice >= minSpendThreshold ||
        (bestDeal != null || trendingDeal != null || priceDrop != null || categoryDeal != null || amazonDeal != null || widget.customFinalPrice != null);
    final bool isLowestCouponActive = lowestStore != null ? _isCouponActiveForStore(lowestStore.storeName) : false;
    final double activeCouponSavings = (isLowestCouponActive && isLowestEligible)
        ? lowestStore.couponDiscount
        : 0.0;
    final double activePayNow = (activeStorePrice - activeCouponSavings).clamp(0.0, activeStorePrice);
    final double activeCashback = isLowestEligible
        ? (lowestStore?.exactCashbackAmount ?? (exactCustomCashback ?? (activePayNow * ((lowestStore?.cashbackRate ?? defaultCashbackRate) / 100)).roundToDouble()))
        : 0.0;
    final double activeEffectivePrice = (activePayNow - activeCashback).clamp(0.0, activePayNow);
    final String activeProductId = widget.productId ??
        product?.id.toString() ??
        bestDeal?.id ??
        trendingDeal?.id ??
        priceDrop?.id ??
        offerItem?.id.toString() ??
        widget.compareId ??
        '';
    final String activeImageUrl = imageList.isNotEmpty
        ? imageList.first
        : (widget.customImageUrl ?? '');

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.mainBackground,
      appBar: AppBar(
        title: Text(
          ProductDetailScreen.cleanTitle(title),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: textDark,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: primaryAccent,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: isDark ? AppColors.darkCard : AppColors.mainBackground,
        foregroundColor: textDark,
        elevation: 0,
        centerTitle: true,
      ),
      bottomNavigationBar: _buildBottomActionBar(
        context: context,
        isDark: isDark,
        title: title,
        displayStoreName: displayStoreName,
        resolvedOriginalUrl: resolvedOriginalUrl,
        resolvedAffiliateUrl: resolvedAffiliateUrl,
        storePrice: activeStorePrice,
        effectivePrice: activeEffectivePrice,
        cashbackAmount: activeCashback,
        productId: activeProductId,
        imageUrl: activeImageUrl,
      ),

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
        child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. PRODUCT / BRAND IMAGE CONTAINER WITH ROSETTE BADGE & DOTS
                  Container(
                    width: double.infinity,
                    height: 280,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkCard : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: borderColor,
                      ),
                    ),
                    child: imageList.isEmpty
                        ? Container(
                            color: isDark ? AppColors.darkSurface : AppColors.beigeSurface,
                            child: Center(
                              child: Icon(
                                Icons.storefront_rounded,
                                size: 80,
                                color: primaryAccent,
                              ),
                            ),
                          )
                        : Stack(
                            children: [
                              PageView.builder(
                                itemCount: imageList.length,
                                onPageChanged: (index) {
                                  setState(() {
                                    _currentImageIndex = index;
                                  });
                                },
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Center(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: NetworkImageWithSkeleton(
                                          imageUrl: imageList[index],
                                          fit: BoxFit.contain,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Container(
                                              color: isDark
                                                  ? AppColors.darkSurface
                                                  : AppColors.beigeSurface,
                                              child: const Center(
                                                child: Icon(
                                                  Icons.image_not_supported_outlined,
                                                  size: 64,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              if (discountPercent > 0)
                                Positioned(
                                  top: 12,
                                  right: 12,
                                  child: _buildRosetteDiscountBadge(discountPercent, isDark),
                                ),
                              if (imageList.length > 1)
                                Positioned(
                                  bottom: 12,
                                  left: 0,
                                  right: 0,
                                  child: _buildDotIndicators(imageList.length, _currentImageIndex, isDark),
                                ),
                            ],
                          ),
                  ),

                  // 2. PRODUCT TITLE
                  Padding(
                    padding: const EdgeInsets.only(top: 14, bottom: 6),
                    child: Text(
                      ProductDetailScreen.cleanTitle(title),
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: textDark,
                        height: 1.3,
                      ),
                    ),
                  ),

                  // BRAND / STORE TAG
                  if (displayStoreName.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: borderColor),
                            ),
                            child: Text(
                              displayStoreName.toUpperCase(),
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: primaryAccent,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          if (category.isNotEmpty) ...[
                            const SizedBox(width: 6),
                            Text(
                              '•  $category',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: textMuted,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],

                  // PROMINENT PRICE SUMMARY BLOCK (For non-promotional product deals)
                  if (homeOffer == null && activeStorePrice > 0) ...[
                    _buildProductPriceHeader(
                      effectivePrice: activeEffectivePrice,
                      storePrice: activeStorePrice,
                      rawOriginalPrice: rawOriginalPrice,
                      cashback: activeCashback,
                      discountPercent: discountPercent,
                      storeName: displayStoreName,
                      isDark: isDark,
                      primaryAccent: primaryAccent,
                      textDark: textDark,
                      textMuted: textMuted,
                      borderColor: borderColor,
                    ),
                    const SizedBox(height: 10),
                  ],

                  // 3. VARIANT SELECTOR (COLOUR)
                  if (homeOffer == null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Colour',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w500,
                              color: textMuted,
                            ),
                          ),
                          const SizedBox(height: 2),
                          InkWell(
                            onTap: () => _showColorSelectorModal(context, isDark),
                            borderRadius: BorderRadius.circular(6),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    _selectedColor,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: textDark,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Icon(
                                    Icons.arrow_drop_down,
                                    size: 20,
                                    color: primaryAccent,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // 4. ACTIVE STORE OFFER (for promotional offers) OR "LOWEST AT" SECTION (for products)
                  if (homeOffer != null) ...[
                    const SizedBox(height: 12),
                    _buildSectionHeaderBar('Active Store Offer', isDark),
                    _buildHomeOfferCampaignCard(context, homeOffer, isDark),
                  ] else ...[
                    if (lowestStore != null) ...[
                      const SizedBox(height: 12),
                      _buildSectionHeaderBar('Lowest At', isDark),
                      _buildLowestAtCard(
                        context: context,
                        store: lowestStore,
                        mrp: rawOriginalPrice > 0 ? rawOriginalPrice : (lowestStore.storePrice * 1.3),
                        fallbackCouponCode: couponCode,
                        storeDiscount: storeDiscount,
                        productTitle: title,
                        productImage: imageList.isNotEmpty ? imageList.first : '',
                        isDark: isDark,
                      ),
                    ],

                    // 5. "OTHER BUYING OPTIONS" SECTION BAR & CARDS
                    if (displayOtherStores.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      _buildSectionHeaderBar('Other Buying Options', isDark),
                      ...displayOtherStores.map((store) => _buildOtherOptionCard(
                        context: context,
                        store: store,
                        mrp: rawOriginalPrice > 0 ? rawOriginalPrice : (store.storePrice * 1.3),
                        isDark: isDark,
                      )),
                    ],
                  ],

                  // 6. EXPANDABLE ACCORDIONS
                  const SizedBox(height: 14),

                  // Key Features
                  _buildAccordionTile(
                    title: 'Key Features',
                    isExpanded: _isKeyFeaturesExpanded,
                    onToggle: () => setState(() => _isKeyFeaturesExpanded = !_isKeyFeaturesExpanded),
                    isDark: isDark,
                    content: _buildKeyFeaturesContent(
                      description: description,
                      brandName: brandName,
                      category: category,
                      stock: stock,
                      rating: rating,
                      displayStoreName: displayStoreName,
                      isCard: isCard,
                      isLoan: isLoan,
                      isDark: isDark,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Similar Products
                  _buildAccordionTile(
                    title: 'Similar Products',
                    isExpanded: _isSimilarExpanded,
                    onToggle: () => setState(() => _isSimilarExpanded = !_isSimilarExpanded),
                    isDark: isDark,
                    content: _buildSimilarProductsContent(context, category, isDark),
                  ),

                  const SizedBox(height: 8),

                  // Products You Might Like
                  _buildAccordionTile(
                    title: 'Products You Might Like',
                    isExpanded: _isYouMightLikeExpanded,
                    onToggle: () => setState(() => _isYouMightLikeExpanded = !_isYouMightLikeExpanded),
                    isDark: isDark,
                    content: _buildProductsYouMightLikeContent(context, isDark),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
  }

  Widget _buildProductPriceHeader({
    required double effectivePrice,
    required double storePrice,
    required double rawOriginalPrice,
    required double cashback,
    required int discountPercent,
    required String storeName,
    required bool isDark,
    required Color primaryAccent,
    required Color textDark,
    required Color textMuted,
    required Color borderColor,
  }) {
    final effectiveMrp = rawOriginalPrice > storePrice ? rawOriginalPrice : 0.0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Primary Line: Net Effective Price (Big & Bold) + "Effective Price" Badge
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '₹${effectivePrice.toInt()}',
                style: GoogleFonts.inter(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: primaryAccent,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF143823) : const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF059669).withValues(alpha: 0.4)
                        : const Color(0xFFA7F3D0),
                    width: 0.8,
                  ),
                ),
                child: Text(
                  'Effective Price',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    color: isDark ? const Color(0xFF34D399) : const Color(0xFF047857),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // 2. Secondary Line: Store Selling Price + MRP + Discount %
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 4,
            children: [
              Text(
                'Store Price: ₹${storePrice.toInt()} at $storeName',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: textDark,
                ),
              ),
              if (effectiveMrp > 0) ...[
                Text(
                  '₹${effectiveMrp.toInt()}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                    color: textMuted,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
              if (discountPercent > 0) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                  decoration: BoxDecoration(
                    color: AppColors.successBackground,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '$discountPercent% OFF',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w800,
                      color: AppColors.success,
                    ),
                  ),
                ),
              ],
            ],
          ),

          // 3. Cashback Pill
          if (cashback > 0) ...[
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E3A8A).withValues(alpha: 0.35) : const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isDark ? const Color(0xFF2563EB).withValues(alpha: 0.3) : const Color(0xFFBFDBFE),
                  width: 0.8,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.bolt_rounded,
                    size: 16,
                    color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF1D4ED8),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      '₹${cashback.toInt()} Extra Cashback credited to KashIQ Wallet',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: isDark ? const Color(0xFF93C5FD) : const Color(0xFF1D4ED8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildHomeOfferCampaignCard(
    BuildContext context,
    HomeOfferModel offer,
    bool isDark,
  ) {
    final textDark = isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A);
    final primaryAccent = isDark ? const Color(0xFF2563EB) : AppColors.primaryBrown;
    final borderColor = isDark ? const Color(0xFF1E3A8A) : const Color(0xFFE2E8F0);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildStoreLogoWidget(offer.store, isDark),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      offer.store,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: textDark,
                      ),
                    ),
                    if (offer.validity.isNotEmpty)
                      Text(
                        offer.validity,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFD97706),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Offer Badges
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              if (offer.discount.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    offer.discount,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              if (offer.cashback.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF143823) : const Color(0xFFECFDF5),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isDark ? const Color(0xFF059669) : const Color(0xFFA7F3D0),
                    ),
                  ),
                  child: Text(
                    '+ ${offer.cashback}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: isDark ? const Color(0xFF34D399) : const Color(0xFF047857),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // How Cashback Works
          Text(
            'How this Offer Works:',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: textDark,
            ),
          ),
          const SizedBox(height: 8),
          _buildCashbackStep('1', 'Tap "Shop on ${offer.store} with Cashback" below.', isDark),
          const SizedBox(height: 6),
          _buildCashbackStep('2', 'Browse & add items to cart. Complete your purchase on ${offer.store}.', isDark),
          const SizedBox(height: 6),
          _buildCashbackStep('3', 'Your cashback (${offer.cashback}) will be automatically tracked & credited to your KashIQ wallet.', isDark),
          const SizedBox(height: 16),

          // Big Grab Deal Button
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              onPressed: () => _handleShopNow(
                (offer.actionUrl.isNotEmpty && !offer.actionUrl.contains('KashIQ.com'))
                    ? offer.actionUrl
                    : ProductDetailScreen.resolveStoreUrl(offer.store),
                offer.store,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Shop on ${offer.store} with Cashback',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.arrow_forward_rounded, size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCashbackStep(String step, String text, bool isDark) {
    final primaryAccent = isDark ? const Color(0xFF2563EB) : AppColors.primaryBrown;
    final badgeTextColor = isDark ? const Color(0xFF0F172A) : Colors.white;
    final textMuted = isDark ? AppColors.darkTextSecondary : const Color(0xFF64748B);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            color: primaryAccent,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              step,
              style: TextStyle(
                color: badgeTextColor,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: textMuted,
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRosetteDiscountBadge(int percent, bool isDark) {
    final primaryAccent = isDark ? const Color(0xFF2563EB) : AppColors.primaryBrown;
    final badgeTextColor = isDark ? const Color(0xFF0F172A) : Colors.white;

    return Container(
      height: 28,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: primaryAccent, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: primaryAccent,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                Icons.percent_rounded,
                color: badgeTextColor,
                size: 14,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              '$percent% off',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: primaryAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDotIndicators(int count, int activeIndex, bool isDark) {
    final primaryAccent = isDark ? const Color(0xFF2563EB) : AppColors.primaryBrown;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == activeIndex;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: 6.5,
          height: 6.5,
          decoration: BoxDecoration(
            color: isActive
                ? primaryAccent
                : (isDark ? Colors.white24 : const Color(0xFFD8C5AF)),
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }

  Widget _buildSectionHeaderBar(String title, bool isDark) {
    final clean = ProductDetailScreen.cleanTitle(title);
    final primaryAccent = isDark ? const Color(0xFF2563EB) : AppColors.primaryBrown;
    final borderColor = isDark ? const Color(0xFF1E3A8A) : const Color(0xFFE2E8F0);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF132247) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: Text(
        clean,
        style: GoogleFonts.inter(
          fontSize: 13.5,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
          color: primaryAccent,
        ),
      ),
    );
  }

  Widget _buildStoreLogoWidget(String storeName, bool isDark) {
    final lower = storeName.toLowerCase();
    if (lower.contains('amazon')) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(
            'amazon',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 19,
              fontWeight: FontWeight.w900,
              color: isDark ? Colors.white : const Color(0xFF111827),
              letterSpacing: -0.5,
            ),
          ),
          Text(
            '.in',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF2563EB),
            ),
          ),
        ],
      );
    } else if (lower.contains('flipkart')) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Flipkart',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              fontStyle: FontStyle.italic,
              color: const Color(0xFF2563EB),
            ),
          ),
          const SizedBox(width: 4),
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: const Color(0xFFFFE500),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Icon(
              Icons.shopping_bag,
              size: 13,
              color: Color(0xFF2563EB),
            ),
          ),
        ],
      );
    } else if (lower.contains('myntra')) {
      return Text(
        'Myntra',
        style: GoogleFonts.plusJakartaSans(
          fontSize: 18,
          fontWeight: FontWeight.w900,
          color: const Color(0xFFE11D48),
        ),
      );
    } else if (lower.contains('ajio')) {
      return Text(
        'AJIO',
        style: GoogleFonts.plusJakartaSans(
          fontSize: 18,
          fontWeight: FontWeight.w900,
          color: isDark ? Colors.white : const Color(0xFF0F172A),
          letterSpacing: 1.5,
        ),
      );
    } else {
      return Text(
        storeName,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 17,
          fontWeight: FontWeight.w800,
          color: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
        ),
      );
    }
  }

  Widget _buildStoreCouponToggle({
    required String couponCode,
    required double couponDiscount,
    required bool isApplied,
    required bool isDark,
    required VoidCallback onToggle,
  }) {
    if (couponDiscount <= 0 && couponCode.isEmpty) {
      return const SizedBox.shrink();
    }

    final code = couponCode.isNotEmpty ? couponCode : 'COUPON';

    return GestureDetector(
      onTap: onToggle,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.only(left: 8, right: 3, top: 2, bottom: 2),
        decoration: BoxDecoration(
          color: isApplied
              ? (isDark ? const Color(0xFF14532D).withValues(alpha: 0.45) : const Color(0xFFDCFCE7))
              : (isDark ? Colors.white.withValues(alpha: 0.08) : const Color(0xFFF1F5F9)),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isApplied
                ? (isDark ? const Color(0xFF22C55E) : const Color(0xFF16A34A))
                : (isDark ? Colors.white24 : const Color(0xFFCBD5E1)),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.confirmation_num_outlined,
              size: 13,
              color: isApplied
                  ? (isDark ? const Color(0xFF86EFAC) : const Color(0xFF15803D))
                  : (isDark ? AppColors.darkTextSecondary : const Color(0xFF64748B)),
            ),
            const SizedBox(width: 4),
            Text(
              code,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: isApplied
                    ? (isDark ? const Color(0xFF86EFAC) : const Color(0xFF15803D))
                    : (isDark ? AppColors.darkTextPrimary : const Color(0xFF334155)),
              ),
            ),
            if (couponDiscount > 0) ...[
              const SizedBox(width: 4),
              Text(
                '(-₹${couponDiscount.toInt()})',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: isApplied
                      ? (isDark ? const Color(0xFF86EFAC) : const Color(0xFF16A34A))
                      : (isDark ? AppColors.darkTextMuted : const Color(0xFF64748B)),
                ),
              ),
            ],
            const SizedBox(width: 3),
            Transform.scale(
              scale: 0.6,
              child: CupertinoSwitch(
                value: isApplied,
                activeTrackColor: const Color(0xFF16A34A),
                onChanged: (_) => onToggle(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLowestAtCard({
    required BuildContext context,
    required StoreDealOption store,
    required double mrp,
    String fallbackCouponCode = '',
    double storeDiscount = 0.0,
    required String productTitle,
    required String productImage,
    required bool isDark,
  }) {
    final textDark = isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A);
    final textMuted = isDark ? AppColors.darkTextSecondary : const Color(0xFF64748B);
    final primaryAccent = isDark ? const Color(0xFF2563EB) : AppColors.primaryBrown;
    final borderColor = isDark ? const Color(0xFF1E3A8A) : const Color(0xFFE2E8F0);
    final surfaceBeige = isDark ? AppColors.darkSurface : const Color(0xFFF1F5F9);

    // Use real MRP only — don't inflate when unavailable
    final effectiveMrp = (mrp > store.storePrice ? mrp : store.storePrice).roundToDouble();
    final storeDiscountAmount = (effectiveMrp - store.storePrice).clamp(0.0, effectiveMrp);
    final storeDiscountPercent = effectiveMrp > 0 ? ((storeDiscountAmount / effectiveMrp) * 100).round() : 0;

    // Use real coupon only — don't fabricate when none exists
    final effectiveCouponDiscount = store.couponDiscount > 0 ? store.couponDiscount : 0.0;
    final effectiveCouponCode = store.couponCode.isNotEmpty
        ? store.couponCode
        : (fallbackCouponCode.isNotEmpty ? fallbackCouponCode : '');

    final isEligible = (store.exactCashbackAmount != null && store.exactCashbackAmount! > 0) ||
        store.storePrice >= minSpendThreshold ||
        (widget.bestDeal != null || widget.trendingDeal != null || widget.priceDrop != null || widget.categoryDeal != null || widget.amazonDeal != null || widget.customFinalPrice != null);
    final isCouponActive = _isCouponActiveForStore(store.storeName);
    final couponSavings = (isCouponActive && isEligible) ? effectiveCouponDiscount : 0.0;
    final payNow = (store.storePrice - couponSavings).clamp(0.0, store.storePrice);
    final cashback = isEligible
        ? (store.exactCashbackAmount ?? (payNow * (store.cashbackRate / 100)).roundToDouble())
        : 0.0;
    final effectivePrice = (payNow - cashback).clamp(0.0, payNow);


    final isReward = store.storeName.toLowerCase().contains('amazon');
    final cashbackTag = isReward
        ? 'After Rewards of ₹${cashback.toStringAsFixed(0)}'
        : 'After Cashback of ₹${cashback.toStringAsFixed(0)}';

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Store Header with Store Name & Toggleable Coupon Switch beside it!
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 7,
                  runSpacing: 5,
                  children: [
                    _buildStoreLogoWidget(store.storeName, isDark),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.successBackground,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Lowest',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w800,
                          color: AppColors.success,
                        ),
                      ),
                    ),
                    if (effectiveCouponDiscount > 0)
                      _buildStoreCouponToggle(
                        couponCode: effectiveCouponCode,
                        couponDiscount: effectiveCouponDiscount,
                        isApplied: isCouponActive,
                        isDark: isDark,
                        onToggle: () => _toggleCouponForStore(store.storeName),
                      ),
                  ],
                ),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(
                  Icons.info_outline_rounded,
                  size: 19,
                  color: textMuted,
                ),
                onPressed: () => _showStoreInfoModal(context, store.storeName, isDark),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Clean, Compact Price Breakdown (No verbose text, no unnecessary lines)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: primaryAccent.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                // Actual Price & % Off (only show if MRP > store price)
                if (storeDiscountPercent > 0) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Actual Price',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500,
                            color: textMuted,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                          decoration: BoxDecoration(
                            color: AppColors.successBackground,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '$storeDiscountPercent% OFF',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w800,
                              color: AppColors.success,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '₹${effectiveMrp.toInt()}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: textMuted,
                        decoration: TextDecoration.lineThrough,
                        decorationColor: textMuted,
                      ),
                    ),
                  ],
                ),
                ],

                // Coupon (only show if a real coupon exists)
                if (effectiveCouponDiscount > 0) ...[
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.confirmation_num_outlined,
                          size: 13,
                          color: isCouponActive ? const Color(0xFF2563EB) : textMuted,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Coupon ($effectiveCouponCode)',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: isCouponActive ? const Color(0xFF2563EB) : textMuted,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      isCouponActive ? '-₹${couponSavings.toInt()}' : 'Disabled',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: isCouponActive ? const Color(0xFF2563EB) : textMuted,
                      ),
                    ),
                  ],
                ),
                ],

                // You Pay
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'You Pay',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: textDark,
                      ),
                    ),
                    Text(
                      '₹${payNow.toInt()}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        color: textDark,
                      ),
                    ),
                  ],
                ),

                // Cashback
                if (cashback > 0) ...[
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.card_giftcard_rounded,
                            size: 13,
                            color: AppColors.success,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Cashback',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: AppColors.success,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '-₹${cashback.toInt()}',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                ],

                // Divider & Effective Price
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Divider(
                    height: 1,
                    thickness: 0.8,
                    color: borderColor,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Effective Price',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: primaryAccent,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '₹${effectivePrice.toInt()}',
                          style: GoogleFonts.inter(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: primaryAccent,
                          ),
                        ),
                        const SizedBox(width: 3),
                        Text(
                          'ONLY',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w800,
                            color: primaryAccent,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Price Display & Grab Deal Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '₹${effectivePrice.toInt()}',
                          style: GoogleFonts.inter(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: textDark,
                          ),
                        ),
                        const SizedBox(width: 7),
                        Text(
                          '₹${payNow.toInt()} at store',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: textMuted,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                          decoration: BoxDecoration(
                            color: surfaceBeige,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: borderColor, width: 0.8),
                          ),
                          child: Text(
                            cashbackTag,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              color: primaryAccent,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              OutlinedButton(
                onPressed: () => _showGrabDealSliderModal(
                  context: context,
                  store: store,
                  productTitle: productTitle,
                  productImage: productImage,
                  effectivePrice: effectivePrice,
                  cashbackTag: cashbackTag,
                  couponCode: effectiveCouponCode,
                  isDark: isDark,
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: primaryAccent, width: 1.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                  backgroundColor: primaryAccent.withValues(alpha: 0.08),
                ),
                child: Text(
                  'Grab Deal',
                  style: GoogleFonts.plusJakartaSans(
                    color: primaryAccent,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // View Full Breakdown
          InkWell(
            onTap: () => _showPriceBreakdownModal(
              context: context,
              storeName: store.storeName,
              isDark: isDark,
              mrp: effectiveMrp,
              storePrice: store.storePrice,
              couponDiscount: couponSavings,
              couponCode: effectiveCouponCode,
              cashbackAmount: cashback,
              cashbackRate: store.cashbackRate,
              effectivePrice: effectivePrice,
              targetUrl: store.targetUrl,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'View Breakdown',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: primaryAccent,
                    ),
                  ),
                  const SizedBox(width: 3),
                  Icon(
                    Icons.arrow_right_alt_rounded,
                    size: 18,
                    color: primaryAccent,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOtherOptionCard({
    required BuildContext context,
    required StoreDealOption store,
    required double mrp,
    required bool isDark,
  }) {
    final textDark = isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A);
    final textMuted = isDark ? AppColors.darkTextSecondary : const Color(0xFF64748B);
    final primaryAccent = isDark ? const Color(0xFF2563EB) : AppColors.primaryBrown;
    final borderColor = isDark ? const Color(0xFF1E3A8A) : const Color(0xFFE2E8F0);
    final surfaceBeige = isDark ? AppColors.darkSurface : const Color(0xFFF1F5F9);

    // Use real MRP only — don't inflate when unavailable
    final effectiveMrp = (mrp > store.storePrice ? mrp : store.storePrice).roundToDouble();
    final storeDiscountAmount = (effectiveMrp - store.storePrice).clamp(0.0, effectiveMrp);
    final storeDiscountPercent = effectiveMrp > 0 ? ((storeDiscountAmount / effectiveMrp) * 100).round() : 0;

    // Use real coupon only — don't fabricate when none exists
    final effectiveCouponDiscount = store.couponDiscount > 0 ? store.couponDiscount : 0.0;
    final effectiveCouponCode = store.couponCode.isNotEmpty
        ? store.couponCode
        : '';

    final isEligible = (store.exactCashbackAmount != null && store.exactCashbackAmount! > 0) ||
        store.storePrice >= minSpendThreshold ||
        (widget.bestDeal != null || widget.trendingDeal != null || widget.priceDrop != null || widget.categoryDeal != null || widget.amazonDeal != null || widget.customFinalPrice != null);
    final isCouponActive = _isCouponActiveForStore(store.storeName);
    final couponSavings = (isCouponActive && isEligible) ? effectiveCouponDiscount : 0.0;
    final payNow = (store.storePrice - couponSavings).clamp(0.0, store.storePrice);
    final cashback = isEligible
        ? (store.exactCashbackAmount ?? (payNow * (store.cashbackRate / 100)).roundToDouble())
        : 0.0;
    final effectivePrice = (payNow - cashback).clamp(0.0, payNow);


    final isReward = store.storeName.toLowerCase().contains('amazon');
    final cashbackTag = isReward
        ? 'After Rewards of ₹${cashback.toStringAsFixed(0)}'
        : 'After Cashback of ₹${cashback.toStringAsFixed(0)}';

    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Store Header with Store Name, Inactive Tag, and Toggleable Coupon Switch
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 7,
                  runSpacing: 5,
                  children: [
                    _buildStoreLogoWidget(store.storeName, isDark),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white10 : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Higher Price',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.darkTextMuted : const Color(0xFF64748B),
                        ),
                      ),
                    ),
                    if (effectiveCouponDiscount > 0)
                      _buildStoreCouponToggle(
                        couponCode: effectiveCouponCode,
                        couponDiscount: effectiveCouponDiscount,
                        isApplied: isCouponActive,
                        isDark: isDark,
                        onToggle: () => _toggleCouponForStore(store.storeName),
                      ),
                  ],
                ),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(
                  Icons.info_outline_rounded,
                  size: 19,
                  color: textMuted,
                ),
                onPressed: () => _showStoreInfoModal(context, store.storeName, isDark),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Clean, Compact Price Breakdown
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: primaryAccent.withValues(alpha: 0.15),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                // Actual Price & % Off (only show if MRP > store price)
                if (storeDiscountPercent > 0) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Actual Price',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500,
                            color: textMuted,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                          decoration: BoxDecoration(
                            color: AppColors.successBackground,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '$storeDiscountPercent% OFF',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w800,
                              color: AppColors.success,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '₹${effectiveMrp.toInt()}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: textMuted,
                        decoration: TextDecoration.lineThrough,
                        decorationColor: textMuted,
                      ),
                    ),
                  ],
                ),
                ],

                // Coupon (only show if a real coupon exists)
                if (effectiveCouponDiscount > 0) ...[
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.confirmation_num_outlined,
                          size: 13,
                          color: isCouponActive ? const Color(0xFF2563EB) : textMuted,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Coupon ($effectiveCouponCode)',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: isCouponActive ? const Color(0xFF2563EB) : textMuted,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      isCouponActive ? '-₹${couponSavings.toInt()}' : 'Disabled',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: isCouponActive ? const Color(0xFF2563EB) : textMuted,
                      ),
                    ),
                  ],
                ),
                ],

                // You Pay
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'You Pay',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: textDark,
                      ),
                    ),
                    Text(
                      '₹${payNow.toInt()}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        color: textDark,
                      ),
                    ),
                  ],
                ),

                // Cashback
                if (cashback > 0) ...[
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.card_giftcard_rounded,
                            size: 13,
                            color: AppColors.success,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Cashback',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: AppColors.success,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '-₹${cashback.toInt()}',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                ],

                // Divider & Effective Price
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Divider(
                    height: 1,
                    thickness: 0.8,
                    color: borderColor,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Effective Price',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: primaryAccent,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '₹${effectivePrice.toInt()}',
                          style: GoogleFonts.inter(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: primaryAccent,
                          ),
                        ),
                        const SizedBox(width: 3),
                        Text(
                          'ONLY',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w800,
                            color: primaryAccent,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Price Display & Disabled Button Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '₹${effectivePrice.toInt()}',
                          style: GoogleFonts.inter(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: textDark,
                          ),
                        ),
                        const SizedBox(width: 7),
                        Text(
                          '₹${payNow.toInt()} at store',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: textMuted,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                          decoration: BoxDecoration(
                            color: surfaceBeige,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: borderColor, width: 0.8),
                          ),
                          child: Text(
                            cashbackTag,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              color: primaryAccent,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Disabled Grab Deal button
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white10 : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isDark ? Colors.white12 : const Color(0xFFCBD5E1),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.lock_outline_rounded,
                      size: 13,
                      color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Higher Price',
                      style: GoogleFonts.plusJakartaSans(
                        color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // View Full Breakdown
          InkWell(
            onTap: () => _showPriceBreakdownModal(
              context: context,
              storeName: store.storeName,
              isDark: isDark,
              mrp: effectiveMrp,
              storePrice: store.storePrice,
              couponDiscount: couponSavings,
              couponCode: effectiveCouponCode,
              cashbackAmount: cashback,
              cashbackRate: store.cashbackRate,
              effectivePrice: effectivePrice,
              targetUrl: store.targetUrl,
              isStoreAvailable: false,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'View Breakdown',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: primaryAccent,
                    ),
                  ),
                  const SizedBox(width: 3),
                  Icon(
                    Icons.arrow_right_alt_rounded,
                    size: 18,
                    color: primaryAccent,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showColorSelectorModal(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkBorder : const Color(0xFFCBD5E1),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Select Colour',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
                  ),
                ),
                const SizedBox(height: 12),
                ..._availableColors.map((col) {
                  final isSelected = _selectedColor == col;
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _getColorValue(col),
                        border: Border.all(color: Colors.grey.shade400),
                      ),
                    ),
                    title: Text(
                      col,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14.5,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected
                            ? (isDark ? AppColors.darkPrimary : AppColors.primaryBrown)
                            : (isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A)),
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check_circle_rounded, color: AppColors.primaryBrown, size: 20)
                        : null,
                    onTap: () {
                      setState(() {
                        _selectedColor = col;
                      });
                      Navigator.pop(ctx);
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getColorValue(String name) {
    switch (name.toLowerCase()) {
      case 'blue':
        return const Color(0xFF1E3A8A);
      case 'black':
        return Colors.black;
      case 'olive':
        return const Color(0xFF556B2F);
      case 'navy':
        return const Color(0xFF0F172A);
      case 'white':
        return Colors.white;
      case 'red':
        return const Color(0xFFDC2626);
      default:
        return Colors.grey;
    }
  }

  void _showStoreInfoModal(BuildContext context, String storeName, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkBorder : const Color(0xFFD8C5AF),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$storeName Cashback Policy',
                      style: GoogleFonts.inter(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, size: 20),
                      onPressed: () => Navigator.pop(ctx),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                _buildInfoRow(Icons.timer_outlined, 'Tracking Speed', 'Cashback is tracked within 24 to 48 hours of order confirmation.', isDark),
                const SizedBox(height: 10),
                _buildInfoRow(Icons.verified_outlined, 'Confirmation Period', 'Confirmed within 60 to 90 days after return window expires.', isDark),
                const SizedBox(height: 10),
                _buildInfoRow(Icons.cancel_outlined, 'Cancellations / Returns', 'Cashback will be void if the order is returned or cancelled.', isDark),
                const SizedBox(height: 10),
                _buildInfoRow(Icons.account_balance_wallet_outlined, 'Payout', 'Transfer directly to your Bank Account or UPI once confirmed.', isDark),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String subtitle, bool isDark) {
    final primaryAccent = isDark ? const Color(0xFF2563EB) : AppColors.primaryBrown;
    final textDark = isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A);
    final textMuted = isDark ? AppColors.darkTextSecondary : const Color(0xFF64748B);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: primaryAccent),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: textDark,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11.5,
                  color: textMuted,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showPriceBreakdownModal({
    required BuildContext context,
    required String storeName,
    required bool isDark,
    required double mrp,
    required double storePrice,
    required double couponDiscount,
    required String couponCode,
    required double cashbackAmount,
    required double cashbackRate,
    required double effectivePrice,
    required String targetUrl,
    bool isStoreAvailable = true,
  }) {
    final textDark = isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A);
    final textMuted = isDark ? AppColors.darkTextSecondary : const Color(0xFF64748B);
    final primaryAccent = isDark ? const Color(0xFF2563EB) : AppColors.primaryBrown;
    final borderColor = isDark ? const Color(0xFF1E3A8A) : const Color(0xFFE2E8F0);
    final surfaceBeige = isDark ? AppColors.darkSurface : const Color(0xFFF1F5F9);
    final buttonTextColor = isDark ? const Color(0xFF0F172A) : Colors.white;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (modalContext, setModalState) {
            final isEligible = (cashbackAmount > 0) ||
                storePrice >= minSpendThreshold ||
                (widget.bestDeal != null || widget.trendingDeal != null || widget.priceDrop != null || widget.categoryDeal != null || widget.amazonDeal != null || widget.customFinalPrice != null);
            final isCouponActive = _isCouponActiveForStore(storeName);
            final currentCoupon = (isCouponActive && isEligible && couponDiscount > 0)
                ? couponDiscount
                : 0.0;
            final payNow = (storePrice - currentCoupon).clamp(0.0, storePrice);
            final currentCashback = isEligible
                ? (cashbackAmount > 0
                    ? cashbackAmount
                    : (payNow * (cashbackRate / 100)).roundToDouble())
                : 0.0;
            final currentEffective = (payNow - currentCashback).clamp(0.0, payNow);
            final currentSavings = (mrp - currentEffective).clamp(0.0, double.infinity);
            final storeDiscount = mrp > storePrice ? mrp - storePrice : 0.0;

            return Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkBorder : const Color(0xFFD8C5AF),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Price Breakdown',
                                style: GoogleFonts.inter(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
                                ),
                              ),
                              Text(
                                'Verified live on $storeName',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11.5,
                                  color: textMuted,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.close_rounded, size: 22),
                            onPressed: () => Navigator.pop(ctx),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      if (couponDiscount > 0) ...[
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isCouponActive
                                ? primaryAccent.withValues(alpha: isDark ? 0.2 : 0.08)
                                : surfaceBeige,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isCouponActive ? primaryAccent : borderColor,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.local_offer_rounded,
                                size: 20,
                                color: isCouponActive ? primaryAccent : textMuted,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Code: $couponCode',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700,
                                            color: textDark,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                                          decoration: BoxDecoration(
                                            color: AppColors.successBackground,
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            'Save ₹${couponDiscount.toInt()}',
                                            style: GoogleFonts.plusJakartaSans(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.success,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      isCouponActive ? 'Coupon applied to effective price' : 'Tap switch to apply coupon',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 11,
                                        color: textMuted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Switch.adaptive(
                                value: isCouponActive,
                                activeThumbColor: primaryAccent,
                                onChanged: (val) {
                                  setModalState(() {
                                    _storeCouponApplied[storeName] = val;
                                    _isCouponApplied = val;
                                  });
                                  setState(() {});
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: surfaceBeige,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: borderColor),
                        ),
                        child: Column(
                          children: [
                            _buildBreakdownRow('Maximum Retail Price (MRP)', '₹${mrp.toStringAsFixed(0)}', false, isDark),
                            if (storeDiscount > 0) ...[
                              const SizedBox(height: 8),
                              _buildBreakdownRow('$storeName Discount', '- ₹${storeDiscount.toStringAsFixed(0)}', true, isDark),
                            ],
                            const SizedBox(height: 8),
                            _buildBreakdownRow('$storeName Listed Price', '₹${storePrice.toStringAsFixed(0)}', false, isDark, isBold: true),
                            if (currentCoupon > 0) ...[
                              const SizedBox(height: 8),
                              _buildBreakdownRow('Coupon Discount ($couponCode)', '- ₹${currentCoupon.toStringAsFixed(0)}', true, isDark),
                            ],
                            const SizedBox(height: 9),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFEFF6FF),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isDark ? const Color(0xFF3B82F6).withValues(alpha: 0.4) : const Color(0xFF93C5FD),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.shopping_bag_outlined,
                                        size: 14,
                                        color: Color(0xFF2563EB),
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        'You Pay at $storeName:',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.w800,
                                          color: isDark ? const Color(0xFF93C5FD) : const Color(0xFF1D4ED8),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '₹${payNow.toStringAsFixed(0)}',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                      color: isDark ? const Color(0xFF93C5FD) : const Color(0xFF1D4ED8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (currentCashback > 0) ...[
                              const SizedBox(height: 9),
                              _buildBreakdownRow('KashIQ Extra Cashback / Rewards', '- ₹${currentCashback.toStringAsFixed(0)}', true, isDark),
                            ],
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Divider(height: 1, color: borderColor),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Effective Net Price',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                        color: textDark,
                                      ),
                                    ),
                                    Text(
                                      'Total Savings: ₹${currentSavings.toStringAsFixed(1)}',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.success,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  '₹${currentEffective.toStringAsFixed(1)}',
                                  style: GoogleFonts.inter(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.success,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),

                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: isStoreAvailable
                            ? ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(ctx);
                                  _handleShopNow(targetUrl, storeName);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryAccent,
                                  foregroundColor: buttonTextColor,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  elevation: 0,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Grab Deal on ${storeName.toUpperCase()}',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Icon(Icons.arrow_forward_rounded, size: 16, color: buttonTextColor),
                                  ],
                                ),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  color: isDark ? const Color(0xFF262626) : const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isDark ? Colors.white12 : borderColor,
                                    width: 1,
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'Currently Out Of Stock on ${storeName.toUpperCase()}',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w700,
                                    color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBreakdownRow(String label, String value, bool isNegative, bool isDark, {bool isBold = false}) {
    final textDark = isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A);
    final textMuted = isDark ? AppColors.darkTextSecondary : const Color(0xFF64748B);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12.5,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
            color: isBold ? textDark : textMuted,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
            color: isNegative ? AppColors.success : textDark,
          ),
        ),
      ],
    );
  }

  Widget _buildAccordionTile({
    required String title,
    required bool isExpanded,
    required VoidCallback onToggle,
    required bool isDark,
    required Widget content,
    double titleFontSize = 16.5,
    FontWeight titleFontWeight = FontWeight.w800,
  }) {
    final clean = ProductDetailScreen.cleanTitle(title);
    final textDark = isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A);
    final textMuted = isDark ? AppColors.darkTextSecondary : const Color(0xFF64748B);
    final borderColor = isDark ? const Color(0xFF1E3A8A) : const Color(0xFFE2E8F0);

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: onToggle,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    clean,
                    style: GoogleFonts.inter(
                      fontSize: titleFontSize,
                      fontWeight: titleFontWeight,
                      color: textDark,
                    ),
                  ),
                  Icon(
                    isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                    color: textMuted,
                    size: 22,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded) ...[
            Divider(
              height: 1,
              color: borderColor,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: content,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildKeyFeaturesContent({
    required String description,
    required String brandName,
    required String category,
    required int? stock,
    double? rating,
    required String displayStoreName,
    required bool isCard,
    required bool isLoan,
    required bool isDark,
  }) {
    final textDark = isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A);
    final textMuted = isDark ? AppColors.darkTextSecondary : const Color(0xFF64748B);
    final borderColor = isDark ? const Color(0xFF1E3A8A) : const Color(0xFFE2E8F0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (brandName.isNotEmpty) _buildSpecRow('Brand', brandName, isDark),
        if (rating != null) ...[
          const SizedBox(height: 6),
          _buildSpecRow('Rating', '${rating.toStringAsFixed(1)} ★', isDark),
        ],
        if (category.isNotEmpty) ...[
          const SizedBox(height: 6),
          _buildSpecRow('Category', category, isDark),
        ],
        const SizedBox(height: 6),
        _buildSpecRow('Condition', '100% Original & Brand New', isDark),
        if (stock != null) ...[
          const SizedBox(height: 6),
          _buildSpecRow('Stock', '$stock units available', isDark),
        ],
        const SizedBox(height: 12),
        Divider(color: borderColor),
        const SizedBox(height: 10),
        Text(
          'Product Overview',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: textDark,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          description,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12.5,
            color: textMuted,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 14),
        Divider(color: borderColor),
        const SizedBox(height: 10),
        Text(
          'How to Earn Cashback:',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: textDark,
          ),
        ),
        const SizedBox(height: 8),
        _buildCashbackStep('1', 'Tap "Grab Deal" to visit $displayStoreName', isDark),
        const SizedBox(height: 6),
        _buildCashbackStep('2', 'Place your order normally on their website/app', isDark),
        const SizedBox(height: 6),
        _buildCashbackStep('3', 'Cashback is tracked within 24-48 hrs & ready to withdraw', isDark),
      ],
    );
  }

  Widget _buildSpecRow(String label, String value, bool isDark) {
    final textDark = isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A);
    final textMuted = isDark ? AppColors.darkTextSecondary : const Color(0xFF64748B);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            color: textMuted,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: textDark,
          ),
        ),
      ],
    );
  }

  Widget _buildSimilarProductsContent(BuildContext context, String currentCategory, bool isDark) {
    final homeProvider = context.watch<HomeProvider>();
    final allDeals = homeProvider.bestDeals;
    final textMuted = isDark ? AppColors.darkTextSecondary : const Color(0xFF64748B);

    // Smart category matching: filter products matching the current product's category
    final cleanCategory = currentCategory.trim().toLowerCase();
    final matchingDeals = cleanCategory.isNotEmpty
        ? allDeals.where((d) =>
            d.category.trim().toLowerCase() == cleanCategory ||
            d.category.toLowerCase().contains(cleanCategory) ||
            cleanCategory.contains(d.category.toLowerCase())
          ).toList()
        : <BestDealModel>[];

    final deals = matchingDeals.isNotEmpty ? matchingDeals : allDeals;

    if (deals.isEmpty) {
      return Text(
        'No similar deals found at the moment.',
        style: GoogleFonts.plusJakartaSans(
          fontSize: 12,
          color: textMuted,
        ),
      );
    }

    return SizedBox(
      height: 180,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: deals.length > 8 ? 8 : deals.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (ctx, index) {
          final deal = deals[index];
          return _buildMiniDealCard(
            title: deal.title,
            imageUrl: deal.imageUrl,
            price: deal.discountedPrice,
            cashbackText: '₹${deal.cashbackAmount.toInt()} Cashback',
            isDark: isDark,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProductDetailScreen.fromBestDeal(deal),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildProductsYouMightLikeContent(BuildContext context, bool isDark) {
    final homeProvider = context.watch<HomeProvider>();
    final deals = homeProvider.trendingDeals;
    final textMuted = isDark ? AppColors.darkTextSecondary : const Color(0xFF64748B);

    if (deals.isEmpty) {
      return Text(
        'Discovering personalized recommendations for you...',
        style: GoogleFonts.plusJakartaSans(
          fontSize: 12,
          color: textMuted,
        ),
      );
    }

    return SizedBox(
      height: 180,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: deals.length > 8 ? 8 : deals.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (ctx, index) {
          final deal = deals[index];
          return _buildMiniDealCard(
            title: deal.productName,
            imageUrl: deal.imageUrl,
            price: deal.price,
            cashbackText: deal.cashback.isNotEmpty ? deal.cashback : '₹${deal.cashbackAmount.toInt()} Cashback',
            isDark: isDark,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProductDetailScreen.fromTrendingDeal(deal),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildMiniDealCard({
    required String title,
    required String imageUrl,
    required double price,
    required String cashbackText,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    final textDark = isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A);
    final borderColor = isDark ? const Color(0xFF1E3A8A) : const Color(0xFFE2E8F0);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 130,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: borderColor,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: NetworkImageWithSkeleton(
                    imageUrl: imageUrl,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              ProductDetailScreen.cleanTitle(title),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: textDark,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '₹${price.toInt()}',
              style: GoogleFonts.inter(
                fontSize: 12.5,
                fontWeight: FontWeight.w800,
                color: textDark,
              ),
            ),
            const SizedBox(height: 2),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
              decoration: BoxDecoration(
                color: AppColors.successBackground,
                borderRadius: BorderRadius.circular(3),
              ),
              child: Text(
                cashbackText,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: AppColors.success,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showGrabDealSliderModal({
    required BuildContext context,
    required StoreDealOption store,
    required String productTitle,
    required String productImage,
    required double effectivePrice,
    required String cashbackTag,
    required String couponCode,
    required bool isDark,
  }) {
    final textDark = isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A);
    final primaryAccent = isDark ? const Color(0xFF2563EB) : AppColors.primaryBrown;
    final borderColor = isDark ? const Color(0xFF1E3A8A) : const Color(0xFFE2E8F0);
    final surfaceBeige = isDark ? AppColors.darkSurface : const Color(0xFFF1F5F9);
    final buttonTextColor = isDark ? const Color(0xFF0F172A) : Colors.white;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 16,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkBorder : const Color(0xFFD8C5AF),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildStoreLogoWidget(store.storeName, isDark),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                          decoration: BoxDecoration(
                            color: AppColors.successBackground,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            'Verified Partner',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.success,
                            ),
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, size: 22),
                      onPressed: () => Navigator.pop(ctx),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: surfaceBeige,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: borderColor,
                    ),
                  ),
                  child: Row(
                    children: [
                      if (productImage.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: SizedBox(
                            width: 52,
                            height: 52,
                            child: NetworkImageWithSkeleton(
                              imageUrl: productImage,
                              fit: BoxFit.contain,
                            ),
                          ),
                        )
                      else
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkCard : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.shopping_bag_outlined, size: 28),
                        ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ProductDetailScreen.cleanTitle(productTitle),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: textDark,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Row(
                              children: [
                                Text(
                                  '₹${effectivePrice.toStringAsFixed(1)}',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: primaryAccent,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Flexible(
                                  child: Text(
                                    cashbackTag,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.success,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: surfaceBeige,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: borderColor,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.radar_rounded, size: 18, color: primaryAccent),
                          const SizedBox(width: 6),
                          Text(
                            'KashIQ Auto-Tracking Enabled',
                            style: GoogleFonts.inter(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      _buildTrackingStepItem(
                        '1',
                        'We will safely redirect you to ${store.storeName}',
                        isDark,
                      ),
                      const SizedBox(height: 6),
                      _buildTrackingStepItem(
                        '2',
                        'Complete your purchase normally on their official site/app',
                        isDark,
                      ),
                      const SizedBox(height: 6),
                      _buildTrackingStepItem(
                        '3',
                        'Cashback is tracked within 24-48 hrs & added to your KashIQ wallet',
                        isDark,
                      ),
                    ],
                  ),
                ),
                if (couponCode.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.pendingBackground,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.content_copy_rounded, size: 16, color: AppColors.warning),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Coupon code "$couponCode" will be copied automatically!',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: AppColors.warning,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(ctx);
                      if (couponCode.isNotEmpty) {
                        await Clipboard.setData(ClipboardData(text: couponCode));
                      }
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              couponCode.isNotEmpty
                                  ? 'Coupon $couponCode copied! Redirecting to ${store.storeName}...'
                                  : 'Redirecting to ${store.storeName}... Cashback tracking active!',
                            ),
                            backgroundColor: AppColors.primaryBrown,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                      await _handleShopNow(store.targetUrl, store.storeName);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryAccent,
                      foregroundColor: buttonTextColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.launch_rounded, size: 18, color: buttonTextColor),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            'Visit ${store.storeName.toUpperCase()} & Track Deal',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.2,
                              color: buttonTextColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Icon(Icons.arrow_forward_rounded, size: 16, color: buttonTextColor),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTrackingStepItem(String number, String title, bool isDark) {
    final primaryAccent = isDark ? const Color(0xFF2563EB) : AppColors.primaryBrown;
    final badgeTextColor = isDark ? const Color(0xFF0F172A) : Colors.white;
    final textMuted = isDark ? AppColors.darkTextSecondary : const Color(0xFF64748B);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 17,
          height: 17,
          decoration: BoxDecoration(
            color: primaryAccent,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyle(
                color: badgeTextColor,
                fontSize: 9.5,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
              color: textMuted,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }

}
