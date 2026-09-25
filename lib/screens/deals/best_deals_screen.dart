import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../models/home_discovery_models.dart';
import '../../providers/home_provider.dart';
import '../../services/app_cashback_engine.dart';
import '../../theme/app_theme.dart';
import 'all_best_deals_screen.dart';
import 'best_deals_search_screen.dart';
import '../products/product_detail_screen.dart';
import '../stores/store_detail_screen.dart';



/// BestDealsScreen: Redesigned matching reference image with 12 curated sections.
class BestDealsScreen extends StatefulWidget {
  static const String routeName = '/best-deals';
  final VoidCallback? onBack;

  const BestDealsScreen({super.key, this.onBack});

  @override
  State<BestDealsScreen> createState() => _BestDealsScreenState();
}

class _BestDealsScreenState extends State<BestDealsScreen> {




  // Section data comes from GET /api/home (offline fallback in HomeService).
  // Top Deals, Best Store Deals and Price Drops reuse the shared home feed so
  // prices, cashback rates and products stay consistent with the Home screen.
  HomeProvider get _home => Provider.of<HomeProvider>(context, listen: false);
  BestDealsPageModel get _page => _home.bestDealsPage;

  List<BestDealModel> get _topCategoryDeals => _home.topDealsByCategory;
  List<HighestCashbackDealModel> get _highestCashbackDeals =>
      _page.highestCashbackDeals;
  List<BestProductDealModel> get _bestProductDeals => _page.bestProductDeals;
  List<HotelDealModel> get _hotelDeals => _page.hotelDeals;
  List<FlashDealModel> get _flashDeals => _page.flashDeals;
  List<BankOfferModel> get _bankOffers => _page.bankOffers;
  List<BiggestDiscountModel> get _biggestDiscounts => _page.biggestDiscounts;
  List<FeaturedStoreModel> get _bestStores => _home.topCashbackStores;
  List<PriceDropModel> get _priceDrops => _home.priceDrops;
  List<RecommendationPillModel> get _recommendationPills =>
      _page.recommendationPills;

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
    // Subscribe so every section rebuilds when home data or personalisation changes.
    context.watch<HomeProvider>();

