import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/category_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/network_image_with_skeleton.dart';
import 'categories_screen.dart';

class AllCategoriesScreen extends StatefulWidget {
  static const String routeName = '/all-categories';

  const AllCategoriesScreen({super.key});

  @override
  State<AllCategoriesScreen> createState() => _AllCategoriesScreenState();
}

class _AllCategoriesScreenState extends State<AllCategoriesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<CategoryProvider>();
      if (provider.categories.isEmpty) {
        provider.fetchCategories();
      }
    });
  }

  static const Map<String, String> _categoryImages = {
    'beauty': 'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=500&auto=format&fit=crop&q=80',
    'fragrances': 'https://images.unsplash.com/photo-1541643600914-78b084683601?w=500&auto=format&fit=crop&q=80',
    'furniture': 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=500&auto=format&fit=crop&q=80',
    'groceries': 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=500&auto=format&fit=crop&q=80',
    'home-decoration': 'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=500&auto=format&fit=crop&q=80',
    'kitchen-accessories': 'https://images.unsplash.com/photo-1556911220-e15b29be8c8f?w=500&auto=format&fit=crop&q=80',
    'laptops': 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=500&auto=format&fit=crop&q=80',
    'mens-shirts': 'https://images.unsplash.com/photo-1602810318383-e386cc2a3ccf?w=500&auto=format&fit=crop&q=80',
    'mens-shoes': 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=500&auto=format&fit=crop&q=80',
    'mens-watches': 'https://images.unsplash.com/photo-1524592094714-0f0654e20314?w=500&auto=format&fit=crop&q=80',
    'mobile-accessories': 'https://images.unsplash.com/photo-1584438784894-089d6a62b8fa?w=500&auto=format&fit=crop&q=80',
    'motorcycle': 'https://images.unsplash.com/photo-1558981403-c5f9899a28bc?w=500&auto=format&fit=crop&q=80',
    'skin-care': 'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=500&auto=format&fit=crop&q=80',
    'smartphones': 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=500&auto=format&fit=crop&q=80',
    'sports-accessories': 'https://images.unsplash.com/photo-1517649763962-0c623266ddc0?w=500&auto=format&fit=crop&q=80',
    'sunglasses': 'https://images.unsplash.com/photo-1511499767150-a48a237f0083?w=500&auto=format&fit=crop&q=80',
    'tablets': 'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?w=500&auto=format&fit=crop&q=80',
    'tops': 'https://images.unsplash.com/photo-1489987707025-afc232f7ea0f?w=500&auto=format&fit=crop&q=80',
    'vehicle': 'https://images.unsplash.com/photo-1503376780353-7e6692767b70?w=500&auto=format&fit=crop&q=80',
    'womens-bags': 'https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=500&auto=format&fit=crop&q=80',
    'womens-dresses': 'https://images.unsplash.com/photo-1496747611176-843222e1e57c?w=500&auto=format&fit=crop&q=80',
    'womens-jewellery': 'https://images.unsplash.com/photo-1599643478518-a784e5dc4c8f?w=500&auto=format&fit=crop&q=80',
    'womens-shoes': 'https://images.unsplash.com/photo-1543163521-1bf539c55dd2?w=500&auto=format&fit=crop&q=80',
    'womens-watches': 'https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1?w=500&auto=format&fit=crop&q=80',
  };

  static const Map<String, IconData> _categoryIcons = {
    'beauty': Icons.face_retouching_natural_rounded,
    'fragrances': Icons.air_rounded,
    'furniture': Icons.chair_rounded,
    'groceries': Icons.shopping_basket_rounded,
    'home-decoration': Icons.home_rounded,
    'kitchen-accessories': Icons.kitchen_rounded,
    'laptops': Icons.laptop_mac_rounded,
    'mens-shirts': Icons.checkroom_rounded,
    'mens-shoes': Icons.snowshoeing_rounded,
    'mens-watches': Icons.watch_rounded,
    'mobile-accessories': Icons.headphones_rounded,
    'motorcycle': Icons.two_wheeler_rounded,
    'skin-care': Icons.spa_rounded,
    'smartphones': Icons.smartphone_rounded,
    'sports-accessories': Icons.fitness_center_rounded,
    'sunglasses': Icons.visibility_rounded,
    'tablets': Icons.tablet_mac_rounded,
    'tops': Icons.dry_cleaning_rounded,
    'vehicle': Icons.directions_car_rounded,
    'womens-bags': Icons.shopping_bag_rounded,
    'womens-dresses': Icons.woman_rounded,
    'womens-jewellery': Icons.diamond_rounded,
    'womens-shoes': Icons.roller_skating_rounded,
    'womens-watches': Icons.watch_later_rounded,
  };

  String _getImageForCategory(String category) {
    final slug = category.trim().toLowerCase().replaceAll(' ', '-');
    return _categoryImages[slug] ??
        'https://images.unsplash.com/photo-1472851294608-062f824d29cc?w=500&auto=format&fit=crop&q=80';
  }

  IconData _getIconForCategory(String category) {
    final slug = category.trim().toLowerCase().replaceAll(' ', '-');
    return _categoryIcons[slug] ?? Icons.category_rounded;
  }

  void _onSelectCategory(BuildContext context, CategoryProvider provider, String category) {
    provider.fetchProductsByCategory(category);
    Navigator.of(context).pushNamed(CategoriesScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.mainBackground,
      appBar: AppBar(
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
        title: Text(
          'All Categories',
          style: AppTextStyles.screenHeading(
            color: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<CategoryProvider>(
        builder: (context, provider, child) {
          if (provider.categoriesStatus == CategoryStatus.loading && provider.categories.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(color: AppColors.primaryBrown),
                  const SizedBox(height: 14),
                  Text(
                    'Loading all categories...',
                    style: AppTextStyles.caption(
                      color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }

          if (provider.categoriesStatus == CategoryStatus.error && provider.categories.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      size: 48,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.primaryBrown,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      provider.errorMessage,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.body(
                        color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: provider.fetchCategories,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBrown,
                        foregroundColor: AppColors.cardBackground,
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (provider.categories.isEmpty) {
            return Center(
              child: Text(
                'No categories available at the moment.',
                style: AppTextStyles.body(
                  color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            physics: const BouncingScrollPhysics(),
            itemCount: provider.categories.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final categoryName = provider.categories[index];
              final imageUrl = _getImageForCategory(categoryName);
              final iconData = _getIconForCategory(categoryName);

              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _onSelectCategory(context, provider, categoryName),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkCard : AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
                      border: Border.all(
                        color: isDark ? AppColors.darkBorder : AppColors.border,
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Category Thumbnail Image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: SizedBox(
                            width: 72,
                            height: 72,
                            child: NetworkImageWithSkeleton(
                              imageUrl: imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: isDark ? AppColors.darkSurface : AppColors.beigeSurface,
                                  child: Center(
                                    child: Icon(
                                      iconData,
                                      size: 30,
                                      color: isDark ? AppColors.darkTextPrimary : AppColors.primaryBrown,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),

                        // Category Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                categoryName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.cardTitle(
                                  color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                                ).copyWith(fontSize: 15),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    iconData,
                                    size: 14,
                                    color: isDark ? AppColors.darkTextSecondary : AppColors.primaryBrown,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Explore Deals & Products',
                                    style: AppTextStyles.caption(
                                      color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Trailing Chevron Button
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDark ? AppColors.darkSurface : AppColors.beigeSurface,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 14,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.primaryBrown,
                            ),
                          ),
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
    );
  }
}
