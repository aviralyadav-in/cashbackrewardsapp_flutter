import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/storage_service.dart';
import '../../theme/app_theme.dart';
import 'login_screen.dart';

/// KashIQ Onboarding Screen.
///
/// Communicates KashIQ's core USP to first-time users:
/// "Find better deals → combine eligible savings → shop → earn cashback."
///
/// Exactly 3 structured pages:
/// 1. BEST DEALS: "Find the Best Deals, Every Time"
/// 2. STACK YOUR SAVINGS: "Stack Your Savings"
/// 3. SHOP & EARN: "Shop More. Save More. Earn Cashback."
class OnboardingScreen extends StatefulWidget {
  static const String routeName = '/onboarding';

  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  final AppStorageService _storageService = AppStorageService();
  int _currentPage = 0;

  late final List<_OnboardingPageData> _pages = [
    _OnboardingPageData(
      headline: 'Find the Best Deals, Every Time',
      subtitle:
          'Discover great prices, discounts, cashback and offers in one place.',
      visualBuilder: _buildPage1BestDeals,
    ),
    _OnboardingPageData(
      headline: 'Stack Your Savings',
      subtitle:
          'Combine store discounts, coupon codes and real cashback to get the lowest effective price on your purchase.',
      visualBuilder: _buildPage2StackSavings,
    ),
    _OnboardingPageData(
      headline: 'Shop More. Save More. Earn Cashback.',
      subtitle:
          'Shop through KashIQ, unlock eligible offers and earn cashback on qualifying purchases.',
      visualBuilder: _buildPage3ShopAndEarn,
    ),
  ];

