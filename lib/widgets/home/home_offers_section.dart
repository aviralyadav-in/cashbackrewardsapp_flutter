import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/utils/brand_asset_helper.dart';
import '../../models/home_discovery_models.dart';
import '../../theme/app_theme.dart';
import '../common/network_image_with_skeleton.dart';

/// A sliding promotional banner carousel for the "🔥 Offers" section on the Home Screen.
/// Renders curated store campaigns as full-bleed, dynamic promotional banners with
/// auto-scroll, smooth page indicators, brand badges, discount pills, and direct CTAs.
class HomeOffersSection extends StatefulWidget {
  final bool isDark;
  final List<HomeOfferModel> offers;
  final VoidCallback onViewAllTap;
  final Function(HomeOfferModel offer) onOfferTap;

  const HomeOffersSection({
    super.key,
    required this.isDark,
    required this.offers,
    required this.onViewAllTap,
    required this.onOfferTap,
  });

  @override
  State<HomeOffersSection> createState() => _HomeOffersSectionState();
}

class _HomeOffersSectionState extends State<HomeOffersSection> {
  static const Duration _kAutoScrollInterval = Duration(seconds: 4);
  late final PageController _pageController;
  Timer? _autoScrollTimer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.92);
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _autoScrollTimer?.cancel();
    if (widget.offers.length <= 1) return;

    _autoScrollTimer = Timer.periodic(_kAutoScrollInterval, (_) {
      if (_pageController.hasClients && mounted) {
        final nextPage = (_currentPage + 1) % widget.offers.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 650),
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

  @override
  Widget build(BuildContext context) {
    if (widget.offers.isEmpty) return const SizedBox.shrink();

    final isDark = widget.isDark;
    final textDark = isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A);
    final textMuted = isDark ? AppColors.darkTextSecondary : const Color(0xFF64748B);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. SECTION HEADER ROW: "🔥 Hot Offers" + "View All >"
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '🔥 Offers',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: textDark,
                  letterSpacing: -0.3,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: widget.onViewAllTap,
                behavior: HitTestBehavior.opaque,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'View All',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkPrimary : Colors.black,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 11.0,
                      color: isDark ? AppColors.darkPrimary : Colors.black,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // 2. SLIDING PROMOTIONAL BANNER CAROUSEL
        NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification is ScrollStartNotification) {
              _pauseAutoScroll();
            } else if (notification is ScrollEndNotification) {
              _resumeAutoScroll();
            }
            return false;
          },
          child: SizedBox(
            height: 180,
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.offers.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                final offer = widget.offers[index];
                return _buildPromotionalOfferBanner(context, offer, isDark, textDark, textMuted);
              },
            ),
          ),
        ),

        // 3. ANIMATED PAGE INDICATOR DOTS
        if (widget.offers.length > 1) ...[
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.offers.length, (index) {
              final isActive = index == _currentPage;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeOutCubic,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                height: 5,
                width: isActive ? 22 : 6,
                decoration: BoxDecoration(
                  color: isActive
                      ? (isDark ? AppColors.darkPrimary : AppColors.accentBlue)
                      : (isDark
                          ? AppColors.darkSurface
                          : const Color(0xFFD6DCF8)),
                  borderRadius: BorderRadius.circular(3),
                ),
              );
            }),
          ),
        ],
      ],
    );
  }

  /// Builds a single promotional campaign banner for the offer
  Widget _buildPromotionalOfferBanner(
    BuildContext context,
    HomeOfferModel offer,
    bool isDark,
    Color textDark,
    Color textMuted,
  ) {
    final cardBg = isDark ? AppColors.darkCard : Colors.white;
    final borderColor = isDark ? AppColors.darkBorder : const Color(0xFFD6DCF8);
    final effectiveLogo = offer.storeLogo.isNotEmpty
        ? offer.storeLogo
        : BrandAssetHelper.getBrandLogo(offer.store);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 1.1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => widget.onOfferTap(offer),
          child: Stack(
            children: [
              // 1. BASE BACKGROUND GRADIENT
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isDark
                          ? const [
                              AppColors.darkCard,
                              AppColors.darkCardElevated,
                            ]
                          : const [
                              Colors.white,
                              Color(0xFFF3F6FE),
                            ],
                    ),
                  ),
                ),
              ),

              // 2. RIGHT-SIDE PRODUCT/BRAND CAMPAIGN IMAGE
              Positioned(
                top: 0,
                bottom: 0,
                right: 0,
                width: 165,
                child: _buildBannerRightImage(offer, isDark),
              ),

              // 3. SOFT GRADIENT OVERLAY (Seamlessly fades left text area into right image)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      stops: const [0.0, 0.48, 0.80, 1.0],
                      colors: isDark
                          ? [
                              AppColors.darkCard,
                              AppColors.darkCard.withValues(alpha: 0.96),
                              AppColors.darkCard.withValues(alpha: 0.35),
                              Colors.transparent,
                            ]
                          : [
                              Colors.white,
                              Colors.white.withValues(alpha: 0.97),
                              Colors.white.withValues(alpha: 0.30),
                              Colors.transparent,
                            ],
                    ),
                  ),
                ),
              ),

              // 4. BANNER CONTENT (Left Section)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // A. STORE PILL + URGENCY BADGE
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Store pill with logo + store name
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4.5),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.darkSurface : const Color(0xFFEFF3FE),
                              borderRadius: BorderRadius.circular(9),
                              border: Border.all(
                                color: isDark ? AppColors.darkBorder : const Color(0xFFD6DCF8),
                                width: 0.8,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (effectiveLogo.isNotEmpty) ...[
                                  Container(
                                    width: 22,
                                    height: 22,
                                    margin: const EdgeInsets.only(right: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.08),
                                          blurRadius: 3,
                                          offset: const Offset(0, 1),
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: _buildSmallLogo(effectiveLogo, offer.store),
                                    ),
                                  ),
                                ],
                                Text(
                                  offer.store.isNotEmpty ? offer.store : 'Exclusive Store',
                                  style: GoogleFonts.inter(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w700,
                                    color: textDark,
                                  ),
                                ),
                                if (offer.category.isNotEmpty) ...[
                                  Text(
                                    ' • ',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: textMuted,
                                    ),
                                  ),
                                  Text(
                                    offer.category,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: textMuted,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),

                          // Validity / Urgency tag if available
                          if (offer.validity.isNotEmpty) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFEF3C7),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.bolt_rounded,
                                    size: 12,
                                    color: Color(0xFFD97706),
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    offer.validity,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 9.5,
                                      fontWeight: FontWeight.w800,
                                      color: const Color(0xFF92400E),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    // B. CAMPAIGN HEADLINE
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 220),
                      child: Text(
                        offer.title,
                        style: GoogleFonts.inter(
                          fontSize: 15.5,
                          fontWeight: FontWeight.w800,
                          color: textDark,
                          letterSpacing: -0.2,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    // C. OFFER PILLS & CLAIM CTA BUTTON
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Discount Badge
                          if (offer.discount.isNotEmpty) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5.5),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(7),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF8B5CF6).withValues(alpha: 0.3),
                                    blurRadius: 5,
                                    offset: const Offset(0, 1.5),
                                  ),
                                ],
                              ),
                              child: Text(
                                offer.discount,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                          ],

                          // Cashback Pill
                          if (offer.cashback.isNotEmpty) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 9.5, vertical: 5.5),
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF143823) : const Color(0xFFECFDF5),
                                borderRadius: BorderRadius.circular(7),
                                border: Border.all(
                                  color: isDark
                                      ? const Color(0xFF059669).withValues(alpha: 0.5)
                                      : const Color(0xFFA7F3D0),
                                  width: 0.9,
                                ),
                              ),
                              child: Text(
                                offer.cashback,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w800,
                                  color: isDark ? const Color(0xFF34D399) : const Color(0xFF047857),
                                ),
                              ),
                            ),
                          ],

                          const SizedBox(width: 8),

                          // Action Pill CTA
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 6.5),
                            decoration: BoxDecoration(
                              gradient: isDark
                                  ? const LinearGradient(
                                      colors: [Color(0xFFA798FF), Color(0xFF8B77F6)],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    )
                                  : const LinearGradient(
                                      colors: [Color(0xFF2D274B), Color(0xFF1E1A33)],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                              borderRadius: BorderRadius.circular(9),
                              boxShadow: [
                                BoxShadow(
                                  color: isDark
                                      ? const Color(0xFF8B77F6).withValues(alpha: 0.45)
                                      : const Color(0xFF1E1A33).withValues(alpha: 0.28),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Shop Now',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w800,
                                    color: isDark ? AppColors.darkButtonText : Colors.white,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 13,
                                  color: isDark ? AppColors.darkButtonText : Colors.white,
                                ),
                              ],
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
        ),
      ),
    );
  }

  /// Builds right-side image with smooth fitting and fallback asset resolution
  Widget _buildBannerRightImage(HomeOfferModel offer, bool isDark) {
    String resolvedUrl = offer.imageUrl.trim();
    if (resolvedUrl.isEmpty) {
      resolvedUrl = BrandAssetHelper.getBrandBanner(offer.store, category: offer.category);
    } else if (!resolvedUrl.startsWith('assets/')) {
      final local = BrandAssetHelper.findLocalAssetForUrl(resolvedUrl);
      if (local != null) resolvedUrl = local;
    }

    final fallbackAsset = BrandAssetHelper.getBrandBanner(offer.store, category: offer.category);

    Widget imageWidget;
    if (resolvedUrl.startsWith('assets/')) {
      imageWidget = Image.asset(
        resolvedUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _buildFallbackImage(fallbackAsset),
      );
    } else if (resolvedUrl.startsWith('http')) {
      imageWidget = NetworkImageWithSkeleton(
        imageUrl: resolvedUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _buildFallbackImage(fallbackAsset),
      );
    } else {
      imageWidget = _buildFallbackImage(fallbackAsset);
    }

    return ClipRRect(
      borderRadius: const BorderRadius.horizontal(right: Radius.circular(20)),
      child: imageWidget,
    );
  }

  Widget _buildFallbackImage(String fallbackAsset) {
    if (fallbackAsset.startsWith('assets/')) {
      return Image.asset(
        fallbackAsset,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _buildGenericIconFallback(),
      );
    }
    return _buildGenericIconFallback();
  }

  Widget _buildGenericIconFallback() {
    return Container(
      color: widget.isDark ? const Color(0xFF2D274B) : const Color(0xFFEAEFFE),
      child: Center(
        child: Icon(
          Icons.local_offer_outlined,
          size: 40,
          color: AppColors.accentBlue.withValues(alpha: 0.5),
        ),
      ),
    );
  }

  Widget _buildSmallLogo(String logoUrl, String name) {
    if (logoUrl.startsWith('assets/')) {
      return Image.asset(
        logoUrl,
        fit: BoxFit.contain,
        errorBuilder: (_, _, _) => _fallbackLetter(name),
      );
    } else if (logoUrl.startsWith('http')) {
      return NetworkImageWithSkeleton(
        imageUrl: logoUrl,
        fit: BoxFit.contain,
        errorBuilder: (_, _, _) => _fallbackLetter(name),
      );
    }
    return _fallbackLetter(name);
  }

  Widget _fallbackLetter(String name) {
    return Center(
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : 'S',
        style: GoogleFonts.plusJakartaSans(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: widget.isDark ? AppColors.darkPrimary : AppColors.primaryBrown,
        ),
      ),
    );
  }
}
