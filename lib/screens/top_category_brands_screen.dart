import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/brand_model.dart';
import '../theme/app_theme.dart';
import '../widgets/home/grid_brand_card.dart';
import 'product_detail_screen.dart';

class TopCategoryBrandsScreen extends StatelessWidget {
  static const String routeName = '/top-category-brands';

  final String categoryTitle;
  final List<BrandModel> brands;

  const TopCategoryBrandsScreen({
    super.key,
    required this.categoryTitle,
    required this.brands,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.mainBackground,
      appBar: AppBar(
        title: Text(
          '$categoryTitle Websites & Brands',
          style: AppTextStyles.screenHeading(
            color: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
          ).copyWith(fontSize: 17),
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
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          children: [
            // Category Header Banner
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
                gradient: LinearGradient(
                  colors: isDark
                      ? const [AppColors.darkSurface, AppColors.darkCard]
                      : const [AppColors.primaryBrown, AppColors.deepBrown],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
                    blurRadius: 10,
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
                        Text(
                          categoryTitle.toUpperCase(),
                          style: GoogleFonts.fraunces(
                            color: Colors.white70,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Top $categoryTitle Partners',
                          style: GoogleFonts.fraunces(
                            color: Colors.white,
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Shop via CashKaro to earn extra guaranteed cashback rewards!',
                          style: AppTextStyles.caption(
                            color: Colors.white.withValues(alpha: 0.8),
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
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.storefront_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Websites & Brands List Header
            Row(
              children: [
                Container(
                  width: 4,
                  height: 18,
                  decoration: BoxDecoration(
                    color: AppColors.primaryBrown,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Featured Websites & Brands',
                  style: AppTextStyles.sectionHeading(
                    color: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
                  ).copyWith(fontSize: 15),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // 2-Column Brands Grid (2 cards per row)
            if (brands.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Text(
                    'No websites available for this category yet.',
                    style: AppTextStyles.body(
                      color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                    ),
                  ),
                ),
              )
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: brands.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  mainAxisExtent: 160,
                ),
                itemBuilder: (context, index) {
                  final brand = brands[index];
                  return GridBrandCard(
                    brand: brand,
                    isDark: isDark,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ProductDetailScreen.fromBrand(brand),
                        ),
                      );
                    },
                  );
                },
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
