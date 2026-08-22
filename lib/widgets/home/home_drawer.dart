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
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.5,
      backgroundColor: isDark ? const Color(0xFF161618) : Colors.white,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // COMPACT HEADER: CASHKARO BRANDING
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1E90FF), Color(0xFF0F172A)],
                ),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: const Text(
                'CashKaro',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'HandwrittenItalic',
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2.0,
                ),
              ),
            ),

            // SCROLLABLE SECTIONED CATEGORIES LIST FILLING FULL SCREEN HEIGHT
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
                                    // 1. SHOP & EARN
                                    const _DrawerSectionHeader(title: 'Shop & Earn'),
                                    _DrawerCategoryItem(
                                      title: 'Highest Cashback Stores',
                                      onTap: () => _onCategoryTap(context, categoryProvider, 'laptops'),
                                    ),
                                    _DrawerCategoryItem(
                                      title: 'Retailers By Category',
                                      onTap: () => _onCategoryTap(context, categoryProvider, 'groceries'),
                                    ),
                                    _DrawerCategoryItem(
                                      title: 'Top Product Deals',
                                      onTap: () => _onCategoryTap(context, categoryProvider, 'beauty'),
                                    ),

                                    const SizedBox(height: 6),
                                    Divider(
                                      height: 1,
                                      thickness: 1,
                                      color: isDark ? const Color(0xFF28282A) : const Color(0xFFEFEFF4),
                                    ),

                                    // 2. SHOP BY DEVICES
                                    const _DrawerSectionHeader(title: 'Shop by Devices'),
                                    _DrawerCategoryItem(
                                      title: 'Laptop',
                                      onTap: () => _onCategoryTap(context, categoryProvider, 'laptops'),
                                    ),
                                    _DrawerCategoryItem(
                                      title: 'Smartphones',
                                      onTap: () => _onCategoryTap(context, categoryProvider, 'smartphones'),
                                    ),
                                    _DrawerCategoryItem(
                                      title: 'Tablets',
                                      onTap: () => _onCategoryTap(context, categoryProvider, 'tablets'),
                                    ),

                                    const SizedBox(height: 6),
                                    Divider(
                                      height: 1,
                                      thickness: 1,
                                      color: isDark ? const Color(0xFF28282A) : const Color(0xFFEFEFF4),
                                    ),

                                    // 3. FASHION & LIFESTYLES
                                    const _DrawerSectionHeader(title: 'Fashion & Lifestyles'),
                                    _DrawerCategoryItem(
                                      title: 'Men Shirts',
                                      onTap: () => _onCategoryTap(context, categoryProvider, 'mens-shirts'),
                                    ),
                                    _DrawerCategoryItem(
                                      title: 'Women Dresses',
                                      onTap: () => _onCategoryTap(context, categoryProvider, 'womens-dresses'),
                                    ),
                                    _DrawerCategoryItem(
                                      title: 'Men Shoes',
                                      onTap: () => _onCategoryTap(context, categoryProvider, 'mens-shoes'),
                                    ),
                                    _DrawerCategoryItem(
                                      title: 'Women Shoes',
                                      onTap: () => _onCategoryTap(context, categoryProvider, 'womens-shoes'),
                                    ),

                                    const SizedBox(height: 6),
                                    Divider(
                                      height: 1,
                                      thickness: 1,
                                      color: isDark ? const Color(0xFF28282A) : const Color(0xFFEFEFF4),
                                    ),

                                    // 4. MORE CATEGORIES
                                    const _DrawerSectionHeader(title: 'More Categories'),
                                    _DrawerCategoryItem(
                                      title: 'Beauty',
                                      onTap: () => _onCategoryTap(context, categoryProvider, 'beauty'),
                                    ),
                                    _DrawerCategoryItem(
                                      title: 'Grocery',
                                      onTap: () => _onCategoryTap(context, categoryProvider, 'groceries'),
                                    ),
                                    _DrawerCategoryItem(
                                      title: 'Kitchen Accessories',
                                      onTap: () => _onCategoryTap(context, categoryProvider, 'kitchen-accessories'),
                                    ),
                                  ],
                                ),

                                // BOTTOM: SEE ALL CATEGORIES
                                Column(
                                  children: [
                                    const SizedBox(height: 10),
                                    Divider(
                                      height: 1,
                                      thickness: 1,
                                      color: isDark ? const Color(0xFF28282A) : const Color(0xFFEFEFF4),
                                    ),
                                    const SizedBox(height: 6),
                                    _DrawerCategoryItem(
                                      title: 'See All Categories',
                                      isHighlight: true,
                                      showChevron: true,
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pushNamed(AllCategoriesScreen.routeName);
                                      },
                                    ),
                                    const SizedBox(height: 16),
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

class _DrawerSectionHeader extends StatelessWidget {
  final String title;

  const _DrawerSectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(left: 14, right: 14, top: 14, bottom: 6),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.0,
          color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF1E90FF),
        ),
      ),
    );
  }
}

class _DrawerCategoryItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool showChevron;
  final bool isHighlight;

  const _DrawerCategoryItem({
    required this.title,
    required this.onTap,
    this.showChevron = true,
    this.isHighlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isHighlight
                        ? const Color(0xFF1E90FF)
                        : (isDark ? Colors.white : const Color(0xFF1F1F21)),
                  ),
                ),
              ),
              if (showChevron)
                Icon(
                  Icons.chevron_right,
                  size: 16,
                  color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
