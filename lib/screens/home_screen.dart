import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../data/home_mock_data.dart';
import '../models/discovery_section_model.dart';
import '../providers/category_provider.dart';
import '../providers/product_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/cashback_banner_carousel.dart';
import '../widgets/home/home_drawer.dart';
import '../widgets/home/subcategory_promotional_banner.dart';
import '../widgets/home/subtle_section_container.dart';
import '../widgets/home/top_amazon_deals_section.dart';
import '../widgets/home/top_categories_section.dart';
import 'missing_tickets_screen.dart';
import 'my_earnings_screen.dart';
import 'notifications_screen.dart';
import 'profile_screen.dart';
import 'refer_earn_screen.dart';
import 'search_screen.dart';
import 'top_category_brands_screen.dart';

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
    if (index == _selectedIndex) return;

    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildDiscoverySection(DiscoverySectionModel section, bool isDark) {
    return Column(
      children: [
        SubtleSectionContainer(
          title: section.title,
          isDark: isDark,
          lightGradientColors: section.lightGradientColors,
          darkGradientColors: section.darkGradientColors,
          onViewAllTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => TopCategoryBrandsScreen(
                  categoryTitle: section.title,
                  brands: section.brands,
                ),
              ),
            );
          },
          child: GridCardsSection(
            brands: section.brands,
            isDark: isDark,
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

  Widget _buildHomeContent(BuildContext context, bool isDark) {
    return SafeArea(
      child: Column(
        children: [
          // TOP HEADER
          Container(
            color: isDark ? AppColors.darkCard : AppColors.mainBackground,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                // Hamburger Menu Icon
                IconButton(
                  icon: Icon(
                    Icons.menu_rounded,
                    size: 26,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.primaryBrown,
                  ),
                  onPressed: () {
                    _scaffoldKey.currentState?.openDrawer();
                  },
                  tooltip: 'Categories',
                ),

                // App Logo & Title (Fraunces Display Typography)
                Expanded(
                  child: Center(
                    child: Text(
                      'CashKaro',
                      style: GoogleFonts.fraunces(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                ),

                // Notification Bell Icon
                IconButton(
                  icon: Icon(
                    Icons.notifications_outlined,
                    size: 26,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.primaryBrown,
                  ),
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
            color: isDark ? AppColors.darkCard : AppColors.mainBackground,
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(SearchScreen.routeName);
              },
              child: Container(
                height: 46,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(23),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.border,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      color: AppColors.textMuted,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Search stores, products & cashback',
                      style: AppTextStyles.body(
                        color: AppColors.textMuted,
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
                        lightGradientColors: const [AppColors.beigeSurface, AppColors.cardBackground],
                        darkGradientColors: const [AppColors.darkSurface, AppColors.darkCard],
                        onViewAllTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const TopCategoryBrandsScreen(
                                categoryTitle: 'Most Popular',
                                brands: HomeMockData.popularBrandsCatalog,
                              ),
                            ),
                          );
                        },
                        child: GridCardsSection(
                          brands: HomeMockData.popularBrandsCatalog,
                          isDark: isDark,
                          initialCount: 6,
                        ),
                      ),
                      SubcategoryPromotionalBannerWidget(
                        bannerData: HomeMockData.popularBrandsBanner,
                        isDark: isDark,
                      ),

                      // 2. DISCOVERY SECTIONS
                      ...HomeMockData.discoverySections.map((s) => _buildDiscoverySection(s, isDark)),

                      // 3. TOP AMAZON DEALS SECTION
                      TopAmazonDealsSection(isDark: isDark),

                      const SizedBox(height: 24),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PopScope(
      canPop: _selectedIndex == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (_selectedIndex != 0) {
          setState(() {
            _selectedIndex = 0;
          });
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: isDark ? AppColors.darkBackground : AppColors.mainBackground,

        // LEFT CATEGORIES DRAWER (available from Home tab)
        drawer: HomeDrawer(isDark: isDark),

        // MAIN BODY PERSISTENT ACROSS TABS
        body: IndexedStack(
          index: _selectedIndex,
          children: [
            _buildHomeContent(context, isDark),
            ReferEarnScreen(
              onBack: () => setState(() => _selectedIndex = 0),
            ),
            MyEarningsScreen(
              onBack: () => setState(() => _selectedIndex = 0),
            ),
            MissingTicketsScreen(
              onBack: () => setState(() => _selectedIndex = 0),
            ),
            ProfileScreen(
              onBack: () => setState(() => _selectedIndex = 0),
            ),
          ],
        ),

        // 5-ITEM FIXED & PERSISTENT BOTTOM NAVIGATION
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : AppColors.cardBackground,
            border: Border(
              top: BorderSide(
                color: isDark ? AppColors.darkBorder : AppColors.border,
                width: 0.8,
              ),
            ),
          ),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
            unselectedItemColor: AppColors.textMuted,
            backgroundColor: isDark ? AppColors.darkCard : AppColors.cardBackground,
            selectedLabelStyle: AppTextStyles.navLabel(
              color: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
            ),
            unselectedLabelStyle: AppTextStyles.navLabel(
              color: AppColors.textMuted,
            ),
            elevation: 0,
            onTap: _onBottomNavigationTap,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home_rounded),
                label: 'Home',
              ),
              // BottomNavigationBarItem(
              //   icon: Icon(Icons.card_giftcard_outlined),
              //   activeIcon: Icon(Icons.card_giftcard_rounded),
              //   label: 'Refer & Earn',
              // ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_balance_wallet_outlined),
                activeIcon: Icon(Icons.account_balance_wallet_rounded),
                label: 'My Earnings',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.receipt_long_outlined),
                activeIcon: Icon(Icons.receipt_long_rounded),
                label: 'Missing',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline_rounded),
                activeIcon: Icon(Icons.person_rounded),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
