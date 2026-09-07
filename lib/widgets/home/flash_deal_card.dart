import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/brand_model.dart';
import '../../models/flash_deal_model.dart';
import '../network_image_with_skeleton.dart';
import 'brand_confirmation_dialog.dart';

class FlashDealCard extends StatelessWidget {
  final FlashDeal deal;
  final bool isDark;
  final VoidCallback? onTap;

  const FlashDealCard({
    super.key,
    required this.deal,
    required this.isDark,
    this.onTap,
  });

  void _handleAction(BuildContext context) {
    if (onTap != null) {
      onTap!();
      return;
    }

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
    final name = deal.brandName.toLowerCase();

    Widget content;

    // 1. Daily Objects Logo Badge (matches screenshot)
    if (name.contains('daily')) {
      content = Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'D',
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF161616),
            ),
          ),
          const Icon(
            Icons.all_inclusive_rounded,
            size: 13,
            color: Color(0xFF161616),
          ),
          const SizedBox(width: 3),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Daily',
                style: TextStyle(
                  fontSize: 7,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF161616),
                  height: 1.0,
                ),
              ),
              Text(
                'Objects',
                style: TextStyle(
                  fontSize: 7,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF161616),
                  height: 1.0,
                ),
              ),
            ],
          ),
        ],
      );
    }
    // 2. IndusInd Bank Logo Badge (matches screenshot)
    else if (name.contains('indusind')) {
      content = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Text(
            'IndusInd Bank',
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w900,
              color: Color(0xFF8B1E1E),
              letterSpacing: -0.2,
            ),
          ),
          SizedBox(height: 1),
          Text(
            'EAZYDINER CARD',
            style: TextStyle(
              fontSize: 5.5,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
              letterSpacing: 0.4,
            ),
          ),
        ],
      );
    }
    // 3. Ounce Organics Logo Badge (matches screenshot)
    else if (name.contains('ounce')) {
      content = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'ounce',
                style: GoogleFonts.fraunces(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF141414),
                ),
              ),
              const SizedBox(width: 2),
              Container(
                width: 3,
                height: 3,
                decoration: const BoxDecoration(
                  color: Color(0xFF141414),
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const Text(
            'ORGANICS',
            style: TextStyle(
              fontSize: 5.5,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.1,
              color: Color(0xFF4A4A4A),
              height: 1.0,
            ),
          ),
        ],
      );
    }
    // Fallback: assets/cards raster image
    else {
      content = ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: NetworkImageWithSkeleton(
          imageUrl: deal.logo,
          fit: BoxFit.contain,
        ),
      );
    }

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: content,
    );
  }

  Widget _buildProductImage(FlashDeal deal) {
    if (deal.productImage == null || deal.productImage!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.14),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: NetworkImageWithSkeleton(
        imageUrl: deal.productImage!,
        fit: BoxFit.contain,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 285,
      height: 246,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // ===================================================================
          // 1. CARD BODY (Starts at top: 28, product pops out above it!)
          // ===================================================================
          Positioned(
            top: 28,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFE5F4FB),
                    Color(0xFFCEECF8),
                  ],
                ),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.75),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.16),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Column(
                    children: [
                      // UPPER SECTION: Left Column (Brand + Offer + Condition)
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 55,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Top-Left Brand Logo Container
                                  Container(
                                    height: 36,
                                    constraints: const BoxConstraints(
                                      minWidth: 70,
                                      maxWidth: 96,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
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

                                  // Offer & Minimum Condition
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        deal.offer,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800,
                                          color: Color(0xFF14171A),
                                          letterSpacing: -0.2,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        deal.minimumOrder,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF525D6B),
                                          height: 1.2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // Space reserved for the product that pops out on the right
                            const SizedBox(width: 8),
                            const Expanded(
                              flex: 45,
                              child: SizedBox.shrink(),
                            ),
                          ],
                        ),
                      ),

                      // DIVIDER LINE
                      const SizedBox(height: 6),
                      Divider(
                        height: 1,
                        thickness: 0.85,
                        color: const Color(0xFFB8DAEC).withValues(alpha: 0.85),
                      ),
                      const SizedBox(height: 8),

                      // BOTTOM ROW: Cashback + CTA Button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              deal.cashback,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF14171A),
                                letterSpacing: -0.1,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),

                          // Action CTA Button
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => _handleAction(context),
                              borderRadius: BorderRadius.circular(20),
                              child: Ink(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0044EE),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF0044EE).withValues(
                                        alpha: 0.35,
                                      ),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  deal.cta,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 12.5,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                              ),
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

          // ===================================================================
          // 2. PRODUCT IMAGE (POPS OUT OF THE CARD TOP EDGE!)
          // ===================================================================
          Positioned(
            top: 0,
            right: 8,
            width: 140,
            height: 148,
            child: IgnorePointer(
              child: _buildProductImage(deal),
            ),
          ),
        ],
      ),
    );
  }
}
