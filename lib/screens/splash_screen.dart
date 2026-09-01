import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';
import 'login_screen.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // ignore: unused_field
  late Animation<double> _logoAnimation;
  late Animation<double> _textFadeAnimation;
  late Animation<Offset> _textSlideAnimation;
  late Animation<double> _subtitleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    // // Logo animation
    // _logoAnimation = CurvedAnimation(
    //   parent: _controller,
    //   curve: const Interval(
    //     0.0,
    //     0.5,
    //     curve: Curves.elasticOut,
    //   ),
    // );

    // Text fade animation
    _textFadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        0.35,
        0.75,
        curve: Curves.easeIn,
      ),
    );

    // Text slide animation
    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.8),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.35,
          0.75,
          curve: Curves.easeOut,
        ),
      ),
    );

    // Subtitle animation
    _subtitleAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        0.65,
        1.0,
        curve: Curves.easeIn,
      ),
    );

    _controller.forward();

    // Check user authentication state after 3-second splash animation
    Timer(const Duration(seconds: 3), () async {
      if (!mounted) return;

      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final authService = AuthService();
      final storageService = AppStorageService();

      // Ensure profile is loaded from cache if not yet loaded in state
      if (userProvider.user == null) {
        await userProvider.loadUserProfile();
      }

      final cachedProfile = await storageService.getUserProfileCache();
      final firebaseUser = authService.currentUser;

      // User is logged in if UserProvider has user, local cache has profile, or Firebase User exists
      final bool isLoggedIn = userProvider.user != null ||
          (cachedProfile != null && cachedProfile.isNotEmpty) ||
          firebaseUser != null;

      Widget destinationScreen;

      if (isLoggedIn) {
        destinationScreen = const HomeScreen();
      } else {
        final hasSeenOnboarding = await storageService.getHasSeenOnboarding();
        if (!hasSeenOnboarding) {
          destinationScreen = const OnboardingScreen();
        } else {
          destinationScreen = const LoginScreen();
        }
      }

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 800),
          pageBuilder: (context, animation, secondaryAnimation) {
            return destinationScreen;
          },
          transitionsBuilder:
              (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              ),
              child: child,
            );
          },
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.mainBackground,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkBackground : AppColors.mainBackground,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo Icon
              // Container(
              //   width: 80,
              //   height: 80,
              //   decoration: BoxDecoration(
              //     color: isDark ? AppColors.primaryBrown.withValues(alpha: 0.3) : AppColors.beigeSurface,
              //     shape: BoxShape.circle,
              //     border: Border.all(
              //       color: isDark ? AppColors.darkBorder : AppColors.border,
              //       width: 1.5,
              //     ),
              //   ),
              //   child: Center(
              //     child: Icon(
              //       Icons.account_balance_wallet_rounded,
              //       size: 42,
              //       color: isDark ? AppColors.darkTextPrimary : AppColors.primaryBrown,
              //     ),
              //   ),
              // ),

              const SizedBox(height: 24),

              // APP NAME
              FadeTransition(
                opacity: _textFadeAnimation,
                child: SlideTransition(
                  position: _textSlideAnimation,
                  child: Text(
                    'CashKaro',
                    style: GoogleFonts.fraunces(
                      fontSize: 34,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // SUBTITLE
              FadeTransition(
                opacity: _subtitleAnimation,
                child: Text(
                  "#1 India's Best Cashback & Rewards App",
                  style: GoogleFonts.fraunces(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                    letterSpacing: 1.2,
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
