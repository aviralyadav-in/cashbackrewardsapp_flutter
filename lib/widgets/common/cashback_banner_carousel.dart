import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/brand_model.dart';
import '../../screens/products/shopping_confirmation_screen.dart';
import '../../services/brand_service.dart';
import '../../theme/app_theme.dart';
import 'network_image_with_skeleton.dart';

class CashbackBannerCarousel extends StatefulWidget {
  final bool? isDark;
  const CashbackBannerCarousel({super.key, this.isDark});

  @override
  State<CashbackBannerCarousel> createState() => _CashbackBannerCarouselState();
}

class _CashbackBannerCarouselState extends State<CashbackBannerCarousel> {
  static const int _kInitialPage = 10000;
  static const Duration _kAutoScrollInterval = Duration(seconds: 4);
  late final PageController _pageController;
  final BrandService _brandService = BrandService();
  Timer? _autoScrollTimer;

  List<BrandModel> _brands = [];
  bool _isLoading = true;
  int _currentPage = _kInitialPage;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.92, initialPage: _kInitialPage);
    _fetchBrands();
  }

  Future<void> _fetchBrands() async {
    final list = await _brandService.loadBrands();
    final filtered = list
        .where((b) => !b.name.toLowerCase().contains('amazon'))
        .toList();
    if (mounted) {
      setState(() {
        _brands = filtered;
        _isLoading = false;
      });
      _startAutoScroll();
    }
  }

  void _startAutoScroll() {
    _autoScrollTimer?.cancel();
    if (_brands.isEmpty) return;

    _autoScrollTimer = Timer.periodic(_kAutoScrollInterval, (_) {
      if (_pageController.hasClients && mounted) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  void _pauseAutoScroll() {
    _autoScrollTimer?.cancel();
  }

  void _resumeAutoScroll() {
    _startAutoScroll();
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  String _getCardLogoUrl(BrandModel brand) {
    final rawUrl = brand.logoUrl.trim();
    if (rawUrl.startsWith('assets/cards/')) {
      return rawUrl;
    }

    final nameLower = brand.name.toLowerCase();
    final logoLower = rawUrl.toLowerCase();

    if (nameLower.contains('dot') || logoLower.contains('dot')) {
      return 'assets/cards/dotandkey-coupons.png';
    }
    if (nameLower.contains('amazon') || logoLower.contains('amazon')) {
      return 'assets/cards/amazon.jpg';
    }
    if (nameLower.contains('myntra') || logoLower.contains('myntra')) {
      return 'assets/cards/myntra.jpg';
    }
    if (nameLower.contains('flipkart') || logoLower.contains('flipkart')) {
      return 'assets/cards/flipkart-electronics.png';
    }
    if (nameLower.contains('ajio') || logoLower.contains('ajio')) {
      return 'assets/cards/ajio-coupons.jpg';
    }
    if (nameLower.contains('nykaa') || logoLower.contains('nykaa')) {
      return 'assets/cards/nykaa.jpg';
    }
    if (nameLower.contains('mcaffeine') || nameLower.contains('caffeine') || logoLower.contains('caffeine')) {
      return 'assets/cards/mcaffeine-coupons.jpg';
    }
    if (nameLower.contains('hyuga') || logoLower.contains('hyuga')) {
      return 'assets/cards/hyugalife-coupons.jpg';
    }
    if (nameLower.contains('reliance') || logoLower.contains('reliance')) {
      return 'assets/cards/jiomart-electronics.png';
    }
    if (nameLower.contains('meesho') || logoLower.contains('meesho')) {
      return 'assets/cards/shopsy-coupons.png';
    }
    if (nameLower.contains('aqua') || logoLower.contains('aqua')) {
      return 'assets/cards/aqualogica-coupons.png';
    }
    if (nameLower.contains('boat') || logoLower.contains('boat')) {
      return 'assets/cards/boat-coupon.jpg';
    }
    if (nameLower.contains('tatacliq') || logoLower.contains('tatacliq')) {
      return 'assets/cards/tatacliq-coupons.png';
    }
    if (nameLower.contains('dyson') || logoLower.contains('dyson')) {
      return 'assets/cards/dyson-discount-codes.jpg';
    }
    if (nameLower.contains('netmeds') || logoLower.contains('netmeds')) {
      return 'assets/cards/netmeds-coupons.jpg';
    }
    if (nameLower.contains('noise') || logoLower.contains('noise')) {
      return 'assets/cards/gonoise-coupons.jpg';
    }
    if (nameLower.contains('foxtale') || logoLower.contains('foxtale')) {
      return 'assets/cards/foxtale-coupons.jpg';
    }
    if (nameLower.contains('derma') || logoLower.contains('derma')) {
      return 'assets/cards/thedermaco-coupons.jpg';
    }
    if (nameLower.contains('kapiva') || logoLower.contains('kapiva')) {
      return 'assets/cards/kapiva-coupons.jpg';
    }
    if (nameLower.contains('cleartrip') || logoLower.contains('cleartrip')) {
      return 'assets/cards/cleartrip.png';
    }

    if (logoLower.endsWith('.svg') || logoLower.contains('assets/logos')) {
      return 'assets/cards/amazon.jpg';
    }

    return rawUrl;
  }

  String _get3DBannerAsset(BrandModel brand) {
    final nameLower = brand.name.toLowerCase();
    final catLower = brand.category.toLowerCase();

    // 1. Personal Care / Skincare / Beauty (MCaffeine, Dot & Key, Aqualogica, Nykaa)
    if (nameLower.contains('mcaffeine') ||
        nameLower.contains('caffeine') ||
        nameLower.contains('dot') ||
        nameLower.contains('key') ||
        nameLower.contains('aqua') ||
        nameLower.contains('nykaa') ||
        catLower.contains('beauty') ||
        catLower.contains('skincare')) {
      return 'assets/banners/cosmetics_banner_clean.jpg';
    }

    // 2. Shopping / Multi-category (Shopsy, Meesho)
    if (nameLower.contains('meesho') ||
        nameLower.contains('shopsy') ||
        catLower.contains('budget') ||
        catLower.contains('shopping')) {
      return 'assets/banners/shopping_banner_clean.jpg';
    }

    // 3. Fashion & Lifestyle (Myntra, AJIO)
    if (nameLower.contains('myntra') ||
        nameLower.contains('ajio') ||
        catLower.contains('fashion') ||
        catLower.contains('lifestyle')) {
      return 'assets/banners/sneaker_banner_clean.jpg';
    }

    // 4. Mobiles & Smartphones (Flipkart)
    if (nameLower.contains('flipkart') ||
        catLower.contains('mobile') ||
        nameLower.contains('phone')) {
      return 'assets/banners/phone_banner_clean.jpg';
    }

    // 5. Electronics / Smartwatches / Tech (Amazon, Reliance Digital)
    if (nameLower.contains('amazon') ||
        nameLower.contains('reliance') ||
        nameLower.contains('digital') ||
        catLower.contains('electronic') ||
        catLower.contains('tech')) {
      return 'assets/banners/watch_banner_clean.jpg';
    }

    // 6. Default clean high-visibility asset
    return 'assets/banners/cosmetics_banner_clean.jpg';
  }

  (String prefix, String rate, String suffix) _parseCashback(String rawText) {
    final text = rawText.trim();
    if (text.isEmpty) return ('Flat ', '15%', 'Cashback');

    final lower = text.toLowerCase();
    String prefix = 'Flat ';
    String rate = '15%';
    String suffix = 'Cashback';

    final match = RegExp(r'(\d+(?:\.\d+)?%)').firstMatch(text);
    if (match != null) {
      rate = match.group(1)!;
      final before = text.substring(0, match.start).trim();
      final after = text.substring(match.end).trim();
      if (before.isNotEmpty) {
        prefix = before.endsWith(' ') ? before : '$before ';
      } else {
        prefix = 'Flat ';
      }
      if (after.isNotEmpty) {
        suffix = after;
      }
    } else if (lower.startsWith('up to')) {
      prefix = 'Up to ';
      rate = text.substring(5).trim();
    } else if (lower.startsWith('flat')) {
      prefix = 'Flat ';
      rate = text.substring(4).trim();
    } else {
      rate = text;
    }

    return (prefix, rate, suffix);
  }

  void _onBannerTap(BrandModel brand) {
    final cardLogo = _getCardLogoUrl(brand);
    final effectiveBrand = brand.logoUrl == cardLogo
        ? brand
        : BrandModel(
            name: brand.name,
            logoUrl: cardLogo,
            bannerUrl: brand.bannerUrl,
            cashbackPercentage: brand.cashbackPercentage,
            category: brand.category,
            offerText: brand.offerText,
            websiteUrl: brand.websiteUrl,
          );
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ShoppingConfirmationScreen(brand: effectiveBrand),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark ?? (Theme.of(context).brightness == Brightness.dark);

    final activeBrands = _brands
        .where((b) =>
            !b.name.toLowerCase().contains('amazon') &&
            !b.logoUrl.toLowerCase().contains('amazon') &&
            !b.websiteUrl.toLowerCase().contains('amazon'))
        .toList();

    if (_isLoading) {
      return SizedBox(
        height: 176,
        child: Center(
          child: CircularProgressIndicator(
            color: isDark ? AppColors.darkPrimary : const Color(0xFF6738EB),
          ),
        ),
      );
    }

    if (activeBrands.isEmpty) {
      return const SizedBox.shrink();
    }

    final activeIndex = ((_currentPage % activeBrands.length) + activeBrands.length) % activeBrands.length;

    return Column(
      children: [
        // HORIZONTAL SWIPEABLE CAROUSEL (176px height for enhanced typography breathing room)
        SizedBox(
          height: 176,
          child: Listener(
            onPointerDown: (_) => _pauseAutoScroll(),
            onPointerUp: (_) => _resumeAutoScroll(),
            onPointerCancel: (_) => _resumeAutoScroll(),
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                final actualIndex = ((index % activeBrands.length) + activeBrands.length) % activeBrands.length;
                final brand = activeBrands[actualIndex];

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: GestureDetector(
                    onTap: () => _onBannerTap(brand),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E1935) : const Color(0xFFF7F5FE),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: isDark ? const Color(0xFF382F5E) : const Color(0xFFE2DCF8),
                          width: 1.1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF6738EB).withValues(alpha: isDark ? 0.25 : 0.07),
                            blurRadius: 12,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(22),
                        child: _buildShowcaseCard(brand, isDark),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        const SizedBox(height: 8),

        // CAROUSEL DOT INDICATORS
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(activeBrands.length, (index) {
            final isActive = activeIndex == index;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: isActive ? 18 : 5,
              height: 5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: isActive
                    ? const Color(0xFF5B30E5)
                    : (isDark ? const Color(0xFF3D3560) : const Color(0xFFD6CAF6)),
              ),
            );
          }),
        ),
      ],
    );
  }

  /// Showcase banner matching the requested layout with increased logo, fonts and no badge over image
  Widget _buildShowcaseCard(BrandModel brand, bool isDark) {
    final (prefix, rate, suffix) = _parseCashback(brand.cashbackPercentage);

    final textDark = isDark ? Colors.white : const Color(0xFF191332);
    final subtitleColor = isDark ? const Color(0xFFDDD6FE) : const Color(0xFF382F58);

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth;
        final cardHeight = constraints.maxHeight;

        return Stack(
          children: [
            // 1. SOFT LILAC / STUDIO BACKGROUND GRADIENT
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDark
                        ? [
                            const Color(0xFF201B39),
                            const Color(0xFF18142D),
                          ]
                        : [
                            const Color(0xFFF8F6FE),
                            const Color(0xFFF1EDFD),
                            const Color(0xFFEBE3FB),
                          ],
                  ),
                ),
              ),
            ),

            // 2. 3D STUDIO PRODUCT RENDER (Right Side - clean, unblocked view)
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              width: cardWidth * 0.50,
              child: Image.asset(
                _get3DBannerAsset(brand),
                fit: BoxFit.cover,
                alignment: Alignment.centerRight,
              ),
            ),

            // 3. SEAMLESS GRADIENT BLEND (Softly feathers background over the product on the left)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: isDark
                        ? [
                            const Color(0xFF201B39),
                            const Color(0xFF201B39).withValues(alpha: 0.95),
                            const Color(0xFF201B39).withValues(alpha: 0.35),
                            const Color(0xFF201B39).withValues(alpha: 0.0),
                          ]
                        : [
                            const Color(0xFFF8F6FE),
                            const Color(0xFFF8F6FE).withValues(alpha: 0.95),
                            const Color(0xFFF8F6FE).withValues(alpha: 0.35),
                            const Color(0xFFF8F6FE).withValues(alpha: 0.0),
                          ],
                    stops: const [0.0, 0.46, 0.68, 0.95],
                  ),
                ),
              ),
            ),

            // 4. LEFT CONTENT COLUMN
            Positioned(
              top: 10,
              left: 14,
              bottom: 10,
              width: cardWidth * 0.60,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: cardWidth * 0.60,
                  height: cardHeight - 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // ITEM 1: BRAND LOGO PILL (Increased width & height for superior brand visibility)
                      Container(
                        width: 98,
                        height: 38,
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isDark ? const Color(0xFF382F5E) : const Color(0xFFE5DFF6),
                            width: 1.0,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.06),
                              blurRadius: 5,
                              offset: const Offset(0, 1.5),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(7),
                          child: NetworkImageWithSkeleton(
                            imageUrl: _getCardLogoUrl(brand),
                            fit: BoxFit.contain,
                            shape: BoxShape.rectangle,
                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                child: Text(
                                  brand.name,
                                  style: GoogleFonts.inter(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 11.5,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      // ITEM 2: MAIN HEADLINE ("Flat 15% Cashback" / "Up to 8% Cashback")
                      RichText(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: prefix,
                              style: GoogleFonts.inter(
                                fontSize: 18.5,
                                fontWeight: FontWeight.w800,
                                color: textDark,
                                letterSpacing: -0.4,
                              ),
                            ),
                            TextSpan(
                              text: rate,
                              style: GoogleFonts.inter(
                                fontSize: 21.5,
                                fontWeight: FontWeight.w900,
                                color: const Color(0xFF6738EB),
                                letterSpacing: -0.4,
                              ),
                            ),
                            TextSpan(
                              text: ' $suffix',
                              style: GoogleFonts.inter(
                                fontSize: 18.5,
                                fontWeight: FontWeight.w800,
                                color: textDark,
                                letterSpacing: -0.4,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // ITEM 3: SUBTITLE - INCREASED FONT SIZE (13.5) & WEIGHT (w700)
                      Text(
                        'on ${brand.name} ${brand.category}',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: subtitleColor,
                          letterSpacing: -0.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      // ITEM 4: 2 POINTS - INCREASED FONT SIZE & WEIGHT
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Point 1: Lowest Prices
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isDark ? const Color(0xFF2C234E) : const Color(0xFFECE7FC),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.local_offer_outlined,
                                size: 13.0,
                                color: Color(0xFF6738EB),
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Lowest Prices',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w800,
                              color: textDark,
                              letterSpacing: -0.1,
                            ),
                          ),

                          // Subtle Vertical Divider Line
                          Container(
                            width: 1.2,
                            height: 16,
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            color: isDark ? const Color(0xFF45396D) : const Color(0xFFD6CAF6),
                          ),

                          // Point 2: Extra Savings on Top Deals
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isDark ? const Color(0xFF2C234E) : const Color(0xFFECE7FC),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.star_outline_rounded,
                                size: 14.0,
                                color: Color(0xFF6738EB),
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Extra Savings\non Top Deals',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11.0,
                              fontWeight: FontWeight.w800,
                              height: 1.15,
                              color: textDark,
                              letterSpacing: -0.1,
                            ),
                            maxLines: 2,
                          ),
                        ],
                      ),

                      // ITEM 5: "Shop Now →" CTA BUTTON (Vibrant solid violet pill button)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7.5),
                        decoration: BoxDecoration(
                          color: const Color(0xFF5B30E5),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF5B30E5).withValues(alpha: 0.35),
                              blurRadius: 7,
                              offset: const Offset(0, 2.5),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Shop Now',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13.0,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 5),
                            const Icon(
                              Icons.arrow_forward_rounded,
                              size: 14.0,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
