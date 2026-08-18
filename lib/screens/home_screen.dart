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

  void _onCategoryTap(CategoryProvider provider, String targetQuery) {
    Navigator.of(context).pop();

    String matchedCat = targetQuery;
    if (provider.categories.isNotEmpty) {
      final lowerQuery = targetQuery.toLowerCase().replaceAll(' ', '-');
      final found = provider.categories.firstWhere(
        (cat) =>
            cat.toLowerCase().replaceAll(' ', '-') == lowerQuery ||
            cat.toLowerCase().contains(lowerQuery) ||
            lowerQuery.contains(cat.toLowerCase().replaceAll(' ', '-')),
        orElse: () => provider.categories.first,
      );
      matchedCat = found;
    }

    provider.fetchProductsByCategory(matchedCat);
    Navigator.of(context).pushNamed(CategoriesScreen.routeName);
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
                    colors: [Colors.redAccent, Colors.red],
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
                            title: 'Mobiles',
                            onTap: () => _onCategoryTap(categoryProvider, 'smartphones'),
                          ),
                          _DrawerCategoryItem(
                            title: 'Headphones',
                            onTap: () => _onCategoryTap(categoryProvider, 'mobile-accessories'),
                          ),
                          _DrawerCategoryItem(
                            title: 'Laptops',
                            onTap: () => _onCategoryTap(categoryProvider, 'laptops'),
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
                            title: 'Men Fashion',
                            onTap: () => _onCategoryTap(categoryProvider, 'mens-shirts'),
                          ),
                          _DrawerCategoryItem(
                            title: 'Women Fashion',
                            onTap: () => _onCategoryTap(categoryProvider, 'womens-dresses'),
                          ),
                          _DrawerCategoryItem(
                            title: 'Men Shoes',
                            onTap: () => _onCategoryTap(categoryProvider, 'mens-shoes'),
                          ),
                          _DrawerCategoryItem(
                            title: 'Women Shoes',
                            onTap: () => _onCategoryTap(categoryProvider, 'womens-shoes'),
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
                            onTap: () => _onCategoryTap(categoryProvider, 'beauty'),
                          ),
                          _DrawerCategoryItem(
                            title: 'Grocery',
                            onTap: () => _onCategoryTap(categoryProvider, 'groceries'),
                          ),
                          _DrawerCategoryItem(
                            title: 'Diapers',
                            onTap: () => _onCategoryTap(categoryProvider, 'skin-care'),
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
                            color: Colors.redAccent.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.card_giftcard,
                            color: Colors.redAccent,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'CashKaro',
                          style: TextStyle(
                            fontFamily: 'HandwrittenItalic',
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                            color: Colors.redAccent,
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
                child: Consumer<ProductProvider>(
                  builder: (context, provider, child) {
                    return ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        const GoldenTicketBanner(),
                        const SizedBox(height: 20),

                        // DYNAMIC E-COMMERCE CASHBACK BANNER CAROUSEL
                        const CashbackBannerCarousel(),
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
        selectedItemColor: Colors.redAccent,
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
          color: isDark ? Colors.redAccent.shade100 : Colors.redAccent.shade700,
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
                        ? Colors.redAccent
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
                      color: Colors.redAccent,
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
                  color: Colors.redAccent.withValues(alpha: 0.1),
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
                        color: Colors.redAccent,
                      ),
                    ),
                    SizedBox(width: 2),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 10,
                      color: Colors.redAccent,
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
                                              color: Colors.redAccent,
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 4,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.redAccent.withValues(alpha: 0.1),
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              item.storeName.toUpperCase(),
                                              style: const TextStyle(
                                                fontSize: 8,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.redAccent,
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
