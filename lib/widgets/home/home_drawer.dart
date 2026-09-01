import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../providers/category_provider.dart';
import '../../screens/all_categories_screen.dart';
import '../../screens/categories_screen.dart';
import '../../theme/app_theme.dart';

class HomeDrawer extends StatelessWidget {
  final bool isDark;

  const HomeDrawer({
    super.key,
    required this.isDark,
  });

  void _handleCategoryClick(BuildContext context, CategoryProvider provider, String targetQuery) {
    String matchedCat = targetQuery;
    if (provider.categories.isNotEmpty) {
      final cleanTarget = targetQuery.trim().toLowerCase().replaceAll(RegExp(r"[\s\-_']+"), '');
      int foundIndex = provider.categories.indexWhere(
        (cat) => cat.toLowerCase().replaceAll(RegExp(r"[\s\-_']+"), '') == cleanTarget,
      );

      if (foundIndex == -1) {
        final lowerQuery = targetQuery.trim().toLowerCase().replaceAll(' ', '-');
        foundIndex = provider.categories.indexWhere(
          (cat) => cat.toLowerCase().replaceAll(' ', '-') == lowerQuery,
        );
      }

      if (foundIndex == -1) {
        foundIndex = provider.categories.indexWhere(
          (cat) => cat.toLowerCase().replaceAll(RegExp(r"[\s\-_']+"), '').contains(cleanTarget),
        );
      }

      if (foundIndex != -1) {
        matchedCat = provider.categories[foundIndex];
      }
    }

    provider.fetchProductsByCategory(matchedCat);
    Navigator.of(context).pushNamed(CategoriesScreen.routeName);
  }

  void _onCategoryTap(BuildContext context, CategoryProvider provider, String targetQuery) {
    Navigator.of(context).pop();
    _handleCategoryClick(context, provider, targetQuery);
  }

