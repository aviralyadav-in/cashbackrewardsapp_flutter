import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/category_provider.dart';
import '../providers/home_provider.dart';
import '../providers/product_provider.dart';
import '../providers/user_provider.dart';
import '../theme/app_theme.dart';
import '../data/home_mock_data.dart';
import '../widgets/cashback_banner_carousel.dart';
import '../widgets/home/best_deals_section.dart';
import '../widgets/home/featured_stores_section.dart';
import '../widgets/home/store_carousel_section.dart';
import '../widgets/home/home_offers_section.dart';
import '../widgets/home/top_categories_section.dart';
import '../widgets/home/trending_deals_section.dart';
import 'all_best_deals_screen.dart';
import 'all_categories_screen.dart';
import 'all_stores_screen.dart';
import 'all_trending_deals_screen.dart';
import 'best_deals_screen.dart';
import 'my_earnings_screen.dart';
import 'notifications_screen.dart';
import 'offer_section_screen.dart';
import 'product_detail_screen.dart';
import 'profile_screen.dart';
import 'search_screen.dart';
import 'store_detail_screen.dart';

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Future.wait([
        context.read<ProductProvider>().fetchProducts(),
        context.read<CategoryProvider>().fetchCategories(),
        context.read<HomeProvider>().fetchHomeData(),
      ]);
    });
  }

  void _onBottomNavigationTap(int index) {
    if (index == _selectedIndex) return;

    setState(() {
      _selectedIndex = index;
    });
  }


  void _showProfilePopup(BuildContext context, bool isDark) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.25),
      builder: (dialogContext) {
        return Dialog(
          alignment: Alignment.topRight,
          insetPadding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 48,
            right: 16,
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Consumer<UserProvider>(
            builder: (context, userProvider, _) {
              final rawName = userProvider.fullName.trim();
              final rawEmail = userProvider.email.trim();
              final rawPhone = userProvider.phoneNumber.trim();

              final displayName = rawName.isNotEmpty
                  ? rawName
                  : (userProvider.isAuthenticated ? 'KashIQ Member' : 'Guest User');

              final displayEmail = rawEmail.isNotEmpty
                  ? rawEmail
                  : (rawPhone.isNotEmpty ? rawPhone : 'No email registered');

              final initial = displayName.isNotEmpty
                  ? displayName[0].toUpperCase()
                  : 'U';

              return Container(
                width: 275,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF241E1A) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? const Color(0xFF45392F) : const Color(0xFFE2E8F0),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.45 : 0.12),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: isDark
                                  ? const [Color(0xFF1E3A8A), Color(0xFF132247)]
                                  : const [AppColors.primaryBrown, AppColors.deepBrown],
                            ),
                          ),
                          child: Center(
                            child: Text(
                              initial,
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                displayName,
                                style: GoogleFonts.inter(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w700,
                                  color: isDark
                                      ? AppColors.darkTextPrimary
                                      : const Color(0xFF221A15),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                displayEmail,
                                style: TextStyle(
                                  fontSize: 11.5,
                                  color: isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.textSecondary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.of(dialogContext).pop(),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isDark
                                  ? const Color(0xFF332922)
                                  : const Color(0xFFF3ECE4),
                            ),
                            child: Icon(
                              Icons.close_rounded,
                              size: 14,
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Divider(
                      height: 1,
                      thickness: 0.8,
                      color: isDark ? AppColors.darkBorder : AppColors.border,
                    ),
                    const SizedBox(height: 8),
                      InkWell(
                        onTap: () {
                          Navigator.of(dialogContext).pop();
                          _onBottomNavigationTap(4);
                        },
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding:
                            const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                        child: Row(
                          children: [
                            Icon(
                              Icons.account_circle_outlined,
                              size: 17,
                              color: isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.primaryBrown,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'View Full Profile',
                              style: GoogleFonts.inter(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                                color: isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.primaryBrown,
                              ),
                            ),
                            const Spacer(),
                            Icon(
                              Icons.chevron_right_rounded,
                              size: 16,
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.textMuted,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildHomeContent(BuildContext context, bool isDark) {
    return SafeArea(
      child: Column(
        children: [
          // 1. COMPACT HEADER (Logo, Notifications, Profile)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : AppColors.mainBackground,
              border: Border(
                bottom: BorderSide(
                  color: isDark
                      ? AppColors.darkBorder.withValues(alpha: 0.3)
                      : AppColors.border.withValues(alpha: 0.35),
                  width: 0.7,
                ),
              ),
            ),
            child: Row(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primaryBrown,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.account_balance_wallet_rounded,
                          size: 17,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'KashIQ',
                      style: GoogleFonts.inter(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                  constraints: const BoxConstraints(minWidth: 30, minHeight: 32),
                  icon: Icon(
                    Icons.notifications_outlined,
                    size: 24,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.primaryBrown,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(NotificationsScreen.routeName);
                  },
                  tooltip: 'Notifications',
                ),
                const SizedBox(width: 2),
                IconButton(
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                  constraints: const BoxConstraints(minWidth: 30, minHeight: 32),
                  icon: Icon(
                    Icons.person_outline_rounded,
                    size: 25,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.primaryBrown,
                  ),
                  onPressed: () => _showProfilePopup(context, isDark),
                  tooltip: 'Profile',
                ),
              ],
            ),
          ),

          // 2. UNIVERSAL SEARCH ENTRY BAR (Prominent, shopping search experience)
          Container(
            color: isDark ? AppColors.darkCard : AppColors.mainBackground,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(SearchScreen.routeName);
              },
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF132247) : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isDark ? const Color(0xFF1E3A8A) : const Color(0xFFE2E8F0),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.search_rounded,
                      color: isDark ? const Color(0xFF2563EB) : AppColors.primaryBrown,
                      size: 22,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Search products, stores, categories...',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(
                      Icons.mic_none_rounded,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                      size: 19,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // SCROLLABLE DISCOVERY FEED
          Expanded(
            child: RefreshIndicator(
              color: AppColors.primaryBrown,
              onRefresh: () async {
                await Future.wait([
                  context.read<HomeProvider>().fetchHomeData(),
                  context.read<ProductProvider>().fetchProducts(),
                ]);
              },
              child: Consumer2<HomeProvider, UserProvider>(
                builder: (context, homeProvider, userProvider, child) {
                  final bestDeals = homeProvider.bestDeals;
                  final offers = homeProvider.offers;
                  final featuredStores = homeProvider.featuredStores;
                  final trendingDeals = homeProvider.trendingDeals;

                  return ListView(
                    padding: const EdgeInsets.only(top: 8, bottom: 24),
                    children: [
                      // PROMOTIONAL BANNER CAROUSEL
                      const CashbackBannerCarousel(),
                      const SizedBox(height: 14),

                      // SECTION 2.5: 🗂️ EXPLORE / SHOP BY CATEGORY
                      TopCategoriesSection(isDark: isDark),
                      const SizedBox(height: 18),

                      // SECTION 3: CASHBACK SUMMARY
                      // HomeCompactCashbackCard(
                      //   isDark: isDark,
                      //   availableCashback: availableCashback,
                      //   pendingCashback: pendingCashback,
                      //   onViewWalletTap: () {
                      //     setState(() {
                      //       _selectedIndex = 2; // Switch to Wallet / MyEarnings tab
                      //     });
                      //   },
                      // ),
                      // const SizedBox(height: 18),

                      // SECTION 4: 🏆 BEST DEALS FOR YOU
                      BestDealsSection(
                        isDark: isDark,
                        deals: bestDeals,
                        onViewAllTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => AllBestDealsScreen(deals: bestDeals),
                            ),
                          );
                        },
                        onShopNow: (deal) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ProductDetailScreen.fromBestDeal(deal),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 18),

                      // SECTION 4.5: HIGHEST CASHBACK (Top Rates)
                      StoreCarouselSection(
                        isDark: isDark,
                        title: 'Highest Cashback Stores',
                
                        stores: HomeMockData.highestCashbackCatalog,
                      ),
                      const SizedBox(height: 18),

                      // SECTION 5: 🔥 OFFERS
                      HomeOffersSection(
                        isDark: isDark,
                        offers: offers,
                        onViewAllTap: () {
                          final offerItems = offers.map((o) {
                            return OfferSectionItem(
                              id: int.tryParse(o.id.replaceAll(RegExp(r'[^0-9]'), '')) ?? 1,
                              title: o.title,
                              description: o.title,
                              priceOrRate: o.discount,
                              cashbackTag: o.cashback,
                              imageUrl: o.imageUrl,
                              storeName: o.store,
                            );
                          }).toList();

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => OfferSectionScreen(
                                title: 'All Hot Offers',
                                items: offerItems,
                              ),
                            ),
                          );
                        },
                        onOfferTap: (offer) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ProductDetailScreen.fromHomeOffer(offer),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 18),


                      // SECTION 8: ⭐ FEATURED STORES
                      FeaturedStoresSection(
                        isDark: isDark,
                        stores: featuredStores,
                        onViewAllTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => AllStoresScreen(initialStores: featuredStores),
                            ),
                          );
                        },
                        onStoreTap: (store) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => StoreDetailScreen(
                                storeName: store.name,
                                cashbackRate: store.cashbackRate,
                                logoUrl: store.logoUrl,
                                category: 'Shopping',
                                websiteUrl: store.websiteUrl,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 18),

                      // SECTION 8.5: 🏨 TRAVEL & HOTEL BOOKING
                      StoreCarouselSection(
                        isDark: isDark,
                       
                        title: 'Travel & Hotel Deals',
                        subtitle: 'Best rates on hotel stays, airlines & holidays',
                        stores: HomeMockData.hotelBookingCatalog,
                      ),
                      const SizedBox(height: 18),

                      // SECTION 9: 🔥 TRENDING DEALS
                      TrendingDealsSection(
                        isDark: isDark,
                        deals: trendingDeals,
                        onViewAllTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => AllTrendingDealsScreen(deals: trendingDeals),
                            ),
                          );
                        },
                        onDealTap: (deal) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ProductDetailScreen.fromTrendingDeal(deal),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 18),

                      // SECTION 9.5: 💳 PERSONAL LOANS
                      StoreCarouselSection(
                        isDark: isDark,
                      
                        title: 'Personal Loans',
                        subtitle: 'Instant paperless approval & flat cash rewards',
                        stores: HomeMockData.loansCategoryCatalog,
                      ),
                      const SizedBox(height: 18),

                      // SECTION 10.5:  PHARMACY & HEALTH (CashKaro Style)
                      StoreCarouselSection(
                        isDark: isDark,
                     
                        title: 'Pharmacy & Health',
                        subtitle: 'Flat discounts & high cashback on online medicines',
                        stores: HomeMockData.medicineBrandsCatalog,
                      ),
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
          _onBottomNavigationTap(0);
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: isDark ? AppColors.darkBackground : AppColors.mainBackground,
        body: SmoothTabTransition(
          currentIndex: _selectedIndex,
          children: [
            _buildHomeContent(context, isDark),
            AllCategoriesScreen(
              onBack: () => _onBottomNavigationTap(0),
            ),
            BestDealsScreen(
              onBack: () => _onBottomNavigationTap(0),
            ),
            MyEarningsScreen(
              onBack: () => _onBottomNavigationTap(0),
            ),
            ProfileScreen(
              onBack: () => _onBottomNavigationTap(0),
            ),
          ],
        ),
        bottomNavigationBar: _buildFloatingBottomNavBar(isDark),
      ),
    );
  }

  Widget _buildFloatingBottomNavBar(bool isDark) {
    final activeColor = isDark ? AppColors.darkPrimary : AppColors.accentBlue;
    const navItemColor = Colors.white;
    final navBg = isDark ? const Color(0xFF0A1128) : const Color(0xFF0F172A);
    final borderColor = isDark ? const Color(0xFF1E3A8A) : const Color(0xFF1E3A8A);

    final navItems = [
      const _FloatingNavItem(
        icon: Icons.home_outlined,
        activeIcon: Icons.home_rounded,
        label: 'Home',
      ),
      const _FloatingNavItem(
        icon: Icons.grid_view_outlined,
        activeIcon: Icons.grid_view_rounded,
        label: 'Categories',
      ),
      const _FloatingNavItem(
        icon: Icons.local_fire_department_outlined,
        activeIcon: Icons.local_fire_department_rounded,
        label: 'Best Deals',
        isHighlight: true,
      ),
      const _FloatingNavItem(
        icon: Icons.account_balance_wallet_outlined,
        activeIcon: Icons.account_balance_wallet_rounded,
        label: 'Wallet',
      ),
      const _FloatingNavItem(
        icon: Icons.person_outline_rounded,
        activeIcon: Icons.person_rounded,
        label: 'Profile',
      ),
    ];

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 0, 14, 10),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final totalWidth = constraints.maxWidth;
            final tabWidth = totalWidth / navItems.length;

            return TweenAnimationBuilder<double>(
              tween: Tween<double>(end: _selectedIndex.toDouble()),
              duration: const Duration(milliseconds: 320),
              curve: Curves.easeInOutCubic,
              builder: (context, animatedIndex, _) {
                final activeX = (animatedIndex + 0.5) * tabWidth;
                final activeItem = navItems[_selectedIndex];
                final isHighlight = activeItem.isHighlight;

                return SizedBox(
                  height: 78,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // 1. Curved Scoop Notched Bar Background
                      Positioned(
                        left: 0,
                        right: 0,
                        top: 0,
                        bottom: 0,
                        child: CustomPaint(
                          size: Size(totalWidth, 78),
                          painter: CurvedNotchPainter(
                            activeX: activeX,
                            barColor: navBg,
                            borderColor: borderColor,
                            topY: 16.0,
                            barHeight: 58.0,
                            cornerRadius: 28.0,
                            bottomRadius: 24.0,
                          ),
                        ),
                      ),

                      // 2. Elevated Floating Circular Orb at activeX (Matches Image exactly!)
                      Positioned(
                        left: activeX - 25,
                        top: 0,
                        width: 50,
                        height: 50,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: navBg,
                            border: Border.all(
                              color: borderColor,
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.35),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: isHighlight
                                      ? const [Color(0xFF2563EB), Color(0xFF1D4ED8)]
                                      : (isDark
                                          ? const [Color(0xFF38BDF8), Color(0xFF0284C7)]
                                          : const [Color(0xFF2563EB), Color(0xFF1E40AF)]),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: (isHighlight
                                            ? const Color(0xFF2563EB)
                                            : activeColor)
                                        .withValues(alpha: 0.45),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 200),
                                  child: Icon(
                                    activeItem.activeIcon,
                                    key: ValueKey(activeItem.label),
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // 3. Tab Items Row (Resting icons + labels underneath)
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        height: 78,
                        child: Row(
                          children: List.generate(navItems.length, (index) {
                            final item = navItems[index];
                            final isSelected = _selectedIndex == index;
                            final distance = (animatedIndex - index).abs();
                            final iconOpacity = distance.clamp(0.0, 1.0);

                            return Expanded(
                              child: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  HapticFeedback.selectionClick();
                                  _onBottomNavigationTap(index);
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    // Resting icon
                                    Opacity(
                                      opacity: iconOpacity,
                                      child: SizedBox(
                                        height: 24,
                                        child: Center(
                                          child: Icon(
                                            item.icon,
                                            size: 21,
                                            color: item.isHighlight
                                                ? (isDark ? const Color(0xFF38BDF8) : const Color(0xFF60A5FA))
                                                : navItemColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    // Label
                                    Text(
                                      item.label,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: isSelected ? 12.0 : 11.0,
                                        fontWeight: isSelected
                                            ? FontWeight.w800
                                            : FontWeight.w600,
                                        color: item.isHighlight
                                            ? (isDark ? const Color(0xFF38BDF8) : const Color(0xFF60A5FA))
                                            : Colors.white,
                                        letterSpacing: 0.1,
                                      ),
                                    ),
                                    const SizedBox(height: 7),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _FloatingNavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isHighlight;

  const _FloatingNavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    this.isHighlight = false,
  });
}

class CurvedNotchPainter extends CustomPainter {
  final double activeX;
  final Color barColor;
  final Color borderColor;
  final double topY;
  final double barHeight;
  final double cornerRadius;
  final double bottomRadius;

  CurvedNotchPainter({
    required this.activeX,
    required this.barColor,
    required this.borderColor,
    this.topY = 16.0,
    this.barHeight = 58.0,
    this.cornerRadius = 28.0,
    this.bottomRadius = 24.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = barColor
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.30)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16);

    final bottomY = topY + barHeight;
    final path = Path();

    // Scoop Notch parameters matching user's image
    const notchRadius = 36.0;
    const notchDepth = 20.0;
    final leftNotch = activeX - notchRadius;
    final rightNotch = activeX + notchRadius;
    final dipY = topY + notchDepth;

    // Start at top-left rounded corner
    path.moveTo(0, topY + cornerRadius);
    path.quadraticBezierTo(0, topY, cornerRadius, topY);

    // Line to scoop entry
    if (leftNotch > cornerRadius) {
      path.lineTo(leftNotch, topY);
    } else {
      path.lineTo(cornerRadius, topY);
    }

    // Smooth cubic scoop into the bowl
    path.cubicTo(
      activeX - 20, topY,
      activeX - 18, dipY,
      activeX, dipY,
    );

    // Smooth cubic scoop out of the bowl
    path.cubicTo(
      activeX + 18, dipY,
      activeX + 20, topY,
      rightNotch, topY,
    );

    // Line to top-right corner
    if (rightNotch < size.width - cornerRadius) {
      path.lineTo(size.width - cornerRadius, topY);
    }
    path.quadraticBezierTo(size.width, topY, size.width, topY + cornerRadius);

    // Right edge down to bottom-right corner
    path.lineTo(size.width, bottomY - bottomRadius);
    path.quadraticBezierTo(size.width, bottomY, size.width - bottomRadius, bottomY);

    // Bottom edge to bottom-left corner
    path.lineTo(bottomRadius, bottomY);
    path.quadraticBezierTo(0, bottomY, 0, bottomY - bottomRadius);

    path.close();

    // Ambient drop shadow underneath
    canvas.drawPath(path.shift(const Offset(0, 5)), shadowPaint);

    // Solid bar body
    canvas.drawPath(path, paint);

    // Edge border outline
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CurvedNotchPainter oldDelegate) {
    return oldDelegate.activeX != activeX ||
        oldDelegate.barColor != barColor ||
        oldDelegate.borderColor != borderColor;
  }
}

class SmoothTabTransition extends StatefulWidget {
  final int currentIndex;
  final List<Widget> children;
  final Duration duration;

  const SmoothTabTransition({
    super.key,
    required this.currentIndex,
    required this.children,
    this.duration = const Duration(milliseconds: 260),
  });

  @override
  State<SmoothTabTransition> createState() => _SmoothTabTransitionState();
}

class _SmoothTabTransitionState extends State<SmoothTabTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int _previousIndex = 0;
  int _targetIndex = 0;

  @override
  void initState() {
    super.initState();
    _previousIndex = widget.currentIndex;
    _targetIndex = widget.currentIndex;
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );
    _controller.value = 1.0;
  }

  @override
  void didUpdateWidget(SmoothTabTransition oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentIndex != _targetIndex) {
      _previousIndex = _targetIndex;
      _targetIndex = widget.currentIndex;
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        final isAnimating = _controller.isAnimating;
        final progress = _animation.value;
        final isForward = _targetIndex > _previousIndex;
        const slideDistance = 20.0;

        return Stack(
          fit: StackFit.expand,
          children: List.generate(widget.children.length, (index) {
            final isTarget = index == _targetIndex;
            final isPrevious = index == _previousIndex;
            final isActive = isTarget || (isAnimating && isPrevious);

            double opacity = 0.0;
            double dx = 0.0;

            if (!isAnimating) {
              opacity = isTarget ? 1.0 : 0.0;
              dx = 0.0;
            } else if (isTarget) {
              opacity = progress;
              dx = isForward
                  ? slideDistance * (1.0 - progress)
                  : -slideDistance * (1.0 - progress);
            } else if (isPrevious) {
              opacity = 1.0 - progress;
              dx = isForward
                  ? -slideDistance * progress
                  : slideDistance * progress;
            }

            return Offstage(
              offstage: !isActive,
              child: TickerMode(
                enabled: isActive,
                child: IgnorePointer(
                  ignoring: !isTarget,
                  child: Transform.translate(
                    offset: Offset(dx, 0),
                    child: Opacity(
                      opacity: opacity.clamp(0.0, 1.0),
                      child: widget.children[index],
                    ),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

