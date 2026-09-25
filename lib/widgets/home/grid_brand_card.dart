import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/brand_model.dart';
import '../../screens/products/product_detail_screen.dart';
import '../../theme/app_theme.dart';
import '../common/network_image_with_skeleton.dart';

/// Redesigned Brand Card matching the reference design:
/// 1. Top Image Box: Real group/collection of products for the brand
/// 2. Top-Left: Crisp white discount badge (e.g. "60% OFF")
/// 3. Bottom-Left: Mini brand logo badge
/// 4. Brand Name (e.g. "Zara Official", "Amazon.in")
/// 5. Subtitle (e.g. "Apparel & Coats", "Deals & Shopping")
/// 6. Soft mint cashback pill with "+7.5% Back ⚡"
/// 7. Dark "Shop →" pill CTA button
class GridBrandCard extends StatefulWidget {
  final BrandModel brand;
  final bool isDark;
  final VoidCallback? onTap;
  final int? columnIndex;

  const GridBrandCard({
    super.key,
    required this.brand,
    required this.isDark,
    this.onTap,
    this.columnIndex,
  });

  @override
  State<GridBrandCard> createState() => _GridBrandCardState();
}

class _GridBrandCardState extends State<GridBrandCard> {
  bool _isPressed = false;

  String _getBrandCollectionAsset(BrandModel brand) {
    final name = brand.name.toLowerCase();
    final cat = brand.category.toLowerCase();

    if (name.contains('zara')) return 'assets/cards/col_zara.jpg';
    if (name.contains('amazon')) return 'assets/cards/col_amazon.jpg';
    if (name.contains('flipkart')) return 'assets/cards/col_flipkart.jpg';
    if (name.contains('myntra')) return 'assets/cards/col_myntra.jpg';
    if (name.contains('ajio')) return 'assets/cards/col_ajio.jpg';
    if (name.contains('nykaa')) return 'assets/cards/col_nykaa.jpg';
    if (name.contains('dot & key') || name.contains('dotandkey')) {
      return 'assets/cards/col_dotkey.jpg';
    }
    if (name.contains('mcaffeine')) return 'assets/cards/col_mcaffeine.jpg';
    if (name.contains('aqualogica')) return 'assets/cards/col_aqualogica.jpg';
    if (name.contains('derma') || name.contains('foxtale')) {
      return 'assets/cards/col_derma.jpg';
    }
    if (name.contains('shopsy') || name.contains('meesho')) {
      return 'assets/cards/col_shopsy.jpg';
    }
    if (name.contains('reliance') ||
        cat.contains('electronic') ||
        cat.contains('gadget') ||
        cat.contains('mobile')) {
      return 'assets/cards/col_electronics.jpg';
    }
    if (cat.contains('food') ||
        cat.contains('grocery') ||
        name.contains('haldiram') ||
        name.contains('swiggy') ||
        name.contains('zomato')) {
      return 'assets/cards/col_food.jpg';
    }
    if (cat.contains('travel') ||
        cat.contains('flight') ||
        cat.contains('hotel') ||
        name.contains('makemytrip') ||
        name.contains('cleartrip') ||
        name.contains('booking')) {
      return 'assets/cards/col_travel.jpg';
    }
    if (cat.contains('medicine') ||
        cat.contains('pharmacy') ||
        cat.contains('health') ||
        name.contains('netmeds') ||
        name.contains('pharmeasy') ||
        name.contains('apollo')) {
      return 'assets/cards/col_pharmacy.jpg';
    }
    if (cat.contains('card') ||
        cat.contains('banking') ||
        cat.contains('loan') ||
        name.contains('sbi') ||
        name.contains('hdfc') ||
        name.contains('axis')) {
      return 'assets/cards/col_cards.jpg';
    }
    if (cat.contains('fashion') ||
        cat.contains('clothing') ||
        cat.contains('apparel') ||
        name.contains('uniqlo') ||
        name.contains('libas') ||
        name.contains('shyaway')) {
      return 'assets/cards/col_myntra.jpg';
    }
    if (cat.contains('beauty') || cat.contains('personal care')) {
      return 'assets/cards/col_nykaa.jpg';
    }

    return 'assets/cards/col_default.jpg';
  }

  String get _discountText {
    final raw = widget.brand.offerText.trim();
    if (raw.isEmpty) return '60% OFF';

    final match = RegExp(r'(\d+(?:\.\d+)?%)').firstMatch(raw);
    if (match != null) {
      if (raw.toLowerCase().contains('upto') || raw.toLowerCase().contains('up to')) {
        return 'UPTO ${match.group(1)} OFF';
      }
      return '${match.group(1)} OFF';
    }
    if (raw.length <= 12) {
      return raw.toUpperCase();
    }
    return 'HOT DEAL';
  }

  String get _cashbackBadgeText {
    final raw = widget.brand.cashbackPercentage.trim();
    if (raw.isEmpty) return '+7.5% Back';

    final match = RegExp(r'(\d+(?:\.\d+)?%)').firstMatch(raw);
    if (match != null) {
      return '+${match.group(1)} Back';
    }
    final amtMatch = RegExp(r'(₹\d+)').firstMatch(raw);
    if (amtMatch != null) {
      return '+${amtMatch.group(1)} Back';
    }
    return '+7.5% Back';
  }