    return Scaffold(
      backgroundColor: _scaffoldBg(isDark),
      appBar: _buildAppBar(isDark),
      body: RefreshIndicator(
        color: _paletteAccent,
        onRefresh: () => _home.fetchHomeData(),
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
    return AppBar(
      backgroundColor: _scaffoldBg(isDark),
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      leading: (widget.onBack != null || Navigator.of(context).canPop())
          ? IconButton(
              onPressed: () {
                if (widget.onBack != null) {
                  widget.onBack!();
                } else if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                }
              },
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: isDark ? AppColors.darkTextPrimary : AppColors.primaryBrown,
                size: 20,
              ),
            )
          : null,
      title: Text(
        'Best Deals',
        style: AppTextStyles.screenHeading(
          color: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
        ),
      ),
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
    final allDeals = _home.personalizedBestDeals;
    if (_topCategoryDeals.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header with "SEE ALL (n)": n is the size of the list it opens
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
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          AllBestDealsScreen(title: 'Top Deals', deals: allDeals),
                    ),
                  );
                },
                child: Text(
                  'SEE ALL (${allDeals.length})',
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
          height: 210,
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

  /// Store Card Badge for Top Deals For You (e.g. Amazon, Flipkart, Myntra, Tata CLiQ)
  Widget _buildStoreCardBadge(String storeName, bool isDark) {
    final s = storeName.trim().toLowerCase();
    String? svgLogo;

    if (s.contains('amazon')) {
      svgLogo = 'assets/logos/amazon.svg';
    } else if (s.contains('flipkart')) {
      svgLogo = 'assets/logos/flipkart.svg';
    } else if (s.contains('myntra')) {
      svgLogo = 'assets/logos/myntra.svg';
    } else if (s.contains('tatacliq') ||
        s.contains('tata cliq') ||
        s.contains('cliq')) {
      svgLogo = 'assets/logos/tatacliq.svg';
    } else if (s.contains('croma')) {
      svgLogo = 'assets/logos/croma.svg';
    } else if (s.contains('reliance')) {
      svgLogo = 'assets/logos/reliancedigital.svg';
    } else if (s.contains('samsung')) {
      svgLogo = 'assets/logos/samsung.svg';
    } else if (s.contains('nike')) {
      svgLogo = 'assets/logos/nike.svg';
    } else if (s.contains('ajio')) {
      svgLogo = 'assets/logos/ajio.svg';
    } else if (s.contains('shopsy')) {
      svgLogo = 'assets/logos/shopsy.svg';
    } else if (s.contains('apple')) {
      svgLogo = 'assets/logos/apple.svg';
    } else if (s.contains('nykaa')) {
      svgLogo = 'assets/logos/nykaa.svg';
    }

    return Container(
      height: 28,
      constraints: const BoxConstraints(minWidth: 68, maxWidth: 96),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? const Color(0xFF4B4278) : const Color(0xFFD6DCF8),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.06),
            blurRadius: 4,
            offset: const Offset(0, 1.5),
          ),
        ],
      ),
      child: Center(
        child: svgLogo != null
            ? SvgPicture.asset(
                svgLogo,
                height: 15,
                fit: BoxFit.contain,
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.storefront_rounded,
                    size: 13,
                    color: Color(0xFF2D274B),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    storeName,
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF2D274B),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildTopCategoryDealCard(
    BestDealModel item,
    bool isDark,
    double cardWidth,
  ) {
    final cardBg = _cardBg(isDark);
    final borderColor = _borderColor(isDark);
    final textDark = _textDark(isDark);
    final textMuted = _textMuted(isDark);
    final websiteUrl = ProductDetailScreen.resolveStoreUrl(item.store);

    return Container(
      width: cardWidth,
      padding: const EdgeInsets.fromLTRB(11, 10, 11, 10),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top Tag Row: Category rankBadge on left & Store Card on right
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 7,
                  vertical: 3.5,
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
                    Text(
                      _categoryEmoji(item.category),
                      style: const TextStyle(fontSize: 10),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '#1 in ${item.category}',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: _paletteAccent,
                      ),
                    ),
                  ],
                ),
              ),
              // Store card (just like Flipkart, Amazon, Myntra, Tata CLiQ)
              InkWell(
                onTap: () {
                  _openStoreDetail(
                    storeName: item.store,
                    cashbackRate: '+₹${item.cashbackAmount.toInt()} Cashback',
                    logoUrl: 'assets/cards/col_default.jpg',
                    category: item.category,
                    websiteUrl: websiteUrl,
                  );
                },
                borderRadius: BorderRadius.circular(8),
                child: _buildStoreCardBadge(item.store, isDark),
              ),
            ],
          ),
          const SizedBox(height: 8),

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
                      child: _buildDealImage(
                        item.imageUrl,
                        Icon(
                          Icons.shopping_bag_outlined,
                          size: 40,
                          color: _paletteAccent.withValues(alpha: 0.6),
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
              const SizedBox(width: 11),

              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: GoogleFonts.inter(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w800,
                        color: textDark,
                        height: 1.2,
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
                          '₹${item.discountedPrice.toInt()}',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: textDark,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '₹${item.originalPrice.toInt()}',
                          style: GoogleFonts.inter(
                            fontSize: 11,
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
                        fontSize: 12.5,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Savings Pill (styled prominent like Grab Deal Now pill)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3.5,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF059669), Color(0xFF10B981)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF10B981).withValues(alpha: 0.25),
                            blurRadius: 3,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.savings_rounded,
                            size: 12,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              'Save ₹${item.effectiveSavings.toInt()} Total',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
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
          const SizedBox(height: 8),

          // Grab Deal Now CTA Button
          SizedBox(
            width: double.infinity,
            height: 38,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ProductDetailScreen.fromBestDeal(item),
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
                  const Icon(Icons.bolt_rounded, size: 19),
                  const SizedBox(width: 6),
                  Text(
                    'Grab Deal Now',
                    style: GoogleFonts.inter(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.2,
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
            separatorBuilder: (context, index) => const SizedBox(height: 10),
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
                              errorBuilder: (context, error, stackTrace) => Center(
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

  Widget _buildBestProductDealCard(BestProductDealModel item, bool isDark) {
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
                          errorBuilder: (context, error, stackTrace) => Center(
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
              separatorBuilder: (context, index) => const SizedBox(width: 12),
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
                                errorBuilder: (context, error, stackTrace) => const Center(
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
                                errorBuilder: (context, error, stackTrace) => const Center(
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
            separatorBuilder: (context, index) => const SizedBox(height: 10),
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
                            errorBuilder: (context, error, stackTrace) => const Center(
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
            separatorBuilder: (context, index) => const SizedBox(height: 10),
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
                      clipBehavior: Clip.antiAlias,
                      child: _buildDealImage(
                        store.logoUrl,
                        Text(
                          store.name.isNotEmpty ? store.name[0].toUpperCase() : 'S',
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
                          // Brand/store offer
                          Text(
                            storeOfferLabel(store.cashbackRate),
                            style: GoogleFonts.inter(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: _paletteAccent,
                            ),
                          ),
                          // KashIQ cashback (smart deal engine rate)
                          Text(
                            AppCashbackEngine.cashbackLabel(store.name),
                            style: GoogleFonts.inter(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF10B981),
                            ),
                          ),
                          Text(
                            '${store.totalOffers} Active Offers',
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
                            logoUrl: store.logoUrl,
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
            separatorBuilder: (context, index) => const SizedBox(height: 10),
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
                        child: _buildDealImage(
                          drop.imageUrl,
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
                            drop.productName,
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
                              '📉 ₹${drop.priceDropAmount.toInt()} Price Drop',
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
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  ProductDetailScreen.fromPriceDrop(drop),
                            ),
                          );
                        },
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
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: borderColor, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _openSearchScreen(query: item.title),
                    borderRadius: BorderRadius.circular(14),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: _paletteAccent.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(item.icon, size: 18, color: _paletteAccent),
                          ),
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
                          Icon(
                            Icons.chevron_right_rounded,
                            size: 16,
                            color: textMuted.withValues(alpha: 0.6),
                          ),
                        ],
                      ),
                    ),
                  ),
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
              onPressed: () => _openSearchScreen(),
              icon: const Icon(Icons.auto_awesome_rounded, size: 16),
              label: Text(
                'Explore All Deals & Recommendations',
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

  static const Map<String, String> _categoryEmojis = {
    'audio': '🎧',
    'smartphones': '📱',
    'laptops': '💻',
    'footwear': '👟',
    'appliances': '🏠',
    'wearables': '⌚',
    'beauty': '💄',
    'fashion': '👕',
  };

  String _categoryEmoji(String category) =>
      _categoryEmojis[category.trim().toLowerCase()] ?? '🏆';

  /// Backend may send bundled asset paths or remote URLs.
  Widget _buildDealImage(String url, Widget fallback) {
    if (url.startsWith('http')) {
      return Image.network(
        url,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Center(child: fallback),
      );
    }
    return Image.asset(
      url,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Center(child: fallback),
    );
  }

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

  void _openProductDetailFromDeal(BestProductDealModel item) {
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
          customFinalPrice: '₹${(item.currentPrice - item.cashbackAmount).toInt()}',
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
