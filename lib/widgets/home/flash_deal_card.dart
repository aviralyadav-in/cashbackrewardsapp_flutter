import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/brand_model.dart';
import '../../models/flash_deal_model.dart';
import '../network_image_with_skeleton.dart';
import 'brand_confirmation_dialog.dart';

class FlashDealCard extends StatefulWidget {
  final FlashDeal deal;
  final bool isDark;
  final VoidCallback? onTap;

  const FlashDealCard({
    super.key,
    required this.deal,
    required this.isDark,
    this.onTap,
  });

  @override
  State<FlashDealCard> createState() => _FlashDealCardState();
}

class _FlashDealCardState extends State<FlashDealCard> {
  bool _isPressed = false;

  void _handleAction(BuildContext context) {
    if (widget.onTap != null) {
      widget.onTap!();
      return;
    }

    final deal = widget.deal;
    final brand = BrandModel(
      name: deal.brandName,
      logoUrl: deal.logo,
      bannerUrl: deal.productImage ?? deal.logo,
      cashbackPercentage: deal.cashback,
      category: deal.category,
      offerText: '${deal.offer} • ${deal.saving}',
      websiteUrl: deal.websiteUrl,
    );

    showBrandConfirmationDialog(context, brand);
  }

  Widget _buildBrandLogo(FlashDeal deal) {
    if (deal.logo.isNotEmpty) {
      if (deal.logo.startsWith('assets/')) {
        return Image.asset(
          deal.logo,
          fit: BoxFit.contain,
          errorBuilder: (_, _, _) => _buildTextLogoFallback(deal.brandName),
        );
      } else {
        return NetworkImageWithSkeleton(
          imageUrl: deal.logo,
          fit: BoxFit.contain,
          errorBuilder: (_, _, _) => _buildTextLogoFallback(deal.brandName),
        );
      }
    }
    return _buildTextLogoFallback(deal.brandName);
  }

  Widget _buildTextLogoFallback(String name) {
    return Text(
      name,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 11,
        fontWeight: FontWeight.w800,
        color: const Color(0xFF1E293B),
      ),
    );
  }

  Widget _buildProductImage(FlashDeal deal) {
    if (deal.productImage == null || deal.productImage!.isEmpty) {
      return const SizedBox.shrink();
    }

    Widget img;
    if (deal.productImage!.startsWith('assets/')) {
      img = Image.asset(
        deal.productImage!,
        fit: BoxFit.contain,
        errorBuilder: (_, _, _) => const SizedBox.shrink(),
      );
    } else {
      img = NetworkImageWithSkeleton(
        imageUrl: deal.productImage!,
        fit: BoxFit.contain,
        errorBuilder: (_, _, _) => const SizedBox.shrink(),
      );
    }

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: img,
    );
  }

  @override
  Widget build(BuildContext context) {
    final deal = widget.deal;
    final isDark = widget.isDark;

    final cardBg = isDark ? const Color(0xFF171C2B) : Colors.white;
    final cardBorder = isDark ? const Color(0xFF2C354A) : const Color(0xFFE2E8F0);
    final textPrimary = isDark ? Colors.white : const Color(0xFF0F172A);
    final textSecondary = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    return AnimatedScale(
      scale: _isPressed ? 0.96 : 1.0,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOutCubic,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          _handleAction(context);
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: SizedBox(
          width: 285,
          height: 246,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // ===============================================================
              // 1. CARD BODY
              // ===============================================================
              Positioned(
                top: 24,
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: cardBorder,
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: isDark ? 0.4 : 0.12,
                        ),
                        blurRadius: 14,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // UPPER SECTION: Header + Offer
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Left details column
                                Expanded(
                                  flex: 56,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Top Brand Logo
                                      Container(
                                        height: 34,
                                        constraints: const BoxConstraints(
                                          minWidth: 68,
                                          maxWidth: 96,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 7,
                                          vertical: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isDark
                                              ? const Color(0xFF22293C)
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(9),
                                          border: Border.all(
                                            color: isDark
                                                ? Colors.white.withValues(alpha: 0.1)
                                                : Colors.black.withValues(alpha: 0.06),
                                            width: 1,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withValues(
                                                alpha: 0.05,
                                              ),
                                              blurRadius: 4,
                                              offset: const Offset(0, 1),
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: _buildBrandLogo(deal),
                                        ),
                                      ),

                                      // Offer & Condition
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            deal.offer,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.plusJakartaSans(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w800,
                                              color: textPrimary,
                                              letterSpacing: -0.2,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            deal.minimumOrder,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.plusJakartaSans(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w500,
                                              color: textSecondary,
                                              height: 1.2,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 6,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: (isDark
                                                      ? Colors.white
                                                      : Colors.black)
                                                  .withValues(alpha: 0.05),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              deal.category.toUpperCase(),
                                              style: GoogleFonts.plusJakartaSans(
                                                fontSize: 8.5,
                                                fontWeight: FontWeight.w700,
                                                color: textSecondary,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                // Space reserved for product cutout on the right
                                const SizedBox(width: 8),
                                const Expanded(
                                  flex: 44,
                                  child: SizedBox.shrink(),
                                ),
                              ],
                            ),
                          ),

                          // DIVIDER
                          const SizedBox(height: 6),
                          Divider(
                            height: 1,
                            thickness: 0.8,
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.08)
                                : const Color(0xFFE2E8F0),
                          ),
                          const SizedBox(height: 8),

                          // BOTTOM ROW: Cashback Capsule + Modern CTA Button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Glowing Mint Cashback Tag
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF00C853)
                                        .withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: const Color(0xFF00C853)
                                          .withValues(alpha: 0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text(
                                        '✦',
                                        style: TextStyle(
                                          color: Color(0xFF00C853),
                                          fontSize: 10,
                                        ),
                                      ),
                                      const SizedBox(width: 3.5),
                                      Flexible(
                                        child: Text(
                                          deal.cashback,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.plusJakartaSans(
                                            color: const Color(0xFF00A844),
                                            fontSize: 11.5,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: -0.1,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),

                              // Modern Gradient CTA Pill
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 7,
                                ),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF2563EB),
                                      Color(0xFF1D4ED8),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(18),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF2563EB)
                                          .withValues(alpha: 0.32),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      deal.cta,
                                      style: GoogleFonts.plusJakartaSans(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 12,
                                        letterSpacing: 0.2,
                                      ),
                                    ),
                                    const SizedBox(width: 3.5),
                                    const Icon(
                                      Icons.arrow_forward_rounded,
                                      size: 11,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // ===============================================================
              // 2. PRODUCT IMAGE (POPS OUT OF THE CARD TOP EDGE)
              // ===============================================================
              Positioned(
                top: 0,
                right: 8,
                width: 136,
                height: 144,
                child: IgnorePointer(
                  child: _buildProductImage(deal),
                ),
              ),

              // ===============================================================
              // 3. FLOATING SAVING BADGE (TOP RIGHT)
              // ===============================================================
              if (deal.saving.isNotEmpty)
                Positioned(
                  top: 29,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF5722),
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF5722).withValues(alpha: 0.4),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      deal.saving,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 0.3,
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
}
