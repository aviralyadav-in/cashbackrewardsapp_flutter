import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/category_shopping_models.dart';
import 'auth_service.dart';

class CategoryShoppingService {
  final http.Client _client;

  CategoryShoppingService({http.Client? client})
      : _client = client ?? http.Client();

  /// GET /api/categories/:categoryId
  Future<CategoryDetailResponse> fetchCategoryDetail(String categoryId, {String? categoryTitle}) async {
    final cleanId = categoryId.trim().toLowerCase().replaceAll(RegExp(r'[^a-z0-9_]'), '');
    try {
      final uri = Uri.parse('${AuthService.baseUrl}/categories/$cleanId');
      final response = await _client.get(uri).timeout(const Duration(seconds: 3));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        if (data['success'] == true && data['data'] != null) {
          final res = CategoryDetailResponse.fromJson(data['data'] as Map<String, dynamic>);
          final resId = res.category.id.trim().toLowerCase().replaceAll(RegExp(r'[^a-z0-9_]'), '');

          final targetNormalized = (cleanId == 'cards' || cleanId == 'card' || cleanId == 'creditcard' || cleanId == 'creditcards') ? 'credit_cards'
              : ((cleanId == 'groceries' || cleanId == 'food_groceries') ? 'grocery'
              : ((cleanId == 'food_dining' || cleanId == 'dining') ? 'food'
              : ((cleanId == 'travel_holidays' || cleanId == 'holidays') ? 'travel'
              : ((cleanId == 'home') ? 'home_living' : cleanId))));

          final resNormalized = (resId == 'cards' || resId == 'card' || resId == 'creditcard' || resId == 'creditcards') ? 'credit_cards'
              : ((resId == 'groceries' || resId == 'food_groceries') ? 'grocery'
              : ((resId == 'food_dining' || resId == 'dining') ? 'food'
              : ((resId == 'travel_holidays' || resId == 'holidays') ? 'travel'
              : ((resId == 'home') ? 'home_living' : resId))));

          if (resNormalized == targetNormalized) {
            return res;
          } else {
            debugPrint('CategoryShoppingService: Category ID mismatch ($resId != $cleanId). Using fallback.');
          }
        }
      }
    } catch (e) {
      debugPrint('CategoryShoppingService: Network error fetching category detail: $e');
    }

