import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'models/brand_model.dart';
import 'models/category_shopping_models.dart';
import 'models/product.dart';
import 'providers/category_provider.dart';
import 'providers/home_provider.dart';
import 'providers/product_provider.dart';
import 'providers/search_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/user_provider.dart';
import 'screens/account_settings_screen.dart';
import 'screens/all_categories_screen.dart';
import 'screens/all_coupons_screen.dart';
import 'screens/all_stores_screen.dart';
import 'screens/best_deals_screen.dart';
import 'screens/call_us_screen.dart';
import 'screens/categories_screen.dart';
import 'screens/category_detail_screen.dart';
import 'screens/store_detail_screen.dart';
import 'screens/subcategory_detail_screen.dart';
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
import 'screens/product_comparison_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/refer_earn_screen.dart';
import 'screens/review_us_screen.dart';
import 'screens/search_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/smart_coupon_optimizer_screen.dart';
import 'screens/smart_savings_engine_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/withdraw_screen.dart';
import 'screens/your_queries_screen.dart';

// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';

import 'services/deep_link_service.dart';
import 'theme/app_theme.dart';

final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize Deep Linking engine
  DeepLinkService().init(appNavigatorKey);

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
        ChangeNotifierProvider<HomeProvider>(
          create: (_) => HomeProvider(),
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
            navigatorKey: appNavigatorKey,
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
              AllCouponsScreen.routeName: (_) => const AllCouponsScreen(),
              AllStoresScreen.routeName: (_) => const AllStoresScreen(),
              StoreDetailScreen.routeName: (_) => const StoreDetailScreen(),
              ProfileScreen.routeName: (_) => const ProfileScreen(),
              AccountSettingsScreen.routeName: (_) => const AccountSettingsScreen(),
              GetHelpScreen.routeName: (_) => const GetHelpScreen(),
              PrivacyPolicyScreen.routeName: (_) => const PrivacyPolicyScreen(),
              SearchScreen.routeName: (_) => const SearchScreen(),
              ProductComparisonScreen.routeName: (_) => const ProductComparisonScreen(),
              OnboardingScreen.routeName: (_) => const OnboardingScreen(),
              ReferEarnScreen.routeName: (_) => const ReferEarnScreen(),
              MyEarningsScreen.routeName: (_) => const MyEarningsScreen(),
              WithdrawScreen.routeName: (_) => const WithdrawScreen(),
              BestDealsScreen.routeName: (_) => const BestDealsScreen(),
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
              SignupScreen.routeName: (_) => const SignupScreen(),
              SmartCouponOptimizerScreen.routeName: (_) => const SmartCouponOptimizerScreen(),
              SmartSavingsEngineScreen.routeName: (_) => const SmartSavingsEngineScreen(),
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
              if (settings.name == CategoryDetailScreen.routeName) {
                final args = settings.arguments;
                if (args is Map<String, dynamic>) {
                  return MaterialPageRoute(
                    builder: (_) => CategoryDetailScreen(
                      categoryId: args['categoryId'] as String? ?? 'fashion',
                      categoryTitle: args['categoryTitle'] as String?,
                    ),
                    settings: settings,
                  );
                } else if (args is String) {
                  return MaterialPageRoute(
                    builder: (_) => CategoryDetailScreen(categoryId: args),
                    settings: settings,
                  );
                }
                return MaterialPageRoute(
                  builder: (_) => const CategoryDetailScreen(categoryId: 'fashion'),
                  settings: settings,
                );
              }
              if (settings.name == SubcategoryDetailScreen.routeName) {
                final args = settings.arguments;
                if (args is Map<String, dynamic>) {
                  return MaterialPageRoute(
                    builder: (_) => SubcategoryDetailScreen(
                      categoryId: args['categoryId'] as String? ?? 'fashion',
                      subcategoryId: args['subcategoryId'] as String? ?? 'clothing',
                      subcategoryTitle: args['subcategoryTitle'] as String? ?? 'Clothing',
                      parentCategoryTitle: args['parentCategoryTitle'] as String?,
                    ),
                    settings: settings,
                  );
                }
              }
              if (settings.name == StoreDetailScreen.routeName) {
                final args = settings.arguments;
                if (args is CategoryStoreModel) {
                  return MaterialPageRoute(
                    builder: (_) => StoreDetailScreen(store: args),
                    settings: settings,
                  );
                } else if (args is BrandModel) {
                  return MaterialPageRoute(
                    builder: (_) => StoreDetailScreen(brand: args),
                    settings: settings,
                  );
                }
                return MaterialPageRoute(
                  builder: (_) => const StoreDetailScreen(),
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
