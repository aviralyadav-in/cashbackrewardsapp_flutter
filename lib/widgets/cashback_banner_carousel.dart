import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/brand_model.dart';
import '../screens/shopping_confirmation_screen.dart';
import '../services/brand_service.dart';
import '../theme/app_theme.dart';
import 'network_image_with_skeleton.dart';

class CashbackBannerCarousel extends StatefulWidget {
  const CashbackBannerCarousel({super.key});

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
    if (mounted) {
      setState(() {
        _brands = list;
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
    if (nameLower.contains('dot') || logoLower.contains('dot')) {
      return 'assets/cards/dotandkey-coupons.png';
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

    // 1. MCaffeine: Amber Glass Coffee Face Serum on Stone Podium (Matches user reference)
    if (nameLower.contains('mcaffeine') || nameLower.contains('caffeine')) {
      return 'assets/banners/mcaffeine_banner_16_9.jpg';
    }

    // 2. Dot & Key: Pastel Fruit Cream Jar on Stone Podium
    if (nameLower.contains('dot') || nameLower.contains('key')) {
      return 'assets/banners/dotkey_banner_16_9.jpg';
    }

    // 3. Aqualogica: Aqua Dew Sunscreen on Stone Podium
    if (nameLower.contains('aqua')) {
      return 'assets/banners/aqualogica_banner_16_9.jpg';
    }

    // 4. Shopsy / Meesho: Luxury Shopping Bags & Gift Boxes with Gold Coins
    if (nameLower.contains('meesho') || nameLower.contains('shopsy') || nameLower.contains('shopsy')) {
      return 'assets/banners/shopsy_banner_16_9.jpg';
    }

    // 5. Reliance Digital: Ultra-Slim 4K TV & Tech on Stone Podium
    if (nameLower.contains('reliance') || nameLower.contains('digital')) {
      return 'assets/banners/reliance_banner_16_9.jpg';
    }

    // 6. AJIO: Wireless Over-Ear Studio Headphones
    if (nameLower.contains('ajio') || nameLower.contains('boat') || nameLower.contains('noise') || catLower.contains('audio')) {
      return 'assets/banners/headphone_banner_16_9.jpg';
    }

    // 7. Myntra: Designer Sneaker on Stone Podium
    if (nameLower.contains('myntra') || catLower.contains('fashion') || catLower.contains('lifestyle')) {
      return 'assets/banners/sneaker_banner_16_9.jpg';
    }

    // 8. Flipkart: Flagship Smartphone on Stone Stand
    if (nameLower.contains('flipkart') || catLower.contains('mobile') || nameLower.contains('phone')) {
      return 'assets/banners/phone_banner_16_9.jpg';
    }

    // 9. HyugaLife: Whey Protein & Supplement Jar on Stone Podium
    if (nameLower.contains('hyuga') || catLower.contains('health') || catLower.contains('supplement') || catLower.contains('nutrition')) {
      return 'assets/banners/supplements_banner_16_9.jpg';
    }

    // 10. Amazon / Electronics: Luxury 3D Smartwatch on Stone Podium
    if (nameLower.contains('amazon') || catLower.contains('electronic')) {
      return 'assets/banners/watch_banner_16_9.jpg';
    }

    // 11. Skincare / Nykaa fallback
    if (nameLower.contains('nykaa') || catLower.contains('beauty') || catLower.contains('skincare')) {
      return 'assets/banners/dotkey_banner_16_9.jpg';
    }

    return 'assets/banners/watch_banner_16_9.jpg';
  }

  Widget _buildCashbackBadge(BrandModel brand, bool isDark) {
    final rawText = brand.cashbackPercentage.trim();
    if (rawText.isEmpty) return const SizedBox.shrink();

    String prefix = '';
    String rate = '';
    String suffix = '';

    final lower = rawText.toLowerCase();
    if (lower.startsWith('up to')) {
      prefix = 'Up to ';
      final rest = rawText.substring(5).trim();
      final spaceIndex = rest.indexOf(' ');
      if (spaceIndex != -1) {
        rate = rest.substring(0, spaceIndex).trim();
        suffix = rest.substring(spaceIndex).trim();
      } else {
        rate = rest;
      }
    } else if (lower.startsWith('flat')) {
      prefix = 'Flat ';
      final rest = rawText.substring(4).trim();
      final spaceIndex = rest.indexOf(' ');
      if (spaceIndex != -1) {
        rate = rest.substring(0, spaceIndex).trim();
        suffix = rest.substring(spaceIndex).trim();
      } else {
        rate = rest;
      }
    } else {
      final match = RegExp(r'(\d+(?:\.\d+)?%)').firstMatch(rawText);
      if (match != null) {
        rate = match.group(1)!;
        prefix = rawText.substring(0, match.start).trim();
        if (prefix.isNotEmpty) prefix = '$prefix ';
        suffix = rawText.substring(match.end).trim();
      } else {
        prefix = '';
        rate = rawText;
        suffix = '';
      }
    }

    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4.5),
        decoration: BoxDecoration(
          color: const Color(0xFF281910),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFFCBA563),
            width: 1.15,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.45),
              blurRadius: 6,
              offset: const Offset(0, 1.5),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF452B1B),
                border: Border.all(
                  color: const Color(0xFFCBA563).withValues(alpha: 0.6),
                  width: 0.8,
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.bolt_rounded,
                  size: 13,
                  color: Color(0xFFF3C77D),
                ),
              ),
            ),
            const SizedBox(width: 6),
            RichText(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                children: [
                  if (prefix.isNotEmpty)
                    TextSpan(
                      text: prefix,
                      style: GoogleFonts.inter(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFFE5CEB5),
                        letterSpacing: -0.1,
                      ),
                    ),
                  TextSpan(
                    text: rate,
                    style: GoogleFonts.inter(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFF3C77D),
                      letterSpacing: -0.2,
                    ),
                  ),
                  if (suffix.isNotEmpty)
                    TextSpan(
                      text: ' $suffix',
                      style: GoogleFonts.inter(
                        fontSize: 13.0,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFFE5CEB5),
                        letterSpacing: -0.1,
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

  Widget _buildCheckBullet({required String text, required bool isDark}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF1B803D),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.4),
              width: 0.8,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.check_rounded,
              size: 9.5,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 5),
        Flexible(
          child: Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 12.0,
              fontWeight: FontWeight.w400,
              color: Colors.white,
              height: 1.15,
              shadows: [
                Shadow(
                  color: Colors.black.withValues(alpha: 0.4),
                  offset: const Offset(0, 1),
                  blurRadius: 2,
                ),
              ],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_isLoading) {
      return SizedBox(
        height: 168,
        child: Center(
          child: CircularProgressIndicator(
            color: isDark ? AppColors.darkTextPrimary : AppColors.primaryBrown,
          ),
        ),
      );
    }

    if (_brands.isEmpty) {
      return const SizedBox.shrink();
    }

    final activeIndex = ((_currentPage % _brands.length) + _brands.length) % _brands.length;

    return Column(
      children: [
        // HORIZONTAL SWIPEABLE CAROUSEL (Compact 168px height)
        SizedBox(
          height: 168,
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
                final actualIndex = ((index % _brands.length) + _brands.length) % _brands.length;
                final brand = _brands[actualIndex];

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: GestureDetector(
                    onTap: () => _onBannerTap(brand),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isDark ? const Color(0xFF3F3730) : const Color(0xFFE4D8CA),
                          width: 1.1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
                            blurRadius: 12,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final cardWidth = constraints.maxWidth;
                            final cardHeight = constraints.maxHeight;
                            final contentRight = (cardWidth * 0.44).clamp(130.0, 175.0);

                            return Stack(
                              children: [
                                // 1. FULL-BLEED 16:9 SEAMLESS PRODUCT & STUDIO BACKGROUND (NO BLUR, 100% SHARP & CLEAN)
                                Positioned.fill(
                                  child: Image.asset(
                                    _get3DBannerAsset(brand),
                                    fit: BoxFit.cover,
                                    alignment: Alignment.centerRight,
                                  ),
                                ),

                                // Soft luxury dark chocolate bronze gradient scrim on the left side
                                Positioned(
                                  top: 0,
                                  left: 0,
                                  bottom: 0,
                                  width: cardWidth * 0.65,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [
                                          const Color(0xFF261811).withValues(alpha: 0.85),
                                          const Color(0xFF2E1D15).withValues(alpha: 0.65),
                                          Colors.transparent,
                                        ],
                                        stops: const [0.0, 0.60, 1.0],
                                      ),
                                    ),
                                  ),
                                ),

                                // 2. LEFT CONTENT COLUMN (Clean typography & interactive elements matching reference image)
                                Positioned(
                                  top: 8,
                                  left: 10,
                                  bottom: 8,
                                  right: contentRight,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    alignment: Alignment.centerLeft,
                                    child: SizedBox(
                                      width: cardWidth - 10 - contentRight,
                                      height: cardHeight - 16,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          // ROW 1: BRAND LOGO CARD (CREAM PILL) + VERTICAL GOLD DIVIDER + NAME & CATEGORY
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: 72,
                                                height: 31,
                                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFFF7EEDA),
                                                  borderRadius: BorderRadius.circular(8),
                                                  border: Border.all(
                                                    color: const Color(0xFFC8A97E).withValues(alpha: 0.7),
                                                    width: 0.9,
                                                  ),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black.withValues(alpha: 0.25),
                                                      blurRadius: 4,
                                                      offset: const Offset(0, 1),
                                                    ),
                                                  ],
                                                ),
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(5),
                                                  child: NetworkImageWithSkeleton(
                                                    imageUrl: _getCardLogoUrl(brand),
                                                    fit: BoxFit.contain,
                                                    shape: BoxShape.rectangle,
                                                    errorBuilder: (context, error, stackTrace) {
                                                      return Center(
                                                        child: Text(
                                                          brand.name,
                                                          style: GoogleFonts.inter(
                                                            color: const Color(0xFF24160E),
                                                            fontWeight: FontWeight.w600,
                                                            fontSize: 9.5,
                                                          ),
                                                          maxLines: 1,
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 6),
                                              Container(
                                                width: 1.2,
                                                height: 22,
                                                color: const Color(0xFFC8A97E),
                                              ),
                                              const SizedBox(width: 6),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      brand.name,
                                                      style: GoogleFonts.inter(
                                                        fontSize: 16.0,
                                                        fontWeight: FontWeight.w500,
                                                        color: const Color(0xFFF7EBDC),
                                                        letterSpacing: 0,
                                                        shadows: [
                                                          Shadow(
                                                            color: Colors.black.withValues(alpha: 0.5),
                                                            offset: const Offset(0, 1),
                                                            blurRadius: 2,
                                                          ),
                                                        ],
                                                      ),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                    if (brand.category.isNotEmpty)
                                                      Text(
                                                        brand.category,
                                                        style: GoogleFonts.inter(
                                                          fontSize: 11.0,
                                                          fontWeight: FontWeight.w400,
                                                          color: const Color(0xFFD6C3AE),
                                                          shadows: [
                                                            Shadow(
                                                              color: Colors.black.withValues(alpha: 0.4),
                                                              offset: const Offset(0, 1),
                                                              blurRadius: 1.5,
                                                            ),
                                                          ],
                                                        ),
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),

                                          // ROW 2: ELEVATED CAPSULE PILL ("⚡ Flat 12% Cashback" IN BRONZE & GOLD)
                                          _buildCashbackBadge(brand, isDark),

                                          // ROW 3: VALUE BULLETS (WITH GREEN CHECK CIRCLES)
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              _buildCheckBullet(
                                                text: 'Lowest Prices Guaranteed',
                                                isDark: isDark,
                                              ),
                                              const SizedBox(height: 2.5),
                                              _buildCheckBullet(
                                                text: 'Extra Savings Over Store Deals',
                                                isDark: isDark,
                                              ),
                                            ],
                                          ),

                                          // ROW 4: "Shop Now to Earn →" DARK CHOCOLATE & GOLD OUTLINE PILL BUTTON
                                          FittedBox(
                                            fit: BoxFit.scaleDown,
                                            alignment: Alignment.centerLeft,
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6.5),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF1E130B),
                                                borderRadius: BorderRadius.circular(22),
                                                border: Border.all(
                                                  color: const Color(0xFFA07E4B),
                                                  width: 1.0,
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black.withValues(alpha: 0.4),
                                                    blurRadius: 5,
                                                    offset: const Offset(0, 2),
                                                  ),
                                                ],
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    'Shop Now to Earn',
                                                    style: GoogleFonts.inter(
                                                      fontSize: 13.5,
                                                      fontWeight: FontWeight.w500,
                                                      color: const Color(0xFFF7EBDC),
                                                      letterSpacing: -0.1,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 5),
                                                  const Icon(
                                                    Icons.arrow_forward_rounded,
                                                    size: 14,
                                                    color: Color(0xFFF7EBDC),
                                                  ),
                                                ],
                                              ),
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
                        ),
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
          children: List.generate(_brands.length, (index) {
            final isActive = activeIndex == index;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: isActive ? 18 : 5,
              height: 5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: isActive
                    ? (isDark ? AppColors.darkTextPrimary : AppColors.deepBrown)
                    : (isDark ? AppColors.darkBorder : AppColors.border),
              ),
            );
          }),
        ),
      ],
    );
  }
}
