import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cashback_reward_app/screens/auth/onboarding_screen.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    home: child,
  );
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('OnboardingScreen renders exactly 3 pages and transitions smoothly', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 850));

    await tester.pumpWidget(_wrap(const OnboardingScreen()));
    await tester.pumpAndSettle();

    // PAGE 1: BEST DEALS
    expect(find.text('Find the Best Deals, Every Time'), findsOneWidget);
    expect(find.text('Discover great prices, discounts, cashback and offers in one place.'), findsOneWidget);
    expect(find.text('Best Deal'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);
    expect(find.text('Skip'), findsOneWidget);

    // Tap Next -> PAGE 2: STACK YOUR SAVINGS
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    expect(find.text('Stack Your Savings'), findsOneWidget);
    expect(find.text('Combine store discounts, coupon codes and real cashback to get the lowest effective price on your purchase.'), findsOneWidget);
    expect(find.text('Stacked Savings'), findsOneWidget);
    expect(find.text('Back'), findsOneWidget);

    // Tap Next -> PAGE 3: SHOP & EARN
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    expect(find.text('Shop More. Save More. Earn Cashback.'), findsOneWidget);
    expect(find.text('Shop through KashIQ, unlock eligible offers and earn cashback on qualifying purchases.'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
    // Skip is hidden on the last page
    expect(find.text('Skip'), findsNothing);

    // Tap Back -> Returns to Page 2
    await tester.tap(find.text('Back'));
    await tester.pumpAndSettle();
    expect(find.text('Stack Your Savings'), findsOneWidget);
  });
}