  String get _subtitleText {
    final cat = widget.brand.category.trim();
    if (cat.isNotEmpty && cat.toLowerCase() != 'popular') {
      return cat;
    }

    final name = widget.brand.name.toLowerCase();
    if (name.contains('zara') ||
        name.contains('myntra') ||
        name.contains('ajio') ||
        name.contains('libas') ||
        name.contains('shyaway')) {
      return 'Apparel & Coats';
    }
    if (name.contains('amazon') || name.contains('flipkart') || name.contains('shopsy')) {
      return 'Deals & Shopping';
    }
    if (name.contains('nykaa') ||
        name.contains('dot') ||
        name.contains('caffeine') ||
        name.contains('derma') ||
        name.contains('foxtale') ||
        name.contains('aqualogica')) {
      return 'Skincare & Beauty';
    }
    if (name.contains('reliance') ||
        name.contains('boat') ||
        name.contains('noise') ||
        name.contains('realme') ||
        name.contains('oppo')) {
      return 'Tech & Gadgets';
    }
    if (name.contains('food') ||
        name.contains('haldiram') ||
        name.contains('swiggy') ||
        name.contains('zomato')) {
      return 'Food & Gourmet';
    }
    if (name.contains('travel') ||
        name.contains('makemytrip') ||
        name.contains('cleartrip') ||
        name.contains('booking')) {
      return 'Hotels & Flights';
    }
    return 'Offers & Rewards';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final brand = widget.brand;
    final collectionAsset = _getBrandCollectionAsset(brand);
    final logoUrl = brand.logoUrl.trim();

    return AnimatedScale(
      scale: _isPressed ? 0.96 : 1.0,
      duration: const Duration(milliseconds: 140),
      curve: Curves.easeOutCubic,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          if (widget.onTap != null) {
            widget.onTap!();
          } else {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ProductDetailScreen.fromBrand(brand),
              ),
            );
          }
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.05),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // 1. TOP PRODUCT COLLECTION IMAGE CONTAINER
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: SizedBox(
                  height: 106,
                  width: double.infinity,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Product Collection Image
                      Image.asset(
                        collectionAsset,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: const Color(0xFF0F1E2E),
                            child: const Center(
                              child: Icon(
                                Icons.shopping_bag_outlined,
                                color: Colors.white54,
                                size: 28,
                              ),
                            ),
                          );
                        },
                      ),

                      // Soft Top & Bottom Scrim Gradient for Badge Legibility
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.28),
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.35),
                            ],
                            stops: const [0.0, 0.5, 1.0],
                          ),
                        ),
                      ),

                      // Top-Left: Discount Badge (e.g. "60% OFF")
                      Positioned(
                        top: 7,
                        left: 7,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7.5,
                            vertical: 3.5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.18),
                                blurRadius: 4,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Text(
                            _discountText,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF0F172A),
                              letterSpacing: 0.1,
                            ),
                          ),
                        ),
                      ),

                      // Bottom-Left: Brand Logo / Initial Badge
                      Positioned(
                        bottom: 7,
                        left: 7,
                        child: Container(
                          width: 26,
                          height: 26,
                          padding: const EdgeInsets.all(2.5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.25),
                                blurRadius: 4,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: logoUrl.isNotEmpty
                                ? (logoUrl.startsWith('assets/')
                                    ? Image.asset(
                                        logoUrl,
                                        fit: BoxFit.contain,
                                        errorBuilder: (context, error, stackTrace) => _buildFallbackInitial(),
                                      )
                                    : NetworkImageWithSkeleton(
                                        imageUrl: logoUrl,
                                        fit: BoxFit.contain,
                                        shape: BoxShape.rectangle,
                                        errorBuilder: (context, error, stackTrace) => _buildFallbackInitial(),
                                      ))
                                : _buildFallbackInitial(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 7),

              // 2. BRAND TITLE
              Text(
                brand.name,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A),
                  letterSpacing: -0.2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 1.5),

              // 3. CATEGORY / SUBTITLE
              Text(
                _subtitleText,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11.0,
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.darkTextSecondary : const Color(0xFF64748B),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 7),

              // 4. CASHBACK BADGE PILL (e.g. "+7.5% Back ⚡")
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4.5),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0B251B) : const Color(0xFFEBF8F3),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF00E599).withValues(alpha: 0.25)
                        : const Color(0xFFB8EED8),
                    width: 0.8,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        _cashbackBadgeText,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF009660),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Icon(
                      Icons.bolt_rounded,
                      size: 15,
                      color: Color(0xFF009660),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // 5. "Shop →" CTA BUTTON
              Container(
                height: 34,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFF0C1929),
                  borderRadius: BorderRadius.circular(17),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.12),
                      blurRadius: 4,
                      offset: const Offset(0, 1.5),
                    ),
                  ],
                ),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Shop',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13.0,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.1,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        size: 14,
                        color: Colors.white,
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

  Widget _buildFallbackInitial() {
    final initial = widget.brand.name.trim().isNotEmpty
        ? widget.brand.name.trim()[0].toUpperCase()
        : 'B';
    return Center(
      child: Text(
        initial,
        style: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w900,
          fontSize: 11,
          color: const Color(0xFF0F172A),
        ),
      ),
    );
  }
}