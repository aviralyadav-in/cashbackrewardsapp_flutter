import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/home_provider.dart';
import 'all_best_deals_screen.dart';
import 'best_deals_search_screen.dart';
import 'product_detail_screen.dart';
import 'store_detail_screen.dart';



/// Data model for products in the "Best Product Deals" 2-column grid section.
class _BestProductDealItem {
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

  const _BestProductDealItem({
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
}

/// Data model for Top Deals across different categories in "Top Deals For You"
class _TopDealCategoryItem {
  final String id;
  final String category;
  final String categoryEmoji;
  final String rankBadge;
  final String title;
  final String brand;
  final String store;
  final String imageUrl;
  final double currentPrice;
  final double originalPrice;
  final double discountPercentage;
  final double cashbackAmount;
  final double effectivePrice;
  final String savingsHighlight;
  final String description;
  final String websiteUrl;

  const _TopDealCategoryItem({
    required this.id,
    required this.category,
    required this.categoryEmoji,
    required this.rankBadge,
    required this.title,
    required this.brand,
    required this.store,
    required this.imageUrl,
    required this.currentPrice,
    required this.originalPrice,
    required this.discountPercentage,
    required this.cashbackAmount,
    required this.effectivePrice,
    required this.savingsHighlight,
    required this.description,
    required this.websiteUrl,
  });
}

/// Data model for Section: Highest Cashback Deals (Product/Deal-level cashback discovery)
class _HighestCashbackDealItem {
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

  const _HighestCashbackDealItem({
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
}

/// Data model for Hotel Deals
class _HotelDealItem {
  final String title;
  final String cashbackText;
  final String discountTag;
  final String imageUrl;
  final String location;

  const _HotelDealItem({
    required this.title,
    required this.cashbackText,
    required this.discountTag,
    required this.imageUrl,
    this.location = 'Domestic & International',
  });
}

/// Data model for Section: Flash Deals / Ending Soon
class _FlashDealItem {
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

  const _FlashDealItem({
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
}

/// Data model for Section: Banking & Financial Deals
class _BankOfferItem {
  final String title;
  final String subtitle;
  final String statusText;
  final IconData icon;
  final String buttonText;
  final bool isDarkIcon;

  const _BankOfferItem({
    required this.title,
    required this.subtitle,
    required this.statusText,
    required this.icon,
    required this.buttonText,
    this.isDarkIcon = false,
  });
}

/// Data model for Section: Biggest Discounts
class _BiggestDiscountItem {
  final String id;
  final String title;
  final String brand;
  final String store;
  final String imageUrl;
  final double currentPrice;
  final double originalPrice;
  final double discountPercentage;
  final double cashbackAmount;

  const _BiggestDiscountItem({
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
}

/// Data model for Section: Best Store Deals
class _BestStoreDealItem {
  final String name;
  final String avatarText;
  final String cashbackRate;
  final String activeOffers;
  final String websiteUrl;

  const _BestStoreDealItem({
    required this.name,
    required this.avatarText,
    required this.cashbackRate,
    required this.activeOffers,
    required this.websiteUrl,
  });
}

/// Data model for Section: Price Drops
class _PriceDropItem {
  final String id;
  final String title;
  final String brand;
  final String store;
  final String imageUrl;
  final double wasPrice;
  final double nowPrice;
  final double dropAmount;

  const _PriceDropItem({
    required this.id,
    required this.title,
    required this.brand,
    required this.store,
    required this.imageUrl,
    required this.wasPrice,
    required this.nowPrice,
    required this.dropAmount,
  });
}

/// Data model for Section: Deals You May Like (Pill Recommendations)
class _RecommendationPillItem {
  final String title;
  final String subtitle;
  final IconData icon;

  const _RecommendationPillItem({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}

/// BestDealsScreen: Redesigned matching reference image with 12 curated sections.
class BestDealsScreen extends StatefulWidget {
  static const String routeName = '/best-deals';
  final VoidCallback? onBack;

  const BestDealsScreen({super.key, this.onBack});

  @override
  State<BestDealsScreen> createState() => _BestDealsScreenState();
}

class _BestDealsScreenState extends State<BestDealsScreen> {




  // 1.5 Section: Top Deals For You - Cross-Category Top Deals
  static const List<_TopDealCategoryItem> _topCategoryDeals = [
    _TopDealCategoryItem(
      id: 'td-sony-xm5',
      category: 'Audio',
      categoryEmoji: '🏆',
      rankBadge: '#1 Top Overall Value',
      title: 'Sony WH-1000XM5 Premium Noise Canceling',
      brand: 'Sony',
      store: 'Amazon',
      imageUrl: 'assets/banners/headphone_3d.jpg',
      currentPrice: 24990,
      originalPrice: 34990,
      discountPercentage: 28,
      cashbackAmount: 1500,
      effectivePrice: 23490,
      savingsHighlight: 'Stacked Savings: Save ₹11,500 Total',
      description:
          'Industry-leading noise canceling with two processors and 8 microphones. Up to 30-hour battery life with quick charging.',
      websiteUrl: 'https://www.amazon.in',
    ),
    _TopDealCategoryItem(
      id: 'td-iphone-15',
      category: 'Smartphones',
      categoryEmoji: '📱',
      rankBadge: '#1 in Smartphones',
      title: 'Apple iPhone 15 (128GB, Midnight)',
      brand: 'Apple',
      store: 'Flipkart',
      imageUrl: 'assets/banners/phone_banner_16_9.jpg',
      currentPrice: 70999,
      originalPrice: 79900,
      discountPercentage: 11,
      cashbackAmount: 2500,
      effectivePrice: 68499,
      savingsHighlight: 'Stacked Savings: Save ₹11,401 Total',
      description:
          'Dynamic Island, 48MP Main camera, and USB-C in a durable color-infused glass and aluminum design.',
      websiteUrl: 'https://www.flipkart.com',
    ),
    _TopDealCategoryItem(
      id: 'td-macbook-air',
      category: 'Laptops',
      categoryEmoji: '💻',
      rankBadge: '#1 in Laptops',
      title: 'Apple MacBook Air M2 (256GB SSD)',
      brand: 'Apple',
      store: 'Amazon',
      imageUrl: 'assets/cards/dell.jpg',
      currentPrice: 84990,
      originalPrice: 99900,
      discountPercentage: 15,
      cashbackAmount: 4250,
      effectivePrice: 80740,
      savingsHighlight: 'Stacked Savings: Save ₹19,160 Total',
      description:
          'Strikingly thin design with M2 chip, 13.6-inch Liquid Retina display, and up to 18 hours of battery life.',
      websiteUrl: 'https://www.amazon.in',
    ),
    _TopDealCategoryItem(
      id: 'td-nike-270',
      category: 'Footwear',
      categoryEmoji: '👟',
      rankBadge: '#1 in Footwear',
      title: 'Nike Air Max 270 Running Shoes',
      brand: 'Nike',
      store: 'Myntra',
      imageUrl: 'assets/banners/nike_airmax_red.jpg',
      currentPrice: 4155,
      originalPrice: 5999,
      discountPercentage: 31,
      cashbackAmount: 415,
      effectivePrice: 3740,
      savingsHighlight: 'Stacked Savings: Save ₹2,259 Total',
      description:
          "Nike's first lifestyle Air unit brings energy to every step with super-soft foam cushioning.",
      websiteUrl: 'https://www.myntra.com',
    ),
    _TopDealCategoryItem(
      id: 'td-dyson-v12',
      category: 'Appliances',
      categoryEmoji: '🏠',
      rankBadge: '#1 in Appliances',
      title: 'Dyson V12 Detect Slim Vacuum',
      brand: 'Dyson',
      store: 'Tata CLiQ',
      imageUrl: 'assets/banners/reliance_tech_3d.jpg',
      currentPrice: 42900,
      originalPrice: 55900,
      discountPercentage: 23,
      cashbackAmount: 3500,
      effectivePrice: 39400,
      savingsHighlight: 'Stacked Savings: Save ₹16,500 Total',
      description:
          'Laser reveals microscopic dust. Intelligently optimizes suction and run time with Piezo sensor.',
      websiteUrl: 'https://www.tatacliq.com',
    ),
    _TopDealCategoryItem(
      id: 'td-noise-pro5',
      category: 'Wearables',
      categoryEmoji: '⌚',
      rankBadge: '#1 in Wearables',
      title: 'Noise ColorFit Pro 5 Smartwatch',
      brand: 'Noise',
      store: 'Amazon',
      imageUrl: 'assets/banners/watch_3d.jpg',
      currentPrice: 2499,
      originalPrice: 6499,
      discountPercentage: 62,
      cashbackAmount: 180,
      effectivePrice: 2319,
      savingsHighlight: 'Stacked Savings: Save ₹4,180 Total',
      description:
          '1.85-inch AMOLED display, BT calling, SOS connectivity, and comprehensive health tracking suite.',
      websiteUrl: 'https://www.amazon.in',
    ),
  ];

  // 2. Section: Highest Cashback Deals (Product/Deal-level cashback discovery)
  static const List<_HighestCashbackDealItem> _highestCashbackDeals = [
    _HighestCashbackDealItem(
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
    _HighestCashbackDealItem(
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
    _HighestCashbackDealItem(
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
  ];

  // 3. Section: Best Product Deals (4 items from image)
  static const List<_BestProductDealItem> _bestProductDeals = [
    _BestProductDealItem(
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
    _BestProductDealItem(
      id: 'bpd-noise-pro5',
      title: 'Noise ColorFit Pro 5 Smartwatch',
      brand: 'NOISE',
      store: 'Amazon',
      imageUrl: 'assets/banners/watch_3d.jpg',
      currentPrice: 2499,
      originalPrice: 6499,
      discountPercentage: 62,
      cashbackAmount: 180,
      websiteUrl: 'https://www.amazon.in',
    ),
    _BestProductDealItem(
      id: 'bpd-nike-pegasus',
      title: 'Nike Air Zoom Pegasus 40',
      brand: 'OFFSHORE',
      store: 'Myntra',
      imageUrl: 'assets/banners/nike_airmax_red.jpg',
      currentPrice: 6190,
      originalPrice: 10995,
      discountPercentage: 45,
      cashbackAmount: 350,
      websiteUrl: 'https://www.myntra.com',
    ),
    _BestProductDealItem(
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
  ];

  // 4. Section: Hotels & Stays
  static const List<_HotelDealItem> _hotelDeals = [
    _HotelDealItem(
      title: 'The Grand Palace Resort & Spa',
      cashbackText: '+ ₹1,200 Cashback',
      discountTag: '15% OFF',
      imageUrl: 'assets/cards/col_travel.jpg',
      location: 'Udaipur, Rajasthan',
    ),
    _HotelDealItem(
      title: 'Heritage Haveli Stay',
      cashbackText: '+ ₹1,100 Cashback',
      discountTag: '10% OFF',
      imageUrl: 'assets/cards/col_travel.jpg',
      location: 'Jaipur, Rajasthan',
    ),
  ];

  // 5. Section: Flash Deals / Ending Soon
  static const List<_FlashDealItem> _flashDeals = [
    _FlashDealItem(
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
    _FlashDealItem(
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
  ];

  // 6. Section: Banking & Financial Deals
  static const List<_BankOfferItem> _bankOffers = [
    _BankOfferItem(
      title: 'HDFC Regalia Gold Credit Card',
      subtitle:
          'Flat ₹2,500 Amazon Gift Voucher + 4 complimentary lounge visits',
      statusText: 'Instant Digital Approval',
      icon: Icons.credit_card_rounded,
      buttonText: 'Explore Card',
      isDarkIcon: true,
    ),
    _BankOfferItem(
      title: 'Tata AIA Term Life Insurance',
      subtitle: 'Zero Processing Fee with ₹1,500 Cashback on Policy',
      statusText: 'Guaranteed Cashback Credit',
      icon: Icons.shield_outlined,
      buttonText: 'Get Plan',
      isDarkIcon: false,
    ),
  ];

  // 7. Section: Biggest Discounts
  static const List<_BiggestDiscountItem> _biggestDiscounts = [
    _BiggestDiscountItem(
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
    _BiggestDiscountItem(
      id: 'bd-american-tourister',
      title: 'American Tourister Trolley Set',
      brand: 'VIP STYLE',
      store: 'Flipkart',
      imageUrl: 'assets/banners/shopsy_shopping_3d.jpg',
      currentPrice: 1999,
      originalPrice: 9999,
      discountPercentage: 80,
      cashbackAmount: 150,
    ),
  ];

  // 8. Section: Best Store Deals
  static const List<_BestStoreDealItem> _bestStores = [
    _BestStoreDealItem(
      name: 'Amazon',
      avatarText: 'A',
      cashbackRate: 'Up to 10% Cashback',
      activeOffers: '15 Active Offers',
      websiteUrl: 'https://www.amazon.in',
    ),
    _BestStoreDealItem(
      name: 'Myntra',
      avatarText: 'M',
      cashbackRate: 'Up to 15% Cashback',
      activeOffers: '12 Active Offers',
      websiteUrl: 'https://www.myntra.com',
    ),
    _BestStoreDealItem(
      name: 'Tata CLiQ',
      avatarText: 'TC',
      cashbackRate: 'Up to 12% Cashback',
      activeOffers: '8 Active Offers',
      websiteUrl: 'https://www.tatacliq.com',
    ),
  ];

  // 9. Section: Price Drops
  static const List<_PriceDropItem> _priceDrops = [
    _PriceDropItem(
      id: 'pd-ipad-10',
      title: 'Apple iPad 10th Gen (64GB, Wi-Fi)',
      brand: 'Apple',
      store: 'Amazon',
      imageUrl: 'assets/banners/phone_banner_16_9.jpg',
      wasPrice: 44900,
      nowPrice: 32900,
      dropAmount: 12000,
    ),
    _PriceDropItem(
      id: 'pd-bose-qc45',
      title: 'Bose QuietComfort 45',
      brand: 'Bose',
      store: 'Amazon',
      imageUrl: 'assets/banners/headphone_3d.jpg',
      wasPrice: 29900,
      nowPrice: 17900,
      dropAmount: 12000,
    ),
  ];

  // 10. Section: Deals You May Like (Pills)
  static const List<_RecommendationPillItem> _recommendationPills = [
    _RecommendationPillItem(
      title: 'Running Shoes',
      subtitle: 'From ₹1,499',
      icon: Icons.directions_run_rounded,
    ),
    _RecommendationPillItem(
      title: 'Protein Supplements',
      subtitle: 'Up to 35% Off',
      icon: Icons.fitness_center_rounded,
    ),
    _RecommendationPillItem(
      title: 'Smart Bands',
      subtitle: 'From ₹1,199',
      icon: Icons.watch_rounded,
    ),
    _RecommendationPillItem(
      title: 'Travel Backpacks',
      subtitle: 'Under ₹999',
      icon: Icons.backpack_rounded,
    ),
  ];



  // ===========================================================================
  // PALETTE: Hex EAEFFE (Canvas), Hex 9787F3 (Accent), Hex 2D274B (Midnight Plum)
  // ===========================================================================
  static const Color _paletteBg = Color(
    0xFFEAEFFE,
  ); // Soft Periwinkle Canvas (#EAEFFE)
  static const Color _paletteAccent = Color(
    0xFF9787F3,
  ); // Electric Violet / Lilac Accent (#9787F3)
  static const Color _paletteDark = Color(
    0xFF2D274B,
  ); // Midnight Deep Plum Typography & Surfaces (#2D274B)
  static const Color _paletteCardLight =
      Colors.white; // Crisp White Elevated Card
  static const Color _paletteBorderLight = Color(
    0xFFD6DCF8,
  ); // Soft Periwinkle-Lilac Border
  static const Color _paletteMuted = Color(0xFF6B6488); // Muted Plum-Slate Text

  // Dark Mode Counterparts (Anchored around #2D274B)
  static const Color _paletteDarkBg = Color(0xFF1E1A33); // Deep plum background
  static const Color _paletteDarkCard = Color(
    0xFF2D274B,
  ); // #2D274B card surface
  static const Color _paletteDarkBorder = Color(
    0xFF3F3765,
  ); // Subtle dark border
  static const Color _paletteDarkText = Color(
    0xFFF8FAFC,
  ); // High-contrast white
  static const Color _paletteDarkMuted = Color(
    0xFFB4A8E8,
  ); // Lavender muted text
  static const Color _paletteDarkSurface = Color(
    0xFF25203F,
  ); // Elevated dark container

  Color _scaffoldBg(bool isDark) => isDark ? _paletteDarkBg : _paletteBg;
  Color _cardBg(bool isDark) => isDark ? _paletteDarkCard : _paletteCardLight;
  Color _borderColor(bool isDark) =>
      isDark ? _paletteDarkBorder : _paletteBorderLight;
  Color _textDark(bool isDark) => isDark ? _paletteDarkText : _paletteDark;
  Color _textMuted(bool isDark) => isDark ? _paletteDarkMuted : _paletteMuted;
  Color _imageContainerBg(bool isDark) =>
      isDark ? _paletteDarkSurface : _paletteBg;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: _scaffoldBg(isDark),
      appBar: _buildAppBar(isDark),
      body: RefreshIndicator(
        color: _paletteAccent,
        onRefresh: () async {
          await Future.delayed(const Duration(milliseconds: 300));
        },
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(0, 8, 0, 110),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 🔍 SEARCH DEALS SECTION (Kept completely intact as requested)
              _buildSearchDealsSection(isDark),
              const SizedBox(height: 16),

              // 2. ⭐ TOP DEALS FOR YOU (Sony WH-1000XM5 card)
              _buildTopDealsForYouSection(isDark),
              const SizedBox(height: 20),

              // 3. 💰 HIGHEST CASHBACK DEALS (Nykaa, Enchante, Samsung Official)
              _buildHighestCashbackDealsSection(isDark),
              const SizedBox(height: 20),

              // 4. 🏥 HEALTH & PHARMACY DEALS (Banner & 4 categories)
              _buildHealthAndPharmacySection(isDark),
              const SizedBox(height: 20),

              // 5. 🛍️ BEST PRODUCT DEALS (2-Column Grid: boAt, Noise, Nike, Philips)
              _buildBestProductDealsSection(isDark),
              const SizedBox(height: 20),

              // 6. ✈️ TRAVEL ZONE (Dark #2D274B banner & 4 travel chips)
              _buildTravelZoneSection(isDark),
              const SizedBox(height: 20),

              // 7. 🏨 HOTELS & STAYS (Grand Palace & Heritage Haveli)
              _buildHotelsAndStaysSection(isDark),
              const SizedBox(height: 20),

              // 8. ⚡ FLASH DEALS / ENDING SOON (Ambrane & Inalsa Air Fryer)
              _buildFlashDealsSection(isDark),
              const SizedBox(height: 20),

              // 9. 💳 BANKING & FINANCIAL DEALS (HDFC Regalia & Tata AIA)
              _buildBankOffersSection(isDark),
              const SizedBox(height: 20),

              // 10. 💸 BIGGEST DISCOUNTS (75% Levi's & 80% American Tourister)
              _buildBiggestDiscountsSection(isDark),
              const SizedBox(height: 20),

              // 11. 🏪 BEST STORE DEALS (Amazon, Myntra, Tata CLiQ)
              _buildBestStoreDealsSection(isDark),
              const SizedBox(height: 20),

              // 12. 📉 PRICE DROPS (iPad 10th Gen & Bose QC45)
              _buildPriceDropsSection(isDark),
              const SizedBox(height: 20),

              // 13. 👀 DEALS YOU MAY LIKE (2x2 Pill Grid + Load More)
              _buildDealsYouMayLikeSection(isDark),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // APP BAR (Matches Reference: Icon + "BEST DEALS" + Subtitle + Notification & Profile)
  // ===========================================================================

  PreferredSizeWidget _buildAppBar(bool isDark) {
    final textDark = _textDark(isDark);
    final textMuted = _textMuted(isDark);

    return AppBar(
      backgroundColor: _scaffoldBg(isDark),
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 16,
      title: Row(
        children: [
          // If popped from navigator, show subtle back arrow; otherwise show purple tag icon
          if (widget.onBack != null || Navigator.of(context).canPop())
            InkWell(
              onTap: () {
                if (widget.onBack != null) {
                  widget.onBack!();
                } else if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                }
              },
              borderRadius: BorderRadius.circular(10),
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: _paletteAccent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: isDark ? _paletteAccent : _paletteDark,
                  size: 16,
                ),
              ),
            ),

          // Tag Icon in rounded purple square
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: _paletteAccent,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: _paletteAccent.withValues(alpha: 0.35),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.local_offer_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Title & Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'BEST DEALS',
                  style: GoogleFonts.inter(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    color: textDark,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  'Handpicked Offers & Cashback',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        // Notification bell
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.notifications_none_rounded,
            color: textDark,
            size: 23,
          ),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 38, minHeight: 38),
        ),

        // User profile avatar circle
        Padding(
          padding: const EdgeInsets.only(right: 16, left: 4),
          child: Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: _paletteDark,
              shape: BoxShape.circle,
              border: Border.all(color: _borderColor(isDark), width: 1.5),
            ),
            child: const Center(
              child: Icon(Icons.person_rounded, color: Colors.white, size: 19),
            ),
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // 🔍 SEARCH DEALS SECTION (Kept completely untouched as requested)
  // ===========================================================================

  void _openSearchScreen({String? query, String? category}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BestDealsSearchScreen(
          initialQuery: query,
          initialCategory: category,
        ),
      ),
    );
  }

  Widget _buildSearchDealsSection(bool isDark) {
    final borderColor = _borderColor(isDark);
    final searchBarBg = _cardBg(isDark);
    final searchIconColor = _paletteAccent;
    final textMuted = _textMuted(isDark);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
      child: InkWell(
        onTap: () => _openSearchScreen(),
        borderRadius: BorderRadius.circular(24),
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: searchBarBg,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: borderColor, width: 1.2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(Icons.search_rounded, color: searchIconColor, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Search deals, products or stores',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: textMuted,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



  // ===========================================================================
  // 2. ⭐ TOP DEALS FOR YOU (Sony WH-1000XM5 matching Reference Image)
  // ===========================================================================

  Widget _buildTopDealsForYouSection(bool isDark) {
    final textDark = _textDark(isDark);
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth - 44).clamp(315.0, 350.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header with "SEE ALL (6)"
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.dashboard_outlined,
                    color: _paletteAccent,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Top Deals For You',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: textDark,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  final deals = Provider.of<HomeProvider>(
                    context,
                    listen: false,
                  ).bestDeals;
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          AllBestDealsScreen(title: 'Top Deals', deals: deals),
                    ),
                  );
                },
                child: Text(
                  'SEE ALL (${_topCategoryDeals.length})',
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w800,
                    color: _paletteAccent,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        // Horizontal Slidable Carousel of Category Top Deal Cards
        SizedBox(
          height: 255,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _topCategoryDeals.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final item = _topCategoryDeals[index];
              return _buildTopCategoryDealCard(item, isDark, cardWidth);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTopCategoryDealCard(
    _TopDealCategoryItem item,
    bool isDark,
    double cardWidth,
  ) {
    final cardBg = _cardBg(isDark);
    final borderColor = _borderColor(isDark);
    final textDark = _textDark(isDark);
    final textMuted = _textMuted(isDark);

    return Container(
      width: cardWidth,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor, width: 1.1),
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
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top Tag Row: Category rankBadge on left & Cashback on right
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _paletteAccent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: _paletteAccent.withValues(alpha: 0.35),
                    width: 0.8,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(item.categoryEmoji, style: const TextStyle(fontSize: 10)),
                    const SizedBox(width: 4),
                    Text(
                      item.rankBadge,
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: _paletteAccent,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '+₹${item.cashbackAmount.toInt()} Cashback',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF10B981),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 11),

          // Product details row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product image with discount badge
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 96,
                      height: 96,
                      color: _imageContainerBg(isDark),
                      child: Image.asset(
                        item.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Center(
                          child: Icon(
                            Icons.shopping_bag_outlined,
                            size: 40,
                            color: _paletteAccent.withValues(alpha: 0.6),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 4,
                    left: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: _paletteAccent,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${item.discountPercentage.toInt()}% OFF',
                        style: GoogleFonts.inter(
                          fontSize: 8.5,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),

              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'STORE: ${item.store.toUpperCase()}',
                      style: GoogleFonts.inter(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w700,
                        color: textMuted,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.title,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: textDark,
                        height: 1.25,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '₹${item.currentPrice.toInt()}',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: textDark,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '₹${item.originalPrice.toInt()}',
                          style: GoogleFonts.inter(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w500,
                            color: textMuted,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Net Effective: ₹${item.effectivePrice.toInt()}',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF10B981),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.bolt_rounded,
                            size: 11,
                            color: Color(0xFF10B981),
                          ),
                          const SizedBox(width: 2),
                          Flexible(
                            child: Text(
                              item.savingsHighlight,
                              style: GoogleFonts.inter(
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF10B981),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Grab Deal Now CTA Button
          SizedBox(
            width: double.infinity,
            height: 40,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ProductDetailScreen(
                      customTitle: item.title,
                      customBrandName: item.brand,
                      customCategory: item.category,
                      customOriginalPrice: '₹${item.originalPrice.toInt()}',
                      customDiscountedPrice: '₹${item.currentPrice.toInt()}',
                      customDiscountTag:
                          '${item.discountPercentage.toInt()}% OFF',
                      customCashbackTag:
                          '+ ₹${item.cashbackAmount.toInt()} Cashback',
                      customFinalPrice: '₹${item.effectivePrice.toInt()}',
                      customDescription: item.description,
                      customImageUrl: item.imageUrl,
                      customImages: [item.imageUrl],
                      customWebsiteUrl: item.websiteUrl,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _paletteAccent,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.bolt_rounded, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    'Grab Deal Now',
                    style: GoogleFonts.inter(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // 3. 💰 HIGHEST CASHBACK DEALS (Product/Deal-level: Samsung S24, MacBook Air, Sony TV)
  // ===========================================================================

  Widget _buildHighestCashbackDealsSection(bool isDark) {
    final textDark = _textDark(isDark);
    final cardBg = _cardBg(isDark);
    final borderColor = _borderColor(isDark);
    final textMuted = _textMuted(isDark);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.account_balance_wallet_outlined,
                    color: _paletteAccent,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Highest Cashback Deals',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: textDark,
                    ),
                  ),
                ],
              ),
              Text(
                "Ranked by Max Cashback",
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Product/Deal-Level Cards with Cashback Hero Visual
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _highestCashbackDeals.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final item = _highestCashbackDeals[index];
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor, width: 1.1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: isDark ? 0.2 : 0.03,
                      ),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Row: Prominent Cashback Hero Tag + Store
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3.5,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981).withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: const Color(0xFF10B981).withValues(alpha: 0.3),
                              width: 0.8,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.currency_rupee_rounded,
                                size: 12,
                                color: Color(0xFF10B981),
                              ),
                              Text(
                                item.cashbackHighlight,
                                style: GoogleFonts.inter(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w900,
                                  color: const Color(0xFF10B981),
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'STORE: ${item.store.toUpperCase()}',
                          style: GoogleFonts.inter(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w700,
                            color: textMuted,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Product info row
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            width: 60,
                            height: 60,
                            color: _imageContainerBg(isDark),
                            child: Image.asset(
                              item.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Center(
                                child: Icon(
                                  Icons.shopping_bag_outlined,
                                  size: 28,
                                  color: _paletteAccent.withValues(alpha: 0.6),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: GoogleFonts.inter(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                  color: textDark,
                                  height: 1.25,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text(
                                    '₹${item.currentPrice.toInt()}',
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                      color: textDark,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '₹${item.originalPrice.toInt()}',
                                    style: GoogleFonts.inter(
                                      fontSize: 10.5,
                                      color: textMuted,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                item.subtitle,
                                style: GoogleFonts.inter(
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w600,
                                  color: _paletteAccent,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          height: 32,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => ProductDetailScreen(
                                    customTitle: item.title,
                                    customBrandName: item.brand,
                                    customCategory: 'Highest Cashback',
                                    customOriginalPrice:
                                        '₹${item.originalPrice.toInt()}',
                                    customDiscountedPrice:
                                        '₹${item.currentPrice.toInt()}',
                                    customDiscountTag: 'Special Rate',
                                    customCashbackTag: item.cashbackHighlight,
                                    customFinalPrice:
                                        '₹${(item.currentPrice - item.cashbackAmount).toInt()}',
                                    customDescription:
                                        '${item.title} available from ${item.store}. Highest cashback rate verified.',
                                    customImageUrl: item.imageUrl,
                                    customImages: [item.imageUrl],
                                    customWebsiteUrl: item.websiteUrl,
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _paletteAccent,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              'Grab Deal',
                              style: GoogleFonts.inter(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // 4. 🏥 HEALTH & PHARMACY DEALS (NEW Promo Banner + 4 Categories)
  // ===========================================================================

  Widget _buildHealthAndPharmacySection(bool isDark) {
    final textDark = _textDark(isDark);
    final cardBg = _cardBg(isDark);
    final borderColor = _borderColor(isDark);
    final textMuted = _textMuted(isDark);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.health_and_safety_outlined,
                    color: _paletteAccent,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Health & Pharmacy Deals',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: textDark,
                    ),
                  ),
                ],
              ),
              Text(
                'Medicines & Care',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Promo Banner Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: borderColor, width: 1.1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.local_hospital_outlined,
                            size: 14,
                            color: _paletteAccent,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'HEALTH SPECIAL',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: _paletteAccent,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Health & Pharmacy Deals',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: textDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Earn extra cashback with our healthcare providers & partners',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: textMuted,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 30,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _paletteAccent,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'EXPLORE OFFERS',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.4,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Floating shield icon
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: _paletteAccent.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.shield_outlined,
                      size: 28,
                      color: _paletteAccent,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // 4 Category Quick Buttons
          Row(
            children: [
              _buildCategoryPill('Pharmacy', Icons.medication_outlined, isDark),
              const SizedBox(width: 8),
              _buildCategoryPill(
                'Diagnostics',
                Icons.health_and_safety_outlined,
                isDark,
              ),
              const SizedBox(width: 8),
              _buildCategoryPill('Nutrition', Icons.eco_outlined, isDark),
              const SizedBox(width: 8),
              _buildCategoryPill('Personal', Icons.water_drop_outlined, isDark),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryPill(String title, IconData icon, bool isDark) {
    final cardBg = _cardBg(isDark);
    final borderColor = _borderColor(isDark);
    final textDark = _textDark(isDark);

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 1),
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: _paletteAccent),
            const SizedBox(height: 4),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: textDark,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // 5. 🛍️ BEST PRODUCT DEALS (2-Column Grid matching 4 items from Reference Image)
  // ===========================================================================

  Widget _buildBestProductDealsSection(bool isDark) {
    final textDark = _textDark(isDark);
    final textMuted = _textMuted(isDark);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.discount_outlined,
                    color: _paletteAccent,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Best Product Deals',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: textDark,
                    ),
                  ),
                ],
              ),
              Text(
                'Lowest Price Drops',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 2-Column Grid of 4 Cards
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _bestProductDeals.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.68,
            ),
            itemBuilder: (context, index) {
              final item = _bestProductDeals[index];
              return _buildBestProductDealCard(item, isDark);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBestProductDealCard(_BestProductDealItem item, bool isDark) {
    final cardBg = _cardBg(isDark);
    final borderColor = _borderColor(isDark);
    final textDark = _textDark(isDark);
    final textMuted = _textMuted(isDark);

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1.1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _openProductDetailFromDeal(item),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image with Discount Badge
              Expanded(
                flex: 12,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(15),
                      ),
                      child: Container(
                        color: _imageContainerBg(isDark),
                        child: Image.asset(
                          item.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Center(
                            child: Icon(
                              Icons.shopping_bag_outlined,
                              size: 32,
                              color: _paletteAccent.withValues(alpha: 0.5),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 6,
                      left: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: _paletteAccent,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          '${item.discountPercentage.toInt()}% OFF',
                          style: GoogleFonts.inter(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Product Info
              Expanded(
                flex: 11,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(9, 6, 9, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.brand,
                        style: GoogleFonts.inter(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: textMuted,
                          letterSpacing: 0.3,
                        ),
                      ),
                      Text(
                        item.title,
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: textDark,
                          height: 1.25,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '₹${item.currentPrice.toInt()}',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: textDark,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '₹${item.originalPrice.toInt()}',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              color: textMuted,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '+ ₹${item.cashbackAmount.toInt()} Cashback',
                        style: GoogleFonts.inter(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF10B981),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // 6. ✈️ TRAVEL ZONE (Dark #2D274B Promo Card + 4 Category Chips)
  // ===========================================================================

  Widget _buildTravelZoneSection(bool isDark) {
    final cardBg = _cardBg(isDark);
    final borderColor = _borderColor(isDark);
    final textDark = _textDark(isDark);
    final textMuted = _textMuted(isDark);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.flight_takeoff_rounded,
                    color: _paletteAccent,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Travel Deals',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: textDark,
                    ),
                  ),
                ],
              ),
              Text(
                'Flights & Holidays',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Dark Midnight Plum Container (#2D274B)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _paletteDark,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.flight_takeoff_rounded,
                      size: 14,
                      color: _paletteAccent,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'TRAVEL ZONE',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: _paletteAccent,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Flights • Bus • Holidays • Activities',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Up to ₹5,000 Cashback on Bookings',
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    color: const Color(0xFFB4A8E8),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 32,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _paletteAccent,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Explore Travel Deals',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // 4 Travel Chips
          Row(
            children: [
              _buildTravelChip('✈️ Flights', cardBg, borderColor, textDark),
              const SizedBox(width: 8),
              _buildTravelChip('🚌 Bus', cardBg, borderColor, textDark),
              const SizedBox(width: 8),
              _buildTravelChip('🏖️ Holidays', cardBg, borderColor, textDark),
              const SizedBox(width: 8),
              _buildTravelChip('🎟️ Activities', cardBg, borderColor, textDark),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTravelChip(String label, Color bg, Color border, Color text) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: border, width: 1),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: text,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // 7. 🏨 HOTELS & STAYS (The Grand Palace & Heritage Haveli)
  // ===========================================================================

  Widget _buildHotelsAndStaysSection(bool isDark) {
    final textDark = _textDark(isDark);
    final cardBg = _cardBg(isDark);
    final borderColor = _borderColor(isDark);
    final textMuted = _textMuted(isDark);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.hotel_rounded, color: _paletteAccent, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    'Hotels & Stays',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: textDark,
                    ),
                  ),
                ],
              ),
              Text(
                'Domestic & International',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Horizontal scroll of hotel cards
          SizedBox(
            height: 200,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: _hotelDeals.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final hotel = _hotelDeals[index];
                return Container(
                  width: 220,
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: borderColor, width: 1.1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: isDark ? 0.25 : 0.04,
                        ),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(15),
                            ),
                            child: Container(
                              height: 100,
                              width: 220,
                              color: _imageContainerBg(isDark),
                              child: Image.asset(
                                hotel.imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const Center(
                                  child: Icon(Icons.hotel_rounded, size: 36),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 6,
                            left: 6,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: _paletteAccent,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                hotel.discountTag,
                                style: GoogleFonts.inter(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              hotel.title,
                              style: GoogleFonts.inter(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                                color: textDark,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              hotel.cashbackText,
                              style: GoogleFonts.inter(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF10B981),
                              ),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: double.infinity,
                              height: 26,
                              child: OutlinedButton(
                                onPressed: () {},
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: _paletteAccent,
                                  side: const BorderSide(
                                    color: _paletteAccent,
                                    width: 1,
                                  ),
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                child: Text(
                                  'View Hotel',
                                  style: GoogleFonts.inter(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // 8. ⚡ FLASH DEALS / ENDING SOON (Ambrane & Inalsa Air Fryer with Red Header)
  // ===========================================================================

  Widget _buildFlashDealsSection(bool isDark) {
    final textDark = _textDark(isDark);
    final cardBg = _cardBg(isDark);
    final borderColor = _borderColor(isDark);
    final textMuted = _textMuted(isDark);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.flash_on_rounded, color: _paletteAccent, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    'Flash Deals / Ending Soon',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: textDark,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFEF4444).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'ENDS IN 01:23:45',
                  style: GoogleFonts.inter(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFFEF4444),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Row(
            children: _flashDeals.map((item) {
              return Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                    right: item == _flashDeals.first ? 10 : 0,
                  ),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: borderColor, width: 1.1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              height: 90,
                              width: double.infinity,
                              color: _imageContainerBg(isDark),
                              child: Image.asset(
                                item.imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const Center(
                                  child: Icon(Icons.bolt_rounded, size: 32),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 4,
                            left: 4,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEF4444),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '${item.discountPercentage.toInt()}% OFF',
                                style: GoogleFonts.inter(
                                  fontSize: 8.5,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(
                            Icons.timer_outlined,
                            size: 10,
                            color: Color(0xFFEF4444),
                          ),
                          const SizedBox(width: 3),
                          Text(
                            'Ends in: ${item.endsInText}',
                            style: GoogleFonts.inter(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFFEF4444),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.title,
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: textDark,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            '₹${item.currentPrice.toInt()}',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: textDark,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '₹${item.originalPrice.toInt()}',
                            style: GoogleFonts.inter(
                              fontSize: 9.5,
                              color: textMuted,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '+ ₹${item.cashbackAmount.toInt()} Cashback',
                        style: GoogleFonts.inter(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF10B981),
                        ),
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: LinearProgressIndicator(
                          value: item.claimedPercentage,
                          backgroundColor: _paletteBorderLight,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            _paletteAccent,
                          ),
                          minHeight: 4,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        height: 28,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _paletteAccent,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Grab Deal Now',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // 9. 💳 BANKING & FINANCIAL DEALS (HDFC Regalia & Tata AIA Insurance)
  // ===========================================================================

  Widget _buildBankOffersSection(bool isDark) {
    final textDark = _textDark(isDark);
    final cardBg = _cardBg(isDark);
    final borderColor = _borderColor(isDark);
    final textMuted = _textMuted(isDark);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.credit_card_rounded,
                    color: _paletteAccent,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Banking & Financial Deals',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: textDark,
                    ),
                  ),
                ],
              ),
              Text(
                'Cards & Insurance',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _bankOffers.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final item = _bankOffers[index];
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: item.isDarkIcon
                                ? _paletteDark
                                : _paletteAccent.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Icon(
                              item.icon,
                              color: item.isDarkIcon
                                  ? Colors.white
                                  : _paletteAccent,
                              size: 20,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: textDark,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                item.subtitle,
                                style: GoogleFonts.inter(
                                  fontSize: 10.5,
                                  color: textMuted,
                                  height: 1.25,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item.statusText,
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF10B981),
                          ),
                        ),
                        SizedBox(
                          height: 28,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _paletteAccent,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              item.buttonText,
                              style: GoogleFonts.inter(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // 10. 💸 BIGGEST DISCOUNTS (75% Levi's & 80% American Tourister)
  // ===========================================================================

  Widget _buildBiggestDiscountsSection(bool isDark) {
    final textDark = _textDark(isDark);
    final cardBg = _cardBg(isDark);
    final borderColor = _borderColor(isDark);
    final textMuted = _textMuted(isDark);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.percent_rounded, color: _paletteAccent, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    'Biggest Discounts',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: textDark,
                    ),
                  ),
                ],
              ),
              Text(
                'Mega Price Reductions',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Row(
            children: _biggestDiscounts.map((item) {
              return Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                    right: item == _biggestDiscounts.first ? 12 : 0,
                  ),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: borderColor, width: 1.1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Banner (e.g. 75% OFF / 80% OFF)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        decoration: const BoxDecoration(
                          color: _paletteAccent,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(15),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '${item.discountPercentage.toInt()}% OFF',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                      ClipRRect(
                        child: Container(
                          height: 95,
                          width: double.infinity,
                          color: _imageContainerBg(isDark),
                          child: Image.asset(
                            item.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Center(
                              child: Icon(
                                Icons.shopping_bag_outlined,
                                size: 32,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(9),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.brand,
                              style: GoogleFonts.inter(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: textMuted,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              item.title,
                              style: GoogleFonts.inter(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                color: textDark,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  '₹${item.currentPrice.toInt()}',
                                  style: GoogleFonts.inter(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w800,
                                    color: textDark,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '₹${item.originalPrice.toInt()}',
                                  style: GoogleFonts.inter(
                                    fontSize: 9.5,
                                    color: textMuted,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '+ ₹${item.cashbackAmount.toInt()} Cashback',
                              style: GoogleFonts.inter(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF10B981),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // 11. 🏪 BEST STORE DEALS (Amazon, Myntra, Tata CLiQ)
  // ===========================================================================

  Widget _buildBestStoreDealsSection(bool isDark) {
    final textDark = _textDark(isDark);
    final cardBg = _cardBg(isDark);
    final borderColor = _borderColor(isDark);
    final textMuted = _textMuted(isDark);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.storefront_rounded,
                    color: _paletteAccent,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Best Store Deals',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: textDark,
                    ),
                  ),
                ],
              ),
              Text(
                'Official Partners',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _bestStores.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final store = _bestStores[index];
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor, width: 1),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: _imageContainerBg(isDark),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: borderColor, width: 0.8),
                      ),
                      child: Center(
                        child: Text(
                          store.avatarText,
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: textDark,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            store.name,
                            style: GoogleFonts.inter(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              color: textDark,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            store.cashbackRate,
                            style: GoogleFonts.inter(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: _paletteAccent,
                            ),
                          ),
                          Text(
                            store.activeOffers,
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              color: textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 32,
                      child: ElevatedButton(
                        onPressed: () {
                          _openStoreDetail(
                            storeName: store.name,
                            cashbackRate: store.cashbackRate,
                            logoUrl: 'assets/cards/col_default.jpg',
                            category: 'Shopping',
                            websiteUrl: store.websiteUrl,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _paletteAccent,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Shop Now',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // 12. 📉 PRICE DROPS (Apple iPad 10th Gen & Bose QC45)
  // ===========================================================================

  Widget _buildPriceDropsSection(bool isDark) {
    final textDark = _textDark(isDark);
    final cardBg = _cardBg(isDark);
    final borderColor = _borderColor(isDark);
    final textMuted = _textMuted(isDark);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.trending_down_rounded,
                    color: _paletteAccent,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Price Drops',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: textDark,
                    ),
                  ),
                ],
              ),
              Text(
                'Min. 15% Fall Alert',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _priceDrops.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final drop = _priceDrops[index];
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor, width: 1),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: 48,
                        height: 48,
                        color: _imageContainerBg(isDark),
                        child: Image.asset(
                          drop.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.devices_rounded),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            drop.title,
                            style: GoogleFonts.inter(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: textDark,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Earlier: ₹${drop.wasPrice.toInt()} | Now: ₹${drop.nowPrice.toInt()}',
                            style: GoogleFonts.inter(
                              fontSize: 10.5,
                              color: textMuted,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFF10B981,
                              ).withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '📉 ₹${drop.dropAmount.toInt()} Price Drop',
                              style: GoogleFonts.inter(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF10B981),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 32,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _paletteAccent,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Shop Now',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // 13. 👀 DEALS YOU MAY LIKE (2x2 Pill Grid + Load More Button)
  // ===========================================================================

  Widget _buildDealsYouMayLikeSection(bool isDark) {
    final textDark = _textDark(isDark);
    final cardBg = _cardBg(isDark);
    final borderColor = _borderColor(isDark);
    final textMuted = _textMuted(isDark);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.auto_awesome_outlined,
                    color: _paletteAccent,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Deals You May Like',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: textDark,
                    ),
                  ),
                ],
              ),
              Text(
                'Discovery Feed',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 2x2 Grid of Recommendation Pills
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _recommendationPills.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 2.5,
            ),
            itemBuilder: (context, index) {
              final item = _recommendationPills[index];
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: borderColor, width: 1),
                ),
                child: Row(
                  children: [
                    Icon(item.icon, size: 20, color: _paletteAccent),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            item.title,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: textDark,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            item.subtitle,
                            style: GoogleFonts.inter(
                              fontSize: 9.5,
                              color: textMuted,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 14),

          // Load More Recommendations Pill Button
          SizedBox(
            width: double.infinity,
            height: 38,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.refresh_rounded, size: 16),
              label: Text(
                'Load More Recommendations',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: textDark,
                side: BorderSide(color: borderColor, width: 1.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // NAVIGATION HELPERS
  // ===========================================================================

  void _openStoreDetail({
    required String storeName,
    required String cashbackRate,
    required String logoUrl,
    String? category,
    String? websiteUrl,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => StoreDetailScreen(
          storeName: storeName,
          cashbackRate: cashbackRate,
          logoUrl: logoUrl,
          category: category,
          websiteUrl: websiteUrl,
        ),
      ),
    );
  }

  void _openProductDetailFromDeal(_BestProductDealItem item) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProductDetailScreen(
          customTitle: item.title,
          customBrandName: item.brand,
          customCategory: 'Best Deals',
          customOriginalPrice: '₹${item.originalPrice.toInt()}',
          customDiscountedPrice: '₹${item.currentPrice.toInt()}',
          customDiscountTag: '${item.discountPercentage.toInt()}% OFF',
          customCashbackTag: '+ ₹${item.cashbackAmount.toInt()} Cashback',
          customFinalPrice: '₹${item.currentPrice.toInt()}',
          customDescription:
              '${item.title} by ${item.brand}. Lowest price deal available on ${item.store} with stacked cashback.',
          customImageUrl: item.imageUrl,
          customImages: [item.imageUrl],
          customWebsiteUrl: item.websiteUrl,
        ),
      ),
    );
  }
}
