import 'package:flutter_test/flutter_test.dart';
import 'package:cashback_reward_app/models/best_deals_page_models.dart';

void main() {
  group('Deals You May Like Navigation & Data Tests', () {
    test('Fallback contains 4 curated recommendation pills', () {
      final pills = BestDealsPageModel.fallback.recommendationPills;
      expect(pills.length, 4);

      expect(pills[0].title, 'Running Shoes');
      expect(pills[1].title, 'Protein Supplements');
      expect(pills[2].title, 'Smart Bands');
      expect(pills[3].title, 'Travel Backpacks');
    });

    test('Recommendation pill icons are properly mapped', () {
      final pills = BestDealsPageModel.fallback.recommendationPills;
      for (final pill in pills) {
        expect(pill.icon, isNotNull);
        expect(pill.subtitle, isNotEmpty);
      }
    });
  });
}