    return getFallbackCategoryDetail(cleanId, categoryTitle: categoryTitle);
  }

  /// GET /api/categories/:categoryId/subcategories/:subcategoryId
  Future<SubcategoryDetailResponse> fetchSubcategoryDetail(
    String categoryId,
    String subcategoryId, {
    String? filter,
    String? style,
  }) async {
    final cleanCat = categoryId.trim().toLowerCase().replaceAll(RegExp(r'[^a-z0-9_]'), '');
    final cleanSub = subcategoryId.trim().toLowerCase().replaceAll(RegExp(r'[^a-z0-9_]'), '');

    try {
      final queryParams = <String, String>{};
      if (filter != null && filter.isNotEmpty && filter != 'All') {
        queryParams['filter'] = filter;
      }
      if (style != null && style.isNotEmpty && style != 'All') {
        queryParams['style'] = style;
      }

      final uri = Uri.parse('${AuthService.baseUrl}/categories/$cleanCat/subcategories/$cleanSub')
          .replace(queryParameters: queryParams.isNotEmpty ? queryParams : null);

      final response = await _client.get(uri).timeout(const Duration(seconds: 3));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        if (data['success'] == true && data['data'] != null) {
          final res = SubcategoryDetailResponse.fromJson(data['data'] as Map<String, dynamic>);
          final subCat = (res.subcategory.categoryId ?? res.subcategory.id).trim().toLowerCase().replaceAll(RegExp(r'[^a-z0-9_]'), '');
          final targetNormalized = (cleanCat == 'cards' || cleanCat == 'card' || cleanCat == 'creditcard' || cleanCat == 'creditcards') ? 'credit_cards'
              : ((cleanCat == 'groceries' || cleanCat == 'food_groceries') ? 'grocery'
              : ((cleanCat == 'food_dining' || cleanCat == 'dining') ? 'food'
              : ((cleanCat == 'travel_holidays' || cleanCat == 'holidays') ? 'travel'
              : ((cleanCat == 'home') ? 'home_living' : cleanCat))));
          final resNormalized = (subCat == 'cards' || subCat == 'card' || subCat == 'creditcard' || subCat == 'creditcards') ? 'credit_cards'
              : ((subCat == 'groceries' || subCat == 'food_groceries') ? 'grocery'
              : ((subCat == 'food_dining' || subCat == 'dining') ? 'food'
              : ((subCat == 'travel_holidays' || subCat == 'holidays') ? 'travel'
              : ((subCat == 'home') ? 'home_living' : subCat))));

          if (subCat.isEmpty || resNormalized == targetNormalized) {
            return res;
          }
        }
      }
    } catch (e) {
      debugPrint('CategoryShoppingService: Network error fetching subcategory detail: $e');
    }

    return getFallbackSubcategoryDetail(cleanCat, cleanSub, filter: filter, style: style);
  }

  /// GET /api/products/:productId/compare
  Future<SmartProductComparison> compareProduct(String productId) async {
    try {
      final uri = Uri.parse('${AuthService.baseUrl}/products/$productId/compare');
      final response = await _client.get(uri).timeout(const Duration(seconds: 3));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        if (data['success'] == true && data['data'] != null) {
          return SmartProductComparison.fromJson(data['data'] as Map<String, dynamic>);
        }
      }
    } catch (e) {
      debugPrint('CategoryShoppingService: Network error comparing product: $e');
    }

    return getFallbackProductComparison(productId);
  }

  /// Offline fallback data matching exact backend schema using local asset cards & logos
  static CategoryDetailResponse getFallbackCategoryDetail(String categoryId, {String? categoryTitle}) {
    final catKey = categoryId.trim().toLowerCase().replaceAll(RegExp(r'[^a-z0-9_]'), '');

    if (catKey == 'travel' || catKey == 'travel_holidays' || catKey == 'holidays') {
      return const CategoryDetailResponse(
        category: CategoryOverviewModel(
          id: 'travel',
          name: 'Travel & Holidays',
          description: 'Book flights, luxury hotels and holiday packages with highest cashback rates.',
        ),
        subcategories: [
          SubcategoryItemModel(id: 'flights', name: 'Flights', icon: 'flight', itemCount: '500+'),
          SubcategoryItemModel(id: 'hotels', name: 'Hotels', icon: 'hotel', itemCount: '1,200+'),
          SubcategoryItemModel(id: 'bus', name: 'Bus', icon: 'directions_bus', itemCount: '350+'),
          SubcategoryItemModel(id: 'trains', name: 'Trains', icon: 'train', itemCount: '200+'),
          SubcategoryItemModel(id: 'holidays', name: 'Holidays', icon: 'beach_access', itemCount: '150+'),
        ],
        popularStores: [
          CategoryStoreModel(
            id: 'st-makemytrip',
            name: 'MakeMyTrip',
            logoUrl: 'assets/cards/makemytrip-hotels.png',
            cashbackRate: 'Up to 10% Cashback',
            offersCount: '35+ Offers',
            hasCoupons: true,
            actionUrl: 'https://www.makemytrip.com',
            category: 'Travel',
          ),
          CategoryStoreModel(
            id: 'st-cleartrip',
            name: 'Cleartrip',
            logoUrl: 'assets/cards/cleartrip.png',
            cashbackRate: 'Up to 8% Cashback',
            offersCount: '25+ Offers',
            hasCoupons: true,
            actionUrl: 'https://www.cleartrip.com',
            category: 'Travel',
          ),
          CategoryStoreModel(
            id: 'st-agoda',
            name: 'Agoda',
            logoUrl: 'assets/cards/agoda.png',
            cashbackRate: 'Flat 7% Cashback',
            offersCount: '20+ Offers',
            hasCoupons: true,
            actionUrl: 'https://www.agoda.com',
            category: 'Hotels',
          ),
          CategoryStoreModel(
            id: 'st-booking',
            name: 'Booking.com',
            logoUrl: 'assets/cards/booking.jpg',
            cashbackRate: 'Up to 6% Cashback',
            offersCount: '18+ Offers',
            hasCoupons: true,
            actionUrl: 'https://www.booking.com',
            category: 'Hotels',
          ),
        ],
        bestDeals: [
          CategoryDealModel(
            id: 'deal-travel-1',
            title: 'Domestic Flight Booking Special',
            brand: 'MakeMyTrip',
            store: 'MakeMyTrip',
            imageUrl: 'assets/cards/col_travel.jpg',
            originalPrice: 4500,
            discountedPrice: 3800,
            discountPercentage: 15,
            cashbackPercentage: 10,
            cashbackAmount: 380,
            couponCode: 'MMTFLIGHT',
            couponDiscount: 500,
            effectiveSavings: 1080,
            effectivePrice: 2920,
            isBestDeal: true,
            badge: '🏆 Best Deal',
            storesAvailable: ['MakeMyTrip', 'Cleartrip'],
          ),
          CategoryDealModel(
            id: 'deal-travel-2',
            title: 'Luxury Beach Resort 2N/3D Stay',
            brand: 'Agoda',
            store: 'Agoda',
            imageUrl: 'assets/cards/booking.jpg',
            originalPrice: 8999,
            discountedPrice: 6999,
            discountPercentage: 22,
            cashbackPercentage: 7,
            cashbackAmount: 490,
            couponCode: 'AGODASTAY',
            couponDiscount: 800,
            effectiveSavings: 2800,
            effectivePrice: 5709,
            isBestDeal: true,
            badge: '🏆 Top Value',
            storesAvailable: ['Agoda', 'Booking.com'],
          ),
        ],
      );
    }

    if (catKey == 'food' || catKey == 'food_dining' || catKey == 'dining') {
      return const CategoryDetailResponse(
        category: CategoryOverviewModel(
          id: 'food',
          name: 'Food & Dining',
          description: 'Order online food, gourmet meal kits and restaurant dining discounts.',
        ),
        subcategories: [
          SubcategoryItemModel(id: 'delivery', name: 'Delivery', icon: 'delivery_dining', itemCount: '600+'),
          SubcategoryItemModel(id: 'dineout', name: 'Dineout', icon: 'restaurant', itemCount: '400+'),
          SubcategoryItemModel(id: 'pizza', name: 'Pizza', icon: 'local_pizza', itemCount: '180+'),
          SubcategoryItemModel(id: 'cafes', name: 'Cafes', icon: 'local_cafe', itemCount: '220+'),
          SubcategoryItemModel(id: 'bakery', name: 'Bakery', icon: 'bakery_dining', itemCount: '140+'),
        ],
        popularStores: [
          CategoryStoreModel(
            id: 'st-zomato',
            name: 'Zomato',
            logoUrl: 'assets/logos/zomato.svg',
            cashbackRate: 'Flat ₹120 Cashback',
            offersCount: '45+ Offers',
            hasCoupons: true,
            actionUrl: 'https://www.zomato.com',
            category: 'Food',
          ),
          CategoryStoreModel(
            id: 'st-swiggy',
            name: 'Swiggy',
            logoUrl: 'assets/logos/swiggy.svg',
            cashbackRate: 'Flat ₹100 Cashback',
            offersCount: '40+ Offers',
            hasCoupons: true,
            actionUrl: 'https://www.swiggy.com',
            category: 'Food',
          ),
          CategoryStoreModel(
            id: 'st-haldiram',
            name: "Haldiram's",
            logoUrl: 'assets/cards/haldiram-coupons.png',
            cashbackRate: 'Up to 15% Cashback',
            offersCount: '25+ Offers',
            hasCoupons: true,
            actionUrl: 'https://www.haldirams.com',
            category: 'Indian Snacks',
          ),
          CategoryStoreModel(
            id: 'st-ragecoffee',
            name: 'Rage Coffee',
            logoUrl: 'assets/cards/rage-coffee-coupons.png',
            cashbackRate: 'Up to 20% Cashback',
            offersCount: '18+ Offers',
            hasCoupons: true,
            actionUrl: 'https://ragecoffee.com',
            category: 'Beverages',
          ),
        ],
        bestDeals: [
          CategoryDealModel(
            id: 'deal-food-1',
            title: 'Gourmet Feast Combo for 2',
            brand: 'Zomato',
            store: 'Zomato',
            imageUrl: 'assets/cards/col_food.jpg',
            originalPrice: 899,
            discountedPrice: 599,
            discountPercentage: 33,
            cashbackPercentage: 20,
            cashbackAmount: 120,
            couponCode: 'ZOMATOFEAST',
            couponDiscount: 150,
            effectiveSavings: 450,
            effectivePrice: 329,
            isBestDeal: true,
            badge: '🏆 Best Deal',
            storesAvailable: ['Zomato', 'Swiggy'],
          ),
          CategoryDealModel(
            id: 'deal-food-2',
            title: 'Haldiram\'s Royal Sweet & Savory Hamper',
            brand: 'Haldiram\'s',
            store: 'Haldiram\'s',
            imageUrl: 'assets/cards/haldiram-coupons.png',
            originalPrice: 1299,
            discountedPrice: 899,
            discountPercentage: 30,
            cashbackPercentage: 15,
            cashbackAmount: 135,
            couponCode: 'HALDI100',
            couponDiscount: 100,
            effectiveSavings: 535,
            effectivePrice: 664,
            isBestDeal: true,
            badge: '🏆 Festive Pick',
            storesAvailable: ['Haldiram\'s', 'Amazon'],
          ),
        ],
      );
    }

    if (catKey == 'beauty' || catKey == 'beauty_care' || catKey == 'cosmetics') {
      return const CategoryDetailResponse(
        category: CategoryOverviewModel(
          id: 'beauty',
          name: 'Beauty & Skincare',
          description: 'Explore verified cosmetics, haircare, skincare and salon wellness rewards.',
        ),
        subcategories: [
          SubcategoryItemModel(id: 'skincare', name: 'Skincare', icon: 'spa', itemCount: '520+'),
          SubcategoryItemModel(id: 'makeup', name: 'Makeup', icon: 'face', itemCount: '480+'),
          SubcategoryItemModel(id: 'haircare', name: 'Haircare', icon: 'brush', itemCount: '310+'),
          SubcategoryItemModel(id: 'fragrances', name: 'Fragrances', icon: 'sanitizer', itemCount: '190+'),
          SubcategoryItemModel(id: 'wellness', name: 'Wellness', icon: 'health_and_safety', itemCount: '230+'),
        ],
        popularStores: [
          CategoryStoreModel(
            id: 'st-nykaa',
            name: 'Nykaa',
            logoUrl: 'assets/cards/nykaa.jpg',
            cashbackRate: 'Up to 15% Cashback',
            offersCount: '45+ Offers',
            hasCoupons: true,
            actionUrl: 'https://www.nykaa.com',
            category: 'Beauty',
          ),
          CategoryStoreModel(
            id: 'st-foxtale',
            name: 'Foxtale',
            logoUrl: 'assets/cards/foxtale-coupons.jpg',
            cashbackRate: 'Up to 20% Cashback',
            offersCount: '25+ Offers',
            hasCoupons: true,
            actionUrl: 'https://foxtale.in',
            category: 'Skincare',
          ),
          CategoryStoreModel(
            id: 'st-derma',
            name: 'The Derma Co',
            logoUrl: 'assets/cards/thedermaco-coupons.jpg',
            cashbackRate: 'Up to 18% Cashback',
            offersCount: '28+ Offers',
            hasCoupons: true,
            actionUrl: 'https://thedermaco.com',
            category: 'Active Skincare',
          ),
          CategoryStoreModel(
            id: 'st-dotkey',
            name: 'Dot & Key',
            logoUrl: 'assets/cards/dotandkey-coupons.png',
            cashbackRate: 'Up to 12% Cashback',
            offersCount: '22+ Offers',
            hasCoupons: true,
            actionUrl: 'https://www.dotandkey.com',
            category: 'Botanical Skincare',
          ),
          CategoryStoreModel(
            id: 'st-aqualogica',
            name: 'Aqualogica',
            logoUrl: 'assets/cards/aqualogica-coupons.png',
            cashbackRate: 'Up to 18% Cashback',
            offersCount: '20+ Offers',
            hasCoupons: true,
            actionUrl: 'https://aqualogica.in',
            category: 'Hydration',
          ),
          CategoryStoreModel(
            id: 'st-mcaffeine',
            name: 'mCaffeine',
            logoUrl: 'assets/cards/mcaffeine-coupons.jpg',
            cashbackRate: 'Up to 15% Cashback',
            offersCount: '18+ Offers',
            hasCoupons: true,
            actionUrl: 'https://www.mcaffeine.com',
            category: 'Coffee Care',
          ),
        ],
        bestDeals: [
          CategoryDealModel(
            id: 'deal-beauty-1',
            title: 'The Derma Co 10% Vitamin C Face Serum (30ml)',
            brand: 'The Derma Co',
            store: 'Nykaa',
            imageUrl: 'assets/cards/thedermaco-coupons.jpg',
            originalPrice: 649,
            discountedPrice: 519,
            discountPercentage: 20,
            cashbackPercentage: 15,
            cashbackAmount: 78,
            couponCode: 'DERMA100',
            couponDiscount: 100,
            effectiveSavings: 308,
            effectivePrice: 341,
            isBestDeal: true,
            badge: '🏆 Best Deal',
            storesAvailable: ['Nykaa', 'Amazon'],
          ),
          CategoryDealModel(
            id: 'deal-beauty-2',
            title: 'Dot & Key Ceramide & Hyaluronic Barrier Repair Cream',
            brand: 'Dot & Key',
            store: 'Amazon',
            imageUrl: 'assets/cards/dotandkey-coupons.png',
            originalPrice: 595,
            discountedPrice: 449,
            discountPercentage: 24,
            cashbackPercentage: 12,
            cashbackAmount: 54,
            couponCode: 'DOTKEY50',
            couponDiscount: 50,
            effectiveSavings: 250,
            effectivePrice: 345,
            isBestDeal: true,
            badge: '🏆 Top Value',
            storesAvailable: ['Amazon', 'Nykaa'],
          ),
          CategoryDealModel(
            id: 'deal-beauty-3',
            title: 'Aqualogica Glow+ Dewy Sunscreen SPF 50 PA++++',
            brand: 'Aqualogica',
            store: 'Nykaa',
            imageUrl: 'assets/cards/aqualogica-coupons.png',
            originalPrice: 499,
            discountedPrice: 349,
            discountPercentage: 30,
            cashbackPercentage: 18,
            cashbackAmount: 63,
            couponCode: 'AQUA50',
            couponDiscount: 50,
            effectiveSavings: 263,
            effectivePrice: 236,
            isBestDeal: true,
            badge: '✨ Viral Sunscreen',
            storesAvailable: ['Nykaa', 'Amazon'],
          ),
        ],
      );
    }

    if (catKey == 'grocery' || catKey == 'groceries' || catKey == 'food_groceries') {
      return const CategoryDetailResponse(
        category: CategoryOverviewModel(
          id: 'grocery',
          name: 'Grocery & Essentials',
          description: 'Superfast delivery on fresh fruits, vegetables, dairy and daily essentials.',
        ),
        subcategories: [
          SubcategoryItemModel(id: 'dairy', name: 'Dairy & Eggs', icon: 'egg', itemCount: '280+'),
          SubcategoryItemModel(id: 'fruits', name: 'Fruits & Veggies', icon: 'eco', itemCount: '350+'),
          SubcategoryItemModel(id: 'snacks', name: 'Snacks', icon: 'fastfood', itemCount: '420+'),
          SubcategoryItemModel(id: 'cleaning', name: 'Household', icon: 'cleaning_services', itemCount: '210+'),
        ],
        popularStores: [
          CategoryStoreModel(
            id: 'st-bigbasket',
            name: 'BigBasket',
            logoUrl: 'assets/logos/bigbasket.svg',
            cashbackRate: 'Up to 6% Cashback',
            offersCount: '30+ Offers',
            hasCoupons: true,
            actionUrl: 'https://www.bigbasket.com',
            category: 'Grocery',
          ),
          CategoryStoreModel(
            id: 'st-blinkit',
            name: 'Blinkit',
            logoUrl: 'assets/logos/blinkit.svg',
            cashbackRate: 'Up to 8% Cashback',
            offersCount: '25+ Offers',
            hasCoupons: true,
            actionUrl: 'https://www.blinkit.com',
            category: 'Quick Commerce',
          ),
          CategoryStoreModel(
            id: 'st-dmart',
            name: 'DMart Ready',
            logoUrl: 'assets/logos/dmart.svg',
            cashbackRate: 'Up to 5% Cashback',
            offersCount: '20+ Offers',
            hasCoupons: true,
            actionUrl: 'https://www.dmart.in',
            category: 'Supermarket',
          ),
          CategoryStoreModel(
            id: 'st-shopsy',
            name: 'Shopsy Grocery',
            logoUrl: 'assets/cards/shopsy-coupons.png',
            cashbackRate: 'Up to 7.50% Cashback',
            offersCount: '35+ Offers',
            hasCoupons: true,
            actionUrl: 'https://www.shopsy.in',
            category: 'Value Grocery',
          ),
        ],
        bestDeals: [
          CategoryDealModel(
            id: 'deal-groc-1',
            title: 'Organic Farm Fresh Daily Essentials Bundle',
            brand: 'BigBasket',
            store: 'BigBasket',
            imageUrl: 'assets/cards/col_shopsy.jpg',
            originalPrice: 650,
            discountedPrice: 480,
            discountPercentage: 26,
            cashbackPercentage: 6,
            cashbackAmount: 28,
            couponCode: 'BBFRESH',
            couponDiscount: 50,
            effectiveSavings: 220,
            effectivePrice: 402,
            isBestDeal: true,
            badge: '🏆 Best Deal',
            storesAvailable: ['BigBasket', 'Blinkit'],
          ),
          CategoryDealModel(
            id: 'deal-groc-2',
            title: 'True Elements Healthy Roasted Seeds & Berries',
            brand: 'True Elements',
            store: 'Amazon',
            imageUrl: 'assets/cards/true-elements-coupons.jpg',
            originalPrice: 499,
            discountedPrice: 349,
            discountPercentage: 30,
            cashbackPercentage: 8,
            cashbackAmount: 28,
            couponCode: 'TRUE50',
            couponDiscount: 50,
            effectiveSavings: 228,
            effectivePrice: 271,
            isBestDeal: true,
            badge: '🥗 Healthy Pick',
            storesAvailable: ['Amazon', 'BigBasket'],
          ),
        ],
      );
    }

    if (catKey == 'credit_cards' || catKey == 'cards' || catKey == 'card' || catKey == 'creditcard' || catKey == 'creditcards' || catKey == 'banking_finance') {
      return const CategoryDetailResponse(
        category: CategoryOverviewModel(
          id: 'credit_cards',
          name: 'Credit Cards & Finance',
          description: 'Compare top cashback credit cards, instant rewards and paperless approval.',
        ),
        subcategories: [
          SubcategoryItemModel(id: 'cashback_cards', name: 'Cashback Cards', icon: 'credit_card', itemCount: '18+'),
          SubcategoryItemModel(id: 'shopping_cards', name: 'Shopping Cards', icon: 'shopping_cart', itemCount: '24+'),
          SubcategoryItemModel(id: 'travel_cards', name: 'Travel Cards', icon: 'flight', itemCount: '15+'),
          SubcategoryItemModel(id: 'fuel_cards', name: 'Fuel Cards', icon: 'local_gas_station', itemCount: '12+'),
          SubcategoryItemModel(id: 'lifetime_free', name: 'Lifetime Free', icon: 'card_giftcard', itemCount: '20+'),
        ],
        popularStores: [
          CategoryStoreModel(
            id: 'st-sbicard',
            name: 'SBI Card',
            logoUrl: 'assets/cards/sbi-cashback-card.png',
            cashbackRate: 'Flat ₹1,500 Reward',
            offersCount: '10+ Cards',
            hasCoupons: true,
            actionUrl: 'https://www.sbicard.com',
            category: 'Banking',
          ),
          CategoryStoreModel(
            id: 'st-hdfc',
            name: 'HDFC Bank Cards',
            logoUrl: 'assets/cards/hdfcbank-personal-loan.png',
            cashbackRate: 'Flat ₹2,000 Reward',
            offersCount: '12+ Cards',
            hasCoupons: true,
            actionUrl: 'https://www.hdfcbank.com',
            category: 'Banking',
          ),
          CategoryStoreModel(
            id: 'st-axis',
            name: 'Axis Bank Cards',
            logoUrl: 'assets/cards/axis-neo-rupay-credit-card.jpg',
            cashbackRate: 'Flat ₹960 Reward',
            offersCount: '8+ Cards',
            hasCoupons: true,
            actionUrl: 'https://www.axisbank.com',
            category: 'Banking',
          ),
          CategoryStoreModel(
            id: 'st-idfc',
            name: 'IDFC First Bank',
            logoUrl: 'assets/cards/idfc-first-credit-card.png',
            cashbackRate: 'Flat ₹700 Reward',
            offersCount: '6+ Cards',
            hasCoupons: true,
            actionUrl: 'https://www.idfcfirstbank.com',
            category: 'Banking',
          ),
          CategoryStoreModel(
            id: 'st-bobcard',
            name: 'BOBCARD Eterna',
            logoUrl: 'assets/cards/bobcard-eterna-credit-card.png',
            cashbackRate: 'Flat ₹540 Reward',
            offersCount: '5+ Cards',
            hasCoupons: true,
            actionUrl: 'https://www.bobcard.co.in',
            category: 'Banking',
          ),
          CategoryStoreModel(
            id: 'st-uni',
            name: 'Uni GoldX Card',
            logoUrl: 'assets/cards/uni-goldx-credit-card.png',
            cashbackRate: 'Flat ₹1,000 Reward',
            offersCount: '4+ Cards',
            hasCoupons: true,
            actionUrl: 'https://www.uni.cards',
            category: 'Banking',
          ),
        ],
        bestDeals: [
          CategoryDealModel(
            id: 'deal-card-1',
            title: 'SBI SimplyCLICK Card (Flat ₹1,500 Amazon Voucher)',
            brand: 'SBI Card',
            store: 'SBI Card',
            imageUrl: 'assets/cards/sbi-cashback-card.png',
            originalPrice: 499,
            discountedPrice: 499,
            discountPercentage: 0,
            cashbackPercentage: 100,
            cashbackAmount: 1500,
            couponCode: 'APPLYNOW',
            couponDiscount: 0,
            effectiveSavings: 1500,
            effectivePrice: 0,
            isBestDeal: true,
            badge: '🏆 Top Reward',
            storesAvailable: ['SBI Card'],
          ),
          CategoryDealModel(
            id: 'deal-card-2',
            title: 'Axis Bank Neo RuPay Credit Card — Lifetime Free',
            brand: 'Axis Bank',
            store: 'Axis Bank',
            imageUrl: 'assets/cards/axis-neo-rupay-credit-card.jpg',
            originalPrice: 0,
            discountedPrice: 0,
            discountPercentage: 100,
            cashbackPercentage: 100,
            cashbackAmount: 960,
            couponCode: 'LIFETIME',
            couponDiscount: 0,
            effectiveSavings: 960,
            effectivePrice: 0,
            isBestDeal: true,
            badge: '⚡ Lifetime Free',
            storesAvailable: ['Axis Bank'],
          ),
        ],
      );
    }

    if (catKey == 'electronics' || catKey == 'tech' || catKey == 'mobiles') {
      return const CategoryDetailResponse(
        category: CategoryOverviewModel(
          id: 'electronics',
          name: 'Electronics',
          description: 'Shop top gadgets, phones and laptops with price comparisons & verified cashback.',
        ),
        subcategories: [
          SubcategoryItemModel(id: 'mobiles', name: 'Mobiles', icon: 'smartphone', itemCount: '450+'),
          SubcategoryItemModel(id: 'laptops', name: 'Laptops', icon: 'laptop', itemCount: '280+'),
          SubcategoryItemModel(id: 'tvs', name: 'TVs', icon: 'tv', itemCount: '190+'),
          SubcategoryItemModel(id: 'headphones', name: 'Headphones', icon: 'headphones', itemCount: '320+'),
          SubcategoryItemModel(id: 'smartwatches', name: 'Smartwatches', icon: 'watch', itemCount: '210+'),
          SubcategoryItemModel(id: 'cameras', name: 'Cameras', icon: 'photo_camera', itemCount: '95+'),
        ],
        popularStores: [
          CategoryStoreModel(
            id: 'st-amazon',
            name: 'Amazon',
            logoUrl: 'assets/cards/amazon.jpg',
            cashbackRate: 'Up to 8% Cashback',
            offersCount: '50+ Offers',
            hasCoupons: true,
            actionUrl: 'https://www.amazon.in',
            category: 'All Retail',
          ),
          CategoryStoreModel(
            id: 'st-flipkart',
            name: 'Flipkart',
            logoUrl: 'assets/cards/flipkart-electronics.png',
            cashbackRate: 'Up to 6% Cashback',
            offersCount: '40+ Offers',
            hasCoupons: true,
            actionUrl: 'https://www.flipkart.com',
            category: 'Electronics',
          ),
          CategoryStoreModel(
            id: 'st-croma',
            name: 'Croma',
            logoUrl: 'assets/logos/croma.svg',
            cashbackRate: 'Flat 5% Cashback',
            offersCount: '22+ Offers',
            hasCoupons: true,
            actionUrl: 'https://www.croma.com',
            category: 'Electronics',
          ),
          CategoryStoreModel(
            id: 'st-reliance',
            name: 'Reliance Digital',
            logoUrl: 'assets/logos/reliancedigital.svg',
            cashbackRate: 'Up to 5% Cashback',
            offersCount: '19+ Offers',
            hasCoupons: true,
            actionUrl: 'https://www.reliancedigital.in',
            category: 'Electronics',
          ),
          CategoryStoreModel(
            id: 'st-boat',
            name: 'boAt',
            logoUrl: 'assets/cards/boat-coupon.jpg',
            cashbackRate: 'Up to 8% Cashback',
            offersCount: '30+ Offers',
            hasCoupons: true,
            actionUrl: 'https://www.boat-lifestyle.com',
            category: 'Audio',
          ),
          CategoryStoreModel(
            id: 'st-noise',
            name: 'Noise',
            logoUrl: 'assets/cards/gonoise-coupons.jpg',
            cashbackRate: 'Up to 6% Cashback',
            offersCount: '25+ Offers',
            hasCoupons: true,
            actionUrl: 'https://www.gonoise.com',
            category: 'Smartwatches',
          ),
        ],
        bestDeals: [
          CategoryDealModel(
            id: 'prod-4',
            title: 'Apple iPhone 15 (128 GB)',
            brand: 'Apple',
            store: 'Flipkart',
            imageUrl: 'assets/banners/phone_banner_16_9.jpg',
            originalPrice: 79900,
            discountedPrice: 70999,
            discountPercentage: 11,
            cashbackPercentage: 4,
            cashbackAmount: 2500,
            couponCode: 'IPHONE2000',
            couponDiscount: 2000,
            effectiveSavings: 13401,
            effectivePrice: 66499,
            isBestDeal: true,
            badge: '🏆 Best Deal',
            storesAvailable: ['Flipkart', 'Amazon', 'Croma'],
          ),
          CategoryDealModel(
            id: 'prod-boat-1',
            title: 'boAt Rockerz 450 ANC Wireless Headphones',
            brand: 'boAt',
            store: 'Flipkart',
            imageUrl: 'assets/cards/boat-coupon.jpg',
            originalPrice: 3990,
            discountedPrice: 1499,
            discountPercentage: 62,
            cashbackPercentage: 8,
            cashbackAmount: 120,
            couponCode: 'BOAT200',
            couponDiscount: 200,
            effectiveSavings: 2811,
            effectivePrice: 1179,
            isBestDeal: true,
            badge: '🏆 Top Value',
            storesAvailable: ['Flipkart', 'Amazon'],
          ),
          CategoryDealModel(
            id: 'prod-noise-1',
            title: 'Noise ColorFit Pro 5 Smartwatch with AMOLED Display',
            brand: 'Noise',
            store: 'Amazon',
            imageUrl: 'assets/cards/gonoise-coupons.jpg',
            originalPrice: 7999,
            discountedPrice: 3499,
            discountPercentage: 56,
            cashbackPercentage: 6,
            cashbackAmount: 210,
            couponCode: 'NOISE300',
            couponDiscount: 300,
            effectiveSavings: 5010,
            effectivePrice: 2989,
            isBestDeal: true,
            badge: '🏆 Best Deal',
            storesAvailable: ['Amazon', 'Flipkart'],
          ),
        ],
      );
    }

    // Default to Fashion or Custom Category Title
    final displayTitle = categoryTitle != null && categoryTitle.isNotEmpty
        ? categoryTitle
        : (catKey.isNotEmpty ? '${catKey[0].toUpperCase()}${catKey.substring(1)}' : 'Fashion');

    return CategoryDetailResponse(
      category: CategoryOverviewModel(
        id: catKey.isNotEmpty ? catKey : 'fashion',
        name: displayTitle,
        description: 'Shop $displayTitle from top verified stores with cashback, coupons and best deals.',
      ),
      subcategories: [
        SubcategoryItemModel(id: 'clothing', name: 'Clothing', icon: 'checkroom', itemCount: '1,200+'),
        SubcategoryItemModel(id: 'footwear', name: 'Footwear', icon: 'roller_skating', itemCount: '850+'),
        SubcategoryItemModel(id: 'accessories', name: 'Accessories', icon: 'watch', itemCount: '420+'),
        SubcategoryItemModel(id: 'men', name: 'Men', icon: 'male', itemCount: '950+'),
        SubcategoryItemModel(id: 'women', name: 'Women', icon: 'female', itemCount: '1,100+'),
      ],
      popularStores: [
        CategoryStoreModel(
          id: 'st-myntra',
          name: 'Myntra',
          logoUrl: 'assets/cards/myntra.jpg',
          cashbackRate: 'Up to 12% Cashback',
          offersCount: '25+ Offers',
          hasCoupons: true,
          actionUrl: 'https://www.myntra.com',
          category: 'Fashion',
        ),
        CategoryStoreModel(
          id: 'st-ajio',
          name: 'AJIO',
          logoUrl: 'assets/cards/ajio-coupons.jpg',
          cashbackRate: 'Up to 10% Cashback',
          offersCount: '20+ Offers',
          hasCoupons: true,
          actionUrl: 'https://www.ajio.com',
          category: 'Fashion',
        ),
        CategoryStoreModel(
          id: 'st-uniqlo',
          name: 'Uniqlo',
          logoUrl: 'assets/cards/uniqlo-coupons.jpg',
          cashbackRate: 'Flat 6% Cashback',
          offersCount: '15+ Offers',
          hasCoupons: true,
          actionUrl: 'https://www.uniqlo.com/in',
          category: 'Fashion',
        ),
        CategoryStoreModel(
          id: 'st-hummel',
          name: 'Hummel',
          logoUrl: 'assets/cards/hummel-coupons.png',
          cashbackRate: 'Up to 25% Cashback',
          offersCount: '18+ Offers',
          hasCoupons: true,
          actionUrl: 'https://hummel.net.in',
          category: 'Sports & Fashion',
        ),
        CategoryStoreModel(
          id: 'st-libas',
          name: 'Libas',
          logoUrl: 'assets/cards/libas-coupons.jpg',
          cashbackRate: 'Up to 7% Cashback',
          offersCount: '12+ Offers',
          hasCoupons: true,
          actionUrl: 'https://www.libas.in',
          category: 'Ethnic Wear',
        ),
        CategoryStoreModel(
          id: 'st-tatacliq',
          name: 'Tata CLiQ',
          logoUrl: 'assets/cards/tatacliq-coupons.png',
          cashbackRate: 'Up to 6% Cashback',
          offersCount: '30+ Offers',
          hasCoupons: true,
          actionUrl: 'https://www.tatacliq.com',
          category: 'Lifestyle',
        ),
      ],
      bestDeals: [
        CategoryDealModel(
          id: 'prod-shirt-1',
          title: "Levi's Regular Fit Denim & Casual Shirt",
          brand: "Levi's",
          store: 'Myntra',
          imageUrl: 'assets/cards/col_myntra.jpg',
          originalPrice: 2999,
          discountedPrice: 1799,
          discountPercentage: 40,
          cashbackPercentage: 10,
          cashbackAmount: 180,
          couponCode: 'LEVI300',
          couponDiscount: 300,
          effectiveSavings: 1500,
          effectivePrice: 1319,
          isBestDeal: true,
          badge: '🏆 Best Deal',
          storesAvailable: ['Myntra', 'AJIO', 'Amazon'],
        ),
        CategoryDealModel(
          id: 'prod-shirt-2',
          title: 'Roadster Pure Cotton Casual Plaid Shirt',
          brand: 'Roadster',
          store: 'AJIO',
          imageUrl: 'assets/cards/col_ajio.jpg',
          originalPrice: 1999,
          discountedPrice: 1299,
          discountPercentage: 35,
          cashbackPercentage: 8,
          cashbackAmount: 104,
          couponCode: 'ROADSTER200',
          couponDiscount: 200,
          effectiveSavings: 900,
          effectivePrice: 995,
          isBestDeal: true,
          badge: '🏆 Top Value',
          storesAvailable: ['AJIO', 'Myntra', 'Flipkart'],
        ),
        CategoryDealModel(
          id: 'prod-1',
          title: 'Nike Air Max 270 React Sneakers',
          brand: 'Nike',
          store: 'Myntra',
          imageUrl: 'assets/banners/sneaker_banner_16_9.jpg',
          originalPrice: 5999,
          discountedPrice: 5500,
          discountPercentage: 22,
          cashbackPercentage: 10,
          cashbackAmount: 350,
          couponCode: 'NIKE500',
          couponDiscount: 500,
          effectiveSavings: 1349,
          effectivePrice: 4650,
          isBestDeal: true,
          badge: '🏆 Best Deal',
          storesAvailable: ['Myntra', 'Amazon', 'Flipkart'],
        ),
      ],
    );
  }

  static SubcategoryDetailResponse getFallbackSubcategoryDetail(
    String categoryId,
    String subcategoryId, {
    String? filter,
    String? style,
  }) {
    final allProducts = [
      const CategoryDealModel(
        id: 'prod-shirt-1',
        title: "Levi's Regular Fit Denim & Casual Shirt",
        brand: "Levi's",
        store: 'Myntra',
        imageUrl: 'assets/cards/col_myntra.jpg',
        originalPrice: 2999,
        discountedPrice: 1799,
        discountPercentage: 40,
        cashbackPercentage: 10,
        cashbackAmount: 180,
        couponCode: 'LEVI300',
        couponDiscount: 300,
        effectiveSavings: 1500,
        effectivePrice: 1319,
        isBestDeal: true,
        badge: '🏆 Best Deal',
        storesAvailable: ['Myntra', 'AJIO', 'Amazon'],
      ),
      const CategoryDealModel(
        id: 'prod-shirt-2',
        title: 'Roadster Pure Cotton Casual Plaid Shirt',
        brand: 'Roadster',
        store: 'AJIO',
        imageUrl: 'assets/cards/col_ajio.jpg',
        originalPrice: 1999,
        discountedPrice: 1299,
        discountPercentage: 35,
        cashbackPercentage: 8,
        cashbackAmount: 104,
        couponCode: 'ROADSTER200',
        couponDiscount: 200,
        effectiveSavings: 900,
        effectivePrice: 995,
        isBestDeal: true,
        badge: '🏆 Top Value',
        storesAvailable: ['AJIO', 'Myntra', 'Flipkart'],
      ),
      const CategoryDealModel(
        id: 'prod-shirt-3',
        title: 'Peter England Premium Formal White Shirt',
        brand: 'Peter England',
        store: 'Amazon',
        imageUrl: 'assets/cards/col_zara.jpg',
        originalPrice: 1799,
        discountedPrice: 1199,
        discountPercentage: 33,
        cashbackPercentage: 6,
        cashbackAmount: 72,
        couponCode: 'FORMAL100',
        couponDiscount: 100,
        effectiveSavings: 700,
        effectivePrice: 1027,
        isBestDeal: false,
        badge: '👔 Formal Pick',
        storesAvailable: ['Amazon', 'Myntra'],
      ),
      const CategoryDealModel(
        id: 'prod-shirt-4',
        title: 'Nike Air Max 270 React Sneakers',
        brand: 'Nike',
        store: 'Myntra',
        imageUrl: 'assets/banners/sneaker_banner_16_9.jpg',
        originalPrice: 5999,
        discountedPrice: 4999,
        discountPercentage: 17,
        cashbackPercentage: 10,
        cashbackAmount: 499,
        couponCode: 'NIKE500',
        couponDiscount: 500,
        effectiveSavings: 1500,
        effectivePrice: 3999,
        isBestDeal: true,
        badge: '✨ Trending',
        storesAvailable: ['Myntra', 'Flipkart'],
      ),
    ];

    return SubcategoryDetailResponse(
      subcategory: const CategoryOverviewModel(
        id: 'clothing',
        name: 'Clothing',
        description: 'Discover best-selling shirts, jeans, dresses and outerwear with cashback.',
      ),
      filters: const ['All', 'Men', 'Women', 'Shirts', 'T-Shirts', 'Jeans', 'Dresses'],
      subFilters: const {
        'Shirts': ['All', 'Casual', 'Formal', 'Men', 'Women', 'Oversized'],
      },
      products: allProducts,
      stores: const [
        CategoryStoreModel(
          id: 'st-myntra',
          name: 'Myntra',
          logoUrl: 'assets/cards/myntra.jpg',
          cashbackRate: 'Up to 12%',
          offersCount: '25+ Offers',
        ),
        CategoryStoreModel(
          id: 'st-ajio',
          name: 'AJIO',
          logoUrl: 'assets/cards/ajio-coupons.jpg',
          cashbackRate: 'Up to 10%',
          offersCount: '20+ Offers',
        ),
      ],
    );
  }

  static SmartProductComparison getFallbackProductComparison(String productId) {
    if (productId == 'prod-shirt-2') {
      return const SmartProductComparison(
        productId: 'prod-shirt-2',
        title: 'Roadster Pure Cotton Casual Plaid Shirt',
        brand: 'Roadster',
        imageUrl: 'assets/cards/col_ajio.jpg',
        category: 'Fashion',
        subcategory: 'Shirts',
        originalPrice: 1999,
        stores: [
          StoreComparisonDetail(
            store: 'AJIO',
            logoUrl: 'assets/cards/ajio-coupons.jpg',
            productPrice: 1499,
            storeDiscount: 200,
            couponDiscount: 200,
            bankDiscount: 104,
            payNow: 995,
            cashback: 104,
            effectiveCost: 891,
            totalSavings: 608,
            isBestDeal: true,
            eligibility: 'All Bank UPI & Cards',
            shopUrl: 'https://www.ajio.com',
          ),
          StoreComparisonDetail(
            store: 'Myntra',
            logoUrl: 'assets/cards/myntra.jpg',
            productPrice: 1599,
            storeDiscount: 150,
            couponDiscount: 150,
            bankDiscount: 50,
            payNow: 1249,
            cashback: 100,
            effectiveCost: 1149,
            totalSavings: 450,
            isBestDeal: false,
            eligibility: 'HDFC Cards',
            shopUrl: 'https://www.myntra.com',
          ),
        ],
        bestDeal: BestDealSummary(
          store: 'AJIO',
          payNow: 995,
          potentialCashback: 104,
          effectiveCost: 891,
          totalSavings: 608,
        ),
        totalSavings: 608,
      );
    }

    if (productId == 'prod-1') {
      return const SmartProductComparison(
        productId: 'prod-1',
        title: 'Nike Air Max 270 React Sneakers',
        brand: 'Nike',
        imageUrl: 'assets/banners/sneaker_banner_16_9.jpg',
        category: 'Shoes',
        subcategory: 'Footwear',
        originalPrice: 5999,
        stores: [
          StoreComparisonDetail(
            store: 'Myntra',
            logoUrl: 'assets/cards/myntra.jpg',
            productPrice: 5500,
            storeDiscount: 499,
            couponDiscount: 500,
            bankDiscount: 0,
            payNow: 5000,
            cashback: 350,
            effectiveCost: 4650,
            totalSavings: 1349,
            isBestDeal: true,
            eligibility: 'All Payments',
            shopUrl: 'https://www.myntra.com',
          ),
          StoreComparisonDetail(
            store: 'Flipkart',
            logoUrl: 'assets/cards/flipkart-electronics.png',
            productPrice: 5400,
            storeDiscount: 599,
            couponDiscount: 300,
            bankDiscount: 0,
            payNow: 5100,
            cashback: 250,
            effectiveCost: 4850,
            totalSavings: 1149,
            isBestDeal: false,
            eligibility: 'Axis Bank',
            shopUrl: 'https://www.flipkart.com',
          ),
          StoreComparisonDetail(
            store: 'Amazon',
            logoUrl: 'assets/cards/amazon.jpg',
            productPrice: 5600,
            storeDiscount: 399,
            couponDiscount: 200,
            bankDiscount: 0,
            payNow: 5400,
            cashback: 300,
            effectiveCost: 5100,
            totalSavings: 899,
            isBestDeal: false,
            eligibility: 'ICICI Amazon Pay',
            shopUrl: 'https://www.amazon.in',
          ),
        ],
        bestDeal: BestDealSummary(
          store: 'Myntra',
          payNow: 5000,
          potentialCashback: 350,
          effectiveCost: 4650,
          totalSavings: 1349,
        ),
        totalSavings: 1349,
      );
    }

    // Default to Levi's Regular Fit Shirt
    return const SmartProductComparison(
      productId: 'prod-shirt-1',
      title: "Levi's Regular Fit Denim & Casual Shirt",
      brand: "Levi's",
      imageUrl: 'assets/cards/col_myntra.jpg',
      category: 'Fashion',
      subcategory: 'Shirts',
      originalPrice: 2999,
      stores: [
        StoreComparisonDetail(
          store: 'Myntra',
          logoUrl: 'assets/cards/myntra.jpg',
          productPrice: 1999,
          storeDiscount: 200,
          couponDiscount: 300,
          bankDiscount: 150,
          payNow: 1349,
          cashback: 200,
          effectiveCost: 1149,
          totalSavings: 850,
          isBestDeal: true,
          eligibility: 'HDFC / ICICI Bank Cards',
          shopUrl: 'https://www.myntra.com',
        ),
        StoreComparisonDetail(
          store: 'AJIO',
          logoUrl: 'assets/cards/ajio-coupons.jpg',
          productPrice: 2099,
          storeDiscount: 200,
          couponDiscount: 250,
          bankDiscount: 100,
          payNow: 1549,
          cashback: 180,
          effectiveCost: 1369,
          totalSavings: 730,
          isBestDeal: false,
          eligibility: 'All Cards',
          shopUrl: 'https://www.ajio.com',
        ),
        StoreComparisonDetail(
          store: 'Amazon',
          logoUrl: 'assets/cards/amazon.jpg',
          productPrice: 2199,
          storeDiscount: 150,
          couponDiscount: 200,
          bankDiscount: 100,
          payNow: 1749,
          cashback: 150,
          effectiveCost: 1599,
          totalSavings: 600,
          isBestDeal: false,
          eligibility: 'Prime Members',
          shopUrl: 'https://www.amazon.in',
        ),
      ],
      bestDeal: BestDealSummary(
        store: 'Myntra',
        payNow: 1349,
        potentialCashback: 200,
        effectiveCost: 1149,
        totalSavings: 850,
      ),
      totalSavings: 850,
    );
  }
}
