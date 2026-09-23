import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:cashback_reward_app/models/product.dart';
import 'package:cashback_reward_app/providers/home_provider.dart';
import 'package:cashback_reward_app/screens/product_detail_screen.dart';

void main() {
  group('Product Model affiliate & original URL Tests', () {
    test('Product.fromJson parses originalUrl and affiliateUrl correctly', () {
      final json = {
        'id': 123,
        'name': 'Example Product',
        'description': 'Product description',
        'price': 999.0,
        'discountPercentage': 15.0,
        'thumbnail': 'https://example.com/thumb.jpg',
        'originalUrl': 'https://merchant.com/product/123',
        'affiliateUrl': 'https://affiliate-network.com/track/xyz123',
      };

      final product = Product.fromJson(json);

      expect(product.id, equals(123));
      expect(product.title, equals('Example Product'));
      expect(product.originalUrl, equals('https://merchant.com/product/123'));
      expect(product.affiliateUrl, equals('https://affiliate-network.com/track/xyz123'));
    });

    test('Product.fromJson supports alternative keys (snake_case and url)', () {
      final json = {
        'id': 456,
        'title': 'Snake Case Product',
        'description': 'Description',
        'price': 499.0,
        'discountPercentage': 10.0,
        'thumbnail': 'https://example.com/thumb2.jpg',
        'original_url': 'https://merchant.com/product/456',
        'affiliate_url': 'https://affiliate-network.com/track/abc456',
      };

      final product = Product.fromJson(json);

      expect(product.originalUrl, equals('https://merchant.com/product/456'));
      expect(product.affiliateUrl, equals('https://affiliate-network.com/track/abc456'));
    });

    test('Product.fromJson gracefully handles null/missing affiliate and original URLs', () {
      final json = {
        'id': 789,
        'title': 'Standard Product',
        'description': 'Description',
        'price': 299.0,
        'discountPercentage': 0.0,
        'thumbnail': 'https://example.com/thumb3.jpg',
      };

      final product = Product.fromJson(json);

      expect(product.originalUrl, isNull);
      expect(product.affiliateUrl, isNull);
    });

    test('Product.toJson includes originalUrl and affiliateUrl when set', () {
      final product = Product(
        id: 101,
        title: 'Serialized Product',
        description: 'Testing toJson',
        price: 1500.0,
        discountPercentage: 20.0,
        thumbnail: 'https://example.com/thumb.jpg',
        originalUrl: 'https://store.com/item/101',
        affiliateUrl: 'https://track.com/aff/101',
      );

      final map = product.toJson();

      expect(map['originalUrl'], equals('https://store.com/item/101'));
      expect(map['affiliateUrl'], equals('https://track.com/aff/101'));
    });
  });

  group('ProductDetailScreen Action Buttons Widget Tests', () {
    testWidgets('Renders Shop Now and Share & Earn buttons in bottom navigation bar', (tester) async {
      final product = Product(
        id: 1,
        title: 'Premium Wireless Headphones',
        description: 'Noise cancelling Bluetooth headphones with deep bass.',
        price: 2499.0,
        discountPercentage: 25.0,
        thumbnail: 'https://example.com/headphones.jpg',
        brand: 'Sony',
        category: 'Electronics',
        originalUrl: 'https://www.sony.co.in/product/1',
        affiliateUrl: 'https://track.affiliate.com/sony/1',
      );

      await tester.pumpWidget(
        ChangeNotifierProvider<HomeProvider>(
          create: (_) => HomeProvider(),
          child: MaterialApp(
            home: ProductDetailScreen(product: product),
          ),
        ),
      );

      // Verify both buttons are present
      expect(find.text('Shop Now'), findsOneWidget);
      expect(find.text('Share & Earn'), findsOneWidget);
      expect(find.byIcon(Icons.shopping_bag_outlined), findsOneWidget);
      expect(find.byIcon(Icons.share_outlined), findsWidgets);
    });

    testWidgets('Tapping Share & Earn without affiliateUrl shows graceful SnackBar', (tester) async {
      final product = Product(
        id: 2,
        title: 'Basic T-Shirt',
        description: 'Cotton crewneck t-shirt.',
        price: 399.0,
        discountPercentage: 0.0,
        thumbnail: 'https://example.com/shirt.jpg',
        brand: 'Roadster',
        category: 'Fashion',
        originalUrl: 'https://www.myntra.com/tshirt',
        affiliateUrl: null, // No affiliate link
      );

      await tester.pumpWidget(
        ChangeNotifierProvider<HomeProvider>(
          create: (_) => HomeProvider(),
          child: MaterialApp(
            home: ProductDetailScreen(product: product),
          ),
        ),
      );

      // Tap Share & Earn
      await tester.tap(find.text('Share & Earn'));
      await tester.pump();

      // Verify graceful notification is shown without crashing or generating a fake link
      expect(
        find.text('Affiliate link is currently unavailable for this product.'),
        findsOneWidget,
      );
    });
  });
}
