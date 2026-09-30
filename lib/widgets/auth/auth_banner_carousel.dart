import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// Top banner used at the top of Login and Sign Up screens.
class AuthBannerCarousel extends StatelessWidget {
  final double height;
  final bool isDark;

  const AuthBannerCarousel({
    super.key,
    this.height = 250.0,
    required this.isDark,
  });

  static const String _lightBanner = 'assets/banners/login_hero_violet.jpg';
  static const String _darkBanner = 'assets/banners/login_hero_dark.jpg';

  String get _bannerAsset => isDark ? _darkBanner : _lightBanner;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBackground : AppColors.mainBackground,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      child: Image.asset(
        _bannerAsset,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          color: isDark ? AppColors.darkSurface : AppColors.surfaceSubtle,
          child: Center(
            child: Icon(
              Icons.card_giftcard_rounded,
              size: 44,
              color: isDark ? AppColors.darkPrimary : AppColors.accentBlue,
            ),
          ),
        ),
      ),
    );
  }
}
