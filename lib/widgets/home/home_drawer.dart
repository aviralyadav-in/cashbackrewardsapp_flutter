import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/category_provider.dart';
import '../../screens/all_categories_screen.dart';
import '../../screens/categories_screen.dart';

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
    final dividerColor = isDark ? const Color(0xFF28282A) : const Color(0xFFF0F0F2);
    final cardBgColor = isDark ? const Color(0xFF1C1C1E) : const Color(0xFFFAFAFC);
    final cardBorderColor = isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA);

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.84,
      backgroundColor: isDark ? const Color(0xFF121214) : Colors.white,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. CLEAN HEADER WITH "Categories" AND CIRCULAR CLOSE (X) BUTTON
            Container(
              color: isDark ? const Color(0xFF121214) : Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.2,
                      color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                    ),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDark ? const Color(0xFF242428) : const Color(0xFFF2F2F5),
                      ),
                      child: Icon(
                        Icons.close_rounded,
                        size: 18,
                        color: isDark ? Colors.white70 : const Color(0xFF4A4A4A),
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
                        const SizedBox(height: 12),

                        // 2. PROMOTIONAL CASHBACK BANNER
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF1E90FF), Color(0xFF0F172A)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF1E90FF).withValues(alpha: 0.28),
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
                                      child: const Text(
                                        'SPECIAL OFFER',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 9.5,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 0.8,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    const Text(
                                      'Flat Cashback on Top Brands',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.bold,
                                        height: 1.2,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Up to 15% bonus rewards',
                                      style: TextStyle(
                                        color: Colors.white.withValues(alpha: 0.8),
                                        fontSize: 11,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    InkWell(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pushNamed(AllCategoriesScreen.routeName);
                                      },
                                      borderRadius: BorderRadius.circular(20),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: const Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              'Explore Now',
                                              style: TextStyle(
                                                color: Color(0xFF1E90FF),
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(width: 4),
                                            Icon(
                                              Icons.arrow_forward_rounded,
                                              size: 12,
                                              color: Color(0xFF1E90FF),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 52,
                                height: 52,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withValues(alpha: 0.12),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.stars_rounded,
                                    size: 34,
                                    color: Color(0xFFFFD700),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 14),

                        // 3. QUICK CATEGORY OPTIONS: ROW OF 4 SMALL ROUNDED CARDS
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              _buildQuickCard(
                                context: context,
                                provider: categoryProvider,
                                title: 'Laptops',
                                icon: Icons.laptop_mac_rounded,
                                accentColor: const Color(0xFF1E90FF),
                                query: 'laptops',
                                cardBg: cardBgColor,
                                cardBorder: cardBorderColor,
                              ),
                              const SizedBox(width: 8),
                             
                              const SizedBox(width: 8),
                              _buildQuickCard(
                                context: context,
                                provider: categoryProvider,
                                title: 'Beauty',
                                icon: Icons.face_retouching_natural_rounded,
                                accentColor: const Color(0xFF8B5CF6),
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
                                accentColor: const Color(0xFF10B981),
                                query: 'groceries',
                                cardBg: cardBgColor,
                                cardBorder: cardBorderColor,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 18),

                        // 4. SECTION HEADING: BROWSE CATEGORIES
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          child: Row(
                            children: [
                              Text(
                                'BROWSE CATEGORIES',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.1,
                                  color: isDark ? const Color(0xFF8E8E93) : const Color(0xFF6E6E73),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 6),

                        // 5. CATEGORY ROWS WITH ICON, TITLE, SHORT SUBTITLE & CHEVRON
                        _CategoryRowItem(
                          title: 'Highest Cashback Stores',
                          subtitle: 'Top merchant partners & maximum bonus',
                          icon: Icons.storefront_rounded,
                          accentColor: const Color(0xFF1E90FF),
                          onTap: () => _onCategoryTap(context, categoryProvider, 'laptops'),
                          dividerColor: dividerColor,
                        ),
                        _CategoryRowItem(
                          title: 'Retailers By Category',
                          subtitle: 'Explore stores by department & perks',
                          icon: Icons.category_rounded,
                          accentColor: const Color(0xFF6366F1),
                          onTap: () => _onCategoryTap(context, categoryProvider, 'groceries'),
                          dividerColor: dividerColor,
                        ),
                        _CategoryRowItem(
                          title: 'Top Product Deals',
                          subtitle: 'Handpicked daily discounts & offers',
                          icon: Icons.local_offer_rounded,
                          accentColor: const Color(0xFFF59E0B),
                          onTap: () => _onCategoryTap(context, categoryProvider, 'beauty'),
                          dividerColor: dividerColor,
                        ),
                        _CategoryRowItem(
                          title: 'Laptop',
                          subtitle: 'MacBooks, gaming & thin notebooks',
                          icon: Icons.laptop_mac_rounded,
                          accentColor: const Color(0xFF0284C7),
                          onTap: () => _onCategoryTap(context, categoryProvider, 'laptops'),
                          dividerColor: dividerColor,
                        ),
                        _CategoryRowItem(
                          title: 'Smartphones',
                          subtitle: 'iPhones, Android & flagship phones',
                          icon: Icons.smartphone_rounded,
                          accentColor: const Color(0xFF0D9488),
                          onTap: () => _onCategoryTap(context, categoryProvider, 'smartphones'),
                          dividerColor: dividerColor,
                        ),
                        _CategoryRowItem(
                          title: 'Tablets',
                          subtitle: 'iPads, Android tabs & productivity slates',
                          icon: Icons.tablet_android_rounded,
                          accentColor: const Color(0xFF3B82F6),
                          onTap: () => _onCategoryTap(context, categoryProvider, 'tablets'),
                          dividerColor: dividerColor,
                        ),
                        _CategoryRowItem(
                          title: 'Men Shirts',
                          subtitle: 'Casual, formal, linen & denim shirts',
                          icon: Icons.checkroom_rounded,
                          accentColor: const Color(0xFF4F46E5),
                          onTap: () => _onCategoryTap(context, categoryProvider, 'mens-shirts'),
                          dividerColor: dividerColor,
                        ),
                        _CategoryRowItem(
                          title: 'Women Dresses',
                          subtitle: 'Western, ethnic, party & casual wear',
                          icon: Icons.style_rounded,
                          accentColor: const Color(0xFFDB2777),
                          onTap: () => _onCategoryTap(context, categoryProvider, 'womens-dresses'),
                          dividerColor: dividerColor,
                        ),
                        _CategoryRowItem(
                          title: 'Men Shoes',
                          subtitle: 'Sneakers, sports, loafers & formal',
                          icon: Icons.directions_walk_rounded,
                          accentColor: const Color(0xFF059669),
                          onTap: () => _onCategoryTap(context, categoryProvider, 'mens-shoes'),
                          dividerColor: dividerColor,
                        ),
                        _CategoryRowItem(
                          title: 'Women Shoes',
                          subtitle: 'Heels, flats, boots & active footwear',
                          icon: Icons.diamond_rounded,
                          accentColor: const Color(0xFFD946EF),
                          onTap: () => _onCategoryTap(context, categoryProvider, 'womens-shoes'),
                          dividerColor: dividerColor,
                        ),
                        _CategoryRowItem(
                          title: 'Beauty',
                          subtitle: 'Skincare, haircare, makeup & perfumes',
                          icon: Icons.face_retouching_natural_rounded,
                          accentColor: const Color(0xFFE11D48),
                          onTap: () => _onCategoryTap(context, categoryProvider, 'beauty'),
                          dividerColor: dividerColor,
                        ),
                        _CategoryRowItem(
                          title: 'Grocery',
                          subtitle: 'Daily essentials, staples & kitchen food',
                          icon: Icons.shopping_cart_rounded,
                          accentColor: const Color(0xFF16A34A),
                          onTap: () => _onCategoryTap(context, categoryProvider, 'groceries'),
                          dividerColor: dividerColor,
                        ),
                        _CategoryRowItem(
                          title: 'Kitchen Accessories',
                          subtitle: 'Cookware, appliances & dining sets',
                          icon: Icons.kitchen_rounded,
                          accentColor: const Color(0xFFEA580C),
                          onTap: () => _onCategoryTap(context, categoryProvider, 'kitchen-accessories'),
                          dividerColor: dividerColor,
                        ),

                        const SizedBox(height: 8),

                        // 6. SEE ALL CATEGORIES HIGHLIGHTED BOTTOM BANNER
                        Container(
                          margin: const EdgeInsets.fromLTRB(16, 6, 16, 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E90FF).withValues(alpha: isDark ? 0.16 : 0.08),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: const Color(0xFF1E90FF).withValues(alpha: isDark ? 0.35 : 0.22),
                              width: 1,
                            ),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(14),
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
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF1E90FF),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.grid_view_rounded,
                                        size: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    const Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'See All Categories',
                                            style: TextStyle(
                                              fontSize: 13.5,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF1E90FF),
                                            ),
                                          ),
                                          SizedBox(height: 1),
                                          Text(
                                            'Explore 20+ more categories & deals',
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Color(0xFF1E90FF),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 13,
                                      color: Color(0xFF1E90FF),
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
          borderRadius: BorderRadius.circular(12),
          onTap: () => _onCategoryTap(context, provider, query),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(12),
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
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: isDark ? 0.22 : 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      icon,
                      size: 18,
                      color: accentColor,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF222222),
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
              child: Row(
                children: [
                  // Circular Icon Container with subtle tinted theme background
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: isDark ? 0.2 : 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        icon,
                        size: 18,
                        color: accentColor,
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
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : const Color(0xFF1E1E1E),
                          ),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark ? Colors.grey.shade500 : const Color(0xFF757575),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Right Chevron Arrow
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 18,
                    color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 64, right: 16),
          child: Divider(height: 1, thickness: 1, color: dividerColor),
        ),
      ],
    );
  }
}
