import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/home_mock_data.dart';
import '../models/discovery_section_model.dart';
import '../providers/category_provider.dart';
import '../providers/product_provider.dart';
import '../widgets/cashback_banner_carousel.dart';
import '../widgets/home/brand_confirmation_dialog.dart';
import '../widgets/home/grid_brand_card.dart';
import '../widgets/home/home_drawer.dart';
import '../widgets/home/offer_section_carousel.dart';
import '../widgets/home/subcategory_promotional_banner.dart';
import '../widgets/home/subtle_section_container.dart';
import '../widgets/home/top_amazon_deals_section.dart';
import '../widgets/home/top_categories_section.dart';
import '../widgets/home/trending_brands_carousel.dart';
import 'missing_tickets_screen.dart';
import 'my_earnings_screen.dart';
import 'notifications_screen.dart';
import 'offer_section_screen.dart';
import 'profile_screen.dart';
import 'refer_earn_screen.dart';
import 'search_screen.dart';
import 'ticket_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;

  final Set<String> _expandedSectionIds = {};

  void _toggleSection(String sectionId) {
    setState(() {
      if (_expandedSectionIds.contains(sectionId)) {
        _expandedSectionIds.remove(sectionId);
      } else {
        _expandedSectionIds.add(sectionId);
      }
    });
  }

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

  Widget _buildDiscoverySection(DiscoverySectionModel section, bool isDark) {
    final isExpanded = _expandedSectionIds.contains(section.id);

    return Column(
      children: [
        SubtleSectionContainer(
          title: section.title,
          isDark: isDark,
          lightGradientColors: section.lightGradientColors,
          darkGradientColors: section.darkGradientColors,
          onViewAllTap: () => _toggleSection(section.id),
          child: GridCardsSection(
            brands: section.brands,
            isDark: isDark,
            isExpanded: isExpanded,
            initialCount: section.initialCount,
          ),
        ),
        SubcategoryPromotionalBannerWidget(
          bannerData: section.bannerData,
          isDark: isDark,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Split discovery sections around Trending Brands (fashion is [0], beauty..personal loans is [1..])
    final fashionSection = HomeMockData.discoverySections.firstWhere((s) => s.id == 'fashion');
    final otherDiscoverySections = HomeMockData.discoverySections.where((s) => s.id != 'fashion').toList();

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: isDark ? const Color(0xFF0D0D0D) : const Color(0xFFF6F7F9),

      // LEFT CATEGORIES DRAWER
      drawer: HomeDrawer(isDark: isDark),

      // MAIN BODY
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
                  const Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(width: 8),
                        Text(
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
                        TopCategoriesSection(
                          isDark: isDark,
                        ),
                        const SizedBox(height: 24),

                        // 1. CASHBACK ON MOST POPULAR BRANDS
                        SubtleSectionContainer(
                          title: 'Cashback on Most Popular Brands',
                          isDark: isDark,
                          lightGradientColors: const [Color(0xFFEFF6FF), Colors.white],
                          darkGradientColors: const [Color(0xFF0F172A), Color(0xFF0D0D0D)],
                          child: HorizontalBrandCarousel(
                            brands: HomeMockData.popularBrandsCatalog,
                            isDark: isDark,
                          ),
                        ),
                        SubcategoryPromotionalBannerWidget(
                          bannerData: HomeMockData.popularBrandsBanner,
                          isDark: isDark,
                        ),

                        // 2. GET CASHBACK ON FASHION BUYS
                        _buildDiscoverySection(fashionSection, isDark),

                        // 3. TRENDING BRANDS
                        SubtleSectionContainer(
                          title: 'Trending Brands',
                          isDark: isDark,
                          lightGradientColors: const [Color(0xFFF5F0FF), Colors.white],
                          darkGradientColors: const [Color(0xFF161022), Color(0xFF0D0D0D)],
                          child: TrendingBrandsCarouselWidget(
                            items: HomeMockData.trendingBannerCatalog,
                            isDark: isDark,
                            onBrandTap: (brand) => showBrandConfirmationDialog(context, brand),
                          ),
                        ),
                        SubcategoryPromotionalBannerWidget(
                          bannerData: HomeMockData.trendingBanner,
                          isDark: isDark,
                        ),

                        // 4 TO 11: DISCOVERY SECTIONS (Beauty, Cards, Electronics, Shopping, Medicines, Loans, Hotels, Personal Loans)
                        ...otherDiscoverySections.map(
                          (section) => _buildDiscoverySection(section, isDark),
                        ),

                        // 12. TOP AMAZON DEALS
                        TopAmazonDealsSection(isDark: isDark),
                        SubcategoryPromotionalBannerWidget(
                          bannerData: HomeMockData.amazonDealsBanner,
                          isDark: isDark,
                        ),

                        // FLIPKART – FREEDOM SALE
                        OfferSectionCarouselWidget(
                          title: 'Flipkart – Freedom Sale',
                          items: HomeMockData.flipkartOffers,
                          onViewAllTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const OfferSectionScreen(
                                  title: 'Flipkart – Freedom Sale',
                                  items: HomeMockData.flipkartOffers,
                                ),
                              ),
                            );
                          },
                        ),
                        SubcategoryPromotionalBannerWidget(
                          bannerData: HomeMockData.flipkartBanner,
                          isDark: isDark,
                        ),
                        const SizedBox(height: 24),

                        // MEESHO – TOP DEALS
                        OfferSectionCarouselWidget(
                          title: 'Meesho – Top Deals',
                          items: HomeMockData.meeshoOffers,
                          onViewAllTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const OfferSectionScreen(
                                  title: 'Meesho – Top Deals',
                                  items: HomeMockData.meeshoOffers,
                                ),
                              ),
                            );
                          },
                        ),
                        SubcategoryPromotionalBannerWidget(
                          bannerData: HomeMockData.meeshoBanner,
                          isDark: isDark,
                        ),
                        const SizedBox(height: 24),

                        // BEST OF LOANS
                        OfferSectionCarouselWidget(
                          title: 'Best of Loans',
                          items: HomeMockData.loanOffers,
                          onViewAllTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const OfferSectionScreen(
                                  title: 'Best of Loans',
                                  items: HomeMockData.loanOffers,
                                ),
                              ),
                            );
                          },
                        ),
                        SubcategoryPromotionalBannerWidget(
                          bannerData: HomeMockData.bestOfLoansBanner,
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

                              return OfferSectionCarouselWidget(
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
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),

      // 5-ITEM FIXED BOTTOM NAVIGATION
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
