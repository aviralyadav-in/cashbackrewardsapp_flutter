import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/home_mock_data.dart';
import '../../models/amazon_deal_model.dart';
import '../../models/brand_model.dart';
import '../../models/subcategory_banner_data.dart';
import '../../theme/app_theme.dart';
import '../../widgets/home/amazon_deal_card.dart';
import '../../widgets/home/grid_brand_card.dart';
import '../../widgets/home/subcategory_promotional_banner.dart';
import '../products/product_detail_screen.dart';

class TopCategoryBrandsScreen extends StatelessWidget {
  static const String routeName = '/top-category-brands';

  final String categoryTitle;
  final List<BrandModel> brands;
  final List<AmazonDealItemData>? deals;
  final Color? accentColor;
  final Color? backgroundColor;
  final IconData? categoryIcon;
  final SubcategoryBannerData? bannerData;

  const TopCategoryBrandsScreen({
    super.key,
    required this.categoryTitle,
    this.brands = const [],
    this.deals,
    this.accentColor,
    this.backgroundColor,
    this.categoryIcon,
    this.bannerData,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isDealsMode = deals != null && deals!.isNotEmpty;
    final primaryAccent = accentColor ??
        (isDark ? AppColors.darkPrimary : AppColors.primaryBrown);
    final effectiveBanner =
        bannerData ?? HomeMockData.getBannerForCategory(categoryTitle);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.mainBackground,
      appBar: AppBar(
        title: Text(
          isDealsMode ? categoryTitle : '$categoryTitle Stores',
          style: GoogleFonts.plusJakartaSans(
            color: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        backgroundColor: isDark ? AppColors.darkCard : AppColors.mainBackground,
        foregroundColor: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isDark ? AppColors.darkTextPrimary : AppColors.primaryBrown,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          children: [
            // 1. FEATURED CAMPAIGN HERO BANNER
            if (isDealsMode)
              _buildGenericHeader(primaryAccent, isDark, isDealsMode)
            else if (effectiveBanner != null)
              SubcategoryPromotionalBannerWidget(
                bannerData: effectiveBanner,
                isDark: isDark,
              )
            else
              _buildGenericHeader(primaryAccent, isDark, isDealsMode),

            const SizedBox(height: 18),

            // Websites & Brands / Deals List Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 18,
                      decoration: BoxDecoration(
                        color: primaryAccent,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isDealsMode
                          ? 'Featured Deals & Products'
                          : 'Featured Stores & Brands',
                      style: GoogleFonts.plusJakartaSans(
                        color: isDark ? Colors.white : const Color(0xFF1E1E24),
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ],
                ),
                if (!isDealsMode && brands.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: primaryAccent.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${brands.length} Stores',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: primaryAccent,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 14),

            // Grid Content: Deals vs Brands
            if (isDealsMode)
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: deals!.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  mainAxisExtent: 280,
                ),
                itemBuilder: (context, index) {
                  final deal = deals![index];
                  return AmazonDealCard(
                    deal: deal,
                    isDark: isDark,
                  );
                },
              )
            else if (brands.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 48),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.storefront_outlined,
                        size: 40,
                        color: primaryAccent.withValues(alpha: 0.5),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'No stores available for this category yet.',
                        style: GoogleFonts.plusJakartaSans(
                          color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                          fontSize: 13.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              LayoutBuilder(
                builder: (context, constraints) {
                  final crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: brands.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      mainAxisExtent: 250,
                    ),
                    itemBuilder: (context, index) {
                      final brand = brands[index];
                      return GridBrandCard(
                        brand: brand,
                        isDark: isDark,
                        columnIndex: index % crossAxisCount,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ProductDetailScreen.fromBrand(brand),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildGenericHeader(Color primaryAccent, bool isDark, bool isDealsMode) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: isDark
              ? [
                  primaryAccent.withValues(alpha: 0.35),
                  const Color(0xFF1E1E22),
                ]
              : [
                  primaryAccent,
                  primaryAccent.withValues(alpha: 0.84),
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: isDark
              ? primaryAccent.withValues(alpha: 0.25)
              : Colors.transparent,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: primaryAccent.withValues(alpha: isDark ? 0.25 : 0.16),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    categoryTitle.toUpperCase(),
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  isDealsMode
                      ? 'Exclusive $categoryTitle'
                      : 'Top $categoryTitle Stores',
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isDealsMode
                      ? 'Shop top Amazon deals and earn extra guaranteed cashback rewards!'
                      : 'Shop via verified partner stores & earn highest cashback rewards!',
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.22),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            child: Icon(
              categoryIcon ??
                  (isDealsMode
                      ? Icons.local_offer_rounded
                      : Icons.storefront_rounded),
              color: Colors.white,
              size: 26,
            ),
          ),
        ],
      ),
    );
  }
}
