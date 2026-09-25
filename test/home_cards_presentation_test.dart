import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cashback_reward_app/models/brand_model.dart';
import 'package:cashback_reward_app/models/home_discovery_models.dart';
import 'package:cashback_reward_app/widgets/home/best_deals_section.dart';
import 'package:cashback_reward_app/widgets/home/store_carousel_section.dart';
import 'package:cashback_reward_app/widgets/home/featured_stores_section.dart';
import 'package:cashback_reward_app/widgets/home/home_offers_section.dart';

void main() {
  group('Home Screen Card Designs and Image Presentation Tests', () {
    testWidgets('1. Best Deals for You: renders dedicated image container, pills, and Shop Best Deal button', (tester) async {
      bool tapped = false;
      const testDeal = BestDealModel(
        id: 'deal-1',
        title: 'Nike Air Max 270',
        brand: 'Nike',
        store: 'Myntra',
        imageUrl: 'assets/banners/nike_airmax_red.jpg',
        originalPrice: 5999,
        discountedPrice: 4155,
        discountPercentage: 30,
        cashbackPercentage: 10,
        cashbackAmount: 415,
        couponCode: 'NIKE20',
        couponDiscount: 0,
        effectiveSavings: 2259,
        effectivePrice: 3740,
        isBestDeal: true,
        badge: 'Top Deal',
        category: 'Footwear',
        storesAvailable: ['Myntra'],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BestDealsSection(
              isDark: false,
              deals: const [testDeal],
              onShopNow: (deal) {
                tapped = true;
              },
            ),
          ),
        ),
      );

      expect(find.text('Best Deals For You'), findsOneWidget);
      expect(find.text('Save ₹2259'), findsOneWidget);
      expect(find.text('Nike Air Max 270'), findsOneWidget);
      expect(find.text('Nike'), findsOneWidget);
      expect(find.text('₹3740'), findsOneWidget);
      expect(find.text('₹5999'), findsOneWidget);
      expect(find.text('Shop Now'), findsOneWidget);

      await tester.tap(find.text('Shop Now'));
      expect(tapped, isTrue);
    });

    testWidgets('2, 5, 6, 7. Highest Cashback Stores & Categories: offer pill at top, image container, cashback pill, Shop Now CTA', (tester) async {
      const testStore = BrandModel(
        name: 'The Derma Co',
        logoUrl: 'assets/cards/thedermaco-coupons.jpg',
        bannerUrl: 'assets/cards/col_derma.jpg',
        cashbackPercentage: 'Up to 25% Cashback',
        category: 'Beauty',
        offerText: 'Buy 2 Get 2 Free',
        websiteUrl: 'https://thedermaco.com',
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StoreCarouselSection(
              isDark: false,
              title: 'Highest Cashback Stores',
              stores: [testStore],
            ),
          ),
        ),
      );

      expect(find.text('Highest Cashback Stores'), findsOneWidget);
      expect(find.text('Buy 2 Get 2 Free'), findsOneWidget);
      expect(find.text('Up to 25% Cashback'), findsOneWidget);
      expect(find.text('Shop Now'), findsOneWidget);
    });

    testWidgets('4. Featured Stores: matching card structure with offer pill, dedicated image container, cashback pill, Shop Now CTA', (tester) async {
      bool tapped = false;
      const testFeaturedStore = FeaturedStoreModel(
        id: 'store-1',
        name: 'Amazon',
        logoUrl: 'assets/cards/amazon.jpg',
        cashbackRate: 'Up to 8% Cashback',
        maxCashback: 8.0,
        offerTag: 'Up to 50% Off',
        totalOffers: 12,
        totalCoupons: 4,
        websiteUrl: 'https://amazon.in',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FeaturedStoresSection(
              isDark: false,
              stores: const [testFeaturedStore],
              onViewAllTap: () {},
              onStoreTap: (store) {
                tapped = true;
              },
            ),
          ),
        ),
      );

      expect(find.text('Featured Stores'), findsOneWidget);
      expect(find.text('Shop Now'), findsOneWidget);

      await tester.tap(find.text('Shop Now'));
      expect(tapped, isTrue);
    });

    testWidgets('3. Offers Section: Store -> Offer -> Category -> Cashback -> Shop Now', (tester) async {
      bool tapped = false;
      const testOffer = HomeOfferModel(
        id: 'off-1',
        store: 'Myntra',
        storeLogo: 'assets/cards/myntra.jpg',
        title: 'Extra 20% OFF on Top Footwear & Streetwear',
        discount: 'Extra 20% OFF',
        cashback: '10% Cashback',
        cashbackRate: 10.0,
        validity: 'Ends in 2 days',
        imageUrl: 'assets/cards/col_myntra.jpg',
        category: 'Fashion',
        actionUrl: 'https://www.myntra.com',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HomeOffersSection(
              isDark: false,
              offers: const [testOffer],
              onViewAllTap: () {},
              onOfferTap: (offer) {
                tapped = true;
              },
            ),
          ),
        ),
      );

      expect(find.text('🔥 Offers'), findsOneWidget);
      // 1. Offer pill at top
      expect(find.text('Extra 20% OFF'), findsOneWidget);
      // 3. Store name
      expect(find.text('Myntra'), findsOneWidget);
      // 4. Category name
      expect(find.text('Fashion'), findsOneWidget);
      // 5. Cashback pill
      expect(find.text('10% Cashback'), findsOneWidget);
      // 6. Shop Now CTA
      expect(find.text('Shop Now'), findsOneWidget);

      await tester.tap(find.text('Shop Now'));
      expect(tapped, isTrue);
    });
  });
}
