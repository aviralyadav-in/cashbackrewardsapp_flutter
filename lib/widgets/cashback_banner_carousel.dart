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

  String _get3DProductAsset(BrandModel brand) {
    final nameLower = brand.name.toLowerCase();
    final catLower = brand.category.toLowerCase();

    // 1. Health & Supplements / HyugaLife / Nutrition / Vitamins
    if (nameLower.contains('hyuga') ||
        catLower.contains('health') ||
        catLower.contains('supplement') ||
        catLower.contains('nutrition') ||
        catLower.contains('vitamin') ||
        nameLower.contains('healthkart') ||
        nameLower.contains('kapiva')) {
      return 'assets/banners/supplements_3d.jpg';
    }

    // 2. Electronics & Shopping / Amazon / Watches
    if (nameLower.contains('amazon') || catLower.contains('electronic') || (catLower.contains('shopping') && !catLower.contains('budget'))) {
      return 'assets/banners/watch_3d.jpg';
    }

    // 3. Mobiles / Tech / Flipkart
    if (nameLower.contains('flipkart') || catLower.contains('mobile') || nameLower.contains('phone')) {
      return 'assets/banners/phone_3d.jpg';
    }

    // 4. Fashion & Lifestyle / Footwear / Myntra / Budget Shopping
    if (nameLower.contains('myntra') ||
        catLower.contains('fashion') ||
        catLower.contains('lifestyle') ||
        catLower.contains('budget')) {
      return 'assets/banners/sneaker_3d.jpg';
    }

    // 5. Skincare & Beauty / Dot & Key / Nykaa / MCaffeine / Aqualogica
    if (nameLower.contains('nykaa') ||
        nameLower.contains('caffeine') ||
        nameLower.contains('dot') ||
        nameLower.contains('aqua') ||
        catLower.contains('beauty') ||
        catLower.contains('skin') ||
        catLower.contains('care')) {
      return 'assets/banners/skincare_3d.jpg';
    }

    // 6. Audio / Gadgets / boAt / AJIO / Tech
    if (nameLower.contains('boat') ||
        nameLower.contains('ajio') ||
        nameLower.contains('noise') ||
        catLower.contains('tech') ||
        catLower.contains('gadget') ||
        catLower.contains('trendy')) {
      return 'assets/banners/headphone_3d.jpg';
    }

    // Default fallback to 3D Watch matching reference image
    return 'assets/banners/watch_3d.jpg';
  }

  String _getTitleText(BrandModel brand) {
    if (brand.category.isNotEmpty) {
      if (brand.category.contains('&')) {
        final parts = brand.category.split('&');
        return '${parts[0].trim()} &\n${parts[1].trim()}';
      }
      return brand.category;
    }
    return brand.name;
  }

  String _getSubtitleText(BrandModel brand) {
    if (brand.name.toLowerCase().contains('amazon')) {
      return 'On thousands of items across Electronics, Fashion, Home, and Appliances. No hidden fees.';
    }
    if (brand.offerText.isNotEmpty) {
      final text = brand.offerText.trim();
      if (!text.toLowerCase().contains('hidden')) {
        return '$text. No hidden fees.';
      }
      return text;
    }
    return 'On thousands of items across ${brand.category}. No hidden fees.';
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
        height: 215,
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
        // HORIZONTAL SWIPEABLE CAROUSEL
        SizedBox(
          height: 215,
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
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: isDark ? const Color(0xFF3F3730) : const Color(0xFFDCD0C2),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
                          blurRadius: 14,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: isDark
                            ? const [
                                Color(0xFF2C2520),
                                Color(0xFF221D19),
                                Color(0xFF181512),
                              ]
                            : const [
                                Color(0xFFEDE4DA),
                                Color(0xFFE2D5C6),
                                Color(0xFFD6C6B3),
                              ],
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                      child: Stack(
                        children: [
                          // 1. RIGHT SIDE: 3D REAL PRODUCT IMAGE WITH SMOOTH EDGE DISSOLVE
                          Positioned(
                            top: -6,
                            right: -2,
                            bottom: 24,
                            width: 138,
                            child: ShaderMask(
                              shaderCallback: (rect) {
                                return const LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Colors.transparent,
                                    Color(0x99FFFFFF),
                                    Colors.white,
                                    Colors.white,
                                  ],
                                  stops: [0.0, 0.20, 0.45, 1.0],
                                ).createShader(rect);
                              },
                              blendMode: BlendMode.dstIn,
                              child: Image.asset(
                                _get3DProductAsset(brand),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                          // 2. FLOATING RUPEE BADGE (₹) near bottom-left of 3D product
                          Positioned(
                            bottom: 42,
                            right: 108,
                            child: Container(
                              width: 26,
                              height: 26,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: isDark
                                      ? const [Color(0xFF3D332A), Color(0xFF26201A)]
                                      : const [Color(0xFFFFFBF6), Color(0xFFE4D5C5)],
                                ),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: isDark ? 0.2 : 0.7),
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.12),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  '₹',
                                  style: GoogleFonts.fraunces(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: isDark ? const Color(0xFFF3E7D7) : const Color(0xFF332215),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // 3. BOTTOM-RIGHT CTA BUTTON ("Shop Now to Earn →")
                          Positioned(
                            bottom: 10,
                            right: 10,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 6.5),
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFFF7F2EB) : Colors.white,
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.12),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Shop Now to Earn',
                                    style: GoogleFonts.poppins(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF181818),
                                      letterSpacing: -0.1,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(
                                    Icons.arrow_forward_rounded,
                                    size: 13,
                                    color: Color(0xFF181818),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // 4. LEFT CONTENT: LOGO & TITLE, CASHBACK PILL, SUBTITLE
                          Positioned(
                            top: 14,
                            left: 14,
                            bottom: 12,
                            right: 122,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // TOP: LOGO CIRCLE + CATEGORY TITLE
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(alpha: 0.08),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: ClipOval(
                                        child: NetworkImageWithSkeleton(
                                          imageUrl: _getCardLogoUrl(brand),
                                          fit: BoxFit.contain,
                                          shape: BoxShape.circle,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Center(
                                              child: Text(
                                                brand.name.isNotEmpty
                                                    ? brand.name.substring(0, 1).toUpperCase()
                                                    : '',
                                                style: GoogleFonts.fraunces(
                                                  color: AppColors.primaryBrown,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        _getTitleText(brand),
                                        style: GoogleFonts.poppins(
                                          fontSize: 14.5,
                                          fontWeight: FontWeight.w800,
                                          color: isDark ? AppColors.darkTextPrimary : const Color(0xFF1F2429),
                                          height: 1.15,
                                          letterSpacing: -0.3,
                                        ),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),

                                // MIDDLE: PROMINENT CASHBACK PILL BADGE
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? const Color(0xFF332B24)
                                        : const Color(0xFFF9F5EE),
                                    borderRadius: BorderRadius.circular(24),
                                    border: Border.all(
                                      color: isDark
                                          ? const Color(0xFF4D4036)
                                          : const Color(0xFFE4D7C8),
                                      width: 1,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.06),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    brand.cashbackPercentage,
                                    style: GoogleFonts.fraunces(
                                      color: isDark ? const Color(0xFFF8E9D6) : const Color(0xFF271A10),
                                      fontSize: 15.5,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: -0.2,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),

                                // BOTTOM-LEFT: SUBTITLE / DESCRIPTION
                                Padding(
                                  padding: const EdgeInsets.only(right: 4.0),
                                  child: Text(
                                    _getSubtitleText(brand),
                                    style: GoogleFonts.poppins(
                                      color: isDark
                                          ? const Color(0xFFCCC2B7)
                                          : const Color(0xFF363636),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      height: 1.25,
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),

        const SizedBox(height: 12),

        // CAROUSEL DOT INDICATORS
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_brands.length, (index) {
            final isActive = activeIndex == index;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: isActive ? 20 : 6,
              height: 6,
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
