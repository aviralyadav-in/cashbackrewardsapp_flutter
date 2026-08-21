import 'dart:async';
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

  bool _showAllFashion = false;
  bool _showAllBeauty = false;
  bool _showAllLifetimeCards = false;
  bool _showAllElectronics = false;
  bool _showAllShoppingCards = false;
  bool _showAllMedicines = false;
  bool _showAllCardsLoans = false;
  bool _showAllHotelBooking = false;
  bool _showAllPersonalLoans = false;
  bool _showAllAmazonDeals = false;

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
        width: MediaQuery.of(context).size.width * 0.75,
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
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 3.0,
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

                                      // 2. SHOP BY DEVICES
                                      const _DrawerSectionHeader(title: 'Shop by Devices'),
                                      _DrawerCategoryItem(
                                        title: 'Laptop',
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
                                        onTap: () => _onCategoryTap(categoryProvider, 'mens-shirts'),
                                      ),
                                      _DrawerCategoryItem(
                                        title: 'Women Dresses',
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
                                        title: 'Kitchen Accessories',
                                        onTap: () => _onCategoryTap(categoryProvider, 'kitchen-accessories'),
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
                        // Container(
                        //   padding: const EdgeInsets.all(5),
                        //   decoration: BoxDecoration(
                        //     color: const Color(0xFF1E90FF).withValues(alpha: 0.15),
                        //     shape: BoxShape.circle,
                        //   ),
                        //   child: const Icon(
                        //     Icons.card_giftcard,
                        //     color: Color(0xFF1E90FF),
                        //     size: 22,
                        //   ),
                        // ),
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

                        // 1. CASHBACK ON MOST POPULAR BRANDS
                        _buildSubtleSectionContainer(
                          title: 'Cashback on Most Popular Brands',
                          isDark: isDark,
                          lightGradientColors: const [Color(0xFFEFF6FF), Colors.white],
                          darkGradientColors: const [Color(0xFF0F172A), Color(0xFF0D0D0D)],
                          child: _buildHorizontalBrandCarousel(_popularBrandsCatalog, isDark),
                        ),
                        _SubcategoryPromotionalBannerWidget(
                          bannerData: _popularBrandsBanner,
                          isDark: isDark,
                        ),

                        // 2. GET CASHBACK ON FASHION BUYS
                        _buildSubtleSectionContainer(
                          title: 'Get Cashback on Fashion Buys',
                          isDark: isDark,
                          lightGradientColors: const [Color(0xFFFFF0F5), Colors.white],
                          darkGradientColors: const [Color(0xFF1E1016), Color(0xFF0D0D0D)],
                          onViewAllTap: () {
                            setState(() {
                              _showAllFashion = !_showAllFashion;
                            });
                          },
                          child: _buildGridCardsSection(
                            _fashionBrandsCatalog,
                            isDark,
                            isExpanded: _showAllFashion,
                            initialCount: 3,
                          ),
                        ),
                        _SubcategoryPromotionalBannerWidget(
                          bannerData: _fashionBanner,
                          isDark: isDark,
                        ),

                        // 3. TRENDING BRANDS
                        _buildSubtleSectionContainer(
                          title: 'Trending Brands',
                          isDark: isDark,
                          lightGradientColors: const [Color(0xFFF5F0FF), Colors.white],
                          darkGradientColors: const [Color(0xFF161022), Color(0xFF0D0D0D)],
                          child: _TrendingBrandsCarouselWidget(
                            items: _trendingBannerCatalog,
                            isDark: isDark,
                            onBrandTap: (brand) => _showConfirmationDialog(context, brand),
                          ),
                        ),
                        _SubcategoryPromotionalBannerWidget(
                          bannerData: _trendingBanner,
                          isDark: isDark,
                        ),

                        // 4. GET CASHBACK ON BEAUTY BRANDS
                        _buildSubtleSectionContainer(
                          title: 'Get Cashback on Beauty Brands',
                          isDark: isDark,
                          lightGradientColors: const [Color(0xFFFFF5EE), Colors.white],
                          darkGradientColors: const [Color(0xFF1E1410), Color(0xFF0D0D0D)],
                          onViewAllTap: () {
                            setState(() {
                              _showAllBeauty = !_showAllBeauty;
                            });
                          },
                          child: _buildGridCardsSection(
                            _beautyBrandsCatalog,
                            isDark,
                            isExpanded: _showAllBeauty,
                            initialCount: 6,
                          ),
                        ),
                        _SubcategoryPromotionalBannerWidget(
                          bannerData: _beautyBanner,
                          isDark: isDark,
                        ),

                        // 5. REWARDS ON LIFETIME FREE CARDS
                        _buildSubtleSectionContainer(
                          title: 'Rewards on Lifetime Free Cards',
                          isDark: isDark,
                          lightGradientColors: const [Color(0xFFFFFDF0), Colors.white],
                          darkGradientColors: const [Color(0xFF1C1A10), Color(0xFF0D0D0D)],
                          onViewAllTap: () {
                            setState(() {
                              _showAllLifetimeCards = !_showAllLifetimeCards;
                            });
                          },
                          child: _buildGridCardsSection(
                            _lifetimeFreeCardsCatalog,
                            isDark,
                            isExpanded: _showAllLifetimeCards,
                            initialCount: 6,
                          ),
                        ),
                        _SubcategoryPromotionalBannerWidget(
                          bannerData: _lifetimeCardsBanner,
                          isDark: isDark,
                        ),

                        // 6. GET CASHBACK ON ELECTRONICS
                        _buildSubtleSectionContainer(
                          title: 'Get Cashback on Electronics',
                          isDark: isDark,
                          lightGradientColors: const [Color(0xFFF0FAF7), Colors.white],
                          darkGradientColors: const [Color(0xFF101E1A), Color(0xFF0D0D0D)],
                          onViewAllTap: () {
                            setState(() {
                              _showAllElectronics = !_showAllElectronics;
                            });
                          },
                          child: _buildGridCardsSection(
                            _electronicsBrandsCatalog,
                            isDark,
                            isExpanded: _showAllElectronics,
                            initialCount: 6,
                          ),
                        ),
                        _SubcategoryPromotionalBannerWidget(
                          bannerData: _electronicsBanner,
                          isDark: isDark,
                        ),

                        // 7. BEST CARDS FOR SHOPPING
                        _buildSubtleSectionContainer(
                          title: 'Best Cards for Shopping',
                          isDark: isDark,
                          lightGradientColors: const [Color(0xFFFFF8F0), Colors.white],
                          darkGradientColors: const [Color(0xFF1E1610), Color(0xFF0D0D0D)],
                          onViewAllTap: () {
                            setState(() {
                              _showAllShoppingCards = !_showAllShoppingCards;
                            });
                          },
                          child: _buildGridCardsSection(
                            _shoppingCardsCatalog,
                            isDark,
                            isExpanded: _showAllShoppingCards,
                            initialCount: 6,
                          ),
                        ),
                        _SubcategoryPromotionalBannerWidget(
                          bannerData: _shoppingCardsBanner,
                          isDark: isDark,
                        ),

                        // 8. GET CASHBACK ON MEDICINES
                        _buildSubtleSectionContainer(
                          title: 'Get Cashback on Medicines',
                          isDark: isDark,
                          lightGradientColors: const [Color(0xFFF0FFF4), Colors.white],
                          darkGradientColors: const [Color(0xFF101F14), Color(0xFF0D0D0D)],
                          onViewAllTap: () {
                            setState(() {
                              _showAllMedicines = !_showAllMedicines;
                            });
                          },
                          child: _buildGridCardsSection(
                            _medicineBrandsCatalog,
                            isDark,
                            isExpanded: _showAllMedicines,
                            initialCount: 6,
                          ),
                        ),
                        _SubcategoryPromotionalBannerWidget(
                          bannerData: _medicineBanner,
                          isDark: isDark,
                        ),

                        // 9. GET REWARDS ON CARDS AND LOANS
                        _buildSubtleSectionContainer(
                          title: 'Get Rewards on Cards and Loans',
                          isDark: isDark,
                          lightGradientColors: const [Color(0xFFFFFBF0), Colors.white],
                          darkGradientColors: const [Color(0xFF1D1B10), Color(0xFF0D0D0D)],
                          onViewAllTap: () {
                            setState(() {
                              _showAllCardsLoans = !_showAllCardsLoans;
                            });
                          },
                          child: _buildGridCardsSection(
                            _cardsAndLoansCatalog,
                            isDark,
                            isExpanded: _showAllCardsLoans,
                            initialCount: 6,
                          ),
                        ),
                        _SubcategoryPromotionalBannerWidget(
                          bannerData: _cardsLoansBanner,
                          isDark: isDark,
                        ),

                        // 10. GET CASHBACK ON HOTEL BOOKING
                        _buildSubtleSectionContainer(
                          title: 'Get Cashback on Hotel Booking',
                          isDark: isDark,
                          lightGradientColors: const [Color(0xFFF0F9FF), Colors.white],
                          darkGradientColors: const [Color(0xFF101B24), Color(0xFF0D0D0D)],
                          onViewAllTap: () {
                            setState(() {
                              _showAllHotelBooking = !_showAllHotelBooking;
                            });
                          },
                          child: _buildGridCardsSection(
                            _hotelBookingCatalog,
                            isDark,
                            isExpanded: _showAllHotelBooking,
                            initialCount: 6,
                          ),
                        ),
                        _SubcategoryPromotionalBannerWidget(
                          bannerData: _hotelBookingBanner,
                          isDark: isDark,
                        ),

                        // 11. GET REWARDS ON PERSONAL LOANS
                        _buildSubtleSectionContainer(
                          title: 'Get Rewards on Personal Loans',
                          isDark: isDark,
                          lightGradientColors: const [Color(0xFFF3F0FF), Colors.white],
                          darkGradientColors: const [Color(0xFF141022), Color(0xFF0D0D0D)],
                          onViewAllTap: () {
                            setState(() {
                              _showAllPersonalLoans = !_showAllPersonalLoans;
                            });
                          },
                          child: _buildGridCardsSection(
                            _personalLoansCatalog,
                            isDark,
                            isExpanded: _showAllPersonalLoans,
                            initialCount: 6,
                          ),
                        ),
                        _SubcategoryPromotionalBannerWidget(
                          bannerData: _personalLoansBanner,
                          isDark: isDark,
                        ),

                        // 12. TOP AMAZON DEALS (FINAL HOMEPAGE SECTION - NO GRADIENT BACKGROUND)
                        _buildTopAmazonDealsSection(isDark),
                        _SubcategoryPromotionalBannerWidget(
                          bannerData: _amazonDealsBanner,
                          isDark: isDark,
                        ),

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
                        _SubcategoryPromotionalBannerWidget(
                          bannerData: _flipkartBanner,
                          isDark: isDark,
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
                        _SubcategoryPromotionalBannerWidget(
                          bannerData: _meeshoBanner,
                          isDark: isDark,
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
                        _SubcategoryPromotionalBannerWidget(
                          bannerData: _bestOfLoansBanner,
                          isDark: isDark,
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
                                                // const SizedBox(height: 40),
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

  // =========================================================================
  // HELPER WIDGETS & RENDERERS FOR THE 11 DISCOVERY SECTIONS
  // =========================================================================

  Widget _buildSubtleSectionContainer({
    required String title,
    required Widget child,
    required bool isDark,
    required List<Color> lightGradientColors,
    required List<Color> darkGradientColors,
    VoidCallback? onViewAllTap,
  }) {
    final gradientColors = isDark ? darkGradientColors : lightGradientColors;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
                      title,
                      style: TextStyle(
                        fontSize: 16.5,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
                if (onViewAllTap != null)
                  InkWell(
                    onTap: onViewAllTap,
                    borderRadius: BorderRadius.circular(16),
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
          ),
          const SizedBox(height: 14),

          // Section Child
          child,
        ],
      ),
    );
  }

  Widget _buildHorizontalBrandCarousel(List<BrandModel> brands, bool isDark) {
    return SizedBox(
      height: 152,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: brands.length,
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final brand = brands[index];
          return SizedBox(
            width: 122,
            child: _buildGridBrandCard(context, brand, isDark),
          );
        },
      ),
    );
  }



  Widget _buildGridCardsSection(
    List<BrandModel> brands,
    bool isDark, {
    required bool isExpanded,
    int initialCount = 6,
  }) {
    final displayBrands = isExpanded || brands.length <= initialCount
        ? brands
        : brands.sublist(0, initialCount);

    final List<List<BrandModel>> rows = [];
    for (var i = 0; i < displayBrands.length; i += 3) {
      rows.add(
        displayBrands.sublist(
            i, i + 3 > displayBrands.length ? displayBrands.length : i + 3),
      );
    }

    return Column(
      children: List.generate(rows.length, (rowIndex) {
        final rowBrands = rows[rowIndex];
        final isLastRow = rowIndex == rows.length - 1;

        return Padding(
          padding: EdgeInsets.only(bottom: isLastRow ? 0.0 : 10.0),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
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
          ),
        );
      }),
    );
  }

  // =========================================================================
  // DATA CATALOGS FOR THE 11 HOMEPAGE DISCOVERY SECTIONS
  // =========================================================================

  List<BrandModel> get _popularBrandsCatalog => const [
        BrandModel(
          name: 'Amazon.in',
          logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/a/a9/Amazon_logo.svg',
          bannerUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=800&auto=format&fit=crop&q=80',
          cashbackPercentage: 'Up to 8% Rewards',
          category: 'Popular',
          offerText: 'Up to 80% Off',
          websiteUrl: 'https://www.amazon.in',
        ),
        BrandModel(
          name: 'Flipkart',
          logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/7/7a/Flipkart_logo.svg',
          bannerUrl: 'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?w=800&auto=format&fit=crop&q=80',
          cashbackPercentage: 'Up to 7% Rewards',
          category: 'Popular',
          offerText: 'Up to 75% Off',
          websiteUrl: 'https://www.flipkart.com',
        ),
        BrandModel(
          name: 'Myntra',
          logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/b/bc/Myntra_Logo.png',
          bannerUrl: 'https://images.unsplash.com/photo-1483985988355-763728e1935b?w=800&auto=format&fit=crop&q=80',
          cashbackPercentage: 'Flat 7.5% Rewards',
          category: 'Popular',
          offerText: 'Up to 60% Off',
          websiteUrl: 'https://www.myntra.com',
        ),
        BrandModel(
          name: 'AJIO',
          logoUrl: 'https://assets.ajio.com/static/img/Ajio-Logo.svg',
          bannerUrl: 'https://images.unsplash.com/photo-1445205170230-053b83016050?w=800&auto=format&fit=crop&q=80',
          cashbackPercentage: 'Flat 10% Rewards',
          category: 'Popular',
          offerText: 'Flat 50% Off',
          websiteUrl: 'https://www.ajio.com',
        ),
        BrandModel(
          name: 'MakeMyTrip',
          logoUrl: 'https://imgak.mmtcdn.com/pwa_v3/pwa_commons_assets/desktop/logo.png',
          bannerUrl: 'https://images.unsplash.com/photo-1436491865332-7a61a109cc05?w=800&auto=format&fit=crop&q=80',
          cashbackPercentage: 'Flat 8% Rewards',
          category: 'Popular',
          offerText: 'Up to 35% Off',
          websiteUrl: 'https://www.makemytrip.com',
        ),
        BrandModel(
          name: 'Samsung',
          logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/2/24/Samsung_Logo.svg',
          bannerUrl: 'https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?w=800&auto=format&fit=crop&q=80',
          cashbackPercentage: 'Up to 9% Rewards',
          category: 'Popular',
          offerText: 'Up to 50% Off',
          websiteUrl: 'https://www.samsung.com/in',
        ),
      ];

  List<BrandModel> get _fashionBrandsCatalog => const [
        BrandModel(
          name: 'Myntra',
          logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/b/bc/Myntra_Logo.png',
          bannerUrl: 'https://images.unsplash.com/photo-1483985988355-763728e1935b?w=800&auto=format&fit=crop&q=80',
          cashbackPercentage: 'Flat 7.5% Cashback',
          category: 'Fashion',
          offerText: 'Up to 70% Off',
          websiteUrl: 'https://www.myntra.com',
        ),
        BrandModel(
          name: 'AJIO',
          logoUrl: 'https://assets.ajio.com/static/img/Ajio-Logo.svg',
          bannerUrl: 'https://images.unsplash.com/photo-1445205170230-053b83016050?w=800&auto=format&fit=crop&q=80',
          cashbackPercentage: 'Flat 10% Cashback',
          category: 'Fashion',
          offerText: 'Up to 60% Off',
          websiteUrl: 'https://www.ajio.com',
        ),
        BrandModel(
          name: 'Nike',
          logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/a/a6/Logo_NIKE.svg',
          bannerUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800&auto=format&fit=crop&q=80',
          cashbackPercentage: 'Up to 9% Cashback',
          category: 'Fashion',
          offerText: 'Up to 40% Off',
          websiteUrl: 'https://www.nike.com/in',
        ),
        BrandModel(
          name: 'H&M',
          logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/5/53/H%26M-Logo.svg',
          bannerUrl: 'https://images.unsplash.com/photo-1490481651871-ab68de25d43d?w=800&auto=format&fit=crop&q=80',
          cashbackPercentage: 'Flat 8% Cashback',
          category: 'Fashion',
          offerText: 'Up to 50% Off',
          websiteUrl: 'https://www2.hm.com/en_in',
        ),
        BrandModel(
          name: 'Zara',
          logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/f/fd/Zara_Logo.svg',
          bannerUrl: 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=800&auto=format&fit=crop&q=80',
          cashbackPercentage: 'Up to 6% Cashback',
          category: 'Fashion',
          offerText: 'Up to 30% Off',
          websiteUrl: 'https://www.zara.com/in',
        ),
        BrandModel(
          name: 'ASOS',
          logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/a/a9/Amazon_logo.svg',
          bannerUrl: 'https://images.unsplash.com/photo-1483985988355-763728e1935b?w=800&auto=format&fit=crop&q=80',
          cashbackPercentage: 'Up to 8% Cashback',
          category: 'Fashion',
          offerText: 'Up to 50% Off',
          websiteUrl: 'https://www.asos.com',
        ),
      ];

  List<_TrendingBannerItemData> get _trendingBannerCatalog => const [
        _TrendingBannerItemData(
          brand: BrandModel(
            name: 'Amazon.in',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/a/a9/Amazon_logo.svg',
            bannerUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Up to 8% Rewards',
            category: 'E-Commerce',
            offerText: 'Up to 80% Off',
            websiteUrl: 'https://www.amazon.in',
          ),
          tagline: 'Great Freedom Festival & Deals',
        ),
        _TrendingBannerItemData(
          brand: BrandModel(
            name: 'Flipkart',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/7/7a/Flipkart_logo.svg',
            bannerUrl: 'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Up to 7% Rewards',
            category: 'E-Commerce',
            offerText: 'Up to 75% Off',
            websiteUrl: 'https://www.flipkart.com',
          ),
          tagline: 'Big Billion Days & Electronics',
        ),
        _TrendingBannerItemData(
          brand: BrandModel(
            name: 'Myntra',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/b/bc/Myntra_Logo.png',
            bannerUrl: 'https://images.unsplash.com/photo-1483985988355-763728e1935b?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Flat 7.5% Rewards',
            category: 'E-Commerce',
            offerText: 'Up to 70% Off',
            websiteUrl: 'https://www.myntra.com',
          ),
          tagline: 'End of Reason Sale Deals',
        ),
        _TrendingBannerItemData(
          brand: BrandModel(
            name: 'AJIO',
            logoUrl: 'https://assets.ajio.com/static/img/Ajio-Logo.svg',
            bannerUrl: 'https://images.unsplash.com/photo-1445205170230-053b83016050?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Flat 10% Rewards',
            category: 'E-Commerce',
            offerText: 'Flat 50% Off',
            websiteUrl: 'https://www.ajio.com',
          ),
          tagline: 'Trends & International Fashion',
        ),
        _TrendingBannerItemData(
          brand: BrandModel(
            name: 'Meesho',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/7/7a/Flipkart_logo.svg',
            bannerUrl: 'https://images.unsplash.com/photo-1472851294608-062f824d29cc?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Up to 6% Rewards',
            category: 'E-Commerce',
            offerText: 'Up to 60% Off',
            websiteUrl: 'https://www.meesho.com',
          ),
          tagline: 'Lowest Price Quality Deals',
        ),
        _TrendingBannerItemData(
          brand: BrandModel(
            name: 'Tata CLiQ',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/b/bc/Myntra_Logo.png',
            bannerUrl: 'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Up to 8% Rewards',
            category: 'E-Commerce',
            offerText: 'Up to 50% Off',
            websiteUrl: 'https://www.tatacliq.com',
          ),
          tagline: 'Luxury Fashion & Electronics',
        ),
        _TrendingBannerItemData(
          brand: BrandModel(
            name: 'Nykaa',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/0/00/Nykaa_New_Logo.svg',
            bannerUrl: 'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Up to 8% Rewards',
            category: 'Beauty',
            offerText: 'Up to 50% Off',
            websiteUrl: 'https://www.nykaa.com',
          ),
          tagline: 'Pink Friday Beauty & Cosmetics',
        ),
        _TrendingBannerItemData(
          brand: BrandModel(
            name: 'Croma',
            logoUrl: 'https://media.croma.com/image/upload/v1637759004/Croma%20Assets/CMS/Category%20Icon/Croma_Logo.png',
            bannerUrl: 'https://images.unsplash.com/photo-1526738549149-8e07eca6c147?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Flat 6% Rewards',
            category: 'Electronics',
            offerText: 'Up to 50% Off',
            websiteUrl: 'https://www.croma.com',
          ),
          tagline: 'Electronics & Home Appliances',
        ),
        _TrendingBannerItemData(
          brand: BrandModel(
            name: 'Reliance Digital',
            logoUrl: 'https://www.reliancedigital.in/build/client/images/rel_stat_svg.svg',
            bannerUrl: 'https://images.unsplash.com/photo-1550009158-9ebf69173e03?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Up to 5% Rewards',
            category: 'Electronics',
            offerText: 'Up to 45% Off',
            websiteUrl: 'https://www.reliancedigital.in',
          ),
          tagline: 'Digital India Tech Deals',
        ),
        _TrendingBannerItemData(
          brand: BrandModel(
            name: 'Snapdeal',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/7/7a/Flipkart_logo.svg',
            bannerUrl: 'https://images.unsplash.com/photo-1472851294608-062f824d29cc?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Up to 7% Rewards',
            category: 'E-Commerce',
            offerText: 'Up to 65% Off',
            websiteUrl: 'https://www.snapdeal.com',
          ),
          tagline: 'Daily Bargains & Essentials',
        ),
        _TrendingBannerItemData(
          brand: BrandModel(
            name: 'Nike',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/a/a6/Logo_NIKE.svg',
            bannerUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Up to 9% Rewards',
            category: 'Fashion',
            offerText: 'Up to 40% Off',
            websiteUrl: 'https://www.nike.com/in',
          ),
          tagline: 'Air Jordan & Sportswear Drops',
        ),
        _TrendingBannerItemData(
          brand: BrandModel(
            name: 'Adidas',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/2/20/Adidas_Logo.svg',
            bannerUrl: 'https://images.unsplash.com/photo-1518002171953-a080ee817e1f?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Up to 8% Rewards',
            category: 'Fashion',
            offerText: 'Up to 45% Off',
            websiteUrl: 'https://www.adidas.co.in',
          ),
          tagline: 'Originals & Running Sneakers',
        ),
        _TrendingBannerItemData(
          brand: BrandModel(
            name: 'H&M',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/5/53/H%26M-Logo.svg',
            bannerUrl: 'https://images.unsplash.com/photo-1490481651871-ab68de25d43d?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Flat 8% Rewards',
            category: 'Fashion',
            offerText: 'Up to 50% Off',
            websiteUrl: 'https://www2.hm.com/en_in',
          ),
          tagline: 'Sustainable High Fashion',
        ),
        _TrendingBannerItemData(
          brand: BrandModel(
            name: 'Zara',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/f/fd/Zara_Logo.svg',
            bannerUrl: 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Up to 6% Rewards',
            category: 'Fashion',
            offerText: 'Up to 30% Off',
            websiteUrl: 'https://www.zara.com/in',
          ),
          tagline: 'New Seasonal Outfits & Trends',
        ),
        _TrendingBannerItemData(
          brand: BrandModel(
            name: 'Sephora',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/2/21/Sephora_logo.svg',
            bannerUrl: 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Flat 10% Rewards',
            category: 'Beauty',
            offerText: 'Up to 40% Off',
            websiteUrl: 'https://sephora.in',
          ),
          tagline: 'Premium Cosmetics & Skincare',
        ),
        _TrendingBannerItemData(
          brand: BrandModel(
            name: 'Etsy',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/a/a9/Amazon_logo.svg',
            bannerUrl: 'https://images.unsplash.com/photo-1513519245088-0e12902e5a38?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Up to 5% Rewards',
            category: 'Global',
            offerText: 'Up to 30% Off',
            websiteUrl: 'https://www.etsy.com',
          ),
          tagline: 'Handcrafted & Unique Gifts',
        ),
        _TrendingBannerItemData(
          brand: BrandModel(
            name: 'eBay',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/1/1b/EBay_logo.svg',
            bannerUrl: 'https://images.unsplash.com/photo-1526738549149-8e07eca6c147?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Up to 4% Rewards',
            category: 'Global',
            offerText: 'Global Deals',
            websiteUrl: 'https://www.ebay.com',
          ),
          tagline: 'Refurbished Tech & Collectibles',
        ),
        _TrendingBannerItemData(
          brand: BrandModel(
            name: 'Walmart',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/c/ca/Walmart_logo.svg',
            bannerUrl: 'https://images.unsplash.com/photo-1578916171728-46686eac8d58?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Up to 5% Rewards',
            category: 'Global',
            offerText: 'Rollback Prices',
            websiteUrl: 'https://www.walmart.com',
          ),
          tagline: 'Everyday Low Prices & Savings',
        ),
        _TrendingBannerItemData(
          brand: BrandModel(
            name: 'Best Buy',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/f/f5/Best_Buy_Logo.svg',
            bannerUrl: 'https://images.unsplash.com/photo-1550009158-9ebf69173e03?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Up to 6% Rewards',
            category: 'Global',
            offerText: 'Tech Outlet Sale',
            websiteUrl: 'https://www.bestbuy.com',
          ),
          tagline: 'Expert Electronics & Gadgets',
        ),
        _TrendingBannerItemData(
          brand: BrandModel(
            name: 'Target',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/c/c5/Target_Corporation_logo_vector.svg',
            bannerUrl: 'https://images.unsplash.com/photo-1472851294608-062f824d29cc?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Up to 5% Rewards',
            category: 'Global',
            offerText: 'Target Circle Deals',
            websiteUrl: 'https://www.target.com',
          ),
          tagline: 'Style, Home & Daily Essentials',
        ),
      ];

  List<BrandModel> get _beautyBrandsCatalog => const [
        BrandModel(
          name: 'Nykaa',
          logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/0/00/Nykaa_New_Logo.svg',
          bannerUrl: 'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=800&auto=format&fit=crop&q=80',
          cashbackPercentage: 'Up to 8% Cashback',
          category: 'Beauty',
          offerText: 'Up to 50% Off',
          websiteUrl: 'https://www.nykaa.com',
        ),
        BrandModel(
          name: 'Sephora',
          logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/2/21/Sephora_logo.svg',
          bannerUrl: 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?w=800&auto=format&fit=crop&q=80',
          cashbackPercentage: 'Flat 10% Cashback',
          category: 'Beauty',
          offerText: 'Up to 40% Off',
          websiteUrl: 'https://sephora.in',
        ),
        BrandModel(
          name: 'Mamaearth',
          logoUrl: 'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=400&auto=format&fit=crop&q=80',
          bannerUrl: 'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=800&auto=format&fit=crop&q=80',
          cashbackPercentage: 'Flat 12% Cashback',
          category: 'Beauty',
          offerText: 'Buy 1 Get 1 Free',
          websiteUrl: 'https://mamaearth.in',
        ),
        BrandModel(
          name: 'Plum Goodness',
          logoUrl: 'https://images.unsplash.com/photo-1598440947619-2c35fc9aa908?w=400&auto=format&fit=crop&q=80',
          bannerUrl: 'https://images.unsplash.com/photo-1598440947619-2c35fc9aa908?w=800&auto=format&fit=crop&q=80',
          cashbackPercentage: 'Up to 15% Cashback',
          category: 'Beauty',
          offerText: 'Flat 30% Off',
          websiteUrl: 'https://plumgoodness.com',
        ),
        BrandModel(
          name: 'Minimalist',
          logoUrl: 'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=400&auto=format&fit=crop&q=80',
          bannerUrl: 'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=800&auto=format&fit=crop&q=80',
          cashbackPercentage: 'Flat 10% Cashback',
          category: 'Beauty',
          offerText: 'Flat ₹100 Off',
          websiteUrl: 'https://beminimalist.co',
        ),
        BrandModel(
          name: 'Sugar Cosmetics',
          logoUrl: 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?w=400&auto=format&fit=crop&q=80',
          bannerUrl: 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?w=800&auto=format&fit=crop&q=80',
          cashbackPercentage: 'Up to 12% Cashback',
          category: 'Beauty',
          offerText: 'Up to 45% Off',
          websiteUrl: 'https://sugarcosmetics.com',
        ),
      ];

  List<BrandModel> get _lifetimeFreeCardsCatalog => const [
        BrandModel(
          name: 'HDFC Freedom',
          logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/2/28/HDFC_Bank_Logo.svg',
          bannerUrl: 'https://images.unsplash.com/photo-1559526324-4b87b5e36e44?w=800&auto=format&fit=crop&q=80',
          cashbackPercentage: 'Flat ₹1,500 Bonus',
          category: 'Cards',
          offerText: 'Lifetime Free Card',
          websiteUrl: 'https://www.hdfcbank.com',
        ),
        BrandModel(
          name: 'SBI SimplyCLICK',
          logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/c/cc/SBI-Logo.svg',
          bannerUrl: 'https://images.unsplash.com/photo-1563013544-824ae1b704d3?w=800&auto=format&fit=crop&q=80',
          cashbackPercentage: 'Flat ₹1,200 Cashback',
          category: 'Cards',
          offerText: 'Zero Annual Fee',
          websiteUrl: 'https://www.sbicard.com',
        ),
        BrandModel(
          name: 'Axis MyZone',
          logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/1/1a/Axis_Bank_logo.svg',
          bannerUrl: 'https://images.unsplash.com/photo-1601597111158-2fceff292cdc?w=800&auto=format&fit=crop&q=80',
          cashbackPercentage: 'Flat ₹1,500 Cashback',
          category: 'Cards',
          offerText: 'Lifetime Free Card',
          websiteUrl: 'https://www.axisbank.com',
        ),
        BrandModel(
          name: 'ICICI Amazon Pay',
          logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/1/12/ICICI_Bank_Logo.svg',
          bannerUrl: 'https://images.unsplash.com/photo-1556742049-0a67dd385203?w=800&auto=format&fit=crop&q=80',
          cashbackPercentage: 'Flat ₹1,000 Rewards',
          category: 'Cards',
          offerText: 'Zero Joining Fee',
          websiteUrl: 'https://www.icicibank.com',
        ),
        BrandModel(
          name: 'IDFC Millennia',
          logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/a/a2/IDFC_First_Bank_logo.svg',
          bannerUrl: 'https://images.unsplash.com/photo-1559526324-4b87b5e36e44?w=800&auto=format&fit=crop&q=80',
          cashbackPercentage: 'Flat ₹1,000 Bonus',
          category: 'Cards',
          offerText: 'Lifetime Free Card',
          websiteUrl: 'https://www.idfcfirstbank.com',
        ),
        BrandModel(
          name: 'OneCard Credit',
          logoUrl: 'https://images.unsplash.com/photo-1563013544-824ae1b704d3?w=400&auto=format&fit=crop&q=80',
          bannerUrl: 'https://images.unsplash.com/photo-1563013544-824ae1b704d3?w=800&auto=format&fit=crop&q=80',
          cashbackPercentage: 'Flat ₹800 Cashback',
          category: 'Cards',
          offerText: 'Metal Card Free',
          websiteUrl: 'https://getonecard.app',
        ),
      ];

  List<BrandModel> get _electronicsBrandsCatalog => const [
        BrandModel(
          name: 'Amazon',
          logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/a/a9/Amazon_logo.svg',
          bannerUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=800&auto=format&fit=crop&q=80',
          cashbackPercentage: 'Up to 6% Cashback',
          category: 'Electronics',
          offerText: 'Up to 65% Off',
          websiteUrl: 'https://www.amazon.in',
        ),
        BrandModel(
          name: 'Flipkart',
          logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/7/7a/Flipkart_logo.svg',
          bannerUrl: 'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?w=800&auto=format&fit=crop&q=80',
          cashbackPercentage: 'Up to 7% Cashback',
          category: 'Electronics',
          offerText: 'Up to 70% Off',
          websiteUrl: 'https://www.flipkart.com',
        ),
        BrandModel(
          name: 'Croma',
          logoUrl: 'https://media.croma.com/image/upload/v1637759004/Croma%20Assets/CMS/Category%20Icon/Croma_Logo.png',
          bannerUrl: 'https://images.unsplash.com/photo-1526738549149-8e07eca6c147?w=800&auto=format&fit=crop&q=80',
          cashbackPercentage: 'Flat 6% Cashback',
          category: 'Electronics',
          offerText: 'Up to 50% Off',
          websiteUrl: 'https://www.croma.com',
        ),
        BrandModel(
          name: 'Apple Store',
          logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/f/fa/Apple_logo_black.svg',
          bannerUrl: 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=800&auto=format&fit=crop&q=80',
          cashbackPercentage: 'Up to 4% Cashback',
          category: 'Electronics',
          offerText: 'Save up to ₹10,000',
          websiteUrl: 'https://www.apple.com/in',
        ),
        BrandModel(
          name: 'Samsung',
          logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/2/24/Samsung_Logo.svg',
          bannerUrl: 'https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?w=800&auto=format&fit=crop&q=80',
          cashbackPercentage: 'Up to 8% Cashback',
          category: 'Electronics',
          offerText: 'Up to 55% Off',
          websiteUrl: 'https://www.samsung.com/in',
        ),
        BrandModel(
          name: 'Reliance Digital',
          logoUrl: 'https://www.reliancedigital.in/build/client/images/rel_stat_svg.svg',
          bannerUrl: 'https://images.unsplash.com/photo-1550009158-9ebf69173e03?w=800&auto=format&fit=crop&q=80',
          cashbackPercentage: 'Up to 5% Cashback',
          category: 'Electronics',
          offerText: 'Up to 45% Off',
          websiteUrl: 'https://www.reliancedigital.in',
        ),
      ];

  List<BrandModel> get _shoppingCardsCatalog => const [
        BrandModel(
          name: 'HDFC Millennia',
          logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/2/28/HDFC_Bank_Logo.svg',
          bannerUrl: 'https://images.unsplash.com/photo-1559526324-4b87b5e36e44?w=800&auto=format&fit=crop&q=80',
          cashbackPercentage: 'Flat ₹1,500 Bonus',
          category: 'Shopping Cards',
          offerText: '5% Online Cashback',
          websiteUrl: 'https://www.hdfcbank.com',
        ),
        BrandModel(
          name: 'SBI CashCard',
          logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/c/cc/SBI-Logo.svg',
          bannerUrl: 'https://images.unsplash.com/photo-1563013544-824ae1b704d3?w=800&auto=format&fit=crop&q=80',
          cashbackPercentage: 'Flat ₹1,200 Cashback',
          category: 'Shopping Cards',
          offerText: '5% Unlimited Online',
          websiteUrl: 'https://www.sbicard.com',
        ),
        BrandModel(
          name: 'Axis Flipkart Card',
          logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/1/1a/Axis_Bank_logo.svg',
          bannerUrl: 'https://images.unsplash.com/photo-1601597111158-2fceff292cdc?w=800&auto=format&fit=crop&q=80',
          cashbackPercentage: 'Flat ₹1,500 Cashback',
          category: 'Shopping Cards',
          offerText: '5% Flipkart Cashback',
          websiteUrl: 'https://www.axisbank.com',
        ),
        BrandModel(
          name: 'ICICI Amazon Pay',
          logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/1/12/ICICI_Bank_Logo.svg',
          bannerUrl: 'https://images.unsplash.com/photo-1556742049-0a67dd385203?w=800&auto=format&fit=crop&q=80',
          cashbackPercentage: 'Flat ₹1,000 Rewards',
          category: 'Shopping Cards',
          offerText: '5% Amazon Cashback',
          websiteUrl: 'https://www.icicibank.com',
        ),
        BrandModel(
          name: 'HSBC Cashback',
          logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/1/12/ICICI_Bank_Logo.svg',
          bannerUrl: 'https://images.unsplash.com/photo-1559526324-4b87b5e36e44?w=800&auto=format&fit=crop&q=80',
          cashbackPercentage: 'Flat ₹1,200 Bonus',
          category: 'Shopping Cards',
          offerText: '10% Dining Cashback',
          websiteUrl: 'https://www.hsbc.co.in',
        ),
        BrandModel(
          name: 'StanChart Smart',
          logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/1/1a/Axis_Bank_logo.svg',
          bannerUrl: 'https://images.unsplash.com/photo-1563013544-824ae1b704d3?w=800&auto=format&fit=crop&q=80',
          cashbackPercentage: 'Flat ₹1,000 Bonus',
          category: 'Shopping Cards',
          offerText: '2% Online Cashback',
          websiteUrl: 'https://www.sc.com/in',
        ),
      ];

  List<BrandModel> get _medicineBrandsCatalog => const [
        BrandModel(
          name: 'Tata 1mg',
          logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/6/6f/1mg_Logo.png',
          bannerUrl: 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=800&auto=format&fit=crop&q=80',
          cashbackPercentage: 'Flat 12% Cashback',
          category: 'Medicines',
          offerText: 'Up to 25% Off',
          websiteUrl: 'https://www.1mg.com',
        ),
        BrandModel(
          name: 'PharmEasy',
          logoUrl: 'https://pharmeasy.in/assets/src/images/logo.svg',
          bannerUrl: 'https://images.unsplash.com/photo-1471864190281-a93a3070b6de?w=800&auto=format&fit=crop&q=80',
          cashbackPercentage: 'Up to 15% Cashback',
          category: 'Medicines',
          offerText: 'Up to 30% Off',
          websiteUrl: 'https://www.pharmeasy.in',
        ),
        BrandModel(
          name: 'Netmeds',
          logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/6/6f/1mg_Logo.png',
          bannerUrl: 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=800&auto=format&fit=crop&q=80',
          cashbackPercentage: 'Flat 10% Cashback',
          category: 'Medicines',
          offerText: 'Flat 20% Off',
          websiteUrl: 'https://www.netmeds.com',
        ),
        BrandModel(
          name: 'Apollo Pharmacy',
          logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/6/6f/1mg_Logo.png',
          bannerUrl: 'https://images.unsplash.com/photo-1471864190281-a93a3070b6de?w=800&auto=format&fit=crop&q=80',
          cashbackPercentage: 'Up to 8% Cashback',
          category: 'Medicines',
          offerText: 'Up to 15% Off',
          websiteUrl: 'https://www.apollopharmacy.in',
        ),
        BrandModel(
          name: 'HealthKart',
          logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/d/d7/HealthKart_Logo.png',
          bannerUrl: 'https://images.unsplash.com/photo-1579722821273-0f6c7d44362f?w=800&auto=format&fit=crop&q=80',
          cashbackPercentage: 'Up to 10% Cashback',
          category: 'Medicines',
          offerText: 'Up to 40% Off',
          websiteUrl: 'https://www.healthkart.com',
        ),
        BrandModel(
          name: 'PharmEasy Lab',
          logoUrl: 'https://pharmeasy.in/assets/src/images/logo.svg',
          bannerUrl: 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=800&auto=format&fit=crop&q=80',
          cashbackPercentage: 'Flat ₹500 Cashback',
          category: 'Medicines',
          offerText: 'Flat 70% Off Labs',
          websiteUrl: 'https://www.pharmeasy.in',
        ),
      ];

  List<BrandModel> get _cardsAndLoansCatalog => const [
        BrandModel(
          name: 'MoneyTap Line',
          logoUrl: 'https://www.moneytap.com/images/logo.png',
          bannerUrl: 'https://images.unsplash.com/photo-1554224155-8d04cb21cd6c?w=800&auto=format&fit=crop&q=80',
          cashbackPercentage: 'Flat ₹1,000 Bonus',
          category: 'Cards & Loans',
          offerText: 'Credit Line ₹5 Lakhs',
          websiteUrl: 'https://www.moneytap.com',
        ),
        BrandModel(
          name: 'Navi Financial',
          logoUrl: 'https://navi.com/assets/images/navi_logo.png',
          bannerUrl: 'https://images.unsplash.com/photo-1579621970563-ebec7560ff3e?w=800&auto=format&fit=crop&q=80',
          cashbackPercentage: 'Flat ₹1,200 Cashback',
          category: 'Cards & Loans',
          offerText: 'Instant Cash Loans',
          websiteUrl: 'https://navi.com',
        ),
        BrandModel(
          name: 'KreditBee',
          logoUrl: 'https://www.moneytap.com/images/logo.png',
          bannerUrl: 'https://images.unsplash.com/photo-1554224155-8d04cb21cd6c?w=800&auto=format&fit=crop&q=80',
          cashbackPercentage: 'Flat ₹800 Cashback',
          category: 'Cards & Loans',
          offerText: 'Personal Credit Line',
          websiteUrl: 'https://www.kreditbee.in',
        ),
        BrandModel(
          name: 'Bajaj Finserv',
          logoUrl: 'https://navi.com/assets/images/navi_logo.png',
          bannerUrl: 'https://images.unsplash.com/photo-1579621970563-ebec7560ff3e?w=800&auto=format&fit=crop&q=80',
          cashbackPercentage: 'Flat ₹1,500 Bonus',
          category: 'Cards & Loans',
          offerText: 'Insta EMI Card Free',
          websiteUrl: 'https://www.bajajfinserv.in',
        ),
        BrandModel(
          name: 'IndusInd Card',
          logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/1/12/ICICI_Bank_Logo.svg',
          bannerUrl: 'https://images.unsplash.com/photo-1559526324-4b87b5e36e44?w=800&auto=format&fit=crop&q=80',
          cashbackPercentage: 'Flat ₹1,200 Rewards',
          category: 'Cards & Loans',
          offerText: 'Lifetime Free Card',
          websiteUrl: 'https://www.indusind.com',
        ),
        BrandModel(
          name: 'BoB Credit Card',
          logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/1/1a/Axis_Bank_logo.svg',
          bannerUrl: 'https://images.unsplash.com/photo-1563013544-824ae1b704d3?w=800&auto=format&fit=crop&q=80',
          cashbackPercentage: 'Flat ₹1,000 Cashback',
          category: 'Cards & Loans',
          offerText: 'Zero Annual Fee',
          websiteUrl: 'https://www.bobfinancial.com',
        ),
      ];

  List<BrandModel> get _hotelBookingCatalog => const [
        BrandModel(
          name: 'MakeMyTrip',
          logoUrl: 'https://imgak.mmtcdn.com/pwa_v3/pwa_commons_assets/desktop/logo.png',
          bannerUrl: 'https://images.unsplash.com/photo-1436491865332-7a61a109cc05?w=800&auto=format&fit=crop&q=80',
          cashbackPercentage: 'Flat 8% Cashback',
          category: 'Travel',
          offerText: 'Up to 35% Off',
          websiteUrl: 'https://www.makemytrip.com',
        ),
        BrandModel(
          name: 'Booking.com',
          logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/b/be/Booking.com_logo.svg',
          bannerUrl: 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800&auto=format&fit=crop&q=80',
          cashbackPercentage: 'Up to 9% Cashback',
          category: 'Travel',
          offerText: 'Up to 40% Off',
          websiteUrl: 'https://www.booking.com',
        ),
        BrandModel(
          name: 'Agoda',
          logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/c/ce/Agoda_logo.svg',
          bannerUrl: 'https://images.unsplash.com/photo-1488646953014-85cb44e25828?w=800&auto=format&fit=crop&q=80',
          cashbackPercentage: 'Flat 10% Cashback',
          category: 'Travel',
          offerText: 'Up to 50% Off',
          websiteUrl: 'https://www.agoda.com',
        ),
        BrandModel(
          name: 'Expedia',
          logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/c/ce/Agoda_logo.svg',
          bannerUrl: 'https://images.unsplash.com/photo-1488646953014-85cb44e25828?w=800&auto=format&fit=crop&q=80',
          cashbackPercentage: 'Flat 7% Cashback',
          category: 'Travel',
          offerText: 'Up to 30% Off',
          websiteUrl: 'https://www.expedia.com',
        ),
        BrandModel(
          name: 'Air India',
          logoUrl: 'https://imgak.mmtcdn.com/pwa_v3/pwa_commons_assets/desktop/logo.png',
          bannerUrl: 'https://images.unsplash.com/photo-1436491865332-7a61a109cc05?w=800&auto=format&fit=crop&q=80',
          cashbackPercentage: 'Flat 6% Cashback',
          category: 'Travel',
          offerText: 'Flight Deals',
          websiteUrl: 'https://www.airindia.com',
        ),
        BrandModel(
          name: 'Qatar Airways',
          logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/b/be/Booking.com_logo.svg',
          bannerUrl: 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800&auto=format&fit=crop&q=80',
          cashbackPercentage: 'Flat 8% Cashback',
          category: 'Travel',
          offerText: 'Global Flights',
          websiteUrl: 'https://www.qatarairways.com',
        ),
      ];

  List<BrandModel> get _personalLoansCatalog => const [
        BrandModel(
          name: 'Navi Loans',
          logoUrl: 'https://navi.com/assets/images/navi_logo.png',
          bannerUrl: 'https://images.unsplash.com/photo-1579621970563-ebec7560ff3e?w=800&auto=format&fit=crop&q=80',
          cashbackPercentage: 'Flat ₹1,200 Cashback',
          category: 'Personal Loans',
          offerText: 'Loans up to ₹20 Lakhs',
          websiteUrl: 'https://navi.com',
        ),
        BrandModel(
          name: 'MoneyTap',
          logoUrl: 'https://www.moneytap.com/images/logo.png',
          bannerUrl: 'https://images.unsplash.com/photo-1554224155-8d04cb21cd6c?w=800&auto=format&fit=crop&q=80',
          cashbackPercentage: 'Flat ₹1,000 Bonus',
          category: 'Personal Loans',
          offerText: 'Instant Credit Line',
          websiteUrl: 'https://www.moneytap.com',
        ),
        BrandModel(
          name: 'Tata Capital',
          logoUrl: 'https://navi.com/assets/images/navi_logo.png',
          bannerUrl: 'https://images.unsplash.com/photo-1579621970563-ebec7560ff3e?w=800&auto=format&fit=crop&q=80',
          cashbackPercentage: 'Flat ₹1,500 Bonus',
          category: 'Personal Loans',
          offerText: 'Low Interest Rates',
          websiteUrl: 'https://www.tatacapital.com',
        ),
        BrandModel(
          name: 'Paysense',
          logoUrl: 'https://www.moneytap.com/images/logo.png',
          bannerUrl: 'https://images.unsplash.com/photo-1554224155-8d04cb21cd6c?w=800&auto=format&fit=crop&q=80',
          cashbackPercentage: 'Flat ₹800 Cashback',
          category: 'Personal Loans',
          offerText: 'Quick Disbursal',
          websiteUrl: 'https://www.gopaysense.com',
        ),
        BrandModel(
          name: 'CASHe',
          logoUrl: 'https://navi.com/assets/images/navi_logo.png',
          bannerUrl: 'https://images.unsplash.com/photo-1579621970563-ebec7560ff3e?w=800&auto=format&fit=crop&q=80',
          cashbackPercentage: 'Flat ₹700 Cashback',
          category: 'Personal Loans',
          offerText: 'Instant Salary Loan',
          websiteUrl: 'https://www.cashe.co.in',
        ),
        BrandModel(
          name: 'mPokket',
          logoUrl: 'https://www.moneytap.com/images/logo.png',
          bannerUrl: 'https://images.unsplash.com/photo-1554224155-8d04cb21cd6c?w=800&auto=format&fit=crop&q=80',
          cashbackPercentage: 'Flat ₹500 Cashback',
          category: 'Personal Loans',
          offerText: 'Student & Youth Loan',
          websiteUrl: 'https://mpokket.in',
        ),
      ];

  // =========================================================================
  // TOP AMAZON DEALS SECTION & PRODUCT CARDS (NO GRADIENT BACKGROUND)
  // =========================================================================

  Widget _buildTopAmazonDealsSection(bool isDark) {
    final deals = _amazonDealsCatalog;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
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
                    'Top Amazon Deals',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    _showAllAmazonDeals = !_showAllAmazonDeals;
                  });
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E90FF).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _showAllAmazonDeals ? 'Show Less' : 'View All',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E90FF),
                        ),
                      ),
                      const SizedBox(width: 2),
                      Icon(
                        _showAllAmazonDeals ? Icons.keyboard_arrow_up : Icons.arrow_forward_ios,
                        size: 10,
                        color: const Color(0xFF1E90FF),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Horizontal Slider OR Grid View based on _showAllAmazonDeals
          if (!_showAllAmazonDeals)
            SizedBox(
              height: 275,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: deals.length,
                itemBuilder: (context, index) {
                  final deal = deals[index];
                  return Container(
                    width: 175,
                    margin: const EdgeInsets.only(right: 12),
                    child: _buildAmazonProductCard(context, deal, isDark),
                  );
                },
              ),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: deals.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.64,
                crossAxisSpacing: 10,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                final deal = deals[index];
                return _buildAmazonProductCard(context, deal, isDark);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildAmazonProductCard(
    BuildContext context,
    _AmazonDealItemData deal,
    bool isDark,
  ) {
    final brandModel = BrandModel(
      name: '${deal.brandName} - ${deal.productName}',
      logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/a/a9/Amazon_logo.svg',
      bannerUrl: deal.imageUrl,
      cashbackPercentage: 'Flat ${deal.rewardPercentage.toInt()}% Reward',
      category: 'Amazon Deals',
      offerText: 'After Rewards: ₹${_formatCurrency(deal.finalPrice)}',
      websiteUrl: deal.productUrl,
    );

    return GestureDetector(
      onTap: () => _showConfirmationDialog(context, brandModel),
      child: Container(
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
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TOP PART: Product Image + Brand + Product Name + Actual Price
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Image Container
                      Expanded(
                        child: Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: NetworkImageWithSkeleton(
                              imageUrl: deal.imageUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Brand Name
                      Text(
                        deal.brandName.toUpperCase(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                          color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 2),

                      // Product Name
                      Text(
                        deal.productName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Actual Price
                      Row(
                        children: [
                          Text(
                            'Actual Price: ',
                            style: TextStyle(
                              fontSize: 10.5,
                              color: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
                            ),
                          ),
                          Text(
                            '₹${_formatCurrency(deal.actualPrice.round())}',
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.lineThrough,
                              color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // DASHED DIVIDER LINE
              CustomPaint(
                size: const Size(double.infinity, 1),
                painter: _DashedLinePainter(
                  color: isDark ? const Color(0xFF28282A) : const Color(0xFFE5E5EA),
                  dashWidth: 5,
                  dashSpace: 4,
                ),
              ),

              // BOTTOM PART: Reward % + Final Price
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                color: isDark
                    ? const Color(0xFF1E90FF).withValues(alpha: 0.08)
                    : const Color(0xFF1E90FF).withValues(alpha: 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'After Rewards of ${deal.rewardPercentage.toStringAsFixed(deal.rewardPercentage % 1 == 0 ? 0 : 1)}%',
                      style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E90FF),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          'Final Price: ',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.grey.shade300 : Colors.grey.shade800,
                          ),
                        ),
                        Text(
                          '₹${_formatCurrency(deal.finalPrice)}',
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w900,
                            color: isDark ? Colors.white : Colors.black87,
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
  }

  List<_AmazonDealItemData> get _amazonDealsCatalog => const [
        _AmazonDealItemData(
          brandName: 'Samsung',
          productName: 'Samsung Galaxy S24 Ultra 5G (256GB)',
          imageUrl: 'https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?w=800&auto=format&fit=crop&q=80',
          actualPrice: 129999,
          rewardPercentage: 5.0,
          productUrl: 'https://www.amazon.in',
        ),
        _AmazonDealItemData(
          brandName: 'Apple',
          productName: 'Apple MacBook Air M3 (15-inch, 16GB)',
          imageUrl: 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=800&auto=format&fit=crop&q=80',
          actualPrice: 134900,
          rewardPercentage: 4.0,
          productUrl: 'https://www.amazon.in',
        ),
        _AmazonDealItemData(
          brandName: 'Sony',
          productName: 'Sony WH-1000XM5 Wireless Headphones',
          imageUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=800&auto=format&fit=crop&q=80',
          actualPrice: 29990,
          rewardPercentage: 6.0,
          productUrl: 'https://www.amazon.in',
        ),
        _AmazonDealItemData(
          brandName: 'Nike',
          productName: "Nike Air Force 1 '07 Sneakers",
          imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800&auto=format&fit=crop&q=80',
          actualPrice: 8695,
          rewardPercentage: 8.0,
          productUrl: 'https://www.amazon.in',
        ),
        _AmazonDealItemData(
          brandName: 'Logitech',
          productName: 'Logitech MX Master 3S Mouse',
          imageUrl: 'https://images.unsplash.com/photo-1615663245857-ac93bb7c39e7?w=800&auto=format&fit=crop&q=80',
          actualPrice: 10995,
          rewardPercentage: 5.0,
          productUrl: 'https://www.amazon.in',
        ),
        _AmazonDealItemData(
          brandName: 'Bose',
          productName: 'Bose QuietComfort Ultra Earbuds',
          imageUrl: 'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?w=800&auto=format&fit=crop&q=80',
          actualPrice: 25900,
          rewardPercentage: 7.0,
          productUrl: 'https://www.amazon.in',
        ),
        _AmazonDealItemData(
          brandName: 'Dyson',
          productName: 'Dyson V15 Detect Vacuum Cleaner',
          imageUrl: 'https://images.unsplash.com/photo-1558317374-067fb5f30001?w=800&auto=format&fit=crop&q=80',
          actualPrice: 65900,
          rewardPercentage: 5.0,
          productUrl: 'https://www.amazon.in',
        ),
        _AmazonDealItemData(
          brandName: 'Asus',
          productName: 'Asus ROG Zephyrus G16 Gaming Laptop',
          imageUrl: 'https://images.unsplash.com/photo-1603302576837-37561b2e2302?w=800&auto=format&fit=crop&q=80',
          actualPrice: 189990,
          rewardPercentage: 5.0,
          productUrl: 'https://www.amazon.in',
        ),
      ];
}

class _TrendingBrandsCarouselWidget extends StatefulWidget {
  final List<_TrendingBannerItemData> items;
  final bool isDark;
  final Function(BrandModel brand) onBrandTap;

  const _TrendingBrandsCarouselWidget({
    required this.items,
    required this.isDark,
    required this.onBrandTap,
  });

  @override
  State<_TrendingBrandsCarouselWidget> createState() =>
      _TrendingBrandsCarouselWidgetState();
}

class _TrendingBrandsCarouselWidgetState
    extends State<_TrendingBrandsCarouselWidget> {
  late PageController _pageController;
  Timer? _autoSlideTimer;
  static const int _kInfiniteInitialPage = 5000;

  @override
  void initState() {
    super.initState();
    final initialPage = widget.items.isNotEmpty
        ? _kInfiniteInitialPage - (_kInfiniteInitialPage % widget.items.length)
        : 0;

    _pageController = PageController(
      initialPage: initialPage,
      viewportFraction: 0.84,
    );

    _startAutoSlide();
  }

  void _startAutoSlide() {
    _autoSlideTimer?.cancel();
    if (widget.items.isEmpty) return;

    _autoSlideTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (!mounted || !_pageController.hasClients) return;
      final nextPage = _pageController.page!.round() + 1;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 135,
      child: PageView.builder(
        controller: _pageController,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final actualIndex = index % widget.items.length;
          final item = widget.items[actualIndex];

          return GestureDetector(
            onTap: () => widget.onBrandTap(item.brand),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                color: widget.isDark ? const Color(0xFF161618) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: widget.isDark
                      ? const Color(0xFF28282A)
                      : const Color(0xFFE5E5EA),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: widget.isDark ? 0.3 : 0.04,
                    ),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Row(
                  children: [
                    // Left Image Part (38%)
                    SizedBox(
                      width: 105,
                      height: double.infinity,
                      child: NetworkImageWithSkeleton(
                        imageUrl: item.brand.bannerUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                    // Right Content Part (62%)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 22,
                                  height: 22,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: widget.isDark
                                        ? const Color(0xFF242426)
                                        : Colors.grey.shade100,
                                    border: Border.all(
                                      color: const Color(0xFF1E90FF)
                                          .withValues(alpha: 0.3),
                                    ),
                                  ),
                                  child: ClipOval(
                                    child: NetworkImageWithSkeleton(
                                      imageUrl: item.brand.logoUrl,
                                      fit: BoxFit.contain,
                                      errorBuilder: (ctx, err, stack) => Center(
                                        child: Text(
                                          item.brand.name.substring(0, 1),
                                          style: const TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF1E90FF),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    item.brand.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: widget.isDark
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              item.tagline,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w500,
                                color: widget.isDark
                                    ? Colors.grey.shade400
                                    : Colors.grey.shade600,
                              ),
                            ),
                            Text(
                              item.brand.offerText,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: widget.isDark
                                    ? Colors.grey.shade300
                                    : Colors.grey.shade800,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1E90FF).withValues(
                                  alpha: widget.isDark ? 0.16 : 0.1,
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                item.brand.cashbackPercentage,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E90FF),
                                ),
                              ),
                            ),
                          ],
                        ),
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
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
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
            padding: EdgeInsets.only(bottom: isLastRow ? 0.0 : 10.0),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
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
            ),
          );
        }),
      ),
    );
  }

  Widget _buildGridBrandCard(
      BuildContext context, BrandModel brand, bool isDark) {
    final imageUrl = brand.logoUrl.isNotEmpty
        ? brand.logoUrl
        : (brand.bannerUrl.isNotEmpty ? brand.bannerUrl : brand.websiteUrl);

    return GestureDetector(
      onTap: () => _showConfirmationDialog(context, brand),
      child: Container(
        height: 148,
        padding: const EdgeInsets.all(8),
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
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 1. Offer / Discount Percentage (Top Tag)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.06)
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                brand.offerText,
                maxLines: 1,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 9.5,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.grey.shade300 : Colors.black87,
                ),
              ),
            ),

            // 2. Center: Brand Logo / Image + Brand Name
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF222225) : Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isDark
                              ? const Color(0xFF333336)
                              : const Color(0xFFEEEEEE),
                          width: 0.8,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: NetworkImageWithSkeleton(
                            imageUrl: imageUrl,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) => Container(
                              color: isDark
                                  ? const Color(0xFF242426)
                                  : Colors.grey.shade200,
                              child: const Icon(
                                Icons.storefront_outlined,
                                size: 18,
                                color: Color(0xFF1E90FF),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      brand.name,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 3. Reward / Cashback Percentage (Bottom Text - Dodger Blue Accent)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF1E90FF).withValues(alpha: isDark ? 0.16 : 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFF1E90FF).withValues(alpha: 0.25),
                  width: 1,
                ),
              ),
              child: Text(
                brand.cashbackPercentage,
                maxLines: 1,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E90FF),
                ),
              ),
            ),
          ],
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
            logoUrl: 'https://www.freepnglogos.com/uploads/amazon-png-logo-vector/woodland-gardening-amazon-png-logo-vector-8.png',
            bannerUrl: 'https://www.freepnglogos.com/uploads/amazon-png-logo-vector/woodland-gardening-amazon-png-logo-vector-8.png',
            cashbackPercentage: 'Up to 8% Rewards',
            category: 'Most Popular',
            offerText: 'Up to 8000000% Off',
            websiteUrl: 'https://www.amazon.in',
          ),
          BrandModel(
            name: 'Flipkart',
            logoUrl: 'https://www.freepnglogos.com/uploads/flipkart-logo-png/flipkart-logo-transparent-vector-3.png',
            bannerUrl: 'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Up to 7% Rewards',
            category: 'Most Popular',
            offerText: 'Up to 75% Off',
            websiteUrl: 'https://www.flipkart.com',
          ),
          BrandModel(
            name: 'Myntra',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/b/bc/Myntra_Logo.png',
            bannerUrl: 'https://images.unsplash.com/photo-1483985988355-763728e1935b?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Flat 7.5% Rewards',
            category: 'Most Popular',
            offerText: 'Up to 60% Off',
            websiteUrl: 'https://www.myntra.com',
          ),
          BrandModel(
            name: 'AJIO',
            logoUrl: 'https://assets.ajio.com/static/img/Ajio-Logo.svg',
            bannerUrl: 'https://images.unsplash.com/photo-1445205170230-053b83016050?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Flat 10% Rewards',
            category: 'Most Popular',
            offerText: 'Flat 50% Off',
            websiteUrl: 'https://www.ajio.com',
          ),
          BrandModel(
            name: 'MakeMyTrip',
            logoUrl: 'https://imgak.mmtcdn.com/pwa_v3/pwa_commons_assets/desktop/logo.png',
            bannerUrl: 'https://images.unsplash.com/photo-1436491865332-7a61a109cc05?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Flat 8% Rewards',
            category: 'Most Popular',
            offerText: 'Up to 35% Off',
            websiteUrl: 'https://www.makemytrip.com',
          ),
          BrandModel(
            name: 'Samsung',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/2/24/Samsung_Logo.svg',
            bannerUrl: 'https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Up to 9% Rewards',
            category: 'Most Popular',
            offerText: 'Up to 50% Off',
            websiteUrl: 'https://www.samsung.com/in',
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
            offerText: 'Up to 70% Off',
            websiteUrl: 'https://www.myntra.com',
          ),
          BrandModel(
            name: 'AJIO',
            logoUrl: 'https://assets.ajio.com/static/img/Ajio-Logo.svg',
            bannerUrl: 'https://images.unsplash.com/photo-1445205170230-053b83016050?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Flat 10% Cashback',
            category: 'Fashion',
            offerText: 'Up to 60% Off',
            websiteUrl: 'https://www.ajio.com',
          ),
          BrandModel(
            name: 'Nike',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/a/a6/Logo_NIKE.svg',
            bannerUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Up to 9% Cashback',
            category: 'Fashion',
            offerText: 'Up to 40% Off',
            websiteUrl: 'https://www.nike.com/in',
          ),
          BrandModel(
            name: 'H&M',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/5/53/H%26M-Logo.svg',
            bannerUrl: 'https://images.unsplash.com/photo-1490481651871-ab68de25d43d?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Flat 8% Cashback',
            category: 'Fashion',
            offerText: 'Up to 50% Off',
            websiteUrl: 'https://www2.hm.com/en_in',
          ),
          BrandModel(
            name: 'Zara',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/f/fd/Zara_Logo.svg',
            bannerUrl: 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Up to 6% Cashback',
            category: 'Fashion',
            offerText: 'Up to 30% Off',
            websiteUrl: 'https://www.zara.com/in',
          ),
          BrandModel(
            name: 'ASOS',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/a/a9/Amazon_logo.svg',
            bannerUrl: 'https://images.unsplash.com/photo-1483985988355-763728e1935b?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Up to 8% Cashback',
            category: 'Fashion',
            offerText: 'Up to 50% Off',
            websiteUrl: 'https://www.asos.com',
          ),
        ];

      case 'Credit Cards':
        return const [
          BrandModel(
            name: 'SBI Card',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/c/cc/SBI-Logo.svg',
            bannerUrl: 'https://images.unsplash.com/photo-1563013544-824ae1b704d3?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Flat ₹1,200 Cashback',
            category: 'Credit Cards',
            offerText: 'Instant ₹500 Gift Card',
            websiteUrl: 'https://www.sbicard.com',
          ),
          BrandModel(
            name: 'HDFC Bank',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/2/28/HDFC_Bank_Logo.svg',
            bannerUrl: 'https://images.unsplash.com/photo-1559526324-4b87b5e36e44?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Flat ₹1,500 Bonus',
            category: 'Credit Cards',
            offerText: 'Lifetime Free Card',
            websiteUrl: 'https://www.hdfcbank.com',
          ),
          BrandModel(
            name: 'ICICI Bank',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/1/12/ICICI_Bank_Logo.svg',
            bannerUrl: 'https://images.unsplash.com/photo-1556742049-0a67dd385203?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Flat ₹1,000 Rewards',
            category: 'Credit Cards',
            offerText: 'Zero Joining Fee',
            websiteUrl: 'https://www.icicibank.com',
          ),
          BrandModel(
            name: 'Axis Bank',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/1/1a/Axis_Bank_logo.svg',
            bannerUrl: 'https://images.unsplash.com/photo-1601597111158-2fceff292cdc?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Flat ₹1,500 Cashback',
            category: 'Credit Cards',
            offerText: '5% Unlimited Cashback',
            websiteUrl: 'https://www.axisbank.com',
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
            offerText: 'Up to 50% Off',
            websiteUrl: 'https://www.nykaa.com',
          ),
          BrandModel(
            name: 'Sephora',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/2/21/Sephora_logo.svg',
            bannerUrl: 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Flat 10% Cashback',
            category: 'Beauty & Grooming',
            offerText: 'Up to 40% Off',
            websiteUrl: 'https://sephora.in',
          ),
          BrandModel(
            name: 'Mamaearth',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/0/00/Nykaa_New_Logo.svg',
            bannerUrl: 'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Flat 12% Cashback',
            category: 'Beauty & Grooming',
            offerText: 'Buy 1 Get 1 Free',
            websiteUrl: 'https://mamaearth.in',
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
            offerText: 'Up to 60% Off',
            websiteUrl: 'https://www.pepperfry.com',
          ),
          BrandModel(
            name: 'Urban Ladder',
            logoUrl: 'https://www.urbanladder.com/assets/logo.png',
            bannerUrl: 'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Up to 8% Cashback',
            category: 'Home & Kitchen',
            offerText: 'Up to 50% Off',
            websiteUrl: 'https://www.urbanladder.com',
          ),
          BrandModel(
            name: 'IKEA India',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/c/c5/Ikea_logo.svg',
            bannerUrl: 'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Up to 5% Cashback',
            category: 'Home & Kitchen',
            offerText: 'Up to 40% Off',
            websiteUrl: 'https://www.ikea.com/in',
          ),
        ];

      case 'Electronics':
        return const [
          BrandModel(
            name: 'Amazon',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/a/a9/Amazon_logo.svg',
            bannerUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Up to 6% Cashback',
            category: 'Electronics',
            offerText: 'Up to 65% Off',
            websiteUrl: 'https://www.amazon.in',
          ),
          BrandModel(
            name: 'Flipkart',
            logoUrl: 'https://www.freepnglogos.com/uploads/flipkart-logo-png/flipkart-logo-transparent-vector-3.png',
            bannerUrl: 'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Up to 7% Cashback',
            category: 'Electronics',
            offerText: 'Up to 70% Off',
            websiteUrl: 'https://www.flipkart.com',
          ),
          BrandModel(
            name: 'Croma',
            logoUrl: 'https://media.croma.com/image/upload/v1637759004/Croma%20Assets/CMS/Category%20Icon/Croma_Logo.png',
            bannerUrl: 'https://images.unsplash.com/photo-1526738549149-8e07eca6c147?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Flat 6% Cashback',
            category: 'Electronics',
            offerText: 'Up to 50% Off',
            websiteUrl: 'https://www.croma.com',
          ),
          BrandModel(
            name: 'Apple Store',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/f/fa/Apple_logo_black.svg',
            bannerUrl: 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Up to 4% Cashback',
            category: 'Electronics',
            offerText: 'Save up to ₹10,000',
            websiteUrl: 'https://www.apple.com/in',
          ),
          BrandModel(
            name: 'Samsung',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/2/24/Samsung_Logo.svg',
            bannerUrl: 'https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Up to 8% Cashback',
            category: 'Electronics',
            offerText: 'Up to 55% Off',
            websiteUrl: 'https://www.samsung.com/in',
          ),
          BrandModel(
            name: 'Reliance Digital',
            logoUrl: 'https://www.reliancedigital.in/build/client/images/rel_stat_svg.svg',
            bannerUrl: 'https://images.unsplash.com/photo-1550009158-9ebf69173e03?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Up to 5% Cashback',
            category: 'Electronics',
            offerText: 'Up to 45% Off',
            websiteUrl: 'https://www.reliancedigital.in',
          ),
        ];

      case 'Food & Grocery':
        return const [
          BrandModel(
            name: 'Swiggy',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/1/13/Swiggy_logo.svg',
            bannerUrl: 'https://images.unsplash.com/photo-1578916171728-46686eac8d58?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Flat 10% Cashback',
            category: 'Food & Grocery',
            offerText: 'Flat 50% Off',
            websiteUrl: 'https://www.swiggy.com',
          ),
          BrandModel(
            name: 'Zomato',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/b/bd/Zomato_Logo.svg',
            bannerUrl: 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Flat 8% Cashback',
            category: 'Food & Grocery',
            offerText: 'Up to 60% Off',
            websiteUrl: 'https://www.zomato.com',
          ),
          BrandModel(
            name: 'Blinkit',
            logoUrl: 'https://blinkit.com/images/header/blinkit_logo.png',
            bannerUrl: 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Up to 8% Cashback',
            category: 'Food & Grocery',
            offerText: 'Flat ₹100 Off',
            websiteUrl: 'https://www.blinkit.com',
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
            offerText: 'Up to 35% Off',
            websiteUrl: 'https://www.makemytrip.com',
          ),
          BrandModel(
            name: 'Booking.com',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/b/be/Booking.com_logo.svg',
            bannerUrl: 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Up to 9% Cashback',
            category: 'Flights & Hotels',
            offerText: 'Up to 40% Off',
            websiteUrl: 'https://www.booking.com',
          ),
          BrandModel(
            name: 'Agoda',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/c/ce/Agoda_logo.svg',
            bannerUrl: 'https://images.unsplash.com/photo-1488646953014-85cb44e25828?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Flat 10% Cashback',
            category: 'Flights & Hotels',
            offerText: 'Up to 50% Off',
            websiteUrl: 'https://www.agoda.com',
          ),
          BrandModel(
            name: 'Expedia',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/c/ce/Agoda_logo.svg',
            bannerUrl: 'https://images.unsplash.com/photo-1488646953014-85cb44e25828?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Flat 7% Cashback',
            category: 'Flights & Hotels',
            offerText: 'Up to 30% Off',
            websiteUrl: 'https://www.expedia.com',
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
            offerText: 'Up to 80% Off',
            websiteUrl: 'https://www.amazon.in',
          ),
        ];
    }
  }
}

