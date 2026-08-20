// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'login_screen.dart';


// class SplashScreen extends StatefulWidget {
//     const SplashScreen({super.key});
//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     Timer(Duration(seconds: 3), () {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => LoginScreen()),
//       );
//     });
//   }

//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         color: Colors.blue,
//         child: Center(
//           child: Text(
//             'Cashback & Rewards',
//             style: TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }








import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';
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

    // Logo animation
    _logoAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        0.0,
        0.5,
        curve: Curves.elasticOut,
      ),
    );

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
      backgroundColor: isDark ? const Color(0xFF0D0D0D) : const Color(0xFFFFFFFF),

      body: Container(
        width: double.infinity,
        height: double.infinity,

        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? const [
                    Color(0xFF0D0D0D),
                    Color(0xFF151D2A),
                    Color(0xFF0D0D0D),
                  ]
                : const [
                    Color(0xFFFFFFFF),
                    Color(0xFFF0F7FF),
                    Color(0xFFFFFFFF),
                  ],
          ),
        ),

        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // =========================
              // CLEAN SHARP LOGO (NO GLOW)
              // =========================

              ScaleTransition(
                scale: _logoAnimation,

                child: Container(
                  width: 130,
                  height: 130,

                  decoration: BoxDecoration(
                    shape: BoxShape.circle,

                    color: isDark ? const Color(0xFF151D2A) : Colors.white,

                    border: Border.all(
                      color: const Color(0xFF1E90FF),
                      width: 2,
                    ),
                  ),

                  child: const Center(
                    child: Icon(
                      Icons.card_giftcard,
                      size: 70,
                      color: Color(0xFF1E90FF),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 35),

              // =========================
              // APP NAME
              // =========================

              FadeTransition(
                opacity: _textFadeAnimation,

                child: SlideTransition(
                  position: _textSlideAnimation,

                  child: Text(
                    'CashKaro',

                    style: TextStyle( 
                      fontFamily: 'HandwrittenItalic',
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF1F2937),
                      letterSpacing: 3.0,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // =========================
              // SUBTITLE
              // =========================

              FadeTransition(
                opacity: _subtitleAnimation,

                child: const Text(
                  'India\'s #1 Cashback App',

                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1E90FF),
                    letterSpacing: 2.5,
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

