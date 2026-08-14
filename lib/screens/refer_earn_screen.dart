import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ReferEarnScreen extends StatefulWidget {
  static const String routeName = '/refer-earn';

  const ReferEarnScreen({super.key});

  @override
  State<ReferEarnScreen> createState() => _ReferEarnScreenState();
}

class _ReferEarnScreenState extends State<ReferEarnScreen> {
  static const String _referralLink = 'https://cashkaro.com/refer/CK89421';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0D0D0D) : const Color(0xFFF5F5F7),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF161618) : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black87,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isDark ? Colors.white : Colors.black87,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Refer & Earn',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. TOP PROMOTIONAL CAROUSEL (~25% SCREEN HEIGHT)
              const _PromotionalCarouselWidget(),

              const SizedBox(height: 24),

              // 2. YOUR REFERRAL LINK SECTION
              _ReferralLinkSection(
                referralLink: _referralLink,
                isDark: isDark,
              ),

              const SizedBox(height: 20),

              // 3. INVITE FRIENDS BUTTON
              _InviteFriendsButton(referralLink: _referralLink),

              const SizedBox(height: 28),

              // 4. HOW REFER & EARN WORKS SECTION
              _HowItWorksSection(isDark: isDark),

              const SizedBox(height: 32),
            ],
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
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [
            Colors.redAccent,
            Color(0xFFC62828),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.redAccent.withValues(alpha: 0.35),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
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
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  slide.tag,
                                  style: const TextStyle(
                                    color: Colors.redAccent,
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 0.4,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),

                              // White Title
                              Text(
                                slide.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  height: 1.2,
                                ),
                              ),
                              const SizedBox(height: 6),

                              // White Subtitle
                              Text(
                                slide.subtitle,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
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
                          width: 68,
                          height: 68,
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
                            size: 36,
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
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.4),
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
// 2. REFERRAL LINK SECTION WIDGET
// ==========================================
class _ReferralLinkSection extends StatelessWidget {
  final String referralLink;
  final bool isDark;

  const _ReferralLinkSection({
    required this.referralLink,
    required this.isDark,
  });

  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: referralLink));
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
            SizedBox(width: 10),
            Text(
              'Link copied!',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: Colors.redAccent,
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
        Row(
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
            Text(
              'Your Referral Link',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Rounded Container with Copy Button
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF161618) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? const Color(0xFF28282A) : const Color(0xFFE5E5EA),
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
              const Icon(
                Icons.link_rounded,
                color: Colors.redAccent,
                size: 22,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  referralLink,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.grey.shade300 : Colors.black87,
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Copy Button
              Material(
                color: Colors.redAccent.withValues(alpha: isDark ? 0.12 : 0.1),
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  onTap: () => _copyToClipboard(context),
                  borderRadius: BorderRadius.circular(10),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.copy_rounded,
                          size: 16,
                          color: Colors.redAccent,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Copy',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent,
                          ),
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
// 3. INVITE FRIENDS BUTTON (RED ACCENT THEMED)
// ==========================================
class _InviteFriendsButton extends StatelessWidget {
  final String referralLink;

  const _InviteFriendsButton({required this.referralLink});

  void _shareViaWhatsApp(BuildContext context) {
    final shareText =
        'Hey! Join CashKaro using my referral link and earn real cashback on all your online shopping: $referralLink';
    Clipboard.setData(ClipboardData(text: shareText));

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
        backgroundColor: Colors.redAccent,
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
      height: 52,
      child: ElevatedButton(
        onPressed: () => _shareViaWhatsApp(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.redAccent,
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: Colors.redAccent.withValues(alpha: 0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline_rounded,
              size: 22,
              color: Colors.white,
            ),
            SizedBox(width: 10),
            Text(
              'Invite Friends via WhatsApp',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.3,
              ),
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
  final bool isDark;

  const _HowItWorksSection({required this.isDark});

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
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'How Refer & Earn Works',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        _buildStepCard(
          stepNumber: '1',
          title: 'Invite your friends',
          description: 'Share your unique referral link via WhatsApp or Social Media.',
        ),
        const SizedBox(height: 10),
        _buildStepCard(
          stepNumber: '2',
          title: 'Friends shop online',
          description: 'Your friends shop via CashKaro at 1500+ top retailers.',
        ),
        const SizedBox(height: 10),
        _buildStepCard(
          stepNumber: '3',
          title: 'Earn 10% cashback for life!',
          description: 'You get 10% of their earned cashback credited directly to you, forever.',
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
        color: isDark ? const Color(0xFF161618) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF28282A) : const Color(0xFFE5E5EA),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.redAccent.withValues(alpha: isDark ? 0.12 : 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                stepNumber,
                style: const TextStyle(
                  color: Colors.redAccent,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
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
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
