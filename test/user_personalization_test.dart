import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cashback_reward_app/models/home_discovery_models.dart';
import 'package:cashback_reward_app/services/user_personalization_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final dummyDeals = [
    const BestDealModel(
      id: 'd-shoe-1',
      title: 'Nike Air Max 270',
      brand: 'Nike',
      store: 'Myntra',
      imageUrl: 'assets/nike.jpg',
      originalPrice: 6000,
      discountedPrice: 4000,
      discountPercentage: 33,
      cashbackPercentage: 10,
      cashbackAmount: 400,
      couponCode: 'NIKE500',
      couponDiscount: 500,
      effectiveSavings: 2500,
      effectivePrice: 3500,
      isBestDeal: true,
      badge: 'Best Deal',
      category: 'Footwear',
      storesAvailable: ['Myntra'],
    ),
    const BestDealModel(
      id: 'd-shoe-2',
      title: 'Puma Velocity Nitro',
      brand: 'Puma',
      store: 'Puma',
      imageUrl: 'assets/puma.jpg',
      originalPrice: 7000,
      discountedPrice: 5500,
      discountPercentage: 21,
      cashbackPercentage: 8,
      cashbackAmount: 440,
      couponCode: '',
      couponDiscount: 0,
      effectiveSavings: 1940,
      effectivePrice: 5060,
      isBestDeal: true,
      badge: 'Best Deal',
      category: 'Footwear',
      storesAvailable: ['Puma'],
    ),
    const BestDealModel(
      id: 'd-phone-1',
      title: 'Apple iPhone 15',
      brand: 'Apple',
      store: 'Flipkart',
      imageUrl: 'assets/iphone.jpg',
      originalPrice: 80000,
      discountedPrice: 70000,
      discountPercentage: 12,
      cashbackPercentage: 6,
      cashbackAmount: 4200,
      couponCode: 'FLIP1000',
      couponDiscount: 1000,
      effectiveSavings: 15200,
      effectivePrice: 64800,
      isBestDeal: true,
      badge: 'Best Deal',
      category: 'Smartphones',
      storesAvailable: ['Flipkart'],
    ),
    const BestDealModel(
      id: 'd-laptop-1',
      title: 'Apple MacBook Air M2',
      brand: 'Apple',
      store: 'Amazon',
      imageUrl: 'assets/macbook.jpg',
      originalPrice: 99000,
      discountedPrice: 85000,
      discountPercentage: 14,
      cashbackPercentage: 7,
      cashbackAmount: 5950,
      couponCode: 'AMZ2000',
      couponDiscount: 2000,
      effectiveSavings: 21950,
      effectivePrice: 77050,
      isBestDeal: true,
      badge: 'Best Deal',
      category: 'Laptops',
      storesAvailable: ['Amazon'],
    ),
    const BestDealModel(
      id: 'd-audio-1',
      title: 'boAt Rockerz 450',
      brand: 'boAt',
      store: 'Flipkart',
      imageUrl: 'assets/boat.jpg',
      originalPrice: 4000,
      discountedPrice: 1500,
      discountPercentage: 62,
      cashbackPercentage: 6,
      cashbackAmount: 90,
      couponCode: '',
      couponDiscount: 0,
      effectiveSavings: 2590,
      effectivePrice: 1410,
      isBestDeal: true,
      badge: 'Best Deal',
      category: 'Audio',
      storesAvailable: ['Flipkart'],
    ),
    const BestDealModel(
      id: 'd-beauty-1',
      title: 'Vitamin C Face Serum',
      brand: 'The Derma Co',
      store: 'Nykaa',
      imageUrl: 'assets/derma.jpg',
      originalPrice: 650,
      discountedPrice: 450,
      discountPercentage: 30,
      cashbackPercentage: 10,
      cashbackAmount: 45,
      couponCode: '',
      couponDiscount: 0,
      effectiveSavings: 245,
      effectivePrice: 405,
      isBestDeal: true,
      badge: 'Best Deal',
      category: 'Beauty',
      storesAvailable: ['Nykaa'],
    ),
  ];

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('UserPersonalizationService Tests', () {
    test('1. Cold Start: New user sees top deal from each unique category', () async {
      final service = UserPersonalizationService();
      await service.init();

      expect(service.isNewUser, isTrue);

      final coldDeals = service.getColdStartDeals(dummyDeals);
      expect(coldDeals.isNotEmpty, isTrue);

      // Verify that every deal in the result belongs to a unique category
      final categories = coldDeals.map((d) => d.category.toLowerCase()).toList();
      final uniqueCategories = categories.toSet();
      expect(categories.length, equals(uniqueCategories.length),
          reason: 'Every category in cold start should appear at most once to ensure catalog diversity');

      expect(uniqueCategories.contains('footwear'), isTrue);
      expect(uniqueCategories.contains('smartphones'), isTrue);
      expect(uniqueCategories.contains('laptops'), isTrue);
      expect(uniqueCategories.contains('audio'), isTrue);
      expect(uniqueCategories.contains('beauty'), isTrue);
    });

    test('2. Search Personalization: Searching for shoes boosts footwear to first place', () async {
      final service = UserPersonalizationService();
      await service.init();

      // Record user search
      await service.recordSearch('Nike shoes');
      expect(service.isNewUser, isFalse);
      expect(service.recentSearches.contains('Nike shoes'), isTrue);

      final personalized = service.getPersonalizedBestDeals(dummyDeals);
      expect(personalized.first.brand.toLowerCase(), equals('nike'),
          reason: 'Searching for Nike shoes must boost the Nike deal to top position');
    });

    test('3. Order Personalization: Ordering from Nykaa boosts Beauty deals', () async {
      final service = UserPersonalizationService();
      await service.init();

      await service.recordOrder(
        store: 'Nykaa',
        category: 'Beauty',
        brand: 'The Derma Co',
      );
      expect(service.isNewUser, isFalse);

      final personalized = service.getPersonalizedBestDeals(dummyDeals);
      expect(personalized.first.category.toLowerCase(), equals('beauty'),
          reason: 'Buying from Nykaa/Beauty must prioritize Beauty items for the active user');
    });

    test('4. Similar Products: Excludes current product and matches same category', () async {
      final service = UserPersonalizationService();
      await service.init();

      final current = dummyDeals[0]; // Nike Air Max 270 (Footwear)
      final similar = service.getSimilarProducts(
        currentId: current.id,
        currentCategory: current.category,
        currentBrand: current.brand,
        currentPrice: current.discountedPrice,
        allDeals: dummyDeals,
      );

      // Must never contain current product
      expect(similar.any((d) => d.id == current.id), isFalse);

      // Should find the other footwear product (Puma)
      expect(similar.any((d) => d.category.toLowerCase() == 'footwear'), isTrue);
      expect(similar.first.id, equals('d-shoe-2'));
    });

    test('5. Products You Might Like: Recommends complementary items with no overlap', () async {
      final service = UserPersonalizationService();
      await service.init();

      final current = dummyDeals[2]; // Apple iPhone 15 (Smartphones)
      final excludedIds = {'d-phone-1', 'd-laptop-1'};

      final recommended = service.getProductsYouMightLike(
        currentId: current.id,
        currentCategory: current.category,
        excludedProductIds: excludedIds,
        allDeals: dummyDeals,
      );

      // Must exclude all in excludedIds
      expect(recommended.any((d) => excludedIds.contains(d.id)), isFalse);

      // For Smartphones, complementary categories are Audio/Wearables/Electronics
      expect(recommended.any((d) => d.category.toLowerCase() == 'audio'), isTrue);
    });

    test('6. Click Personalization: Clicking on Laptop product boosts Laptops to top', () async {
      SharedPreferences.setMockInitialValues({});
      final service = UserPersonalizationService();
      await service.init();
      service.clearForTesting();

      await service.recordProductClick(
        id: 'd-laptop-1',
        category: 'Laptops',
        brand: 'Apple',
        store: 'Amazon',
      );
      expect(service.isNewUser, isFalse);

      final personalized = service.getPersonalizedBestDeals(dummyDeals);
      expect(personalized.first.id, equals('d-laptop-1'),
          reason: 'Clicking on MacBook Air must boost the laptop deal to top position');
    });
  });
}