class _TrendingBannerItemData {
  final BrandModel brand;
  final String tagline;

  const _TrendingBannerItemData({
    required this.brand,
    required this.tagline,
  });
}

void _showConfirmationDialog(BuildContext context, BrandModel brand) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

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
              'Redirecting to ${brand.name}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 8),

            // Description Subtitle
            Text(
              'You are leaving our app to visit ${brand.name}\'s official website.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 16),

            // Offer Summary Pill
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF1E90FF).withValues(alpha: isDark ? 0.15 : 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF1E90FF).withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.card_giftcard,
                    color: Color(0xFF1E90FF),
                    size: 20,
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

Widget _buildGridBrandCard(BuildContext context, BrandModel brand, bool isDark) {
  final imageUrl = brand.logoUrl.isNotEmpty
      ? brand.logoUrl
      : (brand.bannerUrl.isNotEmpty ? brand.bannerUrl : brand.websiteUrl);
  return GestureDetector(
    onTap: () => _showConfirmationDialog(context, brand),
    child: Container(
      height: 148,
      padding: const EdgeInsets.all(8),
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
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Top: Offer / Discount % Tag
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF242426) : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              brand.offerText,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 9.5,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ),

          // Center: Brand Image / Logo + Brand Name
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Brand Logo Container
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF222225) : Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isDark
                            ? const Color(0xFF333336)
                            : const Color(0xFFEEEEEE),
                        width: 0.8,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: NetworkImageWithSkeleton(
                          imageUrl: imageUrl,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: isDark
                                ? const Color(0xFF242426)
                                : Colors.grey.shade200,
                            child: const Icon(
                              Icons.storefront_outlined,
                              size: 18,
                              color: Color(0xFF1E90FF),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Brand Name
                  Text(
                    brand.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom: Cashback / Reward % Badge
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3.5),
            decoration: BoxDecoration(
              color: const Color(0xFF1E90FF)
                  .withValues(alpha: isDark ? 0.16 : 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              brand.cashbackPercentage,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 9.5,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E90FF),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _AmazonDealItemData {
  final String brandName;
  final String productName;
  final String imageUrl;
  final double actualPrice;
  final double rewardPercentage;
  final String productUrl;

  const _AmazonDealItemData({
    required this.brandName,
    required this.productName,
    required this.imageUrl,
    required this.actualPrice,
    required this.rewardPercentage,
    this.productUrl = 'https://www.amazon.in',
  });

  int get finalPrice => (actualPrice * (1.0 - (rewardPercentage / 100.0))).round();
}

class _DashedLinePainter extends CustomPainter {
  final Color color;
  final double dashWidth;
  final double dashSpace;

  const _DashedLinePainter({
    required this.color,
    this.dashWidth = 5.0,
    this.dashSpace = 4.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    double startX = 0;
    final y = size.height / 2;
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, y),
        Offset((startX + dashWidth).clamp(0, size.width), y),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant _DashedLinePainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.dashWidth != dashWidth ||
        oldDelegate.dashSpace != dashSpace;
  }
}

String _formatCurrency(num amount) {
  final str = amount.round().toString();
  final reg = RegExp(r'(\d+?)(?=(\d{3})+(?!\d))');
  return str.replaceAllMapped(reg, (Match m) => '${m[1]},');
}

class _SubcategoryBannerData {
  final String brandName;
  final String headline;
  final String subText;
  final String offerTag;
  final String buttonText;
  final Color themeColor;
  final Color lightColor;
  final IconData logoIcon;

  const _SubcategoryBannerData({
    required this.brandName,
    required this.headline,
    required this.subText,
    required this.offerTag,
    required this.buttonText,
    required this.themeColor,
    required this.lightColor,
    required this.logoIcon,
  });
}

const _popularBrandsBanner = _SubcategoryBannerData(
  brandName: 'Mega Fest',
  headline: 'TOP POPULAR STORES FESTIVAL',
  subText: 'Get Flat 15% Real Cashback across 500+ Top Online Retailers',
  offerTag: 'FLAT 15% CASHBACK',
  buttonText: 'Explore Stores',
  themeColor: Color(0xFF1E90FF),
  lightColor: Color(0xFFCBE2FE),
  logoIcon: Icons.stars_rounded,
);

const _fashionBanner = _SubcategoryBannerData(
  brandName: 'Fashion Hub',
  headline: 'SEASON END FASHION SALE',
  subText: 'Up to 80% OFF + Extra 12% Real Cashback on Top Clothing Brands',
  offerTag: 'UP TO 80% OFF',
  buttonText: 'Shop Fashion',
  themeColor: Color(0xFFEC4899),
  lightColor: Color(0xFFFBCFE8),
  logoIcon: Icons.checkroom_rounded,
);

const _trendingBanner = _SubcategoryBannerData(
  brandName: 'Trending Zone',
  headline: 'HOT VIRAL DEALS OF THE WEEK',
  subText: 'Grab Extra Rewards on Top Trending & Viral Products',
  offerTag: 'HOT DEALS ⚡',
  buttonText: 'Grab Deals',
  themeColor: Color(0xFF8B5CF6),
  lightColor: Color(0xFFDDD6FE),
  logoIcon: Icons.local_fire_department_rounded,
);

const _beautyBanner = _SubcategoryBannerData(
  brandName: 'Beauty Glam',
  headline: 'GLOW & CARE BEAUTY DAYS',
  subText: 'Flat 50% OFF + Extra 15% Rewards on Skincare & Makeup',
  offerTag: 'FLAT 50% OFF',
  buttonText: 'Shop Beauty',
  themeColor: Color(0xFFF43F5E),
  lightColor: Color(0xFFFECDD3),
  logoIcon: Icons.spa_rounded,
);

const _lifetimeCardsBanner = _SubcategoryBannerData(
  brandName: 'Free Cards',
  headline: 'ZERO ANNUAL FEE CREDIT CARDS',
  subText: 'Get Lifetime Free Card + Free ₹1,500 Amazon Gift Voucher',
  offerTag: 'FREE ₹1,500 VOUCHER',
  buttonText: 'Apply Card',
  themeColor: Color(0xFFD97706),
  lightColor: Color(0xFFFDE68A),
  logoIcon: Icons.credit_card_rounded,
);

const _electronicsBanner = _SubcategoryBannerData(
  brandName: 'Tech Zone',
  headline: 'MEGA GADGET & TECH SALE',
  subText: 'Up to 60% OFF + Flat ₹3,000 Extra Cashback on Laptops & Phones',
  offerTag: 'UP TO 60% OFF',
  buttonText: 'Shop Electronics',
  themeColor: Color(0xFF0D9488),
  lightColor: Color(0xFF99F6E4),
  logoIcon: Icons.devices_rounded,
);

const _shoppingCardsBanner = _SubcategoryBannerData(
  brandName: 'Shopping Cards',
  headline: '5% UNLIMITED SHOPPING CASHBACK',
  subText: 'Earn Unlimited Cashback on Amazon, Flipkart, Zomato & More',
  offerTag: '5% UNLIMITED',
  buttonText: 'Get Card',
  themeColor: Color(0xFFEA580C),
  lightColor: Color(0xFFFED7AA),
  logoIcon: Icons.shopping_bag_rounded,
);

const _medicineBanner = _SubcategoryBannerData(
  brandName: 'Health Care',
  headline: 'HEALTH & WELLNESS SAVINGS',
  subText: 'Flat 25% OFF Medicines + Extra 10% Cashback & Free Delivery',
  offerTag: 'FLAT 25% OFF',
  buttonText: 'Order Medicines',
  themeColor: Color(0xFF059669),
  lightColor: Color(0xFFA7F3D0),
  logoIcon: Icons.medical_services_rounded,
);

const _cardsLoansBanner = _SubcategoryBannerData(
  brandName: 'Credit & Loans',
  headline: 'QUICK APPROVAL LOANS & CARDS',
  subText: 'Low Interest Rates + Flat ₹2,000 Gift Voucher on Approval',
  offerTag: 'INSTANT APPROVAL',
  buttonText: 'Check Loan',
  themeColor: Color(0xFF4F46E5),
  lightColor: Color(0xFFC7D2FE),
  logoIcon: Icons.account_balance_rounded,
);

const _hotelBookingBanner = _SubcategoryBannerData(
  brandName: 'Travel Deals',
  headline: 'WANDERLUST HOTEL DEALS',
  subText: 'Up to 50% OFF Hotel Stays + Extra ₹1,000 Cashback on Bookings',
  offerTag: 'UP TO 50% OFF',
  buttonText: 'Book Hotels',
  themeColor: Color(0xFF2563EB),
  lightColor: Color(0xFFBAE6FD),
  logoIcon: Icons.hotel_rounded,
);

const _personalLoansBanner = _SubcategoryBannerData(
  brandName: 'Personal Loans',
  headline: 'FLEXIBLE PERSONAL LOANS',
  subText: 'Paperless Approval in 5 Mins + Flat ₹1,500 Real Cash Reward',
  offerTag: 'PAPERLESS 5 MINS',
  buttonText: 'Apply Loan',
  themeColor: Color(0xFF65A30D),
  lightColor: Color(0xFFD9F99D),
  logoIcon: Icons.request_quote_rounded,
);

const _amazonDealsBanner = _SubcategoryBannerData(
  brandName: 'Amazon Deals',
  headline: 'AMAZON SUPER CASHBACK DEALS',
  subText: 'Extra Cashback on Daily Essentials, Electronics & Appliances',
  offerTag: 'SUPER CASHBACK',
  buttonText: 'Shop Amazon',
  themeColor: Color(0xFFD97706),
  lightColor: Color(0xFFFED7AA),
  logoIcon: Icons.shopping_cart_rounded,
);

const _flipkartBanner = _SubcategoryBannerData(
  brandName: 'Flipkart Sale',
  headline: 'FLIPKART FREEDOM MEGA SAVINGS',
  subText: 'Up to 80% OFF on Top Brands + Extra 10% Instant Real Cashback',
  offerTag: 'EXTRA 10% CASHBACK',
  buttonText: 'Shop Flipkart',
  themeColor: Color(0xFF2874F0),
  lightColor: Color(0xFFDBEAFE),
  logoIcon: Icons.shopping_bag_rounded,
);

const _meeshoBanner = _SubcategoryBannerData(
  brandName: 'Meesho Deals',
  headline: 'BUDGET DEALS STARTING AT ₹99',
  subText: 'Lowest Prices Guaranteed + Flat ₹150 Extra Reward on First Orders',
  offerTag: 'FLAT ₹150 REWARD',
  buttonText: 'Explore Meesho',
  themeColor: Color(0xFFD946EF),
  lightColor: Color(0xFFFAE8FF),
  logoIcon: Icons.local_offer_rounded,
);

const _bestOfLoansBanner = _SubcategoryBannerData(
  brandName: 'Best Loans',
  headline: 'LOWEST INTEREST LOAN OFFERS',
  subText: 'Instant Approval with Zero Processing Fee + ₹2,500 Gift Voucher',
  offerTag: 'ZERO PROCESSING FEE',
  buttonText: 'Check Loan Offers',
  themeColor: Color(0xFF0F766E),
  lightColor: Color(0xFFCCFBF1),
  logoIcon: Icons.account_balance_rounded,
);

class _SubcategoryPromotionalBannerWidget extends StatelessWidget {
  final _SubcategoryBannerData bannerData;
  final bool isDark;

  const _SubcategoryPromotionalBannerWidget({
    required this.bannerData,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final topColor = isDark ? const Color(0xFF1C1C20) : Colors.white;
    final bottomColor = isDark
        ? Color.alphaBlend(bannerData.themeColor.withValues(alpha: 0.28), const Color(0xFF101014))
        : bannerData.lightColor;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [topColor, bottomColor],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // TOP SECTION (WHITE BG AREA)
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // LEFT: Brand Badge, Offer Tag & Headline
              Expanded(
                flex: 70,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // BRAND & OFFER TAG ROW
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: bannerData.themeColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: bannerData.themeColor.withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            bannerData.brandName.toUpperCase(),
                            style: TextStyle(
                              color: isDark ? Colors.white : bannerData.themeColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: bannerData.themeColor,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            bannerData.offerTag,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // PROMOTIONAL HEADLINE
                    Text(
                      bannerData.headline,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                        fontSize: 15.5,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.2,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // RIGHT: CIRCULAR BRAND/CATEGORY ICON BADGE
              Expanded(
                flex: 30,
                child: Center(
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: bannerData.themeColor.withValues(alpha: 0.1),
                      border: Border.all(
                        color: bannerData.themeColor.withValues(alpha: 0.25),
                        width: 1.5,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        bannerData.logoIcon,
                        size: 32,
                        color: isDark ? Colors.white : bannerData.themeColor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // BOTTOM SECTION (LIGHT COLOR AREA)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // SUPPORTING OFFER DETAILS (LEFT)
              Expanded(
                child: Text(
                  bannerData.subText,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isDark ? Colors.grey.shade300 : const Color(0xFF334155),
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // NON-CLICKABLE CTA PROMO BADGE (RIGHT)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: bannerData.themeColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: bannerData.themeColor.withValues(alpha: 0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      bannerData.buttonText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      size: 12,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


