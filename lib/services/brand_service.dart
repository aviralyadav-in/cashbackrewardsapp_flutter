import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/brand_model.dart';

class BrandService {
  static const String _assetPath = 'assets/data/brands.json';

  /// Loads list of e-commerce brands dynamically from JSON asset.
  Future<List<BrandModel>> loadBrands() async {
    try {
      final jsonString = await rootBundle.loadString(_assetPath);
      final List<dynamic> jsonList = jsonDecode(jsonString) as List<dynamic>;
      return jsonList
          .map((item) => BrandModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // Fallback data list ensuring application resiliency
      return _fallbackBrands;
    }
  }

  static final List<BrandModel> _fallbackBrands = [
    const BrandModel(
      name: 'Amazon.in',
      logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/a/a9/Amazon_logo.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Up to 8% Cashback',
      category: 'Electronics & Shopping',
      offerText: 'Earn rewards on Electronics, Fashion, Appliances & More',
      websiteUrl: 'https://www.amazon.in',
    ),
    const BrandModel(
      name: 'Myntra',
      logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/b/bc/Myntra_Logo.png',
      bannerUrl: 'https://images.unsplash.com/photo-1483985988355-763728e1935b?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat 7.5% Cashback',
      category: 'Fashion & Lifestyle',
      offerText: 'Huge discounts on Top Fashion Brands + Extra Cashback',
      websiteUrl: 'https://www.myntra.com',
    ),
    const BrandModel(
      name: 'Flipkart',
      logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/7/7a/Flipkart_logo.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Up to 7% Cashback',
      category: 'Mobiles & Mega Sale',
      offerText: 'Best Cashback Deals on Smartphones, Laptops & Home',
      websiteUrl: 'https://www.flipkart.com',
    ),
    const BrandModel(
      name: 'AJIO',
      logoUrl: 'https://assets.ajio.com/static/img/Ajio-Logo.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1445205170230-053b83016050?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat 10% Cashback',
      category: 'Trendy Fashion',
      offerText: 'Exclusive Trends & Designer Collections with Real Rewards',
      websiteUrl: 'https://www.ajio.com',
    ),
    const BrandModel(
      name: 'Meesho',
      logoUrl: 'https://images.meesho.com/images/pow/meeshoLogo.png',
      bannerUrl: 'https://images.unsplash.com/photo-1472851294608-062f824d29cc?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Up to 6% Cashback',
      category: 'Budget Shopping',
      offerText: 'Lowest Prices Guaranteed + Extra Cashback on Orders',
      websiteUrl: 'https://www.meesho.com',
    ),
    const BrandModel(
      name: 'MCaffeine',
      logoUrl: 'https://cdn.shopify.com/s/files/1/1454/5188/files/mcaffeine-logo.png',
      bannerUrl: 'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat 12% Cashback',
      category: 'Personal Care & Skincare',
      offerText: 'Caffeinated Skincare & Body Products with Bonus Cashback',
      websiteUrl: 'https://www.mcaffeine.com',
    ),
    const BrandModel(
      name: 'Dot & Key',
      logoUrl: 'https://www.dotandkey.com/cdn/shop/files/Dot_Key_Logo.png',
      bannerUrl: 'https://images.unsplash.com/photo-1598440947619-2c35fc9aa908?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Up to 15% Cashback',
      category: 'Beauty & Skincare',
      offerText: 'Fruit-forward Skincare Essentials + Highest Cashback',
      websiteUrl: 'https://www.dotandkey.com',
    ),
    const BrandModel(
      name: 'HyugaLife',
      logoUrl: 'https://hyugalife.com/assets/logo.png',
      bannerUrl: 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat 8% Cashback',
      category: 'Health & Supplements',
      offerText: 'Authentic Health Supplements & Protein Drinks with Cashback',
      websiteUrl: 'https://hyugalife.com',
    ),
    const BrandModel(
      name: 'Reliance Digital',
      logoUrl: 'https://www.reliancedigital.in/build/client/images/rel_stat_svg.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1550009158-9ebf69173e03?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Up to 5% Cashback',
      category: 'Tech & Appliances',
      offerText: 'Great Deals on TV, Audio, Refrigerators & Laptops',
      websiteUrl: 'https://www.reliancedigital.in',
    ),
    const BrandModel(
      name: 'Aqualogica',
      logoUrl: 'https://aqualogica.in/cdn/shop/files/Aqualogica_Logo.png',
      bannerUrl: 'https://images.unsplash.com/photo-1571781926291-c477ebfd024b?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat 14% Cashback',
      category: 'Hydrating Skincare',
      offerText: 'Sunscreen & Gel Moisturizers + Special Bonus Rewards',
      websiteUrl: 'https://aqualogica.in',
    ),
  ];
}
