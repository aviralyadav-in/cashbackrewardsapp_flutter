import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'models/product.dart';
import 'providers/category_provider.dart';
import 'providers/product_provider.dart';
import 'providers/search_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/user_provider.dart';
import 'screens/account_settings_screen.dart';
import 'screens/all_categories_screen.dart';
import 'screens/call_us_screen.dart';
import 'screens/categories_screen.dart';
import 'screens/get_help_screen.dart';
import 'screens/home_screen.dart';
import 'screens/know_why_screen.dart';
import 'screens/login_screen.dart';
import 'screens/missing_tickets_screen.dart';
import 'screens/my_earnings_screen.dart';
import 'screens/my_order_details_screen.dart';
import 'screens/my_referrals_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/payments_history_screen.dart';
import 'screens/payments_screen.dart';
import 'screens/privacy_policy_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/refer_earn_screen.dart';
import 'screens/review_us_screen.dart';
import 'screens/search_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/withdraw_screen.dart';
import 'screens/your_queries_screen.dart';

// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';

import 'theme/app_theme.dart';

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
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.isDarkMode
                ? ThemeMode.dark
                : ThemeMode.light,
            home: SplashScreen(),
            routes: {
              HomeScreen.routeName: (_) => const HomeScreen(),
              CategoriesScreen.routeName: (_) => const CategoriesScreen(),
              AllCategoriesScreen.routeName: (_) => const AllCategoriesScreen(),
              ProfileScreen.routeName: (_) => const ProfileScreen(),
              AccountSettingsScreen.routeName: (_) => const AccountSettingsScreen(),
              GetHelpScreen.routeName: (_) => const GetHelpScreen(),
              PrivacyPolicyScreen.routeName: (_) => const PrivacyPolicyScreen(),
              SearchScreen.routeName: (_) => const SearchScreen(),
              OnboardingScreen.routeName: (_) => const OnboardingScreen(),
              ReferEarnScreen.routeName: (_) => const ReferEarnScreen(),
              MyEarningsScreen.routeName: (_) => const MyEarningsScreen(),
              WithdrawScreen.routeName: (_) => const WithdrawScreen(),
              KnowWhyScreen.routeName: (_) => const KnowWhyScreen(),
              MyOrderDetailsScreen.routeName: (_) => const MyOrderDetailsScreen(),
              MissingTicketsScreen.routeName: (_) => const MissingTicketsScreen(),
              PaymentsScreen.routeName: (_) => const PaymentsScreen(),
              PaymentsHistoryScreen.routeName: (_) => const PaymentsHistoryScreen(),
              YourQueriesScreen.routeName: (_) => const YourQueriesScreen(),
              MyReferralsScreen.routeName: (_) => const MyReferralsScreen(),
              CallUsScreen.routeName: (_) => const CallUsScreen(),
              ReviewUsScreen.routeName: (_) => const ReviewUsScreen(),
              NotificationsScreen.routeName: (_) => const NotificationsScreen(),
              LoginScreen.routeName: (_) => const LoginScreen(),
            },
            onGenerateRoute: (settings) {
              if (settings.name == ProductDetailScreen.routeName) {
                final args = settings.arguments;
                if (args is Product) {
                  return MaterialPageRoute(
                    builder: (_) => ProductDetailScreen(product: args),
                    settings: settings,
                  );
                }
                return MaterialPageRoute(
                  builder: (_) => const ProductDetailScreen(),
                  settings: settings,
                );
              }
              return null;
            },
          );
        },
      ),
    );
  }
}
