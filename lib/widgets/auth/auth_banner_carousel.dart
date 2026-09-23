import 'dart:async';
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// Auto-sliding banner carousel used at the top of Login and Sign Up screens.
///
/// Features:
/// - 100% crisp, unblurred, high-definition banner images (NO blur, NO gradient wash).
/// - Smooth 3.5s auto-scroll across 4 high-definition shopping & cashback banners.
/// - Rounded bottom corners for a modern, refined look.
/// - Modern floating pill indicators.
/// - Memory-safe with proper timer cancellation in dispose.
class AuthBannerCarousel extends StatefulWidget {
  final double height;
  final bool isDark;

  const AuthBannerCarousel({
    super.key,
    this.height = 250.0,
    required this.isDark,
  });

  @override
  State<AuthBannerCarousel> createState() => _AuthBannerCarouselState();
}

class _AuthBannerCarouselState extends State<AuthBannerCarousel> {
  late final PageController _pageController;
  Timer? _autoSlideTimer;
  int _currentPage = 0;

  static const List<String> _bannerAssets = [
    'assets/banners/login_hero.jpg',
    'assets/banners/shopsy_shopping_3d.jpg',
    'assets/banners/reliance_tech_3d.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _autoSlideTimer = Timer.periodic(const Duration(milliseconds: 3500), (timer) {
      if (!mounted || !_pageController.hasClients) return;
      final nextPage = (_currentPage + 1) % _bannerAssets.length;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 650),
        curve: Curves.easeInOutCubic,
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
    return Container(
      height: widget.height,
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Sliding Banners - 100% Crisp, Clear, ZERO Blur, ZERO Gradient Wash
          PageView.builder(
            controller: _pageController,
            itemCount: _bannerAssets.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return Image.asset(
                _bannerAssets[index],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: AppColors.primaryBrown.withValues(alpha: 0.2),
                ),
              );
            },
          ),

          // 2. Modern Animated Floating Pill Indicators
          Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(_bannerAssets.length, (index) {
                    final isActive = _currentPage == index;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      height: 5,
                      width: isActive ? 18 : 6,
                      decoration: BoxDecoration(
                        color: isActive ? Colors.white : Colors.white54,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
