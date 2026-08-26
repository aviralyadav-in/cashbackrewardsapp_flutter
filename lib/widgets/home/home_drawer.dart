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
    final dividerColor = isDark ? const Color(0xFF28282A) : const Color(0xFFEEEEEE);

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.72,
      backgroundColor: isDark ? const Color(0xFF161618) : Colors.white,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // COMPACT WHITE HEADER: "Category" ON LEFT, CLOSE (X) ICON ON RIGHT
            Container(
              color: isDark ? const Color(0xFF161618) : Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Category',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                    ),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () => Navigator.of(context).pop(),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        Icons.close_rounded,
                        size: 20,
                        color: isDark ? Colors.white70 : const Color(0xFF333333),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // THIN LIGHT-GRAY DIVIDER BELOW HEADER
            Divider(
              height: 1,
              thickness: 1,
              color: dividerColor,
            ),

            // SCROLLABLE CATEGORY LIST
            Expanded(
              child: Consumer<CategoryProvider>(
                builder: (context, categoryProvider, child) {
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight,
                          ),
                          child: IntrinsicHeight(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    const SizedBox(height: 4),

                                    // GROUP 1: SHOP & EARN
                                    _DrawerCategoryItem(
                                      title: 'Highest Cashback Stores',
                                      icon: Icons.storefront_outlined,
                                      onTap: () => _onCategoryTap(context, categoryProvider, 'laptops'),
                                    ),
                                    _DrawerCategoryItem(
                                      title: 'Retailers By Category',
                                      icon: Icons.category_outlined,
                                      onTap: () => _onCategoryTap(context, categoryProvider, 'groceries'),
                                    ),
                                    _DrawerCategoryItem(
                                      title: 'Top Product Deals',
                                      icon: Icons.local_offer_outlined,
                                      onTap: () => _onCategoryTap(context, categoryProvider, 'beauty'),
                                    ),

                                    // DIVIDER
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 4),
                                      child: Divider(
                                        height: 1,
                                        thickness: 1,
                                        color: dividerColor,
                                      ),
                                    ),

                                    // GROUP 2: SHOP BY DEVICES
                                    _DrawerCategoryItem(
                                      title: 'Laptop',
                                      icon: Icons.laptop_outlined,
                                      onTap: () => _onCategoryTap(context, categoryProvider, 'laptops'),
                                    ),
                                    _DrawerCategoryItem(
                                      title: 'Smartphones',
                                      icon: Icons.smartphone_outlined,
                                      onTap: () => _onCategoryTap(context, categoryProvider, 'smartphones'),
                                    ),
                                    _DrawerCategoryItem(
                                      title: 'Tablets',
                                      icon: Icons.tablet_android_outlined,
                                      onTap: () => _onCategoryTap(context, categoryProvider, 'tablets'),
                                    ),

                                    // DIVIDER
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 4),
                                      child: Divider(
                                        height: 1,
                                        thickness: 1,
                                        color: dividerColor,
                                      ),
                                    ),

                                    // GROUP 3: FASHION & LIFESTYLES
                                    _DrawerCategoryItem(
                                      title: 'Men Shirts',
                                      icon: Icons.checkroom_outlined,
                                      onTap: () => _onCategoryTap(context, categoryProvider, 'mens-shirts'),
                                    ),
                                    _DrawerCategoryItem(
                                      title: 'Women Dresses',
                                      icon: Icons.style_outlined,
                                      onTap: () => _onCategoryTap(context, categoryProvider, 'womens-dresses'),
                                    ),
                                    _DrawerCategoryItem(
                                      title: 'Men Shoes',
                                      icon: Icons.directions_walk_outlined,
                                      onTap: () => _onCategoryTap(context, categoryProvider, 'mens-shoes'),
                                    ),
                                    _DrawerCategoryItem(
                                      title: 'Women Shoes',
                                      icon: Icons.diamond_outlined,
                                      onTap: () => _onCategoryTap(context, categoryProvider, 'womens-shoes'),
                                    ),

                                    // DIVIDER
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 4),
                                      child: Divider(
                                        height: 1,
                                        thickness: 1,
                                        color: dividerColor,
                                      ),
                                    ),

                                    // GROUP 4: MORE CATEGORIES
                                    _DrawerCategoryItem(
                                      title: 'Beauty',
                                      icon: Icons.face_retouching_natural_outlined,
                                      onTap: () => _onCategoryTap(context, categoryProvider, 'beauty'),
                                    ),
                                    _DrawerCategoryItem(
                                      title: 'Grocery',
                                      icon: Icons.shopping_cart_outlined,
                                      onTap: () => _onCategoryTap(context, categoryProvider, 'groceries'),
                                    ),
                                    _DrawerCategoryItem(
                                      title: 'Kitchen Accessories',
                                      icon: Icons.kitchen_outlined,
                                      onTap: () => _onCategoryTap(context, categoryProvider, 'kitchen-accessories'),
                                    ),
                                  ],
                                ),

                                // BOTTOM SECTION: SEE ALL CATEGORIES
                                Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 4),
                                      child: Divider(
                                        height: 1,
                                        thickness: 1,
                                        color: dividerColor,
                                      ),
                                    ),
                                    _DrawerCategoryItem(
                                      title: 'See All Categories',
                                      icon: Icons.grid_view_outlined,
                                      showChevron: true,
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pushNamed(AllCategoriesScreen.routeName);
                                      },
                                    ),
                                    const SizedBox(height: 8),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerCategoryItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool showChevron;

  const _DrawerCategoryItem({
    required this.title,
    required this.icon,
    required this.onTap,
    this.showChevron = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              // BLACK/DARK OUTLINE ICON
              Icon(
                icon,
                size: 19,
                color: isDark ? Colors.white70 : const Color(0xFF333333),
              ),
              const SizedBox(width: 12),

              // CATEGORY TITLE IN CLEAN COMPACT REGULAR/MEDIUM FONT
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white : const Color(0xFF222222),
                  ),
                ),
              ),

              // RIGHT-SIDE CHEVRON ARROW
              if (showChevron)
                Icon(
                  Icons.chevron_right_rounded,
                  size: 18,
                  color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
