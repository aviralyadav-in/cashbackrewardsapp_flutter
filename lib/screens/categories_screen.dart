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
        itemCount: provider.products.length,
        separatorBuilder: (context, index) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Divider(
            height: 1,
            thickness: 1,
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFF28282A)
                : const Color(0xFFE5E5EA),
          ),
        ),
        itemBuilder: (context, index) {
          final product = provider.products[index];
          final isDark = Theme.of(context).brightness == Brightness.dark;

          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                Navigator.of(context).pushNamed(
                  ProductDetailScreen.routeName,
                  arguments: product,
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: NetworkImageWithSkeleton(
                        imageUrl: product.thumbnail,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        borderRadius: BorderRadius.circular(12),
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 100,
                            height: 100,
                            color: isDark
                                ? const Color(0xFF242426)
                                : Colors.grey.shade200,
                            child: const Icon(
                              Icons.broken_image,
                              size: 40,
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.title,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),

                          const SizedBox(height: 6),

                          Text(
                            product.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: isDark
                                      ? Colors.grey[400]
                                      : Colors.grey[700],
                                ),
                          ),

                          const SizedBox(height: 10),

                          // PRICE BREAKDOWN: ACTUAL PRICE -> DISCOUNT -> FINAL PRICE
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (product.discountPercentage > 0)
                                Row(
                                  children: [
                                    Text(
                                      'Actual: \$${product.originalPrice.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        decoration: TextDecoration.lineThrough,
                                        color: isDark
                                            ? Colors.grey.shade500
                                            : Colors.grey.shade600,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.green.shade50,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        '${product.discountPercentage.toStringAsFixed(0)}% OFF',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.green.shade800,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                              const SizedBox(height: 4),

                              Row(
                                children: [
                                  Text(
                                    'Final: \$${product.finalPrice.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: isDark
                                          ? Colors.green.shade400
                                          : Colors.green.shade700,
                                    ),
                                  ),
                                  const Spacer(),
                                  const Icon(
                                    Icons.chevron_right,
                                    size: 20,
                                    color: Colors.grey,
                                  ),
                                ],
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