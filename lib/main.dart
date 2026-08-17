import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'providers/category_provider.dart';
import 'providers/product_provider.dart';
import 'providers/search_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/user_provider.dart';
import 'screens/account_settings_screen.dart';
import 'screens/categories_screen.dart';
import 'screens/get_help_screen.dart';
import 'screens/home_screen.dart';
// import 'screens/login_screen.dart';
import 'screens/missing_tickets_screen.dart';
import 'screens/my_earnings_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/privacy_policy_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/refer_earn_screen.dart';
import 'screens/search_screen.dart';
import 'screens/splash_screen.dart';

// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const CashbackRewardApp());
}

class CashbackRewardApp extends StatelessWidget {
  const CashbackRewardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ProductProvider>(
          create: (_) => ProductProvider(),
        ),
        ChangeNotifierProvider<CategoryProvider>(
          create: (_) => CategoryProvider(),
        ),

        ChangeNotifierProvider<SearchProvider>(create: (_) => SearchProvider()),

        ChangeNotifierProvider<UserProvider>(
          create: (_) => UserProvider(),
        ),

        ChangeNotifierProvider<ThemeProvider>(
          create: (_) {
            final provider = ThemeProvider();
            provider.initialize();
            return provider;
          },
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Cashback & Rewards App',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              brightness: Brightness.light,
              scaffoldBackgroundColor: const Color(0xFFF5F5F7),
              colorScheme: const ColorScheme.light(
                primary: Colors.redAccent,
                secondary: Colors.red,
                surface: Colors.white,
                onSurface: Colors.black87,
                onPrimary: Colors.white,
              ),
              useMaterial3: true,
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                elevation: 0,
                centerTitle: true,
                titleTextStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                iconTheme: IconThemeData(color: Colors.black),
              ),
              cardTheme: CardThemeData(
                color: Colors.white,
                elevation: 2,
                shadowColor: Colors.black.withValues(alpha: 0.08),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(
                    color: Color(0xFFE5E5EA),
                  ),
                ),
              ),
              inputDecorationTheme: InputDecorationTheme(
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                labelStyle: TextStyle(color: Colors.grey.shade700),
                hintStyle: TextStyle(color: Colors.grey.shade500),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color(0xFFE5E5EA)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color(0xFFE5E5EA)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: Colors.redAccent,
                    width: 2,
                  ),
                ),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 4,
                  shadowColor: Colors.red.withValues(alpha: 0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              bottomNavigationBarTheme: BottomNavigationBarThemeData(
                backgroundColor: Colors.white,
                selectedItemColor: Colors.redAccent,
                unselectedItemColor: Colors.grey.shade600,
                elevation: 8,
              ),
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              scaffoldBackgroundColor: const Color(0xFF0D0D0D),
              colorScheme: const ColorScheme.dark(
                primary: Colors.redAccent,
                secondary: Colors.red,
                surface: Color(0xFF161618),
                onSurface: Colors.white,
                onPrimary: Colors.white,
              ),
              useMaterial3: true,
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                elevation: 0,
                centerTitle: true,
                titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                iconTheme: IconThemeData(color: Colors.white),
              ),
              cardTheme: CardThemeData(
                color: const Color(0xFF161618),
                elevation: 3,
                shadowColor: Colors.black.withValues(alpha: 0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: Color(0xFF2E2E2E),
                  ),
                ),
              ),
              inputDecorationTheme: InputDecorationTheme(
                filled: true,
                fillColor: const Color(0xFF161618),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                labelStyle: TextStyle(color: Colors.grey.shade400),
                hintStyle: TextStyle(color: Colors.grey.shade500),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color(0xFF2E2E2E)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color(0xFF2E2E2E)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: Colors.redAccent,
                    width: 2,
                  ),
                ),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 4,
                  shadowColor: Colors.red.withValues(alpha: 0.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              bottomNavigationBarTheme: BottomNavigationBarThemeData(
                backgroundColor: const Color(0xFF0D0D0D),
                selectedItemColor: Colors.redAccent,
                unselectedItemColor: Colors.grey.shade600,
                elevation: 8,
              ),
            ),
            themeMode: themeProvider.isDarkMode
                ? ThemeMode.dark
                : ThemeMode.light,
            home: SplashScreen(),
            routes: {
              HomeScreen.routeName: (_) => const HomeScreen(),
              CategoriesScreen.routeName: (_) => const CategoriesScreen(),
              ProfileScreen.routeName: (_) => const ProfileScreen(),
              AccountSettingsScreen.routeName: (_) => const AccountSettingsScreen(),
              GetHelpScreen.routeName: (_) => const GetHelpScreen(),
              PrivacyPolicyScreen.routeName: (_) => const PrivacyPolicyScreen(),
              SearchScreen.routeName: (_) => const SearchScreen(),
              OnboardingScreen.routeName: (_) => const OnboardingScreen(),
              ReferEarnScreen.routeName: (_) => const ReferEarnScreen(),
              MyEarningsScreen.routeName: (_) => const MyEarningsScreen(),
              MissingTicketsScreen.routeName: (_) => const MissingTicketsScreen(),
              NotificationsScreen.routeName: (_) => const NotificationsScreen(),
            },
          );
        },
      ),
    );
  }
}
