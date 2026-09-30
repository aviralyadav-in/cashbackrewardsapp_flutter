import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../providers/user_provider.dart';
import '../../services/auth_service.dart';
import '../../services/deep_link_service.dart';
import '../../services/storage_service.dart';
import '../../theme/app_theme.dart';
import '../home/home_screen.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _textController;
  late final Animation<double> _textFade;
  late final Animation<Offset> _textSlide;

  @override
  void initState() {
    super.initState();

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _textFade = CurvedAnimation(
      parent: _textController,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
    );

    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic),
    ));

    _textController.forward();
    _prepareAndNavigate();
  }

  Future<void> _prepareAndNavigate() async {
    final startTime = DateTime.now();

    // Warm up backend connection in background during splash screen
    unawaited(AuthService.getWorkingBaseUrl());

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final storageService = AppStorageService();

    if (userProvider.user == null) {
      await userProvider.loadCachedProfile();
    }

    final storedUserId  = await storageService.getUserId();
    final cachedProfile = await storageService.getUserProfileCache();

    final bool isLoggedIn =
        userProvider.isAuthenticated ||
        (storedUserId != null && storedUserId.isNotEmpty) ||
        (cachedProfile != null && cachedProfile.isNotEmpty);

    final Widget destination =
        isLoggedIn ? const HomeScreen() : const OnboardingScreen();

    final elapsed = DateTime.now().difference(startTime).inMilliseconds;
    const minDuration = 4000;
    if (elapsed < minDuration) {
      await Future.delayed(Duration(milliseconds: minDuration - elapsed));
    }

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) => destination,
        transitionsBuilder: (context, anim, secondaryAnimation, child) => FadeTransition(
          opacity: CurvedAnimation(parent: anim, curve: Curves.easeInOut),
          child: child,
        ),
      ),
    );

    // After the destination screen is in place, handle any pending cold-start
    // deep link (e.g. product share link clicked when app was closed).
    final pendingUri = DeepLinkService().consumePendingUri();
    if (pendingUri != null) {
      debugPrint('[SPLASH] Consuming pending cold-start deep link: $pendingUri');
      // Wait one frame so the destination screen is fully mounted
      WidgetsBinding.instance.addPostFrameCallback((_) {
        DeepLinkService().handleUri(pendingUri);
      });
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.mainBackground,
      body: Center(
        child: FadeTransition(
            opacity: _textFade,
            child: SlideTransition(
              position: _textSlide,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'KashIQ',
                    style: GoogleFonts.inter(
                      fontSize: 48,
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.deepBrown,
                      letterSpacing: -0.8,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          offset: const Offset(0, 2),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "#1 India's Best Cashback & Rewards App",
                    style: GoogleFonts.inter(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.textPrimary,
                      letterSpacing: 0.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
  }
}
