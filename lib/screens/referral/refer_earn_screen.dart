import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../providers/user_provider.dart';
import '../../theme/app_theme.dart';
import 'my_referrals_screen.dart';

class ReferEarnScreen extends StatefulWidget {
  static const String routeName = '/refer-earn';
  final VoidCallback? onBack;

  const ReferEarnScreen({super.key, this.onBack});

  @override
  State<ReferEarnScreen> createState() => _ReferEarnScreenState();
}

class _ReferEarnScreenState extends State<ReferEarnScreen> {
  bool _isLoadingStats = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    if (!mounted) return;
    setState(() => _isLoadingStats = true);
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await Future.wait([
        userProvider.loadWalletData(),
        userProvider.getUserReferrals(),
      ]);
    } catch (_) {}
    if (mounted) {
      setState(() => _isLoadingStats = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final userProvider = Provider.of<UserProvider>(context);
    final myCode = userProvider.referralCode.isNotEmpty
        ? userProvider.referralCode
        : 'KASH100';
    final referralLink = 'kashiq://referral?code=$myCode';

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.mainBackground,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkCard : AppColors.mainBackground,
        foregroundColor: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isDark ? AppColors.darkTextPrimary : AppColors.primaryBrown,
            size: 20,
          ),
          onPressed: () {
            if (widget.onBack != null) {
              widget.onBack!();
            } else if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          },
        ),
        title: Text(
          'Refer & Earn',
          style: AppTextStyles.screenHeading(
            color: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadData,
          color: AppColors.primaryBrown,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. TOP PROMOTIONAL CAROUSEL (~25% SCREEN HEIGHT)
                const _PromotionalCarouselWidget(),

                const SizedBox(height: 24),

                // 2. YOUR REFERRAL CODE & LINK SECTION
                _ReferralCodeAndLinkSection(
                  referralCode: myCode,
                  referralLink: referralLink,
                  isDark: isDark,
                ),

                const SizedBox(height: 20),

                // 3. INVITE FRIENDS BUTTON
                _InviteFriendsButton(
                  referralCode: myCode,
                  referralLink: referralLink,
                ),

                const SizedBox(height: 24),

                // 3.5. REFERRAL NETWORK & PURCHASE TRACKING SECTION (REAL DATABASE DATA)
                _ReferralNetworkTrackingSection(
                  totalReferred: userProvider.totalReferred,
                  purchasedUsersCount: userProvider.purchasedUsersCount,
                  pendingPurchaseCount: userProvider.pendingPurchaseCount,
                  referralEarnings: userProvider.referralEarnings,
                  referredUsers: userProvider.referredUsers,
                  isLoading: _isLoadingStats,
                  isDark: isDark,
                  onRefresh: _loadData,
                ),

                const SizedBox(height: 28),

                // 4. HOW REFER & EARN WORKS SECTION
                _HowItWorksSection(
                  referralCode: myCode,
                  isDark: isDark,
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 1. PROMOTIONAL CAROUSEL WIDGET
// ==========================================
class _PromotionalCarouselWidget extends StatefulWidget {
  const _PromotionalCarouselWidget();

  @override
  State<_PromotionalCarouselWidget> createState() =>
      _PromotionalCarouselWidgetState();
}

class _PromotionalCarouselWidgetState
    extends State<_PromotionalCarouselWidget> {
  late final PageController _pageController;
  Timer? _autoSlideTimer;
  int _currentPage = 0;

  final List<_PromoSlideData> _slides = const [
    _PromoSlideData(
      tag: '100% SECURE DIRECT TRANSFER',
      title: 'Withdraw Earnings to Bank!',
      subtitle: 'Transfer your cashback directly to your bank account anytime.',
      icon: Icons.account_balance_rounded,
    ),
    _PromoSlideData(
      tag: '10% LIFETIME BONUS',
      title: 'Earn Cashback For Lifetime!',
      subtitle: 'Get 10% of whatever your friends earn, forever!',
      icon: Icons.workspace_premium_rounded,
    ),
    _PromoSlideData(
      tag: 'NO LIMIT ON REFERRALS',
      title: 'Refer & Earn Unlimited!',
      subtitle: 'Invite unlimited friends & watch your real cash grow.',
      icon: Icons.card_giftcard_rounded,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);

    _autoSlideTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        final nextPage = (_currentPage + 1) % _slides.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _onSlideTap() {
    if (_pageController.hasClients) {
      final nextPage = (_currentPage + 1) % _slides.length;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final carouselHeight = (screenHeight * 0.25).clamp(185.0, 235.0);

    return Container(
      height: carouselHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        gradient: const LinearGradient(
          colors: [
            AppColors.primaryBrown,
            AppColors.deepBrown,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBrown.withValues(alpha: 0.35),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        child: GestureDetector(
          onTap: _onSlideTap,
          child: Stack(
            children: [
              // PageView Slides
              PageView.builder(
                controller: _pageController,
                itemCount: _slides.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final slide = _slides[index];

                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        // Left Text Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Highlight Tag
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.beigeSurface,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  slide.tag,
                                  style: GoogleFonts.inter(
                                    color: AppColors.deepBrown,
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.4,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),

                              // White Title (Fraunces Display Typography)
                              Text(
                                slide.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  height: 1.2,
                                ),
                              ),
                              const SizedBox(height: 6),

                              // White Subtitle
                              Text(
                                slide.subtitle,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.inter(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  fontSize: 12,
                                  height: 1.25,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Right Illustration Icon Container
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.18),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.4),
                              width: 1.5,
                            ),
                          ),
                          child: Icon(
                            slide.icon,
                            size: 32,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              // Bottom Dots Indicator
              Positioned(
                bottom: 12,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _slides.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentPage == index ? 20 : 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? AppColors.beigeSurface
                            : Colors.white.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
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

class _PromoSlideData {
  final String tag;
  final String title;
  final String subtitle;
  final IconData icon;

  const _PromoSlideData({
    required this.tag,
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}

// ==========================================
// 2. REFERRAL CODE & LINK SECTION WIDGET
// ==========================================
class _ReferralCodeAndLinkSection extends StatelessWidget {
  final String referralCode;
  final String referralLink;
  final bool isDark;

  const _ReferralCodeAndLinkSection({
    required this.referralCode,
    required this.referralLink,
    required this.isDark,
  });

  void _copyToClipboard(BuildContext context, String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Text(
              '$label copied to clipboard!',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: AppColors.primaryBrown,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- A. REFERRAL CODE CARD ---
        Row(
          children: [
            Container(
              width: 4,
              height: 18,
              decoration: BoxDecoration(
                color: AppColors.primaryBrown,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Your Referral Code',
              style: AppTextStyles.sectionHeading(
                color: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : AppColors.cardBackground,
            borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.border,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBrown.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.monetization_on_rounded,
                      color: AppColors.primaryBrown,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'REFERRAL CODE',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          referralCode,
                          style: GoogleFonts.inter(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.5,
                            color: isDark ? AppColors.darkPrimary : AppColors.deepBrown,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Material(
                    color: isDark
                        ? AppColors.darkPrimary.withValues(alpha: 0.2)
                        : AppColors.beigeSurface,
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      onTap: () => _copyToClipboard(context, referralCode, 'Referral code'),
                      borderRadius: BorderRadius.circular(10),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.copy_rounded,
                              size: 16,
                              color: isDark ? AppColors.darkPrimary : AppColors.primaryBrown,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Copy',
                              style: AppTextStyles.buttonText(
                                color: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
                              ).copyWith(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'You get ₹20 and your friend gets ₹10 once they complete their 1st shopping order!',
                style: AppTextStyles.caption(
                  color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // --- B. REFERRAL LINK CARD ---
        Row(
          children: [
            Container(
              width: 4,
              height: 18,
              decoration: BoxDecoration(
                color: AppColors.primaryBrown,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Your Referral Link',
              style: AppTextStyles.sectionHeading(
                color: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : AppColors.cardBackground,
            borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.border,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                Icons.link_rounded,
                color: isDark ? AppColors.darkPrimary : AppColors.primaryBrown,
                size: 22,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  referralLink,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Material(
                color: isDark
                    ? AppColors.darkPrimary.withValues(alpha: 0.2)
                    : AppColors.beigeSurface,
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  onTap: () => _copyToClipboard(context, referralLink, 'Referral link'),
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.copy_rounded,
                          size: 16,
                          color: isDark ? AppColors.darkPrimary : AppColors.primaryBrown,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Copy',
                          style: AppTextStyles.buttonText(
                            color: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
                          ).copyWith(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ==========================================
// 3. INVITE FRIENDS BUTTON
// ==========================================
class _InviteFriendsButton extends StatelessWidget {
  final String referralCode;
  final String referralLink;

  const _InviteFriendsButton({
    required this.referralCode,
    required this.referralLink,
  });

  void _shareViaWhatsApp(BuildContext context) {
    final shareText =
        'Hey! Join KashIQ with my referral code $referralCode to get ₹10 bonus on your 1st shopping order + earn guaranteed cashback on Flipkart, Amazon, Myntra & 1,500+ stores!\n\nUse Code: $referralCode\nTap to join: $referralLink\nOr visit: https://kashiq.app/refer/$referralCode';
    Clipboard.setData(ClipboardData(text: shareText));

    // Open native system share dialog (WhatsApp, Telegram, SMS, etc.)
    SharePlus.instance.share(ShareParams(text: shareText));


    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.share_rounded, color: Colors.white, size: 20),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Referral message copied! Open WhatsApp to share.',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.primaryBrown,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        onPressed: () => _shareViaWhatsApp(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBrown,
          foregroundColor: AppColors.cardBackground,
          elevation: 2,
          shadowColor: AppColors.primaryBrown.withValues(alpha: 0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.chat_bubble_outline_rounded,
              size: 20,
              color: AppColors.cardBackground,
            ),
            const SizedBox(width: 10),
            Text(
              'Invite Friends via WhatsApp',
              style: AppTextStyles.buttonText(
                color: AppColors.cardBackground,
              ).copyWith(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 4. HOW IT WORKS SECTION
// ==========================================
class _HowItWorksSection extends StatelessWidget {
  final String referralCode;
  final bool isDark;

  const _HowItWorksSection({
    required this.referralCode,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 18,
              decoration: BoxDecoration(
                color: AppColors.primaryBrown,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'How Refer & Earn Works',
              style: AppTextStyles.sectionHeading(
                color: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        _buildStepCard(
          stepNumber: '1',
          title: 'Invite your friends',
          description: 'Share your referral code $referralCode or link with friends via WhatsApp.',
        ),
        const SizedBox(height: 10),
        _buildStepCard(
          stepNumber: '2',
          title: 'Friend completes 1st shopping order',
          description: 'Your friend signs up using your code and completes their very first shopping order on any store.',
        ),
        const SizedBox(height: 10),
        _buildStepCard(
          stepNumber: '3',
          title: 'You get ₹20, Friend gets ₹10!',
          description: 'Once their 1st shopping order is tracked, ₹20 is credited to your wallet (User A) and ₹10 to your friend (User B)!',
        ),
      ],
    );
  }

  Widget _buildStepCard({
    required String stepNumber,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.border,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkPrimary.withValues(alpha: 0.2)
                  : AppColors.beigeSurface,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                stepNumber,
                style: GoogleFonts.inter(
                  color: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.cardTitle(
                    color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: AppTextStyles.body(
                    color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                  ).copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// 5. REFERRAL NETWORK & PURCHASE TRACKING SECTION
// ==========================================
class _ReferralNetworkTrackingSection extends StatelessWidget {
  final int totalReferred;
  final int purchasedUsersCount;
  final int pendingPurchaseCount;
  final double referralEarnings;
  final List<Map<String, dynamic>> referredUsers;
  final bool isLoading;
  final bool isDark;
  final VoidCallback onRefresh;

  const _ReferralNetworkTrackingSection({
    required this.totalReferred,
    required this.purchasedUsersCount,
    required this.pendingPurchaseCount,
    required this.referralEarnings,
    required this.referredUsers,
    required this.isLoading,
    required this.isDark,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final double purchaseRatio = totalReferred > 0
        ? (purchasedUsersCount / totalReferred).clamp(0.0, 1.0)
        : 0.0;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.border,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title Row with Live Indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 18,
                    decoration: BoxDecoration(
                      color: AppColors.primaryBrown,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Your Referral Network',
                    style: AppTextStyles.sectionHeading(
                      color: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF10B981).withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFF10B981),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Live Tracking',
                      style: GoogleFonts.inter(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF10B981),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // 3 Metric Cards Row
          Row(
            children: [
              // Card 1: Total Referred
              Expanded(
                child: _buildMetricTile(
                  icon: Icons.people_alt_rounded,
                  iconColor: const Color(0xFF3B82F6),
                  iconBg: const Color(0xFF3B82F6).withValues(alpha: 0.12),
                  title: 'Total Referred',
                  value: isLoading ? '...' : '$totalReferred',
                  subtext: 'Friends Joined',
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 8),

              // Card 2: Purchased Product
              Expanded(
                child: _buildMetricTile(
                  icon: Icons.shopping_bag_rounded,
                  iconColor: const Color(0xFF10B981),
                  iconBg: const Color(0xFF10B981).withValues(alpha: 0.12),
                  title: 'Purchased Order',
                  value: isLoading ? '...' : '$purchasedUsersCount',
                  subtext: '₹20 Bonus Paid',
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 8),

              // Card 3: Referral Earnings
              Expanded(
                child: _buildMetricTile(
                  icon: Icons.account_balance_wallet_rounded,
                  iconColor: const Color(0xFFD97706),
                  iconBg: const Color(0xFFD97706).withValues(alpha: 0.12),
                  title: 'Total Earned',
                  value: isLoading ? '...' : '₹${referralEarnings.toStringAsFixed(0)}',
                  subtext: 'Lifetime Cash',
                  isDark: isDark,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Conversion Summary / Progress Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkSurface
                  : AppColors.beigeSurface.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.border,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Purchase Conversion',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
                      ),
                    ),
                    Text(
                      totalReferred > 0
                          ? '$purchasedUsersCount of $totalReferred bought a product'
                          : '0 friends joined yet',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: totalReferred > 0 && purchasedUsersCount > 0
                            ? const Color(0xFF10B981)
                            : (isDark ? AppColors.darkTextSecondary : AppColors.textMuted),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: purchaseRatio,
                    minHeight: 6,
                    backgroundColor: isDark
                        ? AppColors.darkBorder
                        : AppColors.primaryBrown.withValues(alpha: 0.15),
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
                  ),
                ),
                if (pendingPurchaseCount > 0) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.info_outline_rounded,
                        size: 13,
                        color: Color(0xFFD97706),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          '$pendingPurchaseCount friend(s) haven\'t purchased yet. You earn ₹20 on their 1st shopping order!',
                          style: GoogleFonts.inter(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w500,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          // Referred Friends List Preview
          if (referredUsers.isNotEmpty) ...[
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'RECENT REFERRED FRIENDS',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                  ),
                ),
                Text(
                  '${referredUsers.length} total',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Show up to 4 recent friends
            ...referredUsers.take(4).map((user) {
              final name = user['name'] as String? ?? 'Friend';
              final phone = user['phoneNumber'] as String? ?? '';
              final hasShopped = user['hasShopped'] == true;

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : const Color(0xFFFAFAFA),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.border.withValues(alpha: 0.7),
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: hasShopped
                          ? const Color(0xFF10B981).withValues(alpha: 0.15)
                          : (isDark
                              ? AppColors.darkPrimary.withValues(alpha: 0.2)
                              : AppColors.beigeSurface),
                      child: Text(
                        name.isNotEmpty ? name[0].toUpperCase() : 'U',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          color: hasShopped
                              ? const Color(0xFF10B981)
                              : (isDark ? AppColors.darkPrimary : AppColors.deepBrown),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                            ),
                          ),
                          if (phone.isNotEmpty)
                            Text(
                              phone,
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                              ),
                            ),
                        ],
                      ),
                    ),
                    // Purchase status badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: hasShopped
                            ? const Color(0xFF10B981).withValues(alpha: 0.12)
                            : const Color(0xFFF59E0B).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: hasShopped
                              ? const Color(0xFF10B981).withValues(alpha: 0.3)
                              : const Color(0xFFF59E0B).withValues(alpha: 0.3),
                          width: 0.8,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            hasShopped ? Icons.check_circle_rounded : Icons.hourglass_top_rounded,
                            size: 12,
                            color: hasShopped ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            hasShopped ? 'Purchased (+₹20)' : 'Pending Order',
                            style: GoogleFonts.inter(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              color: hasShopped ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ] else if (!isLoading) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.beigeSurface.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.group_add_rounded,
                    size: 20,
                    color: AppColors.primaryBrown,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'No friends referred yet. Share your code above and earn ₹20 when they buy their 1st product!',
                      style: GoogleFonts.inter(
                        fontSize: 11.5,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 8),

          // View Full Referrals Screen Button
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed(MyReferralsScreen.routeName);
              },
              style: TextButton.styleFrom(
                foregroundColor: isDark ? AppColors.darkPrimary : AppColors.primaryBrown,
                padding: const EdgeInsets.symmetric(vertical: 8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'View Full Referral History & Earnings',
                    style: GoogleFonts.inter(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_forward_rounded, size: 14),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricTile({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String value,
    required String subtext,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.beigeSurface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: iconBg,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 15, color: iconColor),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
            ),
          ),
          Text(
            subtext,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              fontSize: 9.5,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
