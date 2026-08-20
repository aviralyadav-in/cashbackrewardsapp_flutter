import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/category_provider.dart';
import '../providers/product_provider.dart';
import 'categories_screen.dart';
import 'missing_tickets_screen.dart';
import 'my_earnings_screen.dart';
import 'notifications_screen.dart';
import 'offer_section_screen.dart';
import 'profile_screen.dart';
import 'refer_earn_screen.dart';
import 'search_screen.dart';
import 'ticket_screen.dart';
import '../models/brand_model.dart';
import '../services/url_launcher_service.dart';
import '../widgets/cashback_banner_carousel.dart';
import '../widgets/network_image_with_skeleton.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      await context.read<ProductProvider>().fetchProducts();
      if (!mounted) return;
      await context.read<CategoryProvider>().fetchCategories();
    });
  }

  void _onBottomNavigationTap(int index) {
    if (index == _selectedIndex && index == 0) return;

    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.of(context).pushNamed(ReferEarnScreen.routeName).then((_) {
          if (mounted) setState(() => _selectedIndex = 0);
        });
        break;
      case 2:
        Navigator.of(context).pushNamed(MyEarningsScreen.routeName).then((_) {
          if (mounted) setState(() => _selectedIndex = 0);
        });
        break;
      case 3:
        Navigator.of(context).pushNamed(MissingTicketsScreen.routeName).then((_) {
          if (mounted) setState(() => _selectedIndex = 0);
        });
        break;
      case 4:
        Navigator.of(context).pushNamed(ProfileScreen.routeName).then((_) {
          if (mounted) setState(() => _selectedIndex = 0);
        });
        break;
    }
  }

  void _handleCategoryClick(CategoryProvider provider, String targetQuery) {
    String matchedCat = targetQuery;
    if (provider.categories.isNotEmpty) {
      final lowerQuery = targetQuery.toLowerCase().replaceAll(' ', '-');
      final found = provider.categories.firstWhere(
        (cat) =>
            cat.toLowerCase().replaceAll(' ', '-') == lowerQuery ||
            cat.toLowerCase().contains(lowerQuery) ||
            lowerQuery.contains(cat.toLowerCase().replaceAll(' ', '-')),
        orElse: () => targetQuery,
      );
      matchedCat = found;
    }

    provider.fetchProductsByCategory(matchedCat);
    Navigator.of(context).pushNamed(CategoriesScreen.routeName);
  }

  void _onCategoryTap(CategoryProvider provider, String targetQuery) {
    Navigator.of(context).pop();
    _handleCategoryClick(provider, targetQuery);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: isDark ? const Color(0xFF0D0D0D) : const Color(0xFFF6F7F9),

      // =========================
      // LEFT CATEGORIES DRAWER
      // =========================
      drawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.5,
        backgroundColor: isDark ? const Color(0xFF161618) : Colors.white,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // COMPACT HEADER: CASHKARO BRANDING
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1E90FF), Color(0xFF0F172A)],
                  ),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                child: Text(
                  'CashKaro',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'HandwrittenItalic',
                    color: Colors.white,
                    fontSize:30,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 3.0,                
                  ),
                ),
              ),

              // SCROLLABLE SECTIONED CATEGORIES LIST
              Expanded(
                child: Consumer<CategoryProvider>(
                  builder: (context, categoryProvider, child) {
                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // 1. SHOP & EARN
                          const _DrawerSectionHeader(title: 'Shop & Earn'),
                          _DrawerCategoryItem(
                            title: 'Highest Cashback Stores',
                            onTap: () => _onCategoryTap(categoryProvider, 'laptops'),
                          ),
                          _DrawerCategoryItem(
                            title: 'Retailers By Category',
                            onTap: () => _onCategoryTap(categoryProvider, 'groceries'),
                          ),
                          _DrawerCategoryItem(
                            title: 'Top Product Deals',
                            onTap: () => _onCategoryTap(categoryProvider, 'beauty'),
                          ),

                          const SizedBox(height: 6),
                          Divider(
                            height: 1,
                            thickness: 1,
                            color: isDark ? const Color(0xFF28282A) : const Color(0xFFEFEFF4),
                          ),

                          // 2. SHOP BY DEVICE
                          const _DrawerSectionHeader(title: 'Shop By Device'),
                          _DrawerCategoryItem(
                            title: 'Laptops',
                            onTap: () => _onCategoryTap(categoryProvider, 'laptops'),
                          ),
                          _DrawerCategoryItem(
                            title: 'Smartphones',
                            onTap: () => _onCategoryTap(categoryProvider, 'smartphones'),
                          ),
                          _DrawerCategoryItem(
                            title: 'Tablets',
                            onTap: () => _onCategoryTap(categoryProvider, 'tablets'),
                          ),
                          _DrawerCategoryItem(
                            title: 'Mobile Accessories',
                            onTap: () => _onCategoryTap(categoryProvider, 'mobile-accessories'),
                          ),

                          const SizedBox(height: 6),
                          Divider(
                            height: 1,
                            thickness: 1,
                            color: isDark ? const Color(0xFF28282A) : const Color(0xFFEFEFF4),
                          ),

                          // 3. FASHION & LIFESTYLE
                          const _DrawerSectionHeader(title: 'Fashion & Lifestyle'),
                          _DrawerCategoryItem(
                            title: 'Mens Shirts',
                            onTap: () => _onCategoryTap(categoryProvider, 'mens-shirts'),
                          ),
                          _DrawerCategoryItem(
                            title: 'Mens Shoes',
                            onTap: () => _onCategoryTap(categoryProvider, 'mens-shoes'),
                          ),
                          _DrawerCategoryItem(
                            title: 'Mens Watches',
                            onTap: () => _onCategoryTap(categoryProvider, 'mens-watches'),
                          ),
                          _DrawerCategoryItem(
                            title: 'Womens Dresses',
                            onTap: () => _onCategoryTap(categoryProvider, 'womens-dresses'),
                          ),
                          _DrawerCategoryItem(
                            title: 'Womens Shoes',
                            onTap: () => _onCategoryTap(categoryProvider, 'womens-shoes'),
                          ),
                          _DrawerCategoryItem(
                            title: 'Womens Bags',
                            onTap: () => _onCategoryTap(categoryProvider, 'womens-bags'),
                          ),
                          _DrawerCategoryItem(
                            title: 'Womens Jewellery',
                            onTap: () => _onCategoryTap(categoryProvider, 'womens-jewellery'),
                          ),
                          _DrawerCategoryItem(
                            title: 'Womens Watches',
                            onTap: () => _onCategoryTap(categoryProvider, 'womens-watches'),
                          ),
                          _DrawerCategoryItem(
                            title: 'Tops',
                            onTap: () => _onCategoryTap(categoryProvider, 'tops'),
                          ),
                          _DrawerCategoryItem(
                            title: 'Sunglasses',
                            onTap: () => _onCategoryTap(categoryProvider, 'sunglasses'),
                          ),
                          _DrawerCategoryItem(
                            title: 'Beauty',
                            onTap: () => _onCategoryTap(categoryProvider, 'beauty'),
                          ),
                          _DrawerCategoryItem(
                            title: 'Fragrances',
                            onTap: () => _onCategoryTap(categoryProvider, 'fragrances'),
                          ),
                          _DrawerCategoryItem(
                            title: 'Skin Care',
                            onTap: () => _onCategoryTap(categoryProvider, 'skin-care'),
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
                            title: 'Furniture',
                            onTap: () => _onCategoryTap(categoryProvider, 'furniture'),
                          ),
                          _DrawerCategoryItem(
                            title: 'Groceries',
                            onTap: () => _onCategoryTap(categoryProvider, 'groceries'),
                          ),
                          _DrawerCategoryItem(
                            title: 'Home Decoration',
                            onTap: () => _onCategoryTap(categoryProvider, 'home-decoration'),
                          ),
                          _DrawerCategoryItem(
                            title: 'Kitchen Accessories',
                            onTap: () => _onCategoryTap(categoryProvider, 'kitchen-accessories'),
                          ),
                          _DrawerCategoryItem(
                            title: 'Motorcycle',
                            onTap: () => _onCategoryTap(categoryProvider, 'motorcycle'),
                          ),
                          _DrawerCategoryItem(
                            title: 'Vehicle',
                            onTap: () => _onCategoryTap(categoryProvider, 'vehicle'),
                          ),
                          _DrawerCategoryItem(
                            title: 'Sports Accessories',
                            onTap: () => _onCategoryTap(categoryProvider, 'sports-accessories'),
                          ),

                          const SizedBox(height: 10),
                          Divider(
                            height: 1,
                            thickness: 1,
                            color: isDark ? const Color(0xFF28282A) : const Color(0xFFEFEFF4),
                          ),
                          const SizedBox(height: 6),

                          // SEE ALL CATEGORIES
                          _DrawerCategoryItem(
                            title: 'See All Categories',
                            isHighlight: true,
                            showChevron: true,
                            onTap: () {
                              Navigator.of(context).pop();
                              if (categoryProvider.categories.isNotEmpty) {
                                categoryProvider.fetchProductsByCategory(
                                  categoryProvider.categories.first,
                                );
                              }
                              Navigator.of(context).pushNamed(CategoriesScreen.routeName);
                            },
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),

      // =========================
      // MAIN BODY & CONTENT
      // =========================
      body: SafeArea(
        child: Column(
          children: [
            // TOP HEADER
            Container(
              color: isDark ? const Color(0xFF161618) : Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  // Hamburger Menu Icon
                  IconButton(
                    icon: const Icon(Icons.menu, size: 26),
                    onPressed: () {
                      _scaffoldKey.currentState?.openDrawer();
                    },
                    tooltip: 'Categories',
                  ),

                  // App Logo & Title
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E90FF).withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.card_giftcard,
                            color: Color(0xFF1E90FF),
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'CashKaro',
                          style: TextStyle(
                            fontFamily: 'HandwrittenItalic',
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1E90FF),
                            letterSpacing: 3.0,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Notification Bell Icon
                  IconButton(
                    icon: const Icon(Icons.notifications_none_outlined, size: 26),
                    onPressed: () {
                      Navigator.of(context).pushNamed(NotificationsScreen.routeName);
                    },
                    tooltip: 'Notifications',
                  ),
                ],
              ),
            ),

            // SEARCH BAR
            Container(
              color: isDark ? const Color(0xFF161618) : Colors.white,
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(SearchScreen.routeName);
                },
                child: Container(
                  height: 46,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF242426) : const Color(0xFFF0F2F5),
                    borderRadius: BorderRadius.circular(23),
                    border: Border.all(
                      color: isDark ? const Color(0xFF2E2E2E) : const Color(0xFFE2E4E8),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.search,
                        color: Colors.grey.shade500,
                        size: 22,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Search for products',
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // HOME CONTENT
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await context.read<ProductProvider>().fetchProducts();
                },
                child: Consumer2<ProductProvider, CategoryProvider>(
                  builder: (context, provider, categoryProvider, child) {
                    return ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        const GoldenTicketBanner(),
                        const SizedBox(height: 20),

                        // DYNAMIC E-COMMERCE CASHBACK BANNER CAROUSEL
                        const CashbackBannerCarousel(),
                        const SizedBox(height: 24),

                        // TOP CATEGORIES SECTION
                        _TopCategoriesSection(
                          isDark: isDark,
                        ),
                        const SizedBox(height: 24),

                        // FLIPKART – FREEDOM SALE
                        _OfferSectionCarouselWidget(
                          title: 'Flipkart – Freedom Sale',
                          items: _flipkartOffers,
                          onViewAllTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => OfferSectionScreen(
                                  title: 'Flipkart – Freedom Sale',
                                  items: _flipkartOffers,
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 24),

                        // MEESHO – TOP DEALS
                        _OfferSectionCarouselWidget(
                          title: 'Meesho – Top Deals',
                          items: _meeshoOffers,
                          onViewAllTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => OfferSectionScreen(
                                  title: 'Meesho – Top Deals',
                                  items: _meeshoOffers,
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 24),

                        // BEST OF LOANS
                        _OfferSectionCarouselWidget(
                          title: 'Best of Loans',
                          items: _loanOffers,
                          onViewAllTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => OfferSectionScreen(
                                  title: 'Best of Loans',
                                  items: _loanOffers,
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 24),

                        // EXCLUSIVE CASHBACK DEALS (API SECTION)
                        if (provider.status == ProductStatus.loading ||
                            provider.status == ProductStatus.initial)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 40.0),
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircularProgressIndicator(),
                                  SizedBox(height: 16),
                                  Text('Loading best cashback deals...'),
                                ],
                              ),
                            ),
                          )
                        else if (provider.status == ProductStatus.error)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 30.0),
                            child: Center(
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
                                    onPressed: provider.fetchProducts,
                                    child: const Text('Retry'),
                                  ),
                                ],
                              ),
                            ),
                          )
                        else if (provider.products.isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 40.0),
                            child: Center(
                              child: Text('No offers available right now.'),
                            ),
                          )
                        else
                          Builder(
                            builder: (context) {
                              final apiOffers = provider.products
                                  .map(
                                    (p) => OfferSectionItem(
                                      id: p.id,
                                      title: p.title,
                                      description: p.description,
                                      priceOrRate: '\$${p.price.toStringAsFixed(2)}',
                                      cashbackTag:
                                          'FLAT ${p.discountPercentage.toStringAsFixed(0)}% CASHBACK',
                                      imageUrl: p.thumbnail,
                                      storeName: 'Exclusive',
                                    ),
                                  )
                                  .toList();

                              return _OfferSectionCarouselWidget(
                                title: 'Exclusive Cashback Deals',
                                items: apiOffers,
                                onViewAllTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => OfferSectionScreen(
                                        title: 'Exclusive Cashback Deals',
                                        items: apiOffers,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),

                        // ABSOLUTE BOTTOM FADED BRANDING SECTION (VERY LARGE, BRAND-STYLED TAGLINE)
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 50,
                            bottom: 50,
                            left: 4,
                            right: 4,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Your Shopping.',
                                style: TextStyle(
                                  fontFamily: 'HandwrittenItalic',
                                  fontSize: 60,
                                  fontWeight: FontWeight.bold,
                                  height: 1.1,
                                  color: isDark
                                      ? Colors.white.withValues(alpha: 0.16)
                                      : const Color(0xFF1F1F21).withValues(alpha: 0.16),
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Your Cashback.',
                                style: TextStyle(
                                  fontFamily: 'HandwrittenItalic',
                                  fontSize: 60,
                                  fontWeight: FontWeight.bold,
                                  height: 1.1,
                                  color: isDark
                                      ? Colors.white.withValues(alpha: 0.16)
                                      : const Color(0xFF1F1F21).withValues(alpha: 0.16),
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                'Made for smart shoppers 😎',
                                style: TextStyle(
                                  fontFamily: 'HandwrittenItalic',
                                  fontSize: 40,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? Colors.white.withValues(alpha: 0.40)
                                      : const Color(0xFF1F1F21).withValues(alpha: 0.40),
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),

      // =========================
      // 5-ITEM FIXED BOTTOM NAVIGATION
      // =========================
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF1E90FF),
        unselectedItemColor: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
        backgroundColor: isDark ? const Color(0xFF161618) : Colors.white,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        elevation: 10,
        onTap: _onBottomNavigationTap,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard_outlined),
            activeIcon: Icon(Icons.card_giftcard),
            label: 'Refer & Earn',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            activeIcon: Icon(Icons.account_balance_wallet),
            label: 'My Earnings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            activeIcon: Icon(Icons.receipt_long),
            label: 'Missing',
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
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    color: isHighlight
                        ? const Color(0xFF1E90FF)
                        : (isDark ? Colors.white : const Color(0xFF1F1F21)),
                  ),
                ),
              ),
              if (showChevron)
                Icon(
                  Icons.chevron_right,
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

final List<OfferSectionItem> _flipkartOffers = const [
  OfferSectionItem(
    id: 101,
    title: 'Samsung Galaxy M34 5G',
    description: '6GB RAM, 128GB Storage, 50MP Camera',
    priceOrRate: '\$199',
    cashbackTag: 'FLAT 15% CASHBACK',
    imageUrl:
        'https://cdn.dummyjson.com/products/images/smartphones/iPhone%205s/1.png',
    storeName: 'Flipkart',
  ),
  OfferSectionItem(
    id: 102,
    title: 'Realme Buds Air 5',
    description: 'Active Noise Cancellation, 38H Playtime',
    priceOrRate: '\$39',
    cashbackTag: 'FLAT 20% CASHBACK',
    imageUrl:
        'https://cdn.dummyjson.com/products/images/mobile-accessories/Apple%20AirPods%20Max/1.png',
    storeName: 'Flipkart',
  ),
  OfferSectionItem(
    id: 103,
    title: 'ASUS Vivobook 15',
    description: 'Intel Core i5 12th Gen, 16GB RAM',
    priceOrRate: '\$499',
    cashbackTag: 'FLAT 10% CASHBACK',
    imageUrl:
        'https://cdn.dummyjson.com/products/images/laptops/Apple%20MacBook%20Pro%2014%20Inch%20Space%20Grey/1.png',
    storeName: 'Flipkart',
  ),
  OfferSectionItem(
    id: 104,
    title: 'Boult Drift Smartwatch',
    description: '1.85" HD Display, Bluetooth Calling',
    priceOrRate: '\$25',
    cashbackTag: 'FLAT 25% CASHBACK',
    imageUrl:
        'https://cdn.dummyjson.com/products/images/womens-watches/IWC%20Ingenieur%20Automatic/1.png',
    storeName: 'Flipkart',
  ),
  OfferSectionItem(
    id: 105,
    title: 'Sony Bravia 4K Smart TV',
    description: '55 Inch Google TV, Dolby Atmos',
    priceOrRate: '\$599',
    cashbackTag: 'FLAT 12% CASHBACK',
    imageUrl:
        'https://cdn.dummyjson.com/products/images/mobile-accessories/Amazon%20Echo%20Dot%203rd%20Gen/1.png',
    storeName: 'Flipkart',
  ),
];

final List<OfferSectionItem> _meeshoOffers = const [
  OfferSectionItem(
    id: 201,
    title: 'Designer Silk Saree',
    description: 'Traditional Embroidered Saree',
    priceOrRate: '\$29',
    cashbackTag: 'UP TO 25% CASHBACK',
    imageUrl:
        'https://cdn.dummyjson.com/products/images/womens-dresses/Corset%20Mini%20Dress/1.png',
    storeName: 'Meesho',
  ),
  OfferSectionItem(
    id: 202,
    title: 'Men Casual Printed Shirt',
    description: '100% Breathable Cotton Fit',
    priceOrRate: '\$15',
    cashbackTag: 'UP TO 30% CASHBACK',
    imageUrl:
        'https://cdn.dummyjson.com/products/images/mens-shirts/Man%20Shirt/1.png',
    storeName: 'Meesho',
  ),
  OfferSectionItem(
    id: 203,
    title: 'Matte Lipstick Combo',
    description: 'Long Lasting 12H Stay Lipstick',
    priceOrRate: '\$12',
    cashbackTag: 'UP TO 20% CASHBACK',
    imageUrl:
        'https://cdn.dummyjson.com/products/images/beauty/Essence%20Mascara%20Lash%20Princess/1.png',
    storeName: 'Meesho',
  ),
  OfferSectionItem(
    id: 204,
    title: 'Running Sports Shoes',
    description: 'Lightweight Mesh Comfort Shoes',
    priceOrRate: '\$22',
    cashbackTag: 'UP TO 18% CASHBACK',
    imageUrl:
        'https://cdn.dummyjson.com/products/images/mens-shoes/Sports%20Sneakers/1.png',
    storeName: 'Meesho',
  ),
  OfferSectionItem(
    id: 205,
    title: 'Kitchen Storage Container',
    description: 'Set of 12 Airtight Jar Set',
    priceOrRate: '\$18',
    cashbackTag: 'UP TO 22% CASHBACK',
    imageUrl:
        'https://cdn.dummyjson.com/products/images/kitchen-accessories/Bamboo%20Spatula/1.png',
    storeName: 'Meesho',
  ),
];

final List<OfferSectionItem> _loanOffers = const [
  OfferSectionItem(
    id: 301,
    title: 'Instant Personal Loan',
    description: 'Quick Approval in 10 Mins',
    priceOrRate: '10.49% p.a.',
    cashbackTag: 'FLAT \$50 REWARD',
    imageUrl:
        'https://cdn.dummyjson.com/products/images/groceries/Apple/1.png',
    storeName: 'Loans',
  ),
  OfferSectionItem(
    id: 302,
    title: 'Pre-Approved Home Loan',
    description: 'Lowest Interest Rates & 0 Processing Fee',
    priceOrRate: '8.40% p.a.',
    cashbackTag: 'FLAT \$100 REWARD',
    imageUrl:
        'https://cdn.dummyjson.com/products/images/groceries/Honey%20Jar/1.png',
    storeName: 'Loans',
  ),
  OfferSectionItem(
    id: 303,
    title: 'Business Expansion Loan',
    description: 'Unsecured Collateral-Free Business Loan',
    priceOrRate: '11.99% p.a.',
    cashbackTag: 'FLAT \$75 REWARD',
    imageUrl:
        'https://cdn.dummyjson.com/products/images/groceries/Kiwi/1.png',
    storeName: 'Loans',
  ),
  OfferSectionItem(
    id: 304,
    title: 'Instant Credit Card Loan',
    description: 'Zero Interest for 45 Days',
    priceOrRate: '0% Interest',
    cashbackTag: 'FLAT \$30 REWARD',
    imageUrl:
        'https://cdn.dummyjson.com/products/images/groceries/Lemon/1.png',
    storeName: 'Loans',
  ),
  OfferSectionItem(
    id: 305,
    title: 'Higher Education Loan',
    description: 'Coverage for Tuition & Living Expenses',
    priceOrRate: '9.50% p.a.',
    cashbackTag: 'FLAT \$60 REWARD',
    imageUrl:
        'https://cdn.dummyjson.com/products/images/groceries/Milk/1.png',
    storeName: 'Loans',
  ),
];

class _OfferSectionCarouselWidget extends StatelessWidget {
  final String title;
  final List<OfferSectionItem> items;
  final VoidCallback onViewAllTap;

  const _OfferSectionCarouselWidget({
    required this.title,
    required this.items,
    required this.onViewAllTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 18,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E90FF),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: onViewAllTap,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E90FF).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'View All',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E90FF),
                      ),
                    ),
                    SizedBox(width: 2),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 10,
                      color: Color(0xFF1E90FF),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Horizontal Carousel
        SizedBox(
          height: 195,
          child: items.isEmpty
              ? const Center(child: Text('No offers available'))
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];

                    return Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: GestureDetector(
                        onTap: onViewAllTap,
                        child: Container(
                          width: 155,
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF161618) : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isDark
                                  ? const Color(0xFF2E2E2E)
                                  : const Color(0xFFE5E5EA),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Image section
                                Expanded(
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      NetworkImageWithSkeleton(
                                        imageUrl: item.imageUrl,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            color: isDark
                                                ? const Color(0xFF242426)
                                                : Colors.grey.shade200,
                                            child: Icon(
                                              Icons.image_not_supported_outlined,
                                              size: 32,
                                              color: Colors.grey.shade500,
                                            ),
                                          );
                                        },
                                      ),

                                      // Cashback badge
                                      Positioned(
                                        top: 6,
                                        right: 6,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 3,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.green.shade700,
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            item.cashbackTag,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 8.5,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Card info
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        item.title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.bold,
                                          color: isDark ? Colors.white : Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            item.priceOrRate,
                                            style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w900,
                                              color: Color(0xFF1E90FF),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 4,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF1E90FF).withValues(alpha: 0.1),
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              item.storeName.toUpperCase(),
                                              style: const TextStyle(
                                                fontSize: 8,
                                                fontWeight: FontWeight.bold,
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
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

// ==========================================
// TOP CATEGORIES SECTION WIDGET & DATA
// ==========================================
class _TopCategoryItemData {
  final String title;
  final IconData icon;
  final String slug;

  const _TopCategoryItemData({
    required this.title,
    required this.icon,
    required this.slug,
  });
}

final List<_TopCategoryItemData> _topCategories = const [
  _TopCategoryItemData(
    title: 'Most Popular',
    icon: Icons.local_fire_department_rounded,
    slug: 'smartphones',
  ),
  _TopCategoryItemData(
    title: 'Fashion',
    icon: Icons.checkroom_rounded,
    slug: 'mens-shirts',
  ),
  _TopCategoryItemData(
    title: 'Credit Cards',
    icon: Icons.credit_card_rounded,
    slug: 'groceries',
  ),
  _TopCategoryItemData(
    title: 'Beauty & Grooming',
    icon: Icons.face_retouching_natural_rounded,
    slug: 'beauty',
  ),
  _TopCategoryItemData(
    title: 'Home & Kitchen',
    icon: Icons.home_rounded,
    slug: 'home-decoration',
  ),
  _TopCategoryItemData(
    title: 'Electronics',
    icon: Icons.devices_rounded,
    slug: 'laptops',
  ),
  _TopCategoryItemData(
    title: 'Food & Grocery',
    icon: Icons.shopping_bag_rounded,
    slug: 'groceries',
  ),
  _TopCategoryItemData(
    title: 'Mobiles',
    icon: Icons.smartphone_rounded,
    slug: 'smartphones',
  ),
  _TopCategoryItemData(
    title: 'Pharmacy',
    icon: Icons.medical_services_rounded,
    slug: 'skin-care',
  ),
  _TopCategoryItemData(
    title: 'Health & Wellness',
    icon: Icons.health_and_safety_rounded,
    slug: 'skin-care',
  ),
  _TopCategoryItemData(
    title: 'Loans',
    icon: Icons.account_balance_wallet_rounded,
    slug: 'groceries',
  ),
  _TopCategoryItemData(
    title: 'Departmental',
    icon: Icons.storefront_rounded,
    slug: 'groceries',
  ),
  _TopCategoryItemData(
    title: 'Flights & Hotels',
    icon: Icons.flight_takeoff_rounded,
    slug: 'smartphones',
  ),
  _TopCategoryItemData(
    title: 'Education',
    icon: Icons.school_rounded,
    slug: 'laptops',
  ),
];

class _TopCategoriesSection extends StatefulWidget {
  final bool isDark;

  const _TopCategoriesSection({
    required this.isDark,
  });

  @override
  State<_TopCategoriesSection> createState() => _TopCategoriesSectionState();
}

class _TopCategoriesSectionState extends State<_TopCategoriesSection> {
  String _selectedCategoryTitle = 'Most Popular';

  void _showConfirmationDialog(BuildContext context, BrandModel brand) {
    final isDark = widget.isDark;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF1C1C1E) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          contentPadding: const EdgeInsets.all(24),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon Header
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E90FF).withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.exit_to_app_rounded,
                  color: Color(0xFF1E90FF),
                  size: 32,
                ),
              ),
              const SizedBox(height: 16),

              // Title
              Text(
                'You’re leaving CashKaro',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 8),

              // Subtitle
              Text(
                'You are about to visit ${brand.name}.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 16),

              // Cashback Info Box
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: const Color(0xFF1E90FF).withValues(alpha: 0.25),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.card_giftcard_rounded,
                      color: Color(0xFF1E90FF),
                      size: 22,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            brand.cashbackPercentage,
                            style: const TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E90FF),
                            ),
                          ),
                          Text(
                            'Cashback will be tracked automatically.',
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Action Buttons
              Row(
                children: [
                  // Cancel / Go Back Button
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: isDark ? Colors.white : Colors.black87,
                        side: BorderSide(
                          color: isDark ? const Color(0xFF3A3A3C) : const Color(0xFFD1D1D6),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Continue / Visit Website Button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.of(ctx).pop();
                        final success = await UrlLauncherService.openUrl(brand.websiteUrl);
                        if (!success && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Could not open ${brand.name} website'),
                              backgroundColor: const Color(0xFF1E90FF),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E90FF),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Continue',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final activeBrands = _getBrandsForTopCategory(_selectedCategoryTitle);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. SECTION HEADER
        Row(
          children: [
            Container(
              width: 4,
              height: 18,
              decoration: BoxDecoration(
                color: const Color(0xFF1E90FF),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Top Categories',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // 2. HORIZONTAL CATEGORIES SCROLL LIST
        SizedBox(
          height: 98,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: _topCategories.length,
            separatorBuilder: (context, index) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final cat = _topCategories[index];
              final isSelected = _selectedCategoryTitle == cat.title;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedCategoryTitle = cat.title;
                  });
                },
                child: SizedBox(
                  width: 72,
                  child: Column(
                    children: [
                      Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected
                              ? const Color(0xFF1E90FF)
                              : (isDark
                                  ? const Color(0xFF1E1E20)
                                  : const Color(0xFF1E90FF).withValues(alpha: 0.08)),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF1E90FF)
                                : (isDark
                                    ? const Color(0xFF2C2C2E)
                                    : const Color(0xFF1E90FF).withValues(alpha: 0.2)),
                            width: isSelected ? 2 : 1.2,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: const Color(0xFF1E90FF).withValues(alpha: 0.35),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ]
                              : null,
                        ),
                        child: Center(
                          child: Icon(
                            cat.icon,
                            size: 26,
                            color: isSelected ? Colors.white : const Color(0xFF1E90FF),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        cat.title,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                          height: 1.15,
                          color: isSelected
                              ? const Color(0xFF1E90FF)
                              : (isDark ? Colors.grey.shade300 : Colors.black87),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 14),

        // 3. WEBSITES & BRAND BANNERS GRID (3 CARDS PER ROW WITH SUBTLE BACKGROUND VARIATION)
        _buildBrandGridContainer(context, activeBrands, isDark),
      ],
    );
  }

  Widget _buildBrandGridContainer(
      BuildContext context, List<BrandModel> brands, bool isDark) {
    if (brands.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 28),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF141416) : const Color(0xFFF2F3F6),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Center(
          child: Text(
            'No websites available for $_selectedCategoryTitle yet.',
            style: TextStyle(
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              fontSize: 13,
            ),
          ),
        ),
      );
    }

    // Chunk brands into rows of 3
    final List<List<BrandModel>> rows = [];
    for (var i = 0; i < brands.length; i += 3) {
      rows.add(
        brands.sublist(i, i + 3 > brands.length ? brands.length : i + 3),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF141416) : const Color(0xFFF2F3F6),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: List.generate(rows.length, (rowIndex) {
          final rowBrands = rows[rowIndex];
          final isLastRow = rowIndex == rows.length - 1;

          return Padding(
            padding: EdgeInsets.only(bottom: isLastRow ? 0.0 : 12.0),
            child: Row(
              children: [
                Expanded(
                  child: _buildGridBrandCard(context, rowBrands[0], isDark),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: rowBrands.length > 1
                      ? _buildGridBrandCard(context, rowBrands[1], isDark)
                      : const SizedBox.shrink(),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: rowBrands.length > 2
                      ? _buildGridBrandCard(context, rowBrands[2], isDark)
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildGridBrandCard(
      BuildContext context, BrandModel brand, bool isDark) {
    return GestureDetector(
      onTap: () => _showConfirmationDialog(context, brand),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Cover Banner Image with Cashback Badge Overlay
              SizedBox(
                height: 90,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: NetworkImageWithSkeleton(
                        imageUrl: brand.bannerUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withValues(alpha: 0.6),
                              Colors.transparent,
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                      ),
                    ),
                    // Cashback badge pill
                    Positioned(
                      top: 6,
                      left: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 3.5),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
                          ),
                          borderRadius: BorderRadius.circular(7),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Text(
                          brand.cashbackPercentage,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 2. Logo, Brand Name & CTA Button
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                child: Column(
                  children: [
                    // Brand Logo
                    Container(
                      width: 38,
                      height: 38,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF242426)
                            : Colors.grey.shade100,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF1E90FF).withValues(alpha: 0.35),
                          width: 1.2,
                        ),
                      ),
                      child: ClipOval(
                        child: NetworkImageWithSkeleton(
                          imageUrl: brand.logoUrl,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => Center(
                            child: Text(
                              brand.name.substring(0, 1),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E90FF),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Brand Name
                    Text(
                      brand.name,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Shop Now Mini CTA Button
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E90FF),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF1E90FF).withValues(alpha: 0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Text(
                        'Shop Now',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<BrandModel> _getBrandsForTopCategory(String title) {
    switch (title) {
      case 'Most Popular':
        return const [
          BrandModel(
            name: 'Amazon.in',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/a/a9/Amazon_logo.svg',
            bannerUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Up to 8% Cashback',
            category: 'Most Popular',
            offerText: 'Earn rewards on Electronics, Fashion, Appliances & More',
            websiteUrl: 'https://www.amazon.in',
          ),
          BrandModel(
            name: 'Flipkart',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/7/7a/Flipkart_logo.svg',
            bannerUrl: 'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Up to 7% Cashback',
            category: 'Most Popular',
            offerText: 'Best Cashback Deals on Smartphones, Laptops & Home',
            websiteUrl: 'https://www.flipkart.com',
          ),
          BrandModel(
            name: 'Myntra',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/b/bc/Myntra_Logo.png',
            bannerUrl: 'https://images.unsplash.com/photo-1483985988355-763728e1935b?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Flat 7.5% Cashback',
            category: 'Most Popular',
            offerText: 'India Premier Fashion Destination + Extra Rewards',
            websiteUrl: 'https://www.myntra.com',
          ),
          BrandModel(
            name: 'AJIO',
            logoUrl: 'https://assets.ajio.com/static/img/Ajio-Logo.svg',
            bannerUrl: 'https://images.unsplash.com/photo-1445205170230-053b83016050?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Flat 10% Cashback',
            category: 'Most Popular',
            offerText: 'Trendy Apparel & International Brands with Real Cashback',
            websiteUrl: 'https://www.ajio.com',
          ),
          BrandModel(
            name: 'Nike',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/a/a6/Logo_NIKE.svg',
            bannerUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Up to 9% Cashback',
            category: 'Most Popular',
            offerText: 'Iconic Footwear, Athletic Wear & Sneakers',
            websiteUrl: 'https://www.nike.com/in',
          ),
        ];

      case 'Fashion':
        return const [
          BrandModel(
            name: 'Myntra',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/b/bc/Myntra_Logo.png',
            bannerUrl: 'https://images.unsplash.com/photo-1483985988355-763728e1935b?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Flat 7.5% Cashback',
            category: 'Fashion',
            offerText: 'Top Brands in Menswear, Womenswear & Footwear',
            websiteUrl: 'https://www.myntra.com',
          ),
          BrandModel(
            name: 'AJIO',
            logoUrl: 'https://assets.ajio.com/static/img/Ajio-Logo.svg',
            bannerUrl: 'https://images.unsplash.com/photo-1445205170230-053b83016050?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Flat 10% Cashback',
            category: 'Fashion',
            offerText: 'Exclusive Styles & Designer Wardrobe Essentials',
            websiteUrl: 'https://www.ajio.com',
          ),
          BrandModel(
            name: 'H&M',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/5/53/H%26M-Logo.svg',
            bannerUrl: 'https://images.unsplash.com/photo-1490481651871-ab68de25d43d?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Flat 8% Cashback',
            category: 'Fashion',
            offerText: 'Sustainable & Trendy Everyday Fashion',
            websiteUrl: 'https://www2.hm.com/en_in',
          ),
          BrandModel(
            name: 'Zara',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/f/fd/Zara_Logo.svg',
            bannerUrl: 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Up to 6% Cashback',
            category: 'Fashion',
            offerText: 'High Street Fashion & Modern Apparel',
            websiteUrl: 'https://www.zara.com/in',
          ),
          BrandModel(
            name: 'Nike',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/a/a6/Logo_NIKE.svg',
            bannerUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Up to 9% Cashback',
            category: 'Fashion',
            offerText: 'Premium Athletic Wear & Footwear',
            websiteUrl: 'https://www.nike.com/in',
          ),
        ];

      case 'Credit Cards':
        return const [
          BrandModel(
            name: 'HDFC Bank Credit Cards',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/2/28/HDFC_Bank_Logo.svg',
            bannerUrl: 'https://images.unsplash.com/photo-1559526324-4b87b5e36e44?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Flat ₹1,500 Bonus',
            category: 'Credit Cards',
            offerText: 'Lifetime Free Cards with Airport Lounge Access & Rewards',
            websiteUrl: 'https://www.hdfcbank.com',
          ),
          BrandModel(
            name: 'SBI Card',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/c/cc/SBI-Logo.svg',
            bannerUrl: 'https://images.unsplash.com/photo-1563013544-824ae1b704d3?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Flat ₹1,200 Cashback',
            category: 'Credit Cards',
            offerText: 'Instant 5% Cashback on All Online Shopping Spends',
            websiteUrl: 'https://www.sbicard.com',
          ),
          BrandModel(
            name: 'Axis Bank Credit Cards',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/1/1a/Axis_Bank_logo.svg',
            bannerUrl: 'https://images.unsplash.com/photo-1601597111158-2fceff292cdc?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Flat ₹1,500 Cashback',
            category: 'Credit Cards',
            offerText: 'Flipkart Axis Bank 5% Unlimited Cashback Card',
            websiteUrl: 'https://www.axisbank.com',
          ),
          BrandModel(
            name: 'ICICI Bank Credit Cards',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/1/12/ICICI_Bank_Logo.svg',
            bannerUrl: 'https://images.unsplash.com/photo-1556742049-0a67dd385203?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Flat ₹1,000 Rewards',
            category: 'Credit Cards',
            offerText: 'Amazon Pay ICICI Card with Unlimited Rewards',
            websiteUrl: 'https://www.icicibank.com',
          ),
        ];

      case 'Beauty & Grooming':
        return const [
          BrandModel(
            name: 'Nykaa',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/0/00/Nykaa_New_Logo.svg',
            bannerUrl: 'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Up to 8% Cashback',
            category: 'Beauty & Grooming',
            offerText: 'Makeup, Skincare, Haircare & Grooming Products',
            websiteUrl: 'https://www.nykaa.com',
          ),
          BrandModel(
            name: 'Sephora',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/2/21/Sephora_logo.svg',
            bannerUrl: 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Flat 10% Cashback',
            category: 'Beauty & Grooming',
            offerText: 'Luxury Makeup, Fragrances & International Beauty',
            websiteUrl: 'https://sephora.in',
          ),
          BrandModel(
            name: 'MCaffeine',
            logoUrl: 'https://cdn.shopify.com/s/files/1/1454/5188/files/mcaffeine-logo.png',
            bannerUrl: 'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Flat 12% Cashback',
            category: 'Beauty & Grooming',
            offerText: 'Caffeinated Skincare & Body Wash with Extra Bonus',
            websiteUrl: 'https://www.mcaffeine.com',
          ),
          BrandModel(
            name: 'Dot & Key',
            logoUrl: 'https://www.dotandkey.com/cdn/shop/files/Dot_Key_Logo.png',
            bannerUrl: 'https://images.unsplash.com/photo-1598440947619-2c35fc9aa908?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Up to 15% Cashback',
            category: 'Beauty & Grooming',
            offerText: 'Fruit-Infused Skincare & Sunscreen Essentials',
            websiteUrl: 'https://www.dotandkey.com',
          ),
        ];

      case 'Home & Kitchen':
        return const [
          BrandModel(
            name: 'Pepperfry',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/e/e0/Pepperfry_logo.png',
            bannerUrl: 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Flat 9% Cashback',
            category: 'Home & Kitchen',
            offerText: 'Furniture, Home Decor, Kitchenware & Lighting',
            websiteUrl: 'https://www.pepperfry.com',
          ),
          BrandModel(
            name: 'Urban Ladder',
            logoUrl: 'https://www.urbanladder.com/assets/logo.png',
            bannerUrl: 'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Up to 8% Cashback',
            category: 'Home & Kitchen',
            offerText: 'Solid Wood Furniture & Living Room Interiors',
            websiteUrl: 'https://www.urbanladder.com',
          ),
          BrandModel(
            name: 'IKEA India',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/c/c5/Ikea_logo.svg',
            bannerUrl: 'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Up to 5% Cashback',
            category: 'Home & Kitchen',
            offerText: 'Scandinavian Modular Furniture & Smart Kitchen',
            websiteUrl: 'https://www.ikea.com/in',
          ),
        ];

      case 'Electronics':
        return const [
          BrandModel(
            name: 'Reliance Digital',
            logoUrl: 'https://www.reliancedigital.in/build/client/images/rel_stat_svg.svg',
            bannerUrl: 'https://images.unsplash.com/photo-1550009158-9ebf69173e03?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Up to 5% Cashback',
            category: 'Electronics',
            offerText: 'Laptops, Smart TVs, Audio & Home Appliances',
            websiteUrl: 'https://www.reliancedigital.in',
          ),
          BrandModel(
            name: 'Croma',
            logoUrl: 'https://media.croma.com/image/upload/v1637759004/Croma%20Assets/CMS/Category%20Icon/Croma_Logo.png',
            bannerUrl: 'https://images.unsplash.com/photo-1526738549149-8e07eca6c147?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Flat 6% Cashback',
            category: 'Electronics',
            offerText: 'Gadgets, Laptops, Soundbars & Air Conditioners',
            websiteUrl: 'https://www.croma.com',
          ),
          BrandModel(
            name: 'Apple Store Online',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/f/fa/Apple_logo_black.svg',
            bannerUrl: 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Up to 4% Cashback',
            category: 'Electronics',
            offerText: 'MacBook Pro, iPad Air, AirPods & Apple Watch',
            websiteUrl: 'https://www.apple.com/in',
          ),
          BrandModel(
            name: 'Samsung India',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/2/24/Samsung_Logo.svg',
            bannerUrl: 'https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Up to 8% Cashback',
            category: 'Electronics',
            offerText: 'Neo QLED TVs, Refrigerators & Monitors',
            websiteUrl: 'https://www.samsung.com/in',
          ),
        ];

      case 'Food & Grocery':
        return const [
          BrandModel(
            name: 'BigBasket',
            logoUrl: 'https://www.bigbasket.com/static/v263/custui/article/images/bb_logo.png',
            bannerUrl: 'https://images.unsplash.com/photo-1578916171728-46686eac8d58?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Flat 6% Cashback',
            category: 'Food & Grocery',
            offerText: 'Fresh Fruits, Vegetables & Daily Pantry Staples',
            websiteUrl: 'https://www.bigbasket.com',
          ),
          BrandModel(
            name: 'Blinkit',
            logoUrl: 'https://blinkit.com/images/header/blinkit_logo.png',
            bannerUrl: 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Up to 8% Cashback',
            category: 'Food & Grocery',
            offerText: 'Instant Grocery & Snacks Delivery in 10 Minutes',
            websiteUrl: 'https://www.blinkit.com',
          ),
          BrandModel(
            name: 'Walmart',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/c/ca/Walmart_logo2.svg',
            bannerUrl: 'https://images.unsplash.com/photo-1534723452862-4c874018d66d?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Up to 5% Cashback',
            category: 'Food & Grocery',
            offerText: 'Global Grocery Essentials & Wholesale Deals',
            websiteUrl: 'https://www.walmart.com',
          ),
        ];

      case 'Mobiles':
        return const [
          BrandModel(
            name: 'OnePlus India',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/2/2b/OnePlus_logo.svg',
            bannerUrl: 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Up to 6% Cashback',
            category: 'Mobiles',
            offerText: 'Flagship 5G Smartphones & Nord Wireless Earbuds',
            websiteUrl: 'https://www.oneplus.in',
          ),
          BrandModel(
            name: 'Samsung India',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/2/24/Samsung_Logo.svg',
            bannerUrl: 'https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Up to 7% Cashback',
            category: 'Mobiles',
            offerText: 'Galaxy S24 Ultra, Z Fold & M-Series Smartphones',
            websiteUrl: 'https://www.samsung.com/in',
          ),
          BrandModel(
            name: 'Apple Store',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/f/fa/Apple_logo_black.svg',
            bannerUrl: 'https://images.unsplash.com/photo-1510557880182-3d4d3cba35a5?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Up to 4% Cashback',
            category: 'Mobiles',
            offerText: 'iPhone 15 Pro, iPhone 14 & Accessories',
            websiteUrl: 'https://www.apple.com/in',
          ),
        ];

      case 'Pharmacy':
        return const [
          BrandModel(
            name: 'Tata 1mg',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/6/6f/1mg_Logo.png',
            bannerUrl: 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Flat 12% Cashback',
            category: 'Pharmacy',
            offerText: 'Prescription Medicines, Lab Tests & Health Store',
            websiteUrl: 'https://www.1mg.com',
          ),
          BrandModel(
            name: 'PharmEasy',
            logoUrl: 'https://pharmeasy.in/assets/src/images/logo.svg',
            bannerUrl: 'https://images.unsplash.com/photo-1471864190281-a93a3070b6de?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Up to 15% Cashback',
            category: 'Pharmacy',
            offerText: 'Medicines & Health Monitoring Devices Delivered',
            websiteUrl: 'https://www.pharmeasy.in',
          ),
        ];

      case 'Health & Wellness':
        return const [
          BrandModel(
            name: 'HyugaLife',
            logoUrl: 'https://hyugalife.com/assets/logo.png',
            bannerUrl: 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Flat 8% Cashback',
            category: 'Health & Wellness',
            offerText: 'Authentic Health Supplements & Protein Powders',
            websiteUrl: 'https://hyugalife.com',
          ),
          BrandModel(
            name: 'HealthKart',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/d/d7/HealthKart_Logo.png',
            bannerUrl: 'https://images.unsplash.com/photo-1579722821273-0f6c7d44362f?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Up to 10% Cashback',
            category: 'Health & Wellness',
            offerText: 'Bodybuilding Supplements, Vitamins & Immunity Boosters',
            websiteUrl: 'https://www.healthkart.com',
          ),
        ];

      case 'Loans':
        return const [
          BrandModel(
            name: 'MoneyTap',
            logoUrl: 'https://www.moneytap.com/images/logo.png',
            bannerUrl: 'https://images.unsplash.com/photo-1554224155-8d04cb21cd6c?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Flat ₹1,000 Bonus',
            category: 'Loans',
            offerText: 'Instant Personal Credit Line up to 5 Lakhs',
            websiteUrl: 'https://www.moneytap.com',
          ),
          BrandModel(
            name: 'Navi Loans',
            logoUrl: 'https://navi.com/assets/images/navi_logo.png',
            bannerUrl: 'https://images.unsplash.com/photo-1579621970563-ebec7560ff3e?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Flat ₹1,200 Cashback',
            category: 'Loans',
            offerText: 'Zero Paperwork Instant Cash Loans up to 20 Lakhs',
            websiteUrl: 'https://navi.com',
          ),
        ];

      case 'Departmental':
        return const [
          BrandModel(
            name: 'D-Mart Ready',
            logoUrl: 'https://www.dmart.in/images/dmart_logo.png',
            bannerUrl: 'https://images.unsplash.com/photo-1578916171728-46686eac8d58?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Up to 5% Cashback',
            category: 'Departmental',
            offerText: 'Household Supplies, Grocery & Kitchen Offers',
            websiteUrl: 'https://www.dmart.in',
          ),
          BrandModel(
            name: 'Target',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/c/c5/Target_Corporation_logo_vector.svg',
            bannerUrl: 'https://images.unsplash.com/photo-1534723452862-4c874018d66d?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Up to 4% Cashback',
            category: 'Departmental',
            offerText: 'Global Departmental Essentials & Everyday Offers',
            websiteUrl: 'https://www.target.com',
          ),
        ];

      case 'Flights & Hotels':
        return const [
          BrandModel(
            name: 'MakeMyTrip',
            logoUrl: 'https://imgak.mmtcdn.com/pwa_v3/pwa_commons_assets/desktop/logo.png',
            bannerUrl: 'https://images.unsplash.com/photo-1436491865332-7a61a109cc05?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Flat 8% Cashback',
            category: 'Flights & Hotels',
            offerText: 'Flight Bookings, Luxury Resorts & Hotel Savings',
            websiteUrl: 'https://www.makemytrip.com',
          ),
          BrandModel(
            name: 'Booking.com',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/b/be/Booking.com_logo.svg',
            bannerUrl: 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Up to 9% Cashback',
            category: 'Flights & Hotels',
            offerText: 'Worldwide Hotels, Apartments & Vacation Rentals',
            websiteUrl: 'https://www.booking.com',
          ),
          BrandModel(
            name: 'Agoda',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/c/ce/Agoda_logo.svg',
            bannerUrl: 'https://images.unsplash.com/photo-1488646953014-85cb44e25828?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Flat 10% Cashback',
            category: 'Flights & Hotels',
            offerText: 'Hotels, Hostels & Flight Deals Across Asia & World',
            websiteUrl: 'https://www.agoda.com',
          ),
        ];

      case 'Education':
        return const [
          BrandModel(
            name: 'Udemy',
            logoUrl: 'https://www.udemy.com/staticfront/main/assets/v2/logo-udemy.svg',
            bannerUrl: 'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Flat 15% Cashback',
            category: 'Education',
            offerText: 'Online Courses in Coding, AI, Design & Business',
            websiteUrl: 'https://www.udemy.com',
          ),
          BrandModel(
            name: 'Coursera',
            logoUrl: 'https://d3njjcbhbojbot.cloudfront.net/web/images/favicons/icon-192x192.png',
            bannerUrl: 'https://images.unsplash.com/photo-1524178232363-1fb2b075b655?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Up to 12% Cashback',
            category: 'Education',
            offerText: 'Top University Degrees & Professional Certificates',
            websiteUrl: 'https://www.coursera.org',
          ),
          BrandModel(
            name: 'edX',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/8/8f/EdX_logo.svg',
            bannerUrl: 'https://images.unsplash.com/photo-1523240795612-9a054b0db644?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Flat 10% Cashback',
            category: 'Education',
            offerText: 'Harvard, MIT & Top Global University Courses',
            websiteUrl: 'https://www.edx.org',
          ),
        ];

      default:
        return const [
          BrandModel(
            name: 'Amazon.in',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/a/a9/Amazon_logo.svg',
            bannerUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Up to 8% Cashback',
            category: 'E-Commerce',
            offerText: 'Earn rewards on Electronics, Fashion, Appliances & More',
            websiteUrl: 'https://www.amazon.in',
          ),
        ];
    }
  }
}
