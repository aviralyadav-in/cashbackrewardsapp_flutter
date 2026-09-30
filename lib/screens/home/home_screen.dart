import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../providers/category_provider.dart';
import '../../providers/home_provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/user_provider.dart';
import '../../theme/app_theme.dart';
import '../../data/home_mock_data.dart';
import '../../services/affiliate_service.dart';
import '../../widgets/common/cashback_banner_carousel.dart';
import '../../widgets/home/best_deals_section.dart';
import '../../widgets/home/featured_stores_section.dart';
import '../../widgets/home/store_carousel_section.dart';
import '../../widgets/home/home_offers_section.dart';
import '../../widgets/home/cashback_boost_promotional_banner.dart';
import '../../widgets/home/mega_savings_promotional_banner.dart';
import '../../widgets/home/top_categories_section.dart';
import '../../widgets/home/trending_deals_section.dart';
import '../deals/all_best_deals_screen.dart';
import '../categories/all_categories_screen.dart';
import '../stores/all_stores_screen.dart';
import '../deals/all_trending_deals_screen.dart';
import '../deals/best_deals_screen.dart';
import '../wallet/my_earnings_screen.dart';
import '../profile/notifications_screen.dart';
import '../deals/offer_section_screen.dart';
import '../products/product_detail_screen.dart';
import '../profile/profile_screen.dart';
import '../search/search_screen.dart';
import '../stores/store_detail_screen.dart';

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
      final uid = context.read<UserProvider>().uid;
      Future.wait([
        context.read<ProductProvider>().fetchProducts(),
        context.read<CategoryProvider>().fetchCategories(),
        context.read<HomeProvider>().fetchHomeData(userId: uid),
      ]);

      if (uid.isNotEmpty) {
        // Sync historical orders and affiliate clicks to train personalization engine
        AffiliateService().getUserOrders(uid).then((orders) {
          if (mounted && orders.isNotEmpty) {
            context.read<HomeProvider>().syncUserOrders(orders.map((o) => o.toMap()).toList());
          }
        });
        AffiliateService().getUserClicks(uid).then((clicks) {
          if (mounted && clicks.isNotEmpty) {
            context.read<HomeProvider>().syncUserClicks(clicks);
          }
        });
      }
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

              final avatarUrl = userProvider.avatarUrl.isNotEmpty
                  ? userProvider.avatarUrl
                  : 'assets/avatars/avatar.png';

              final ImageProvider avatarImage =
                  (avatarUrl.startsWith('http://') || avatarUrl.startsWith('https://'))
                      ? NetworkImage(avatarUrl)
                      : AssetImage(avatarUrl) as ImageProvider;

              return Container(
                width: 280,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.border,
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
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isDark
                                  ? AppColors.darkPrimary.withValues(alpha: 0.6)
                                  : AppColors.accentBlue.withValues(alpha: 0.45),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.08),
                                blurRadius: 4,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: isDark ? AppColors.darkSurface : const Color(0xFFF3F6FE),
                            backgroundImage: avatarImage,
                            onBackgroundImageError: (error, stackTrace) {},
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
                                      : AppColors.textPrimary,
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
                                  ? AppColors.darkBackground
                                  : const Color(0xFFF1F5F9),
                            ),
                            child: Icon(
                              Icons.close_rounded,
                              size: 14,
                              color: isDark
                                  ? AppColors.darkIconNormal
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
                                  ? AppColors.darkPrimary
                                  : AppColors.accentBlue,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'View Full Profile',
                              style: GoogleFonts.inter(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                                color: isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.accentBlue,
                              ),
                            ),
                            const Spacer(),
                            Icon(
                              Icons.chevron_right_rounded,
                              size: 16,
                              color: isDark
                                  ? AppColors.darkIconNormal
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
              color: isDark ? AppColors.darkBackground : AppColors.mainBackground,
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
                    color: isDark ? AppColors.darkIconNormal : AppColors.primaryBrown,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(NotificationsScreen.routeName);
                  },
                  tooltip: 'Notifications',
                ),
                const SizedBox(width: 6),
                Consumer<UserProvider>(
                  builder: (context, userProv, _) {
                    final avatarUrl = userProv.avatarUrl.isNotEmpty
                        ? userProv.avatarUrl
                        : 'assets/avatars/avatar.png';
                    final ImageProvider headerAvatar =
                        (avatarUrl.startsWith('http://') || avatarUrl.startsWith('https://'))
                            ? NetworkImage(avatarUrl)
                            : AssetImage(avatarUrl) as ImageProvider;

                    return GestureDetector(
                      onTap: () => _showProfilePopup(context, isDark),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDark
                                ? AppColors.darkPrimary.withValues(alpha: 0.6)
                                : AppColors.accentBlue.withValues(alpha: 0.5),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.08),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 15,
                          backgroundColor: isDark ? AppColors.darkSurface : const Color(0xFFF3F6FE),
                          backgroundImage: headerAvatar,
                          onBackgroundImageError: (error, stackTrace) {},
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // 2. UNIVERSAL SEARCH ENTRY BAR (Prominent, shopping search experience)
          Container(
            color: isDark ? AppColors.darkBackground : AppColors.mainBackground,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(SearchScreen.routeName);
              },
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
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
                      color: isDark ? AppColors.darkPrimary : AppColors.primaryBrown,
                      size: 22,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Search products, stores, categories...',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(
                      Icons.mic_none_rounded,
                      color: isDark ? AppColors.darkIconNormal : AppColors.textMuted,
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
                  final bestDeals = homeProvider.personalizedBestDeals;
                  final offers = homeProvider.offers;
                  final featuredStores = homeProvider.featuredStores;
                  final trendingDeals = homeProvider.trendingDeals;

                  return ListView(
                    padding: const EdgeInsets.only(top: 8, bottom: 24),
                    children: [
                      // PROMOTIONAL BANNER CAROUSEL
                      CashbackBannerCarousel(isDark: isDark),
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
                        deals: homeProvider.homeBestDeals,
                        isNewUser: homeProvider.isNewUser,
                        onViewAllTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => AllBestDealsScreen(deals: bestDeals),
                            ),
                          );
                        },
                        onShopNow: (deal) {
                          // Record user product click in personalization engine
                          homeProvider.recordProductClick(
                            id: deal.id,
                            category: deal.category,
                            brand: deal.brand,
                            store: deal.store,
                          );
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ProductDetailScreen.fromBestDeal(deal),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 18),

                      // PROMOTIONAL CAMPAIGN BANNER: MEGA SAVINGS / EXTRA CASHBACK
                      MegaSavingsPromotionalBanner(
                        isDark: isDark,
                        onExploreTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => AllBestDealsScreen(deals: bestDeals),
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

                      // PROMOTIONAL BANNER 2: CASHBACK BOOST
                      CashbackBoostPromotionalBanner(
                        isDark: isDark,
                        onViewStoresTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => AllStoresScreen(initialStores: featuredStores),
                            ),
                          );
                        },
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
    final barBg = isDark ? AppColors.darkCard : Colors.white;
    final borderColor = isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0);

    final navItems = [
      const _HeroNavItem(
        index: 0,
        icon: Icons.home_outlined,
        activeIcon: Icons.home_rounded,
        label: 'Home',
      ),
      const _HeroNavItem(
        index: 1,
        icon: Icons.grid_view_outlined,
        activeIcon: Icons.grid_view_rounded,
        label: 'Categories',
      ),
      const _HeroNavItem(
        index: 2,
        icon: Icons.local_fire_department_outlined,
        activeIcon: Icons.local_fire_department_rounded,
        label: 'Best Deals',
        isHero: true,
      ),
      const _HeroNavItem(
        index: 3,
        icon: Icons.account_balance_wallet_outlined,
        activeIcon: Icons.account_balance_wallet_rounded,
        label: 'Wallet',
      ),
      const _HeroNavItem(
        index: 4,
        icon: Icons.person_outline_rounded,
        activeIcon: Icons.person_rounded,
        label: 'Profile',
      ),
    ];

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 0, 14, 10),
        child: SizedBox(
          height: 80,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [
              // 1. Sleek Modern Floating Dock Background
              Container(
                height: 64,
                decoration: BoxDecoration(
                  color: barBg,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: borderColor, width: 1.1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.40 : 0.07),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: navItems.map((item) {
                    if (item.isHero) {
                      // Empty placeholder for center hero button to balance the row
                      return const Expanded(child: SizedBox.shrink());
                    }

                    final isSelected = _selectedIndex == item.index;
                    return Expanded(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            HapticFeedback.selectionClick();
                            _onBottomNavigationTap(item.index);
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AnimatedScale(
                                scale: isSelected ? 1.08 : 1.0,
                                duration: const Duration(milliseconds: 200),
                                child: Icon(
                                  isSelected ? item.activeIcon : item.icon,
                                  size: 23.5,
                                  color: isDark
                                      ? (isSelected ? AppColors.darkIconActive : AppColors.darkIconNormal)
                                      : Colors.black,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                item.label,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12.0,
                                  fontWeight: isSelected ? FontWeight.w900 : FontWeight.w800,
                                  color: isDark
                                      ? (isSelected ? AppColors.darkIconActive : AppColors.darkIconNormal)
                                      : Colors.black,
                                  letterSpacing: -0.2,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              // Micro-dot indicator for active state
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 220),
                                width: isSelected ? 4 : 0,
                                height: isSelected ? 4 : 0,
                                decoration: BoxDecoration(
                                  color: isDark ? AppColors.darkIconActive : Colors.black,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              // 2. Center Elevated Glowing Hero Button (Best Deals 🔥)
              Positioned(
                top: 0,
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    _onBottomNavigationTap(2);
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedScale(
                        scale: _selectedIndex == 2 ? 1.06 : 1.0,
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeOutBack,
                        child: Container(
                          width: 54,
                          height: 54,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFF9787F3),
                                Color(0xFF7C3AED),
                                Color(0xFF4F46E5),
                              ],
                            ),
                            border: Border.all(
                              color: isDark ? AppColors.darkCard : Colors.white,
                              width: 3.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF7C3AED).withValues(
                                  alpha: _selectedIndex == 2 ? 0.65 : 0.40,
                                ),
                                blurRadius: _selectedIndex == 2 ? 18 : 12,
                                spreadRadius: _selectedIndex == 2 ? 2 : 0,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.local_fire_department_rounded,
                              size: 27,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Best Deals',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12.0,
                          fontWeight: _selectedIndex == 2 ? FontWeight.w900 : FontWeight.w800,
                          color: isDark
                              ? (_selectedIndex == 2 ? AppColors.darkIconActive : AppColors.darkIconNormal)
                              : Colors.black,
                          letterSpacing: -0.2,
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
  }
}

class _HeroNavItem {
  final int index;
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isHero;

  const _HeroNavItem({
    required this.index,
    required this.icon,
    required this.activeIcon,
    required this.label,
    this.isHero = false,
  });
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

