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
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

    // Check Firebase authentication state and onboarding status after splash animation delay
    Timer(const Duration(seconds: 3), () async {
      if (!mounted) return;

      final authService = AuthService();
      final storageService = AppStorageService();

      Widget destinationScreen;

      // Reliable check for persisted Firebase user session
      User? user = authService.currentUser;
      if (user == null) {
        try {
          user = await authService.authStateChanges
              .first
              .timeout(const Duration(seconds: 2), onTimeout: () => authService.currentUser);
        } catch (_) {
          user = authService.currentUser;
        }
      }

      if (user != null) {
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
    return Scaffold(
      backgroundColor: Colors.black,

      body: Container(
        width: double.infinity,
        height: double.infinity,

        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF000000),
              Color(0xFF180000),
              Color(0xFF000000),
            ],
          ),
        ),

        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // =========================
              // GLOWING RED LOGO
              // =========================

              ScaleTransition(
                scale: _logoAnimation,

                child: Container(
                  width: 130,
                  height: 130,

                  decoration: BoxDecoration(
                    shape: BoxShape.circle,

                    color: const Color(0xFF0D0D0D),

                    border: Border.all(
                      color: Colors.redAccent,
                      width: 2,
                    ),

                    boxShadow: [
                      // Outer red glow
                      BoxShadow(
                        color: Colors.red.withValues(alpha: 0.8),
                        blurRadius: 35,
                        spreadRadius: 8,
                      ),

                      // Inner glow
                      BoxShadow(
                        color: Colors.red.withValues(alpha: 0.4),
                        blurRadius: 60,
                        spreadRadius: 2,
                      ),
                    ],
                  ),

                  child: const Center(
                    child: Icon(
                      Icons.card_giftcard,
                      size: 70,
                      color: Colors.redAccent,
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

                  child: const Text(
                    'CashKaro',

                    style: TextStyle( 
                      fontFamily: 'HandwrittenItalic',
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.8,

                      shadows: [
                        Shadow(
                          color: Colors.red,
                          blurRadius: 15,
                        ),
                        Shadow(
                          color: Colors.redAccent,
                          blurRadius: 30,
                        ),
                      ],
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
                    color: Colors.redAccent,
                    letterSpacing: 2.5,

                    shadows: [
                      Shadow(
                        color: Colors.red,
                        blurRadius: 10,
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