  Future<void> _completeOnboarding() async {
    try {
      await _storageService.saveHasSeenOnboarding(true);
    } catch (e) {
      debugPrint('Error saving onboarding flag: $e');
    }

    if (!mounted) return;

    // Always show LoginScreen after Onboarding Screen
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  void _onNext() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _onBack() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = _currentPage == _pages.length - 1;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.mainBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar: KashIQ Brand Tag + Skip Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDark
                              ? AppColors.darkSurface
                              : AppColors.beigeSurface,
                          border: Border.all(
                            color:
                                isDark ? AppColors.darkBorder : AppColors.border,
                          ),
                        ),
                        child: Icon(
                          Icons.account_balance_wallet_rounded,
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.primaryBrown,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'KashIQ',
                        style: GoogleFonts.inter(
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.deepBrown,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  if (!isLastPage)
                    TextButton(
                      onPressed: _completeOnboarding,
                      child: Text(
                        'Skip',
                        style: AppTextStyles.buttonText(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.textMuted,
                        ),
                      ),
                    )
                  else
                    const SizedBox(height: 48),
                ],
              ),
            ),

            // Page View Content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Center(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 8.0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Central Deal / Savings Visualization
                          page.visualBuilder(context, isDark),
                          const SizedBox(height: 24),

                          // Large Headline
                          Text(
                            page.headline,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              color: isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.deepBrown,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.4,
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Subtitle
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 320),
                            child: Text(
                              page.subtitle,
                              textAlign: TextAlign.center,
                              style: AppTextStyles.body(
                                color: isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.textSecondary,
                              ).copyWith(
                                fontSize: 13.5,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Bottom Indicators and Navigation Controls
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Dot indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_pages.length, (index) {
                      final isActive = _currentPage == index;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: isActive ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: isActive
                              ? (isDark
                                  ? AppColors.darkPrimary
                                  : AppColors.deepBrown)
                              : (isDark
                                  ? AppColors.darkBorder
                                  : AppColors.border),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 22),

                  // Controls (Back and Next/Get Started)
                  Row(
                    children: [
                      if (_currentPage > 0)
                        Expanded(
                          flex: 1,
                          child: OutlinedButton(
                            onPressed: _onBack,
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: isDark
                                    ? AppColors.darkBorder
                                    : AppColors.border,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.radiusNormal,
                                ),
                              ),
                            ),
                            child: Text(
                              'Back',
                              style: AppTextStyles.buttonText(
                                color: isDark
                                    ? AppColors.darkTextPrimary
                                    : AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ),
                      if (_currentPage > 0) const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: _onNext,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isDark
                                ? AppColors.darkPrimary
                                : AppColors.primaryBrown,
                            foregroundColor: isDark
                                ? const Color(0xFF1E1A33)
                                : AppColors.cardBackground,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            elevation: 1.5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppDimensions.radiusNormal,
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                isLastPage ? 'Get Started' : 'Next',
                                style: AppTextStyles.buttonText(
                                  color: isDark
                                      ? const Color(0xFF1E1A33)
                                      : AppColors.cardBackground,
                                ).copyWith(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(width: 6),
                              Icon(
                                isLastPage
                                    ? Icons.check_circle_outline_rounded
                                    : Icons.arrow_forward_rounded,
                                size: 18,
                              ),
                            ],
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
    );
  }

  // ===========================================================================
  // PAGE 1 VISUAL: BEST DEALS PRODUCT CARD
  // ===========================================================================
  Widget _buildPage1BestDeals(BuildContext context, bool isDark) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 340),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.border,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Badges Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF3C7), // Warm Amber
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusPill),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('🔥', style: TextStyle(fontSize: 12)),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          'Best Deal',
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFB45309), // Amber-800
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.accentBlue.withValues(alpha: 0.12),
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusPill),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.verified_rounded,
                      size: 13,
                      color: isDark ? AppColors.accentBlue : AppColors.navyDark,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Verified Price',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.navyDark,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Product Graphic & Details
          Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: isDark
                        ? [const Color(0xFF3F3765), const Color(0xFF2D274B)]
                        : [const Color(0xFFEAEFFE), const Color(0xFFD6DCF8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Icon(
                  Icons.headphones_rounded,
                  size: 28,
                  color:
                      isDark ? AppColors.darkPrimary : AppColors.primaryBrown,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Wireless ANC Headphones',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.deepBrown,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Top Rated • Electronics',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11.5,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Pricing & Savings Highlight
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.surfaceSubtle,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 6,
                        children: [
                          Text(
                            '₹6,999',
                            style: TextStyle(
                              fontSize: 12,
                              decoration: TextDecoration.lineThrough,
                              decorationColor: isDark
                                  ? AppColors.darkTextMuted
                                  : AppColors.textMuted,
                              color: isDark
                                  ? AppColors.darkTextMuted
                                  : AppColors.textMuted,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 1.5,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.errorBackground,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              '14% OFF',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: AppColors.error,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 4,
                        children: [
                          Text(
                            '₹5,999',
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.deepBrown,
                            ),
                          ),
                          Text(
                            'Deal Price',
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                // Cashback Badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.successBackground,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.success.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.account_balance_wallet_rounded,
                            size: 12,
                            color: AppColors.success,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            '+ ₹300',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF047857), // Emerald-700
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 1),
                      Text(
                        'Cashback',
                        style: GoogleFonts.inter(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF047857),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '*Illustrative deal example. Offers vary by store.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              fontStyle: FontStyle.italic,
              color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // PAGE 2 VISUAL: STACK YOUR SAVINGS BREAKDOWN
  // ===========================================================================
  Widget _buildPage2StackSavings(BuildContext context, bool isDark) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 340),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.border,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Product Price: ₹6,999',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.accentBlue.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
                ),
                child: Text(
                  'Stacked Savings',
                  style: GoogleFonts.inter(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.accentBlue : AppColors.navyDark,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Savings steps
          _buildStackRow(
            isDark: isDark,
            icon: '🏷️',
            title: 'Best Deal Price',
            subtitle: 'Instant store price drop',
            savingText: '- ₹1,000',
            savingColor: AppColors.accentBlue,
          ),
          _buildStackDivider(isDark),
          _buildStackRow(
            isDark: isDark,
            icon: '✂️',
            title: 'Coupon Code',
            subtitle: 'Store promo applied',
            savingText: '- ₹500',
            savingColor: const Color(0xFFD97706), // Amber-600
          ),
          _buildStackDivider(isDark),
          _buildStackRow(
            isDark: isDark,
            icon: '💰',
            title: 'KashIQ Cashback',
            subtitle: 'Credited to your wallet',
            savingText: '+ ₹500 back',
            savingColor: AppColors.success,
          ),
          const SizedBox(height: 10),

          // Total Savings Summary Container
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1A33) : const Color(0xFFECFDF5),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.success.withValues(alpha: 0.4),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Final: ₹4,999',
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.deepBrown,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Saved ₹2,000',
                    style: GoogleFonts.inter(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '*Illustrative savings example. Varies by store and offer.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              fontStyle: FontStyle.italic,
              color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStackRow({
    required bool isDark,
    required String icon,
    required String title,
    required String subtitle,
    required String savingText,
    required Color savingColor,
  }) {
    return Row(
      children: [
        Text(icon, style: const TextStyle(fontSize: 15)),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color:
                      isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
                ),
              ),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          savingText,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: savingColor,
          ),
        ),
      ],
    );
  }

  Widget _buildStackDivider(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        children: [
          const SizedBox(width: 18),
          Icon(
            Icons.arrow_downward_rounded,
            size: 11,
            color: isDark ? AppColors.darkTextMuted : AppColors.border,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Divider(
              height: 1,
              color: isDark
                  ? AppColors.darkBorder
                  : AppColors.border.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // PAGE 3 VISUAL: 4-STEP SHOP & EARN JOURNEY
  // ===========================================================================
  Widget _buildPage3ShopAndEarn(BuildContext context, bool isDark) {
    final steps = [
      _JourneyStep(
        stepNumber: '1',
        icon: Icons.search_rounded,
        title: 'Find a Deal',
        desc: 'Browse & compare top prices across stores',
        color: AppColors.accentBlue,
      ),
      _JourneyStep(
        stepNumber: '2',
        icon: Icons.local_offer_rounded,
        title: 'Unlock Offers',
        desc: 'Combine eligible coupons & bank discounts',
        color: const Color(0xFFF59E0B), // Amber
      ),
      _JourneyStep(
        stepNumber: '3',
        icon: Icons.shopping_bag_rounded,
        title: 'Shop',
        desc: 'Order on the partner store as usual',
        color: const Color(0xFF3B82F6), // Blue
      ),
      _JourneyStep(
        stepNumber: '4',
        icon: Icons.account_balance_wallet_rounded,
        title: 'Get Cashback',
        desc: 'Cashback credited to your KashIQ wallet',
        color: AppColors.success,
      ),
    ];

    return Container(
      constraints: const BoxConstraints(maxWidth: 340),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.border,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Simple 4-Step Journey',
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.deepBrown,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.successBackground,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
                ),
                child: Text(
                  'Seamless',
                  style: GoogleFonts.inter(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.success,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Connected Steps
          for (int i = 0; i < steps.length; i++) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Step Circle
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: steps[i].color.withValues(alpha: 0.14),
                    border: Border.all(
                      color: steps[i].color.withValues(alpha: 0.4),
                      width: 1.2,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      steps[i].icon,
                      size: 14,
                      color: steps[i].color,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              steps[i].title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: isDark
                                    ? AppColors.darkTextPrimary
                                    : AppColors.deepBrown,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 1,
                            ),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.darkSurface
                                  : AppColors.surfaceSubtle,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Step ${steps[i].stepNumber}',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.textMuted,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 1),
                      Text(
                        steps[i].desc,
                        style: TextStyle(
                          fontSize: 10.5,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.textSecondary,
                          height: 1.25,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (i < steps.length - 1)
              Padding(
                padding: const EdgeInsets.only(left: 13.0),
                child: Container(
                  width: 2,
                  height: 8,
                  color: isDark ? AppColors.darkBorder : AppColors.border,
                ),
              ),
          ],
          const SizedBox(height: 8),
          Text(
            '*Cashback tracked automatically on qualifying partner orders.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              fontStyle: FontStyle.italic,
              color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingPageData {
  final String headline;
  final String subtitle;
  final Widget Function(BuildContext context, bool isDark) visualBuilder;

  const _OnboardingPageData({
    required this.headline,
    required this.subtitle,
    required this.visualBuilder,
  });
}

class _JourneyStep {
  final String stepNumber;
  final IconData icon;
  final String title;
  final String desc;
  final Color color;

  const _JourneyStep({
    required this.stepNumber,
    required this.icon,
    required this.title,
    required this.desc,
    required this.color,
  });
}
