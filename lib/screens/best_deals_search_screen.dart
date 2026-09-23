import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/utils/brand_asset_helper.dart';
import '../widgets/network_image_with_skeleton.dart';
import 'product_detail_screen.dart';
import 'store_detail_screen.dart';

/// Data model for a deal or product in the Best Deals Search screen.
class DealSearchItem {
  final String id;
  final String title;
  final String brand;
  final String category;
  final String store;
  final String imageUrl;
  final double currentPrice;
  final double originalPrice;
  final double discountPercentage;
  final double cashbackAmount;
  final double rating;
  final int ratingCount;
  final bool isPopular;
  final bool isTrending;
  final String websiteUrl;
  final String description;

  const DealSearchItem({
    required this.id,
    required this.title,
    required this.brand,
    required this.category,
    required this.store,
    required this.imageUrl,
    required this.currentPrice,
    required this.originalPrice,
    required this.discountPercentage,
    required this.cashbackAmount,
    this.rating = 4.5,
    this.ratingCount = 1200,
    this.isPopular = false,
    this.isTrending = false,
    this.websiteUrl = 'https://www.amazon.in',
    this.description = '',
  });

  double get effectivePrice =>
      (currentPrice - cashbackAmount).clamp(0, double.infinity);
}

/// Data model for a popular store in the Best Deals Search screen.
class PopularStoreItem {
  final String name;
  final String cashbackRate;
  final String logoUrl;
  final String websiteUrl;
  final String category;
  final String tag;

  const PopularStoreItem({
    required this.name,
    required this.cashbackRate,
    required this.logoUrl,
    required this.websiteUrl,
    required this.category,
    this.tag = 'Popular Store',
  });
}

/// Sort options for Best Deals Search.
enum DealsSortOption {
  recommended,
  priceLowToHigh,
  priceHighToLow,
  biggestDiscount,
  highestCashback,
}

extension DealsSortOptionExtension on DealsSortOption {
  String get label {
    switch (this) {
      case DealsSortOption.recommended:
        return 'Recommended';
      case DealsSortOption.priceLowToHigh:
        return 'Price: Low to High';
      case DealsSortOption.priceHighToLow:
        return 'Price: High to Low';
      case DealsSortOption.biggestDiscount:
        return 'Biggest Discount';
      case DealsSortOption.highestCashback:
        return 'Highest Cashback';
    }
  }
}

class BestDealsSearchScreen extends StatefulWidget {
  static const String routeName = '/best-deals-search';

  final String? initialQuery;
  final String? initialCategory;

  const BestDealsSearchScreen({
    super.key,
    this.initialQuery,
    this.initialCategory,
  });

  @override
  State<BestDealsSearchScreen> createState() => _BestDealsSearchScreenState();
}

