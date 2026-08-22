import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/category_provider.dart';
import '../widgets/network_image_with_skeleton.dart';
import 'product_detail_screen.dart';

class CategoriesScreen extends StatefulWidget {
  static const String routeName = '/categories';

  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final ScrollController _categoryScrollController = ScrollController();
  String? _lastScrolledCategory;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final provider = context.read<CategoryProvider>();
      provider.fetchCategories().then((_) {
        if (mounted && provider.selectedCategory != null) {
          _scrollToSelectedCategory(provider.selectedCategory, provider.categories);
        }
      });
    });
  }

  @override
  void dispose() {
    _categoryScrollController.dispose();
    super.dispose();
  }

  void _scrollToSelectedCategory(String? selectedCategory, List<String> categories) {
    if (selectedCategory == null || categories.isEmpty) return;

    final selectedIndex = categories.indexOf(selectedCategory);
    if (selectedIndex < 0) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_categoryScrollController.hasClients) return;

      final screenWidth = MediaQuery.of(context).size.width;

      double targetOffset = 0.0;
      for (int i = 0; i < selectedIndex; i++) {
        final tp = TextPainter(
          text: TextSpan(
            text: categories[i],
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        // Item padding horizontal (18*2 = 36) + separator (10)
        targetOffset += tp.width + 36.0 + 10.0;
      }

      final selectedTp = TextPainter(
        text: TextSpan(
          text: categories[selectedIndex],
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      final selectedWidth = selectedTp.width + 36.0;

      final centeredOffset = targetOffset - (screenWidth / 2) + (selectedWidth / 2) + 16.0;
      final maxScroll = _categoryScrollController.position.maxScrollExtent;
      final clampedOffset = centeredOffset.clamp(0.0, maxScroll);

      _categoryScrollController.animateTo(
        clampedOffset,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  title: Text(
    'Categories',
    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),
  ),
  centerTitle: true,
),
      body: Consumer<CategoryProvider>(
        builder: (context, provider, child) {
          if (provider.categoriesStatus == CategoryStatus.loading &&
              provider.categories.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 12),
                  Text('Loading categories...'),
                ],
              ),
            );
          }

          if (provider.categoriesStatus == CategoryStatus.error) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Color(0xFF1E90FF),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      provider.errorMessage,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: provider.fetchCategories,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (provider.categories.isEmpty) {
            return const Center(
              child: Text('No categories available.'),
            );
          }

          // Trigger auto-scroll whenever selectedCategory updates
          if (provider.selectedCategory != null &&
              _lastScrolledCategory != provider.selectedCategory) {
            _lastScrolledCategory = provider.selectedCategory;
            _scrollToSelectedCategory(provider.selectedCategory, provider.categories);
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const SizedBox(height: 12),

                // ALL CATEGORIES HORIZONTAL SCROLLABLE LIST WITH AUTO-SCROLL
                SizedBox(
                  height: 55,
                  child: ListView.separated(
                    controller: _categoryScrollController,
                    scrollDirection: Axis.horizontal,
                    itemCount: provider.categories.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      final category = provider.categories[index];

                      final isSelected =
                          provider.selectedCategory == category;

                      return GestureDetector(
                        onTap: () {
                          provider.fetchProductsByCategory(category);
                          _scrollToSelectedCategory(category, provider.categories);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF1E90FF)
                                : Theme.of(context).cardTheme.color,
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFF1E90FF)
                                  : (Theme.of(context).brightness == Brightness.dark
                                      ? const Color(0xFF1E293B)
                                      : const Color(0xFFE5E5EA)),
                            ),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Center(
                            child: Text(
                              category,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // PRODUCTS
                Expanded(
                  child: _buildCategoryProducts(
                    context,
                    provider,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryProducts(
    BuildContext context,
    CategoryProvider provider,
  ) {
    if (provider.selectedCategory == null &&
        provider.productsStatus == CategoryStatus.initial) {
      return const Center(
        child: Text('Choose a category to view products.'),
      );
    }

    if (provider.productsStatus == CategoryStatus.loading) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: Color(0xFF1E90FF)),
            SizedBox(height: 12),
            Text('Loading products...'),
          ],
        ),
      );
    }

    if (provider.productsStatus == CategoryStatus.error) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                size: 48,
                color: Color(0xFF1E90FF),
              ),
              const SizedBox(height: 12),
              Text(
                provider.errorMessage,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => provider.fetchProductsByCategory(
                  provider.selectedCategory ?? '',
                ),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (provider.products.isEmpty) {
      return const Center(
        child: Text('No products found for this category.'),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        if (provider.selectedCategory != null) {
          await provider.fetchProductsByCategory(
            provider.selectedCategory!,
          );
        }
      },
      child: ListView.separated(
        padding: const EdgeInsets.only(bottom: 16),
        physics: const BouncingScrollPhysics(),
        itemCount: provider.products.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final product = provider.products[index];
          final isDark = Theme.of(context).brightness == Brightness.dark;

          return Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                Navigator.of(context).pushNamed(
                  ProductDetailScreen.routeName,
                  arguments: product,
                );
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF161618) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? const Color(0xFF28282A) : const Color(0xFFE5E5EA),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 96,
                        height: 96,
                        color: isDark ? const Color(0xFF242426) : const Color(0xFFF5F5F7),
                        child: NetworkImageWithSkeleton(
                          imageUrl: product.thumbnail,
                          width: 96,
                          height: 96,
                          fit: BoxFit.cover,
                          borderRadius: BorderRadius.circular(12),
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 96,
                              height: 96,
                              color: isDark ? const Color(0xFF242426) : Colors.grey.shade200,
                              child: const Icon(
                                Icons.broken_image_outlined,
                                size: 32,
                                color: Colors.grey,
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Product Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Product Name
                          Text(
                            product.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),

                          const SizedBox(height: 4),

                          // Product Description
                          Text(
                            product.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                              height: 1.3,
                            ),
                          ),

                          const SizedBox(height: 8),

                          // Pricing Section
                          if (product.discountPercentage > 0)
                            Row(
                              children: [
                                Text(
                                  'Actual: \$${product.originalPrice.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    decoration: TextDecoration.lineThrough,
                                    color: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade700.withValues(alpha: isDark ? 0.25 : 0.12),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    '${product.discountPercentage.toStringAsFixed(0)}% OFF',
                                    style: TextStyle(
                                      fontSize: 10.5,
                                      color: isDark ? Colors.green.shade400 : Colors.green.shade800,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                          const SizedBox(height: 4),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Final: \$${product.finalPrice.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  color: const Color(0xFF1E90FF),
                                ),
                              ),
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFF1E90FF).withValues(alpha: isDark ? 0.16 : 0.08),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 12,
                                    color: Color(0xFF1E90FF),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}