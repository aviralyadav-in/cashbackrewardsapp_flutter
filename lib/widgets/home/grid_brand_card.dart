import 'package:flutter/material.dart';
import '../../models/brand_model.dart';
import '../../screens/product_detail_screen.dart';
import '../network_image_with_skeleton.dart';

class GridBrandCard extends StatelessWidget {
  final BrandModel brand;
  final bool isDark;
  final VoidCallback? onTap;

  const GridBrandCard({
    super.key,
    required this.brand,
    required this.isDark,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Prefer clean logoUrl, fallback to bannerUrl or website favicon
    final logoUrl = brand.logoUrl.isNotEmpty
        ? brand.logoUrl
        : (brand.bannerUrl.isNotEmpty ? brand.bannerUrl : brand.websiteUrl);

    return GestureDetector(
      onTap: onTap ??
          () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ProductDetailScreen.fromBrand(brand),
              ),
            );
          },
      child: Container(
        height: 148,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF161618) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? const Color(0xFF28282A) : const Color(0xFFE5E5EA),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // 1. HERO LARGE BRAND LOGO AS MAIN BACKGROUND BRANDING
              Positioned.fill(
                child: Container(
                  color: isDark ? const Color(0xFF18181B) : const Color(0xFFFAFAFA),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 26),
                      child: NetworkImageWithSkeleton(
                        imageUrl: logoUrl,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => Center(
                          child: Text(
                            brand.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: isDark ? Colors.white70 : const Color(0xFF1E90FF),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // 2. SUBTLE OVERLAY FOR CRISP FOREGROUND CONTRAST & LEGIBILITY
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isDark
                          ? [
                              const Color(0xFF161618).withValues(alpha: 0.82),
                              const Color(0xFF161618).withValues(alpha: 0.12),
                              const Color(0xFF161618).withValues(alpha: 0.85),
                            ]
                          : [
                              Colors.white.withValues(alpha: 0.88),
                              Colors.white.withValues(alpha: 0.10),
                              Colors.white.withValues(alpha: 0.90),
                            ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ),

              // 3. FOREGROUND CONTENT: OFFER TAG AT TOP & CASHBACK BADGE AT BOTTOM
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Top: Offer / Discount % Tag
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3.5),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF222225).withValues(alpha: 0.95)
                            : Colors.white.withValues(alpha: 0.95),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: isDark
                              ? const Color(0xFF333336)
                              : const Color(0xFFE5E5EA),
                          width: 0.8,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Text(
                        brand.offerText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),

                    // Bottom: Cashback / Reward % Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E90FF)
                            .withValues(alpha: isDark ? 0.24 : 0.12),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: const Color(0xFF1E90FF).withValues(alpha: 0.35),
                          width: 0.8,
                        ),
                      ),
                      child: Text(
                        brand.cashbackPercentage,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF1E90FF),
                        ),
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
}

class GridCardsSection extends StatelessWidget {
  final List<BrandModel> brands;
  final bool isDark;
  final bool isExpanded;
  final int initialCount;

  const GridCardsSection({
    super.key,
    required this.brands,
    required this.isDark,
    required this.isExpanded,
    this.initialCount = 6,
  });

  @override
  Widget build(BuildContext context) {
    final displayBrands = isExpanded || brands.length <= initialCount
        ? brands
        : brands.sublist(0, initialCount);

    final List<List<BrandModel>> rows = [];
    for (var i = 0; i < displayBrands.length; i += 3) {
      rows.add(
        displayBrands.sublist(
            i, i + 3 > displayBrands.length ? displayBrands.length : i + 3),
      );
    }

    return Column(
      children: List.generate(rows.length, (rowIndex) {
        final rowBrands = rows[rowIndex];
        final isLastRow = rowIndex == rows.length - 1;

        return Padding(
          padding: EdgeInsets.only(bottom: isLastRow ? 0.0 : 10.0),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: GridBrandCard(
                    brand: rowBrands[0],
                    isDark: isDark,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: rowBrands.length > 1
                      ? GridBrandCard(
                          brand: rowBrands[1],
                          isDark: isDark,
                        )
                      : const SizedBox.shrink(),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: rowBrands.length > 2
                      ? GridBrandCard(
                          brand: rowBrands[2],
                          isDark: isDark,
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
