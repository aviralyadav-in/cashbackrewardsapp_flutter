import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';
import '../providers/favorite_provider.dart';
import '../providers/product_provider.dart';
import 'categories_screen.dart';
import 'favorites_screen.dart';
import 'offer_details_screen.dart';
import 'profile_screen.dart';
import 'search_screen.dart';
import 'ticket_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      await context.read<FavoriteProvider>().initialize();
      if (!mounted) return;
      await context.read<ProductProvider>().fetchProducts();
    });
  }

  void _onBottomNavigationTap(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        //
        break;

      case 1:
        Navigator.of(context).pushNamed(CategoriesScreen.routeName);
        break;

      case 2:
        Navigator.of(context).pushNamed(FavoritesScreen.routeName);
        break;

      case 3:
        Navigator.of(context).pushNamed(ProfileScreen.routeName);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // =========================
      // TOP APP BAR
      // =========================
      appBar: AppBar(
        centerTitle: true,

        // Dark / Light mode button
        leading: Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return IconButton(
              onPressed: () {
                themeProvider.toggleTheme();
              },
              icon: Icon(
                themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
              ),
              tooltip: themeProvider.isDarkMode
                  ? 'Switch to Light Mode'
                  : 'Switch to Dark Mode',
            );
          },
        ),

        actions: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(SearchScreen.routeName);
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [Icon(Icons.search, size: 30)],
              ),
            ),
          ),
        ],

        // Center title
        title: const Text(
          'Home',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      // =========================
      // EXISTING HOME BODY
      // =========================
      body: Consumer<ProductProvider>(
        builder: (context, provider, child) {
          switch (provider.status) {
            case ProductStatus.loading:
              return const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Loading offers...'),
                  ],
                ),
              );

            case ProductStatus.error:
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
                        onPressed: provider.fetchProducts,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );

            case ProductStatus.loaded:
              if (provider.products.isEmpty) {
                return const Center(
                  child: Text('No offers available right now.'),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  await provider.fetchProducts();
                },
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: provider.products.length + 1,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return const GoldenTicketBanner();
                    }

                    final product = provider.products[index - 1];

                    return Consumer<FavoriteProvider>(
                      builder: (context, favoriteProvider, child) {
                        final isFavorite = favoriteProvider.isFavorite(
                          product.id,
                        );

                        return InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    OfferDetailsScreen(productId: product.id),
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

                                  // Favorite button
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

            case ProductStatus.initial:
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),

      // =========================
      // BOTTOM NAVIGATION
      // =========================
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,

        onTap: _onBottomNavigationTap,

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.category_outlined),
            activeIcon: Icon(Icons.category),
            label: 'Categories',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            activeIcon: Icon(Icons.favorite),
            label: 'Favorites',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
