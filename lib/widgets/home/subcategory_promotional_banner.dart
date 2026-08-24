import 'package:flutter/material.dart';
import '../../models/subcategory_banner_data.dart';

class SubcategoryPromotionalBannerWidget extends StatelessWidget {
  final SubcategoryBannerData bannerData;
  final bool isDark;

  const SubcategoryPromotionalBannerWidget({
    super.key,
    required this.bannerData,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final topColor = isDark ? const Color(0xFF1C1C20) : Colors.white;
    final bottomColor = isDark
        ? Color.alphaBlend(bannerData.themeColor.withValues(alpha: 0.28), const Color(0xFF101014))
        : bannerData.lightColor;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [topColor, bottomColor],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          // SUBTLE BOTTOM DARKER GRADIENT OVERLAY FOR VISUAL DEPTH
          Positioned.fill(
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.35, 1.0],
                    colors: [
                      Colors.transparent,
                      isDark
                          ? Colors.black.withValues(alpha: 0.25)
                          : Colors.black.withValues(alpha: 0.06),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                // TOP SECTION (WHITE BG AREA)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // LEFT: Brand Badge, Offer Tag & Headline
                    Expanded(
                      flex: 70,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // BRAND & OFFER TAG ROW
                          Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: bannerData.themeColor.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: bannerData.themeColor.withValues(alpha: 0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  bannerData.brandName.toUpperCase(),
                                  style: TextStyle(
                                    color: isDark ? Colors.white : bannerData.themeColor,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: bannerData.themeColor,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  bannerData.offerTag,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          // PROMOTIONAL HEADLINE
                          Text(
                            bannerData.headline,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                              fontSize: 15.5,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.2,
                              height: 1.25,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 8),

                    // RIGHT: CIRCULAR BRAND/CATEGORY ICON BADGE
                    Expanded(
                      flex: 30,
                      child: Center(
                        child: Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: bannerData.themeColor.withValues(alpha: 0.1),
                            border: Border.all(
                              color: bannerData.themeColor.withValues(alpha: 0.25),
                              width: 1.5,
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              bannerData.logoIcon,
                              size: 32,
                              color: isDark ? Colors.white : bannerData.themeColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // BOTTOM SECTION (LIGHT COLOR AREA)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // SUPPORTING OFFER DETAILS (LEFT)
                    Expanded(
                      child: Text(
                        bannerData.subText,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: isDark ? Colors.grey.shade300 : const Color(0xFF334155),
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          height: 1.3,
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // NON-CLICKABLE CTA PROMO BADGE (RIGHT)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: bannerData.themeColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: bannerData.themeColor.withValues(alpha: 0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            bannerData.buttonText,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.arrow_forward_rounded,
                            size: 12,
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
        ],
      ),
    );
  }
}
