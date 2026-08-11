import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/category_provider.dart';
import '../providers/favorite_provider.dart';
import 'offer_details_screen.dart';

class CategoriesScreen extends StatefulWidget {
  static const String routeName = '/categories';

  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context.read<CategoryProvider>().fetchCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
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
                      color: Colors.redAccent,
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

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Categories',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),

                const SizedBox(height: 12),

                // NORMAL CATEGORY LIST
                SizedBox(
                  height: 55,
                  child: ListView.separated(
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
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.redAccent
                                : Theme.of(context).cardTheme.color,
                            border: Border.all(
                              color: isSelected
                                  ? Colors.redAccent
                                  : (Theme.of(context).brightness == Brightness.dark
                                      ? const Color(0xFF2E2E2E)
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
            CircularProgressIndicator(),
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
                color: Colors.redAccent,
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
        separatorBuilder: (context, index) =>
            const SizedBox(height: 14),
        itemBuilder: (context, index) {
          final product = provider.products[index];

          return Consumer<FavoriteProvider>(
            builder: (context, favoriteProvider, child) {
              final isFavorite =
                  favoriteProvider.isFavorite(product.id);

              return InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => OfferDetailsScreen(
                        productId: product.id,
                      ),
                    ),
                  );
                },
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            product.thumbnail,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) {
                              return Container(
                                width: 100,
                                height: 100,
                                color: Colors.grey.shade200,
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
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
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

                              const SizedBox(height: 8),

                              Text(
                                product.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(context).brightness == Brightness.dark
                                          ? Colors.grey[400]
                                          : Colors.grey[700],
                                    ),
                              ),

                              const SizedBox(height: 12),

                              Row(
                                children: [
                                  Text(
                                    '\$${product.price}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),

                                  const Spacer(),

                                  Container(
                                    padding:
                                        const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade50,
                                      borderRadius:
                                          BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      '-${product.discountPercentage.toStringAsFixed(0)}%',
                                      style: TextStyle(
                                        color: Colors.green.shade800,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        IconButton(
                          onPressed: () {
                            favoriteProvider.toggleFavorite(product);
                          },
                          icon: Icon(
                            isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: Colors.red,
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