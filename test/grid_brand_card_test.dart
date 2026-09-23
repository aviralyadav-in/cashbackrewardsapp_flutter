import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cashback_reward_app/models/brand_model.dart';
import 'package:cashback_reward_app/widgets/home/grid_brand_card.dart';

void main() {
  testWidgets('GridBrandCard renders ribbon, brand name, rate block, and CTA correctly', (tester) async {
    const brand = BrandModel(
      name: 'Amazon',
      logoUrl: '',
      bannerUrl: '',
      cashbackPercentage: 'Up to 8% Rewards',
      category: 'Electronics',
      offerText: 'Up to 50% Off',
      websiteUrl: 'https://amazon.in',
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 144,
            height: 184,
            child: GridBrandCard(
              brand: brand,
              isDark: false,
            ),
          ),
        ),
      ),
    );

    expect(find.text('UP TO 50% OFF'), findsOneWidget);
    expect(find.text('Amazon'), findsOneWidget);
    expect(find.text('UP TO'), findsOneWidget);
    expect(find.text('8%'), findsOneWidget);
    expect(find.text('REWARDS'), findsOneWidget);
    expect(find.text('EXPLORE REWARDS'), findsOneWidget);
  });
}
