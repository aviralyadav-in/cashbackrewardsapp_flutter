import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cashback_reward_app/data/flash_deals_data.dart';
import 'package:cashback_reward_app/widgets/home/flash_deal_card.dart';
import 'package:cashback_reward_app/widgets/home/flash_deals_section.dart';

void main() {
  group('Flash Deals Visual & Data Tests', () {
    test('FlashDealsData contains deals with Daily Objects matching user screenshot', () {
      expect(FlashDealsData.flashDeals.length, greaterThanOrEqualTo(8));

      final dailyObjects = FlashDealsData.flashDeals.first;
      expect(dailyObjects.brandName, 'Daily Objects');
      expect(dailyObjects.offer, 'Flat 50% Off');
      expect(dailyObjects.minimumOrder, 'on Selected Orders');
      expect(dailyObjects.cashback, 'Upto ₹410 Cashback');
      expect(dailyObjects.cta, 'Grab Deal');
      expect(dailyObjects.productImage, isNotNull);
    });

    testWidgets('FlashDealCard displays brand, offer, min order, cashback and Grab Deal with pop-out',
        (WidgetTester tester) async {
      final deal = FlashDealsData.flashDeals.first; // Daily Objects

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlashDealCard(
              deal: deal,
              isDark: false,
            ),
          ),
        ),
      );

      // Offer & conditions
      expect(find.text('Flat 50% Off'), findsOneWidget);
      expect(find.text('on Selected Orders'), findsOneWidget);
      // Cashback
      expect(find.text('Upto ₹410 Cashback'), findsOneWidget);
      // CTA
      expect(find.text('Grab Deal'), findsOneWidget);
      // Stack with pop-out
      expect(find.byType(Stack), findsWidgets);
    });

    testWidgets('FlashDealsSection renders Flash Deals, live countdown, carousel, and View All',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: FlashDealsSection(isDark: false),
            ),
          ),
        ),
      );

      // Section title
      expect(find.text('Flash Deals'), findsOneWidget);

      // Countdown pill
      expect(find.textContaining('Ends in 23: 00: 25'), findsOneWidget);

      // Cards
      expect(find.byType(FlashDealCard), findsWidgets);

      // View All button on stage
      expect(find.text('View All'), findsOneWidget);

      // Advance 1 second to verify live ticker
      await tester.pump(const Duration(seconds: 1));
      expect(find.textContaining('Ends in 23: 00: 24'), findsOneWidget);
    });
  });
}