class _BestDealsSearchScreenState extends State<BestDealsSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  String _searchQuery = '';
  DealsSortOption _selectedSort = DealsSortOption.recommended;

  // Curated trending queries & suggestions (top 4-5 items in a horizontal line)
  static const List<Map<String, dynamic>> _trendingSuggestions = [
    {
      'label': 'iPhone 15',
      'query': 'iPhone 15',
      'icon': Icons.phone_iphone_rounded,
    },
    {
      'label': 'boAt Earbuds',
      'query': 'boAt',
      'icon': Icons.headphones_rounded,
    },
    {
      'label': 'Nike Shoes',
      'query': 'Nike',
      'icon': Icons.sports_tennis_rounded,
    },
    {
      'label': 'Whey Protein',
      'query': 'Whey',
      'icon': Icons.fitness_center_rounded,
    },
    {
      'label': 'Smartwatch',
      'query': 'Noise',
      'icon': Icons.watch_rounded,
    },
  ];

  // Popular Brand Stores
  static const List<PopularStoreItem> _popularStores = [
    PopularStoreItem(
      name: 'Amazon',
      cashbackRate: 'Upto 5% Rewards',
      logoUrl: 'assets/cards/amazon.jpg',
      websiteUrl: 'https://www.amazon.in',
      category: 'Electronics & All',
      tag: '⭐ Most Popular',
    ),
    PopularStoreItem(
      name: 'Flipkart',
      cashbackRate: 'Upto 6.5% Cashback',
      logoUrl: 'assets/cards/flipkart-electronics.png',
      websiteUrl: 'https://www.flipkart.com',
      category: 'Electronics & Mobiles',
      tag: '🔥 Mega Sale',
    ),
    PopularStoreItem(
      name: 'Myntra',
      cashbackRate: 'Upto 10% Cashback',
      logoUrl: 'assets/cards/myntra.jpg',
      websiteUrl: 'https://www.myntra.com',
      category: 'Fashion & Footwear',
      tag: '✨ Top Fashion',
    ),
    PopularStoreItem(
      name: 'AJIO',
      cashbackRate: 'Upto 7% Cashback',
      logoUrl: 'assets/cards/ajio-coupons.jpg',
      websiteUrl: 'https://www.ajio.com',
      category: 'Trending Apparel',
      tag: '💎 Big Trends',
    ),
    PopularStoreItem(
      name: 'boAt',
      cashbackRate: 'Upto 15% Rewards',
      logoUrl: 'assets/cards/boat-coupon.jpg',
      websiteUrl: 'https://www.boat-lifestyle.com',
      category: 'Audio & Wearables',
      tag: '⚡ 15% Max Cash',
    ),
    PopularStoreItem(
      name: 'Nykaa',
      cashbackRate: 'Upto 4% Cashback',
      logoUrl: 'assets/cards/nykaa.jpg',
      websiteUrl: 'https://www.nykaa.com',
      category: 'Beauty & Wellness',
      tag: '🌸 Top Beauty',
    ),
    PopularStoreItem(
      name: 'Samsung',
      cashbackRate: 'Upto 10% Cashback',
      logoUrl: 'assets/banners/phone_banner_16_9.jpg',
      websiteUrl: 'https://www.samsung.com/in',
      category: 'Smartphones & TVs',
      tag: '📱 Flagship Deals',
    ),
    PopularStoreItem(
      name: 'Tata CLiQ',
      cashbackRate: 'Upto 12% Cashback',
      logoUrl: 'assets/cards/col_default.jpg',
      websiteUrl: 'https://www.tatacliq.com',
      category: 'Luxury & Lifestyle',
      tag: '🛍️ Curated Deals',
    ),
  ];

  // Comprehensive Catalog of Deals and Products
  static const List<DealSearchItem> _allDeals = [
    // 1. Apple iPhone 15
    DealSearchItem(
      id: 'deal-iphone-15',
      title: 'Apple iPhone 15 (128 GB) - Blue / Starlight',
      brand: 'Apple',
      category: 'Electronics',
      store: 'Flipkart',
      imageUrl: 'assets/banners/phone_banner_16_9.jpg',
      currentPrice: 65999,
      originalPrice: 79900,
      discountPercentage: 17,
      cashbackAmount: 2200,
      rating: 4.8,
      ratingCount: 8400,
      isPopular: true,
      isTrending: true,
      websiteUrl: 'https://www.flipkart.com',
      description:
          'Dynamic Island, 48MP Main Camera, A16 Bionic chip, and durable color-infused glass design with USB-C.',
    ),
    // 2. boAt Airdopes 141 ANC
    DealSearchItem(
      id: 'deal-boat-141',
      title: 'boAt Airdopes 141 ANC True Wireless Earbuds',
      brand: 'boAt',
      category: 'Audio & Wearables',
      store: 'Amazon',
      imageUrl: 'assets/banners/headphone_3d.jpg',
      currentPrice: 1199,
      originalPrice: 4490,
      discountPercentage: 73,
      cashbackAmount: 150,
      rating: 4.4,
      ratingCount: 15200,
      isPopular: true,
      isTrending: true,
      websiteUrl: 'https://www.boat-lifestyle.com',
      description:
          '32dB Active Noise Cancellation, 42 hours total playtime, ENx quad mic technology with ASAP Fast Charging.',
    ),
    // 3. Nike Air Max 270 React
    DealSearchItem(
      id: 'deal-nike-airmax',
      title: 'Nike Air Max 270 React Sports Running Shoes',
      brand: 'Nike',
      category: 'Footwear',
      store: 'Myntra',
      imageUrl: 'assets/banners/nike_airmax_red.jpg',
      currentPrice: 4155,
      originalPrice: 11995,
      discountPercentage: 65,
      cashbackAmount: 350,
      rating: 4.7,
      ratingCount: 3800,
      isPopular: true,
      isTrending: true,
      websiteUrl: 'https://www.myntra.com',
      description:
          'Max Air 270 heel unit for unrivaled, all-day comfort with breathable lightweight woven fabric.',
    ),
    // 4. Sony WH-1000XM5
    DealSearchItem(
      id: 'deal-sony-xm5',
      title: 'Sony WH-1000XM5 Wireless Industry Leading Noise Canceling',
      brand: 'Sony',
      category: 'Audio & Wearables',
      store: 'Amazon',
      imageUrl: 'assets/banners/headphone_banner_16_9.jpg',
      currentPrice: 24990,
      originalPrice: 34990,
      discountPercentage: 29,
      cashbackAmount: 1200,
      rating: 4.9,
      ratingCount: 4200,
      isPopular: true,
      isTrending: true,
      websiteUrl: 'https://www.amazon.in',
      description:
          'Two processors and 8 microphones for unparalleled noise canceling. Up to 30-hour battery life.',
    ),
    // 5. MuscleBlaze Biozyme Whey
    DealSearchItem(
      id: 'deal-mb-whey',
      title: 'MuscleBlaze Raw Whey Protein Concentrate 80% | 1kg Unflavored',
      brand: 'MuscleBlaze',
      category: 'Health & Fitness',
      store: 'Flipkart',
      imageUrl: 'assets/banners/supplements_banner_16_9.jpg',
      currentPrice: 1899,
      originalPrice: 2499,
      discountPercentage: 24,
      cashbackAmount: 180,
      rating: 4.5,
      ratingCount: 6500,
      isPopular: true,
      isTrending: false,
      websiteUrl: 'https://www.flipkart.com',
      description:
          'Labdoor USA certified for accuracy and purity. Delivers 24g protein and 5.2g BCAAs per 30g scoop.',
    ),
    // 6. MuscleBlaze Daily Multivitamin
    DealSearchItem(
      id: 'deal-mb-multi',
      title: 'MuscleBlaze Biozyme Daily Multivitamin with EAF | 90 Tabs',
      brand: 'MuscleBlaze',
      category: 'Health & Fitness',
      store: 'Amazon',
      imageUrl: 'assets/banners/supplements_banner_16_9.jpg',
      currentPrice: 899,
      originalPrice: 1099,
      discountPercentage: 18,
      cashbackAmount: 72,
      rating: 4.3,
      ratingCount: 4100,
      isPopular: false,
      isTrending: false,
      websiteUrl: 'https://www.amazon.in',
      description:
          'Enhanced Absorption Formula packed with 50+ vitamins, minerals, and amino acids for peak immunity.',
    ),
    // 7. Noise ColorFit Pro 5
    DealSearchItem(
      id: 'deal-noise-pro5',
      title: 'Noise ColorFit Pro 5 Smartwatch with AMOLED Display',
      brand: 'Noise',
      category: 'Audio & Wearables',
      store: 'Amazon',
      imageUrl: 'assets/banners/watch_3d.jpg',
      currentPrice: 2499,
      originalPrice: 6499,
      discountPercentage: 62,
      cashbackAmount: 180,
      rating: 4.3,
      ratingCount: 5100,
      isPopular: true,
      isTrending: true,
      websiteUrl: 'https://www.amazon.in',
      description:
          '1.85-inch AMOLED display with 60Hz refresh rate, Bluetooth calling, and comprehensive health suite.',
    ),
    // 8. Philips Multi-Grooming Kit
    DealSearchItem(
      id: 'deal-philips-groomer',
      title: 'Philips Multi-Grooming Kit Series 5000 9-in-1',
      brand: 'Philips',
      category: 'Home Appliances',
      store: 'Amazon',
      imageUrl: 'assets/banners/reliance_tech_3d.jpg',
      currentPrice: 1599,
      originalPrice: 2295,
      discountPercentage: 30,
      cashbackAmount: 80,
      rating: 4.4,
      ratingCount: 3800,
      isPopular: false,
      isTrending: false,
      websiteUrl: 'https://www.amazon.in',
      description:
          'DualCut blades for maximum precision with self-sharpening steel blades and 80-min runtime.',
    ),
    // 9. Inalsa Dual-Zone Air Fryer
    DealSearchItem(
      id: 'deal-inalsa-fryer',
      title: 'Inalsa Dual-Zone 6L Air Fryer Oven with Rapid Hot Air',
      brand: 'Inalsa',
      category: 'Home Appliances',
      store: 'Flipkart',
      imageUrl: 'assets/banners/shopsy_shopping_3d.jpg',
      currentPrice: 4599,
      originalPrice: 14995,
      discountPercentage: 69,
      cashbackAmount: 250,
      rating: 4.6,
      ratingCount: 2900,
      isPopular: true,
      isTrending: true,
      websiteUrl: 'https://www.flipkart.com',
      description:
          'Up to 85% less fat cooking with 8 one-touch presets and digital touch control window.',
    ),
    // 10. Levi's Classic Trucker Denim Jacket
    DealSearchItem(
      id: 'deal-levis-jacket',
      title: "Levi's Classic Trucker Denim Jacket",
      brand: "Levi's",
      category: 'Fashion',
      store: 'Myntra',
      imageUrl: 'assets/cards/col_myntra.jpg',
      currentPrice: 1249,
      originalPrice: 4999,
      discountPercentage: 75,
      cashbackAmount: 120,
      rating: 4.6,
      ratingCount: 1900,
      isPopular: true,
      isTrending: true,
      websiteUrl: 'https://www.myntra.com',
      description:
          'Original Levi’s trucker jacket since 1967. 100% premium cotton denim with welt pockets.',
    ),
    // 11. American Tourister Trolley Set
    DealSearchItem(
      id: 'deal-tourister-luggage',
      title: 'American Tourister 3-Piece Luggage Spinner Trolley Set',
      brand: 'American Tourister',
      category: 'Fashion',
      store: 'Flipkart',
      imageUrl: 'assets/banners/shopsy_shopping_3d.jpg',
      currentPrice: 1999,
      originalPrice: 9999,
      discountPercentage: 80,
      cashbackAmount: 150,
      rating: 4.5,
      ratingCount: 3200,
      isPopular: true,
      isTrending: true,
      websiteUrl: 'https://www.flipkart.com',
      description:
          'Scratch-resistant polypropylene shell, 360-degree silent spinner wheels with TSA combination lock.',
    ),
    // 12. Apple iPad 10th Gen
    DealSearchItem(
      id: 'deal-ipad-10',
      title: 'Apple iPad 10th Gen (10.9-inch, 64GB, Wi-Fi)',
      brand: 'Apple',
      category: 'Electronics',
      store: 'Amazon',
      imageUrl: 'assets/banners/phone_banner_16_9.jpg',
      currentPrice: 32900,
      originalPrice: 44900,
      discountPercentage: 27,
      cashbackAmount: 1500,
      rating: 4.8,
      ratingCount: 5200,
      isPopular: true,
      isTrending: true,
      websiteUrl: 'https://www.amazon.in',
      description:
          'All-screen design with 10.9-inch Liquid Retina display, A14 Bionic chip, and 12MP Ultra Wide front camera.',
    ),
    // 13. Bose QuietComfort 45
    DealSearchItem(
      id: 'deal-bose-qc45',
      title: 'Bose QuietComfort 45 Bluetooth Wireless Noise Cancelling',
      brand: 'Bose',
      category: 'Audio & Wearables',
      store: 'Amazon',
      imageUrl: 'assets/banners/headphone_3d.jpg',
      currentPrice: 17900,
      originalPrice: 29900,
      discountPercentage: 40,
      cashbackAmount: 900,
      rating: 4.7,
      ratingCount: 2300,
      isPopular: false,
      isTrending: false,
      websiteUrl: 'https://www.amazon.in',
      description:
          'Iconic quiet, comfort, and sound. TriPort acoustic architecture delivers deep, rich audio.',
    ),
    // 14. Nike Air Zoom Pegasus 40
    DealSearchItem(
      id: 'deal-nike-pegasus',
      title: 'Nike Air Zoom Pegasus 40 Road Running Shoes',
      brand: 'Nike',
      category: 'Footwear',
      store: 'Myntra',
      imageUrl: 'assets/banners/nike_airmax_red.jpg',
      currentPrice: 6190,
      originalPrice: 10995,
      discountPercentage: 44,
      cashbackAmount: 350,
      rating: 4.7,
      ratingCount: 1600,
      isPopular: true,
      isTrending: false,
      websiteUrl: 'https://www.myntra.com',
      description:
          'Springy ride for any run, the Peg’s familiar, just-for-you feel returns with Nike React technology.',
    ),
    // 15. The Grand Palace Resort Stay
    DealSearchItem(
      id: 'deal-grand-palace',
      title: 'The Grand Palace Resort & Spa 3N Luxury Stay',
      brand: 'Grand Palace',
      category: 'Travel & Stays',
      store: 'Nykaa',
      imageUrl: 'assets/cards/col_travel.jpg',
      currentPrice: 12499,
      originalPrice: 18500,
      discountPercentage: 32,
      cashbackAmount: 1200,
      rating: 4.9,
      ratingCount: 850,
      isPopular: false,
      isTrending: false,
      websiteUrl: 'https://www.nykaa.com',
      description:
          'Lakeview heritage suite with complimentary breakfast, sunset boat cruise, and luxury spa voucher.',
    ),
    // 16. Ambrane 20000mAh Powerbank
    DealSearchItem(
      id: 'deal-ambrane-powerbank',
      title: 'Ambrane 20000mAh Powerbank with 22.5W Fast Charging',
      brand: 'Ambrane',
      category: 'Electronics',
      store: 'Amazon',
      imageUrl: 'assets/banners/headphone_banner_16_9.jpg',
      currentPrice: 1499,
      originalPrice: 3499,
      discountPercentage: 57,
      cashbackAmount: 90,
      rating: 4.3,
      ratingCount: 9200,
      isPopular: false,
      isTrending: false,
      websiteUrl: 'https://www.amazon.in',
      description:
          'Type-C two-way fast charging with multi-layer chipset protection and LED digital display indicator.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialQuery != null && widget.initialQuery!.isNotEmpty) {
      _searchController.text = widget.initialQuery!;
      _searchQuery = widget.initialQuery!.trim();
    } else if (widget.initialCategory != null &&
        widget.initialCategory!.isNotEmpty) {
      _searchController.text = widget.initialCategory!;
      _searchQuery = widget.initialCategory!.trim();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  // ===========================================================================
  // PALETTE: Hex EAEFFE (Canvas), Hex 9787F3 (Accent), Hex 2D274B (Midnight Plum)
  // ===========================================================================
  static const Color _paletteBg = Color(0xFFEAEFFE);
  static const Color _paletteAccent = Color(0xFF9787F3);
  static const Color _paletteDark = Color(0xFF2D274B);
  static const Color _paletteCardLight = Colors.white;
  static const Color _paletteBorderLight = Color(0xFFD6DCF8);
  static const Color _paletteMuted = Color(0xFF6B6488);
  static const Color _paletteSurfaceSubtle = Color(0xFFF3F5FE);

  // Dark Mode Counterparts
  static const Color _paletteDarkBg = Color(0xFF1E1A33);
  static const Color _paletteDarkCard = Color(0xFF2D274B);
  static const Color _paletteDarkBorder = Color(0xFF3F3765);
  static const Color _paletteDarkText = Color(0xFFF8FAFC);
  static const Color _paletteDarkMuted = Color(0xFFB4A8E8);
  static const Color _paletteDarkSurface = Color(0xFF25203F);

  Color _scaffoldBg(bool isDark) => isDark ? _paletteDarkBg : _paletteBg;
  Color _cardBg(bool isDark) => isDark ? _paletteDarkCard : _paletteCardLight;
  Color _borderColor(bool isDark) =>
      isDark ? _paletteDarkBorder : _paletteBorderLight;
  Color _textDark(bool isDark) => isDark ? _paletteDarkText : _paletteDark;
  Color _textMuted(bool isDark) => isDark ? _paletteDarkMuted : _paletteMuted;

  // Active search evaluation logic
  bool get _isFilterActive => _searchQuery.isNotEmpty;

  void _resetAllFilters() {
    setState(() {
      _searchController.clear();
      _searchQuery = '';
      _selectedSort = DealsSortOption.recommended;
    });
    _searchFocusNode.unfocus();
  }

  void _applySuggestion(Map<String, dynamic> suggestion) {
    final term =
        (suggestion['query'] ?? suggestion['label']) as String;
    setState(() {
      _searchController.text = term;
      _searchQuery = term.trim();
    });
  }

  List<DealSearchItem> get _filteredDeals {
    List<DealSearchItem> list = _allDeals.where((deal) {
      // Query filter
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matchTitle = deal.title.toLowerCase().contains(q);
        final matchBrand = deal.brand.toLowerCase().contains(q);
        final matchStore = deal.store.toLowerCase().contains(q);
        final matchCategory = deal.category.toLowerCase().contains(q);
        final matchDesc = deal.description.toLowerCase().contains(q);
        if (!matchTitle &&
            !matchBrand &&
            !matchStore &&
            !matchCategory &&
            !matchDesc) {
          return false;
        }
      }
      return true;
    }).toList();

    // Sort evaluation
    switch (_selectedSort) {
      case DealsSortOption.recommended:
        list.sort((a, b) {
          if (a.isPopular && !b.isPopular) return -1;
          if (!a.isPopular && b.isPopular) return 1;
          return b.discountPercentage.compareTo(a.discountPercentage);
        });
        break;
      case DealsSortOption.priceLowToHigh:
        list.sort((a, b) => a.currentPrice.compareTo(b.currentPrice));
        break;
      case DealsSortOption.priceHighToLow:
        list.sort((a, b) => b.currentPrice.compareTo(a.currentPrice));
        break;
      case DealsSortOption.biggestDiscount:
        list.sort(
            (a, b) => b.discountPercentage.compareTo(a.discountPercentage));
        break;
      case DealsSortOption.highestCashback:
        list.sort((a, b) => b.cashbackAmount.compareTo(a.cashbackAmount));
        break;
    }

    return list;
  }

  List<PopularStoreItem> get _filteredStores {
    if (_searchQuery.isEmpty) return _popularStores;
    final q = _searchQuery.toLowerCase();
    return _popularStores.where((s) {
      return s.name.toLowerCase().contains(q) ||
          s.category.toLowerCase().contains(q) ||
          s.tag.toLowerCase().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textDark = _textDark(isDark);
    final textMuted = _textMuted(isDark);

    return Scaffold(
      backgroundColor: _scaffoldBg(isDark),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // 1. Top Search Header
            _buildSearchHeader(isDark, textDark, textMuted),

            // 2. Main Body: Suggestions + Stores + Deals OR Search Results
            Expanded(
              child: _isFilterActive
                  ? _buildSearchResultsBody(isDark, textDark, textMuted)
                  : _buildZeroStateBody(isDark, textDark, textMuted),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // 1. SEARCH HEADER
  // ===========================================================================
  Widget _buildSearchHeader(
    bool isDark,
    Color textDark,
    Color textMuted,
  ) {
    final cardBg = _cardBg(isDark);
    final borderColor = _borderColor(isDark);

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 16, 10),
      color: _scaffoldBg(isDark),
      child: Row(
        children: [
          // Back Button
          IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: textDark,
              size: 20,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 4),

          // Search Field Pill matching main Best Deals search bar
          Expanded(
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: _searchFocusNode.hasFocus
                      ? _paletteAccent
                      : borderColor,
                  width: 1.2,
                ),
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
                  Icon(
                    Icons.search_rounded,
                    color: _paletteAccent,
                    size: 22,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      focusNode: _searchFocusNode,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: textDark,
                      ),
                      cursorColor: _paletteAccent,
                      textInputAction: TextInputAction.search,
                      onChanged: (val) {
                        setState(() {
                          _searchQuery = val.trim();
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search deals, products, or stores...',
                        hintStyle: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: textMuted,
                        ),
                        isDense: true,
                        filled: false,
                        fillColor: Colors.transparent,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  if (_searchQuery.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        _searchController.clear();
                        setState(() {
                          _searchQuery = '';
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Icon(
                          Icons.close_rounded,
                          color: textMuted,
                          size: 18,
                        ),
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
  // 3A. ZERO STATE BODY (Before User Types)
  // Shows: Trending Suggestions, Popular Brand Stores, Popular Deals, Featured Products
  // ===========================================================================
  Widget _buildZeroStateBody(
    bool isDark,
    Color textDark,
    Color textMuted,
  ) {
    final popularDeals = _allDeals.where((d) => d.isPopular).toList();
    final topFeaturedProducts = _allDeals.take(5).toList();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. 🔥 "TRENDING NOW" - Horizontal single line with 4-5 suggestions
          _buildTrendingSuggestionsSection(isDark, textDark, textMuted),
          const SizedBox(height: 20),

          // 2. 🏬 POPULAR BRAND STORES
          _buildPopularStoresSection(isDark, textDark, textMuted),
          const SizedBox(height: 22),

          // 3. ⚡ POPULAR DEALS TODAY
          _buildPopularDealsSection(popularDeals, isDark, textDark, textMuted),
          const SizedBox(height: 22),

          // 4. 🛍️ FEATURED PRODUCTS - Horizontal slide showing top 4-5 products
          _buildFeaturedProductsSlideSection(
              topFeaturedProducts, isDark, textDark, textMuted),
        ],
      ),
    );
  }

  // Section 1: Trending Suggestions (4-5 suggestions in a horizontal line)
  Widget _buildTrendingSuggestionsSection(
    bool isDark,
    Color textDark,
    Color textMuted,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: const Color(0xFFF97316).withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.whatshot_rounded,
                  color: Color(0xFFF97316),
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Trending Now',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: textDark,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: _paletteAccent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Tap to search',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: _paletteAccent,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        // Horizontal single line of 4-5 suggestion pills
        SizedBox(
          height: 38,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _trendingSuggestions.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final sug = _trendingSuggestions[index];
              final label = sug['label'] as String;
              final icon = sug['icon'] as IconData;

              return InkWell(
                onTap: () => _applySuggestion(sug),
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isDark ? _paletteDarkCard : Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: _borderColor(isDark),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: isDark ? 0.2 : 0.02,
                        ),
                        blurRadius: 4,
                        offset: const Offset(0, 1.5),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icon, size: 14, color: _paletteAccent),
                      const SizedBox(width: 6),
                      Text(
                        label,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: textDark,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Section 2: Popular Brand Stores
  Widget _buildPopularStoresSection(
    bool isDark,
    Color textDark,
    Color textMuted,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Popular Brand Stores',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: textDark,
                ),
              ),
              Text(
                '${_popularStores.length} Stores',
                style: GoogleFonts.inter(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: textMuted,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        SizedBox(
          height: 132,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _popularStores.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final store = _popularStores[index];
              return _buildPopularStoreCard(store, isDark, textDark, textMuted);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPopularStoreCard(
    PopularStoreItem store,
    bool isDark,
    Color textDark,
    Color textMuted,
  ) {
    final cardBg = _cardBg(isDark);
    final borderColor = _borderColor(isDark);

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => StoreDetailScreen(
              storeName: store.name,
              cashbackRate: store.cashbackRate,
              logoUrl: store.logoUrl,
              category: store.category,
              websiteUrl: store.websiteUrl,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 130,
        padding: const EdgeInsets.fromLTRB(10, 12, 10, 10),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Store Logo
            SizedBox(
              height: 38,
              child: Center(
                child: NetworkImageWithSkeleton(
                  imageUrl: BrandAssetHelper.getBrandLogo(store.name),
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // Store Name & Tag
            Column(
              children: [
                Text(
                  store.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  store.tag,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: textMuted,
                  ),
                ),
              ],
            ),

            // Cashback Rate Pill
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: _paletteAccent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                store.cashbackRate,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: _paletteAccent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Section 3: Popular Deals Today
  Widget _buildPopularDealsSection(
    List<DealSearchItem> deals,
    bool isDark,
    Color textDark,
    Color textMuted,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text('⚡', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 6),
                  Text(
                    'Popular Deals Today',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: textDark,
                    ),
                  ),
                ],
              ),
              Text(
                'Top Discounts',
                style: GoogleFonts.inter(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: _paletteAccent,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        SizedBox(
          height: 228,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: deals.length,
            separatorBuilder: (_, _) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final deal = deals[index];
              return _buildPopularDealHorizontalCard(
                  deal, isDark, textDark, textMuted);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPopularDealHorizontalCard(
    DealSearchItem deal,
    bool isDark,
    Color textDark,
    Color textMuted,
  ) {
    final cardBg = _cardBg(isDark);
    final borderColor = _borderColor(isDark);

    return InkWell(
      onTap: () => _openProductDetail(deal),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 172,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Image with discount tag
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: 104,
                    width: double.infinity,
                    color: isDark ? _paletteDarkSurface : _paletteSurfaceSubtle,
                    child: NetworkImageWithSkeleton(
                      imageUrl: deal.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 6,
                  left: 6,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF4444),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${deal.discountPercentage.toInt()}% OFF',
                      style: GoogleFonts.inter(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 6,
                  right: 6,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.65),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      deal.store,
                      style: GoogleFonts.inter(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Brand & Title
            Text(
              deal.brand.toUpperCase(),
              style: GoogleFonts.inter(
                fontSize: 9.5,
                fontWeight: FontWeight.w700,
                color: _paletteAccent,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              deal.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: textDark,
              ),
            ),
            const Spacer(),

            // Prices
            Row(
              children: [
                Text(
                  '₹${deal.currentPrice.toInt()}',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: textDark,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '₹${deal.originalPrice.toInt()}',
                  style: GoogleFonts.inter(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w500,
                    color: textMuted,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),

            // Cashback Tag
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '+ ₹${deal.cashbackAmount.toInt()} Cashback',
                style: GoogleFonts.inter(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF059669),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Section 4: Featured Products Horizontal Slide (Top 4-5 products)
  Widget _buildFeaturedProductsSlideSection(
    List<DealSearchItem> products,
    bool isDark,
    Color textDark,
    Color textMuted,
  ) {
    final topProducts = products.take(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Featured Products',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: textDark,
                ),
              ),
              Text(
                'Top 5 Deals',
                style: GoogleFonts.inter(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: textMuted,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 236,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: topProducts.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final product = topProducts[index];
              return _buildPopularDealHorizontalCard(
                product,
                isDark,
                textDark,
                textMuted,
              );
            },
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // 3B. FILTERED / SEARCH RESULTS BODY
  // ===========================================================================
  Widget _buildSearchResultsBody(
    bool isDark,
    Color textDark,
    Color textMuted,
  ) {
    final deals = _filteredDeals;
    final matchingStores = _filteredStores;

    if (deals.isEmpty && matchingStores.isEmpty) {
      return _buildEmptyState(isDark, textDark, textMuted);
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Results Header & Active Filters Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${deals.length} deals found',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: textDark,
                ),
              ),
              // Sort Trigger
              PopupMenuButton<DealsSortOption>(
                initialValue: _selectedSort,
                onSelected: (sort) {
                  setState(() {
                    _selectedSort = sort;
                  });
                },
                color: _cardBg(isDark),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: _borderColor(isDark)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.sort_rounded,
                      size: 16,
                      color: _paletteAccent,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _selectedSort.label,
                      style: GoogleFonts.inter(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: _paletteAccent,
                      ),
                    ),
                  ],
                ),
                itemBuilder: (ctx) => DealsSortOption.values.map((sort) {
                  return PopupMenuItem(
                    value: sort,
                    child: Text(
                      sort.label,
                      style: GoogleFonts.inter(
                        fontSize: 12.5,
                        fontWeight: _selectedSort == sort
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: _selectedSort == sort
                            ? _paletteAccent
                            : textDark,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Matching Stores (if any query matches store name)
          if (matchingStores.isNotEmpty && _searchQuery.isNotEmpty) ...[
            Text(
              'Matching Stores',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: textDark,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 110,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: matchingStores.length,
                separatorBuilder: (_, _) => const SizedBox(width: 10),
                itemBuilder: (context, idx) {
                  final s = matchingStores[idx];
                  return _buildPopularStoreCard(s, isDark, textDark, textMuted);
                },
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Product Deals Grid
          if (deals.isNotEmpty) ...[
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: deals.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.65,
              ),
              itemBuilder: (context, index) {
                final deal = deals[index];
                return _buildDealGridCard(deal, isDark, textDark, textMuted);
              },
            ),
          ],
        ],
      ),
    );
  }

  // 2-Column Product / Deal Grid Card
  Widget _buildDealGridCard(
    DealSearchItem deal,
    bool isDark,
    Color textDark,
    Color textMuted,
  ) {
    final cardBg = _cardBg(isDark);
    final borderColor = _borderColor(isDark);

    return InkWell(
      onTap: () => _openProductDetail(deal),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Stack
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    height: 112,
                    width: double.infinity,
                    color: isDark ? _paletteDarkSurface : _paletteSurfaceSubtle,
                    child: NetworkImageWithSkeleton(
                      imageUrl: deal.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Discount Badge
                Positioned(
                  top: 6,
                  left: 6,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF4444),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${deal.discountPercentage.toInt()}% OFF',
                      style: GoogleFonts.inter(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                // Store Pill
                Positioned(
                  bottom: 6,
                  right: 6,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      deal.store,
                      style: GoogleFonts.inter(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Category & Brand
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    deal.brand.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w700,
                      color: _paletteAccent,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      size: 13,
                      color: Color(0xFFF59E0B),
                    ),
                    const SizedBox(width: 2),
                    Text(
                      deal.rating.toString(),
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: textDark,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 3),

            // Product Title
            Text(
              deal.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: textDark,
                height: 1.25,
              ),
            ),
            const Spacer(),

            // Price Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  '₹${deal.currentPrice.toInt()}',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: textDark,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '₹${deal.originalPrice.toInt()}',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: textMuted,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),

            // Cashback Badge & Effective Price
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.monetization_on_rounded,
                    size: 11,
                    color: Color(0xFF059669),
                  ),
                  const SizedBox(width: 3),
                  Expanded(
                    child: Text(
                      '+ ₹${deal.cashbackAmount.toInt()} Cashback',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF059669),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Empty State Widget
  Widget _buildEmptyState(
    bool isDark,
    Color textDark,
    Color textMuted,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _paletteAccent.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.search_off_rounded,
                size: 48,
                color: _paletteAccent,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No deals match your search',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: textDark,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Try searching for another product name, store, or brand.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 12.5,
                color: textMuted,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _resetAllFilters,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: Text(
                'Clear Search',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _paletteAccent,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }


  // Detail navigation helper
  void _openProductDetail(DealSearchItem deal) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProductDetailScreen(
          customTitle: deal.title,
          customBrandName: deal.brand,
          customCategory: deal.category,
          customOriginalPrice: '₹${deal.originalPrice.toInt()}',
          customDiscountedPrice: '₹${deal.currentPrice.toInt()}',
          customDiscountTag: '${deal.discountPercentage.toInt()}% OFF',
          customCashbackTag: '+ ₹${deal.cashbackAmount.toInt()} Cashback',
          customFinalPrice: '₹${deal.effectivePrice.toInt()}',
          customDescription: deal.description.isNotEmpty
              ? deal.description
              : '${deal.title} by ${deal.brand}. Available on ${deal.store} with stacked cashback.',
          customImageUrl: deal.imageUrl,
          customImages: [deal.imageUrl],
          customWebsiteUrl: deal.websiteUrl,
        ),
      ),
    );
  }
}