  @override
  Widget build(BuildContext context) {
    final dividerColor = isDark ? AppColors.darkBorder : AppColors.border.withValues(alpha: 0.5);
    final cardBgColor = isDark ? AppColors.darkCard : AppColors.cardBackground;
    final cardBorderColor = isDark ? AppColors.darkBorder : AppColors.border;

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.84,
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.mainBackground,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. CLEAN HEADER WITH "Categories" AND CIRCULAR CLOSE (X) BUTTON
            Container(
              color: isDark ? AppColors.darkCard : AppColors.mainBackground,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDark ? AppColors.darkSurface : AppColors.beigeSurface,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.category_rounded,
                            size: 17,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.primaryBrown,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Categories',
                        style: AppTextStyles.screenHeading(
                          color: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
                        ).copyWith(fontSize: 18),
                      ),
                    ],
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDark ? AppColors.darkSurface : AppColors.beigeSurface,
                      ),
                      child: Icon(
                        Icons.close_rounded,
                        size: 18,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.primaryBrown,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // THIN DIVIDER BELOW HEADER
            Divider(height: 1, thickness: 1, color: dividerColor),

            // SCROLLABLE CONTENT
            Expanded(
              child: Consumer<CategoryProvider>(
                builder: (context, categoryProvider, child) {
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 14),

                        // 2. PROMOTIONAL CASHBACK BANNER
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isDark
                                  ? const [AppColors.darkSurface, AppColors.darkCard]
                                  : const [AppColors.primaryBrown, AppColors.deepBrown],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
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
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: 0.18),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        'SPECIAL OFFER',
                                        style: GoogleFonts.fraunces(
                                          color: Colors.white,
                                          fontSize: 9.5,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 0.8,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Flat Cashback on Top Brands',
                                      style: GoogleFonts.fraunces(
                                        color: Colors.white,
                                        fontSize: 14.5,
                                        fontWeight: FontWeight.bold,
                                        height: 1.2,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      'Up to 15% bonus rewards',
                                      style: AppTextStyles.caption(
                                        color: Colors.white.withValues(alpha: 0.82),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    InkWell(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pushNamed(AllCategoriesScreen.routeName);
                                      },
                                      borderRadius: BorderRadius.circular(20),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: AppColors.beigeSurface,
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              'Explore Now',
                                              style: GoogleFonts.fraunces(
                                                color: AppColors.primaryBrown,
                                                fontSize: 11.5,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            const Icon(
                                              Icons.arrow_forward_rounded,
                                              size: 13,
                                              color: AppColors.primaryBrown,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withValues(alpha: 0.12),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.stars_rounded,
                                    size: 32,
                                    color: Color(0xFFFFD700),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // 3. QUICK CATEGORY OPTIONS: ROW OF 3 SMALL ROUNDED CARDS
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              _buildQuickCard(
                                context: context,
                                provider: categoryProvider,
                                title: 'Laptops',
                                icon: Icons.laptop_mac_rounded,
                                accentColor: AppColors.primaryBrown,
                                query: 'laptops',
                                cardBg: cardBgColor,
                                cardBorder: cardBorderColor,
                              ),
                              const SizedBox(width: 8),
                              _buildQuickCard(
                                context: context,
                                provider: categoryProvider,
                                title: 'Beauty',
                                icon: Icons.face_retouching_natural_rounded,
                                accentColor: AppColors.primaryBrown,
                                query: 'beauty',
                                cardBg: cardBgColor,
                                cardBorder: cardBorderColor,
                              ),
                              const SizedBox(width: 8),
                              _buildQuickCard(
                                context: context,
                                provider: categoryProvider,
                                title: 'Grocery',
                                icon: Icons.shopping_basket_rounded,
                                accentColor: AppColors.primaryBrown,
                                query: 'groceries',
                                cardBg: cardBgColor,
                                cardBorder: cardBorderColor,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // 4. SECTION HEADING: BROWSE CATEGORIES
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          child: Row(
                            children: [
                              Container(
                                width: 3.5,
                                height: 14,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryBrown,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'BROWSE CATEGORIES',
                                style: GoogleFonts.fraunces(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.1,
                                  color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 8),

                        // 5. CATEGORY ROWS WITH ICON, TITLE, SHORT SUBTITLE & CHEVRON
                        _CategoryRowItem(
                          title: 'Highest Cashback Stores',
                          subtitle: 'Top merchant partners & maximum bonus',
                          icon: Icons.storefront_rounded,
                          accentColor: AppColors.primaryBrown,
                          onTap: () => _onCategoryTap(context, categoryProvider, 'laptops'),
                          dividerColor: dividerColor,
                        ),
                        _CategoryRowItem(
                          title: 'Retailers By Category',
                          subtitle: 'Explore stores by department & perks',
                          icon: Icons.category_rounded,
                          accentColor: AppColors.primaryBrown,
                          onTap: () => _onCategoryTap(context, categoryProvider, 'groceries'),
                          dividerColor: dividerColor,
                        ),
                        _CategoryRowItem(
                          title: 'Top Product Deals',
                          subtitle: 'Handpicked daily discounts & offers',
                          icon: Icons.local_offer_rounded,
                          accentColor: AppColors.primaryBrown,
                          onTap: () => _onCategoryTap(context, categoryProvider, 'beauty'),
                          dividerColor: dividerColor,
                        ),
                        _CategoryRowItem(
                          title: 'Laptops & PCs',
                          subtitle: 'MacBooks, gaming & thin notebooks',
                          icon: Icons.laptop_mac_rounded,
                          accentColor: AppColors.primaryBrown,
                          onTap: () => _onCategoryTap(context, categoryProvider, 'laptops'),
                          dividerColor: dividerColor,
                        ),
                        _CategoryRowItem(
                          title: 'Smartphones',
                          subtitle: 'iPhones, Android & flagship phones',
                          icon: Icons.smartphone_rounded,
                          accentColor: AppColors.primaryBrown,
                          onTap: () => _onCategoryTap(context, categoryProvider, 'smartphones'),
                          dividerColor: dividerColor,
                        ),
                        _CategoryRowItem(
                          title: 'Tablets',
                          subtitle: 'iPads, Android tabs & productivity slates',
                          icon: Icons.tablet_android_rounded,
                          accentColor: AppColors.primaryBrown,
                          onTap: () => _onCategoryTap(context, categoryProvider, 'tablets'),
                          dividerColor: dividerColor,
                        ),
                        _CategoryRowItem(
                          title: 'Men Shirts',
                          subtitle: 'Casual, formal, linen & denim shirts',
                          icon: Icons.checkroom_rounded,
                          accentColor: AppColors.primaryBrown,
                          onTap: () => _onCategoryTap(context, categoryProvider, 'mens-shirts'),
                          dividerColor: dividerColor,
                        ),
                        _CategoryRowItem(
                          title: 'Women Dresses',
                          subtitle: 'Western, ethnic, party & casual wear',
                          icon: Icons.style_rounded,
                          accentColor: AppColors.primaryBrown,
                          onTap: () => _onCategoryTap(context, categoryProvider, 'womens-dresses'),
                          dividerColor: dividerColor,
                        ),
                        _CategoryRowItem(
                          title: 'Men Shoes',
                          subtitle: 'Sneakers, sports, loafers & formal',
                          icon: Icons.directions_walk_rounded,
                          accentColor: AppColors.primaryBrown,
                          onTap: () => _onCategoryTap(context, categoryProvider, 'mens-shoes'),
                          dividerColor: dividerColor,
                        ),
                        _CategoryRowItem(
                          title: 'Women Shoes',
                          subtitle: 'Heels, flats, boots & active footwear',
                          icon: Icons.diamond_rounded,
                          accentColor: AppColors.primaryBrown,
                          onTap: () => _onCategoryTap(context, categoryProvider, 'womens-shoes'),
                          dividerColor: dividerColor,
                        ),
                        _CategoryRowItem(
                          title: 'Beauty',
                          subtitle: 'Skincare, haircare, makeup & perfumes',
                          icon: Icons.face_retouching_natural_rounded,
                          accentColor: AppColors.primaryBrown,
                          onTap: () => _onCategoryTap(context, categoryProvider, 'beauty'),
                          dividerColor: dividerColor,
                        ),
                        _CategoryRowItem(
                          title: 'Grocery',
                          subtitle: 'Daily essentials, staples & kitchen food',
                          icon: Icons.shopping_cart_rounded,
                          accentColor: AppColors.primaryBrown,
                          onTap: () => _onCategoryTap(context, categoryProvider, 'groceries'),
                          dividerColor: dividerColor,
                        ),
                        _CategoryRowItem(
                          title: 'Kitchen Accessories',
                          subtitle: 'Cookware, appliances & dining sets',
                          icon: Icons.kitchen_rounded,
                          accentColor: AppColors.primaryBrown,
                          onTap: () => _onCategoryTap(context, categoryProvider, 'kitchen-accessories'),
                          dividerColor: dividerColor,
                        ),

                        const SizedBox(height: 10),

                        // 6. SEE ALL CATEGORIES HIGHLIGHTED BOTTOM BANNER
                        Container(
                          margin: const EdgeInsets.fromLTRB(16, 6, 16, 16),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkCard : AppColors.cardBackground,
                            borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
                            border: Border.all(
                              color: isDark ? AppColors.darkBorder : AppColors.border,
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
                              onTap: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).pushNamed(AllCategoriesScreen.routeName);
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: isDark ? AppColors.darkSurface : AppColors.beigeSurface,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.grid_view_rounded,
                                        size: 18,
                                        color: isDark ? AppColors.darkTextPrimary : AppColors.primaryBrown,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'See All Categories',
                                            style: AppTextStyles.cardTitle(
                                              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                                            ).copyWith(fontSize: 14),
                                          ),
                                          const SizedBox(height: 1),
                                          Text(
                                            'Explore 20+ more categories & deals',
                                            style: AppTextStyles.caption(
                                              color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 13,
                                      color: isDark ? AppColors.darkTextPrimary : AppColors.primaryBrown,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickCard({
    required BuildContext context,
    required CategoryProvider provider,
    required String title,
    required IconData icon,
    required Color accentColor,
    required String query,
    required Color cardBg,
    required Color cardBorder,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppDimensions.radiusNormal),
          onTap: () => _onCategoryTap(context, provider, query),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(AppDimensions.radiusNormal),
              border: Border.all(color: cardBorder, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : AppColors.beigeSurface,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      icon,
                      size: 18,
                      color: isDark ? AppColors.darkTextPrimary : accentColor,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption(
                    color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                  ).copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryRowItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final VoidCallback onTap;
  final Color dividerColor;

  const _CategoryRowItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    required this.onTap,
    required this.dividerColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  // Circular Icon Container with subtle beige surface
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurface : AppColors.beigeSurface,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        icon,
                        size: 18,
                        color: isDark ? AppColors.darkTextPrimary : accentColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Category Name & Short Subtitle
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.cardTitle(
                            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                          ).copyWith(fontSize: 14),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption(
                            color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Right Chevron Arrow
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 18,
                    color: isDark ? AppColors.darkBorder : AppColors.border,
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 66, right: 16),
          child: Divider(height: 1, thickness: 1, color: dividerColor),
        ),
      ],
    );
  }
}
