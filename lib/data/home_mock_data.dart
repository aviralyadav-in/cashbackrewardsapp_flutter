import 'package:flutter/material.dart';
import '../models/amazon_deal_model.dart';
import '../models/brand_model.dart';
import '../models/discovery_section_model.dart';
import '../models/subcategory_banner_data.dart';
import '../models/top_category_model.dart';
import '../models/trending_brand_model.dart';
import '../screens/offer_section_screen.dart';

class HomeMockData {
  // =========================================================================
  // PROMOTIONAL BANNERS
  // =========================================================================

  static const SubcategoryBannerData popularBrandsBanner = SubcategoryBannerData(
    brandName: 'Mega Fest',
    headline: 'TOP POPULAR STORES FESTIVAL',
    subText: 'Get Flat 15% Real Cashback across 500+ Top Online Retailers',
    offerTag: 'FLAT 15% CASHBACK',
    buttonText: 'Explore Stores',
    themeColor: Color(0xFF1E90FF),
    lightColor: Color(0xFFCBE2FE),
    logoIcon: Icons.stars_rounded,
  );

  static const SubcategoryBannerData fashionBanner = SubcategoryBannerData(
    brandName: 'Fashion Hub',
    headline: 'SEASON END FASHION SALE',
    subText: 'Up to 80% OFF + Extra 12% Real Cashback on Top Clothing Brands',
    offerTag: 'UP TO 80% OFF',
    buttonText: 'Shop Fashion',
    themeColor: Color(0xFFEC4899),
    lightColor: Color(0xFFFBCFE8),
    logoIcon: Icons.checkroom_rounded,
  );

  static const SubcategoryBannerData trendingBanner = SubcategoryBannerData(
    brandName: 'Trending Zone',
    headline: 'HOT VIRAL DEALS OF THE WEEK',
    subText: 'Grab Extra Rewards on Top Trending & Viral Products',
    offerTag: 'HOT DEALS ⚡',
    buttonText: 'Grab Deals',
    themeColor: Color(0xFF8B5CF6),
    lightColor: Color(0xFFDDD6FE),
    logoIcon: Icons.local_fire_department_rounded,
  );

  static const SubcategoryBannerData beautyBanner = SubcategoryBannerData(
    brandName: 'Beauty Glam',
    headline: 'GLOW & CARE BEAUTY DAYS',
    subText: 'Flat 50% OFF + Extra 15% Rewards on Skincare & Makeup',
    offerTag: 'FLAT 50% OFF',
    buttonText: 'Shop Beauty',
    themeColor: Color(0xFFF43F5E),
    lightColor: Color(0xFFFECDD3),
    logoIcon: Icons.spa_rounded,
  );

  static const SubcategoryBannerData lifetimeCardsBanner = SubcategoryBannerData(
    brandName: 'Free Cards',
    headline: 'ZERO ANNUAL FEE CREDIT CARDS',
    subText: 'Get Lifetime Free Card + Free ₹1,500 Amazon Gift Voucher',
    offerTag: 'FREE ₹1,500 VOUCHER',
    buttonText: 'Apply Card',
    themeColor: Color(0xFFD97706),
    lightColor: Color(0xFFFDE68A),
    logoIcon: Icons.credit_card_rounded,
  );

  static const SubcategoryBannerData electronicsBanner = SubcategoryBannerData(
    brandName: 'Tech Zone',
    headline: 'MEGA GADGET & TECH SALE',
    subText: 'Up to 60% OFF + Flat ₹3,000 Extra Cashback on Laptops & Phones',
    offerTag: 'UP TO 60% OFF',
    buttonText: 'Shop Electronics',
    themeColor: Color(0xFF0D9488),
    lightColor: Color(0xFF99F6E4),
    logoIcon: Icons.devices_rounded,
  );

  static const SubcategoryBannerData shoppingCardsBanner = SubcategoryBannerData(
    brandName: 'Shopping Cards',
    headline: '5% UNLIMITED SHOPPING CASHBACK',
    subText: 'Earn Unlimited Cashback on Amazon, Flipkart, Zomato & More',
    offerTag: '5% UNLIMITED',
    buttonText: 'Get Card',
    themeColor: Color(0xFFEA580C),
    lightColor: Color(0xFFFED7AA),
    logoIcon: Icons.shopping_bag_rounded,
  );

  static const SubcategoryBannerData medicineBanner = SubcategoryBannerData(
    brandName: 'Health Care',
    headline: 'HEALTH & WELLNESS SAVINGS',
    subText: 'Flat 25% OFF Medicines + Extra 10% Cashback & Free Delivery',
    offerTag: 'FLAT 25% OFF',
    buttonText: 'Order Medicines',
    themeColor: Color(0xFF059669),
    lightColor: Color(0xFFA7F3D0),
    logoIcon: Icons.medical_services_rounded,
  );

  static const SubcategoryBannerData cardsLoansBanner = SubcategoryBannerData(
    brandName: 'Credit & Loans',
    headline: 'QUICK APPROVAL LOANS & CARDS',
    subText: 'Low Interest Rates + Flat ₹2,000 Gift Voucher on Approval',
    offerTag: 'INSTANT APPROVAL',
    buttonText: 'Check Loan',
    themeColor: Color(0xFF4F46E5),
    lightColor: Color(0xFFC7D2FE),
    logoIcon: Icons.account_balance_rounded,
  );

  static const SubcategoryBannerData hotelBookingBanner = SubcategoryBannerData(
    brandName: 'Travel Deals',
    headline: 'WANDERLUST HOTEL DEALS',
    subText: 'Up to 50% OFF Hotel Stays + Extra ₹1,000 Cashback on Bookings',
    offerTag: 'UP TO 50% OFF',
    buttonText: 'Book Hotels',
    themeColor: Color(0xFF2563EB),
    lightColor: Color(0xFFBAE6FD),
    logoIcon: Icons.hotel_rounded,
  );

  static const SubcategoryBannerData personalLoansBanner = SubcategoryBannerData(
    brandName: 'Personal Loans',
    headline: 'FLEXIBLE PERSONAL LOANS',
    subText: 'Paperless Approval in 5 Mins + Flat ₹1,500 Real Cash Reward',
    offerTag: 'PAPERLESS 5 MINS',
    buttonText: 'Apply Loan',
    themeColor: Color(0xFF65A30D),
    lightColor: Color(0xFFD9F99D),
    logoIcon: Icons.request_quote_rounded,
  );

  static const SubcategoryBannerData luxuryBanner = SubcategoryBannerData(
    brandName: 'Luxury Designer',
    headline: 'LUXURY MADE AFFORDABLE',
    subText: 'Up to 60% OFF Designer Labels + Extra Real Cash Rewards',
    offerTag: 'UP TO 60% OFF',
    buttonText: 'Shop Luxury',
    themeColor: Color(0xFF7C3AED),
    lightColor: Color(0xFFEDE9FE),
    logoIcon: Icons.diamond_rounded,
  );

  static const SubcategoryBannerData amazonDealsBanner = SubcategoryBannerData(
    brandName: 'Amazon Deals',
    headline: 'CashKaroBACK DEALS',
    subText: 'Extra Cashback on Daily Essentials, Electronics & Appliances',
    offerTag: 'SUPER CASHBACK',
    buttonText: 'Shop Amazon',
    themeColor: Color(0xFFD97706),
    lightColor: Color(0xFFFED7AA),
    logoIcon: Icons.shopping_cart_rounded,
  );

  static const SubcategoryBannerData flipkartBanner = SubcategoryBannerData(
    brandName: 'Flipkart Sale',
    headline: 'FLIPKART FREEDOM MEGA SAVINGS',
    subText: 'Up to 80% OFF on Top Brands + Extra 10% Instant Real Cashback',
    offerTag: 'EXTRA 10% CASHBACK',
    buttonText: 'Shop Flipkart',
    themeColor: Color(0xFF2874F0),
    lightColor: Color(0xFFDBEAFE),
    logoIcon: Icons.shopping_bag_rounded,
  );

  static const SubcategoryBannerData meeshoBanner = SubcategoryBannerData(
    brandName: 'Meesho Deals',
    headline: 'BUDGET DEALS STARTING AT ₹99',
    subText: 'Lowest Prices Guaranteed + Flat ₹150 Extra Reward on First Orders',
    offerTag: 'FLAT ₹150 REWARD',
    buttonText: 'Explore Meesho',
    themeColor: Color(0xFFD946EF),
    lightColor: Color(0xFFFAE8FF),
    logoIcon: Icons.local_offer_rounded,
  );

  static const SubcategoryBannerData bestOfLoansBanner = SubcategoryBannerData(
    brandName: 'Best Loans',
    headline: 'LOWEST INTEREST LOAN OFFERS',
    subText: 'Instant Approval with Zero Processing Fee + ₹2,500 Gift Voucher',
    offerTag: 'ZERO PROCESSING FEE',
    buttonText: 'Check Loan Offers',
    themeColor: Color(0xFF0F766E),
    lightColor: Color(0xFFCCFBF1),
    logoIcon: Icons.account_balance_rounded,
  );

  // =========================================================================
  // BRAND CATALOGS
  // =========================================================================

  static const List<BrandModel> popularBrandsCatalog = [
    BrandModel(
      name: 'Amazon.in',
      logoUrl: 'assets/logos/amazon.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Up to 8% Rewards',
      category: 'Popular',
      offerText: 'Up to 80% Off',
      websiteUrl: 'https://www.amazon.in',
    ),
    BrandModel(
      name: 'Flipkart',
      logoUrl: 'assets/logos/flipkart.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Up to 7% Rewards',
      category: 'Popular',
      offerText: 'Up to 75% Off',
      websiteUrl: 'https://www.flipkart.com',
    ),
    BrandModel(
      name: 'Meesho',
      logoUrl: 'assets/logos/meesho.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1584992236310-6edddc08acff?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Up to 15% Rewards',
      category: 'Popular',
      offerText: 'Deals from ₹99',
      websiteUrl: 'https://www.meesho.com',
    ),
    BrandModel(
      name: 'Myntra',
      logoUrl: 'assets/logos/myntra.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1483985988355-763728e1935b?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat 7.5% Rewards',
      category: 'Popular',
      offerText: 'Up to 60% Off',
      websiteUrl: 'https://www.myntra.com',
    ),
    BrandModel(
      name: 'AJIO',
      logoUrl: 'assets/logos/ajio.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1445205170230-053b83016050?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat 10% Rewards',
      category: 'Popular',
      offerText: 'Flat 50% Off',
      websiteUrl: 'https://www.ajio.com',
    ),
    BrandModel(
      name: 'Nykaa',
      logoUrl: 'assets/logos/nykaa.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Up to 8% Rewards',
      category: 'Popular',
      offerText: 'Up to 50% Off',
      websiteUrl: 'https://www.nykaa.com',
    ),
    BrandModel(
      name: 'Croma',
      logoUrl: 'assets/logos/croma.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1550009158-9ebf69173e03?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat 6% Rewards',
      category: 'Popular',
      offerText: 'Up to 45% Off',
      websiteUrl: 'https://www.croma.com',
    ),
    BrandModel(
      name: 'Tata CLiQ',
      logoUrl: 'assets/logos/tatacliq.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat 8% Rewards',
      category: 'Popular',
      offerText: 'Up to 60% Off',
      websiteUrl: 'https://www.tatacliq.com',
    ),
    BrandModel(
      name: 'Reliance Digital',
      logoUrl: 'assets/logos/reliancedigital.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Up to 5% Rewards',
      category: 'Popular',
      offerText: 'Up to 40% Off',
      websiteUrl: 'https://www.reliancedigital.in',
    ),
    BrandModel(
      name: 'Snapdeal',
      logoUrl: 'assets/logos/snapdeal.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1472851294608-062f824d29cc?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat 9% Rewards',
      category: 'Popular',
      offerText: 'Up to 70% Off',
      websiteUrl: 'https://www.snapdeal.com',
    ),
    BrandModel(
      name: 'Shopsy',
      logoUrl: 'assets/logos/shopsy.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1555529669-e69e7aa0ba9a?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat 12% Rewards',
      category: 'Popular',
      offerText: 'Deals from ₹49',
      websiteUrl: 'https://www.shopsy.in',
    ),
    BrandModel(
      name: 'Samsung',
      logoUrl: 'assets/logos/samsung.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Up to 9% Rewards',
      category: 'Popular',
      offerText: 'Up to 50% Off',
      websiteUrl: 'https://www.samsung.com/in',
    ),
  ];

  static const List<BrandModel> fashionBrandsCatalog = [
    BrandModel(
      name: 'Myntra',
      logoUrl: 'assets/logos/myntra.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1483985988355-763728e1935b?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat 7.5% Cashback',
      category: 'Fashion',
      offerText: 'Up to 70% Off',
      websiteUrl: 'https://www.myntra.com',
    ),
    BrandModel(
      name: 'AJIO',
      logoUrl: 'assets/logos/ajio.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1445205170230-053b83016050?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat 10% Cashback',
      category: 'Fashion',
      offerText: 'Up to 60% Off',
      websiteUrl: 'https://www.ajio.com',
    ),
    BrandModel(
      name: 'Nike',
      logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/a/a6/Logo_NIKE.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Up to 9% Cashback',
      category: 'Fashion',
      offerText: 'Up to 40% Off',
      websiteUrl: 'https://www.nike.com/in',
    ),
    BrandModel(
      name: 'H&M',
      logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/5/53/H%26M-Logo.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1490481651871-ab68de25d43d?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat 8% Cashback',
      category: 'Fashion',
      offerText: 'Up to 50% Off',
      websiteUrl: 'https://www2.hm.com/en_in',
    ),
    BrandModel(
      name: 'Zara',
      logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/f/fd/Zara_Logo.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Up to 6% Cashback',
      category: 'Fashion',
      offerText: 'Up to 30% Off',
      websiteUrl: 'https://www.zara.com/in',
    ),
    BrandModel(
      name: 'ASOS',
      logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/a/a9/Amazon_logo.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1483985988355-763728e1935b?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Up to 8% Cashback',
      category: 'Fashion',
      offerText: 'Up to 50% Off',
      websiteUrl: 'https://www.asos.com',
    ),
  ];

  static const List<TrendingBannerItemData> trendingBannerCatalog = [
    TrendingBannerItemData(
      brand: BrandModel(
        name: 'Amazon.in',
        logoUrl: 'assets/logos/amazon.svg',
        bannerUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=800&auto=format&fit=crop&q=80',
        cashbackPercentage: 'Up to 8% Rewards',
        category: 'E-Commerce',
        offerText: 'Up to 80% Off',
        websiteUrl: 'https://www.amazon.in',
      ),
      tagline: 'Great Freedom Festival & Deals',
    ),
    TrendingBannerItemData(
      brand: BrandModel(
        name: 'Flipkart',
        logoUrl: 'assets/logos/flipkart.svg',
        bannerUrl: 'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?w=800&auto=format&fit=crop&q=80',
        cashbackPercentage: 'Up to 7% Rewards',
        category: 'E-Commerce',
        offerText: 'Up to 75% Off',
        websiteUrl: 'https://www.flipkart.com',
      ),
      tagline: 'Big Billion Days & Electronics',
    ),
    TrendingBannerItemData(
      brand: BrandModel(
        name: 'Myntra',
        logoUrl: 'assets/logos/myntra.svg',
        bannerUrl: 'https://images.unsplash.com/photo-1483985988355-763728e1935b?w=800&auto=format&fit=crop&q=80',
        cashbackPercentage: 'Flat 7.5% Rewards',
        category: 'E-Commerce',
        offerText: 'Up to 70% Off',
        websiteUrl: 'https://www.myntra.com',
      ),
      tagline: 'End of Reason Sale Deals',
    ),
    TrendingBannerItemData(
      brand: BrandModel(
        name: 'AJIO',
        logoUrl: 'assets/logos/ajio.svg',
        bannerUrl: 'https://images.unsplash.com/photo-1445205170230-053b83016050?w=800&auto=format&fit=crop&q=80',
        cashbackPercentage: 'Flat 10% Rewards',
        category: 'E-Commerce',
        offerText: 'Flat 50% Off',
        websiteUrl: 'https://www.ajio.com',
      ),
      tagline: 'Trends & International Fashion',
    ),
    TrendingBannerItemData(
      brand: BrandModel(
        name: 'Meesho',
        logoUrl: 'assets/logos/meesho.svg',
        bannerUrl: 'https://images.unsplash.com/photo-1472851294608-062f824d29cc?w=800&auto=format&fit=crop&q=80',
        cashbackPercentage: 'Up to 6% Rewards',
        category: 'E-Commerce',
        offerText: 'Up to 60% Off',
        websiteUrl: 'https://www.meesho.com',
      ),
      tagline: 'Lowest Price Quality Deals',
    ),
    TrendingBannerItemData(
      brand: BrandModel(
        name: 'Tata CLiQ',
        logoUrl: 'assets/logos/tatacliq.svg',
        bannerUrl: 'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=800&auto=format&fit=crop&q=80',
        cashbackPercentage: 'Up to 8% Rewards',
        category: 'E-Commerce',
        offerText: 'Up to 50% Off',
        websiteUrl: 'https://www.tatacliq.com',
      ),
      tagline: 'Luxury Fashion & Electronics',
    ),
    TrendingBannerItemData(
      brand: BrandModel(
        name: 'Nykaa',
        logoUrl: 'assets/logos/nykaa.svg',
        bannerUrl: 'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=800&auto=format&fit=crop&q=80',
        cashbackPercentage: 'Up to 8% Rewards',
        category: 'Beauty',
        offerText: 'Up to 50% Off',
        websiteUrl: 'https://www.nykaa.com',
      ),
      tagline: 'Pink Friday Beauty & Cosmetics',
    ),
    TrendingBannerItemData(
      brand: BrandModel(
        name: 'Croma',
        logoUrl: 'assets/logos/croma.svg',
        bannerUrl: 'https://images.unsplash.com/photo-1526738549149-8e07eca6c147?w=800&auto=format&fit=crop&q=80',
        cashbackPercentage: 'Flat 6% Rewards',
        category: 'Electronics',
        offerText: 'Up to 50% Off',
        websiteUrl: 'https://www.croma.com',
      ),
      tagline: 'Electronics & Home Appliances',
    ),
    TrendingBannerItemData(
      brand: BrandModel(
        name: 'Reliance Digital',
        logoUrl: 'assets/logos/reliancedigital.svg',
        bannerUrl: 'https://images.unsplash.com/photo-1550009158-9ebf69173e03?w=800&auto=format&fit=crop&q=80',
        cashbackPercentage: 'Up to 5% Rewards',
        category: 'Electronics',
        offerText: 'Up to 45% Off',
        websiteUrl: 'https://www.reliancedigital.in',
      ),
      tagline: 'Digital India Tech Deals',
    ),
    TrendingBannerItemData(
      brand: BrandModel(
        name: 'Snapdeal',
        logoUrl: 'assets/logos/snapdeal.svg',
        bannerUrl: 'https://images.unsplash.com/photo-1472851294608-062f824d29cc?w=800&auto=format&fit=crop&q=80',
        cashbackPercentage: 'Up to 7% Rewards',
        category: 'E-Commerce',
        offerText: 'Up to 65% Off',
        websiteUrl: 'https://www.snapdeal.com',
      ),
      tagline: 'Daily Bargains & Essentials',
    ),
    TrendingBannerItemData(
      brand: BrandModel(
        name: 'Nike',
        logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/a/a6/Logo_NIKE.svg',
        bannerUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800&auto=format&fit=crop&q=80',
        cashbackPercentage: 'Up to 9% Rewards',
        category: 'Fashion',
        offerText: 'Up to 40% Off',
        websiteUrl: 'https://www.nike.com/in',
      ),
      tagline: 'Air Jordan & Sportswear Drops',
    ),
    TrendingBannerItemData(
      brand: BrandModel(
        name: 'Adidas',
        logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/2/20/Adidas_Logo.svg',
        bannerUrl: 'https://images.unsplash.com/photo-1518002171953-a080ee817e1f?w=800&auto=format&fit=crop&q=80',
        cashbackPercentage: 'Up to 8% Rewards',
        category: 'Fashion',
        offerText: 'Up to 45% Off',
        websiteUrl: 'https://www.adidas.co.in',
      ),
      tagline: 'Originals & Running Sneakers',
    ),
    TrendingBannerItemData(
      brand: BrandModel(
        name: 'H&M',
        logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/5/53/H%26M-Logo.svg',
        bannerUrl: 'https://images.unsplash.com/photo-1490481651871-ab68de25d43d?w=800&auto=format&fit=crop&q=80',
        cashbackPercentage: 'Flat 8% Rewards',
        category: 'Fashion',
        offerText: 'Up to 50% Off',
        websiteUrl: 'https://www2.hm.com/en_in',
      ),
      tagline: 'Sustainable High Fashion',
    ),
    TrendingBannerItemData(
      brand: BrandModel(
        name: 'Zara',
        logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/f/fd/Zara_Logo.svg',
        bannerUrl: 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=800&auto=format&fit=crop&q=80',
        cashbackPercentage: 'Up to 6% Rewards',
        category: 'Fashion',
        offerText: 'Up to 30% Off',
        websiteUrl: 'https://www.zara.com/in',
      ),
      tagline: 'New Seasonal Outfits & Trends',
    ),
    TrendingBannerItemData(
      brand: BrandModel(
        name: 'Sephora',
        logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/2/21/Sephora_logo.svg',
        bannerUrl: 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?w=800&auto=format&fit=crop&q=80',
        cashbackPercentage: 'Flat 10% Rewards',
        category: 'Beauty',
        offerText: 'Up to 40% Off',
        websiteUrl: 'https://sephora.in',
      ),
      tagline: 'Premium Cosmetics & Skincare',
    ),
    TrendingBannerItemData(
      brand: BrandModel(
        name: 'Etsy',
        logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/a/a9/Amazon_logo.svg',
        bannerUrl: 'https://images.unsplash.com/photo-1513519245088-0e12902e5a38?w=800&auto=format&fit=crop&q=80',
        cashbackPercentage: 'Up to 5% Rewards',
        category: 'Global',
        offerText: 'Up to 30% Off',
        websiteUrl: 'https://www.etsy.com',
      ),
      tagline: 'Handcrafted & Unique Gifts',
    ),
    TrendingBannerItemData(
      brand: BrandModel(
        name: 'eBay',
        logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/1/1b/EBay_logo.svg',
        bannerUrl: 'https://images.unsplash.com/photo-1526738549149-8e07eca6c147?w=800&auto=format&fit=crop&q=80',
        cashbackPercentage: 'Up to 4% Rewards',
        category: 'Global',
        offerText: 'Global Deals',
        websiteUrl: 'https://www.ebay.com',
      ),
      tagline: 'Refurbished Tech & Collectibles',
    ),
    TrendingBannerItemData(
      brand: BrandModel(
        name: 'Walmart',
        logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/c/ca/Walmart_logo.svg',
        bannerUrl: 'https://images.unsplash.com/photo-1578916171728-46686eac8d58?w=800&auto=format&fit=crop&q=80',
        cashbackPercentage: 'Up to 5% Rewards',
        category: 'Global',
        offerText: 'Rollback Prices',
        websiteUrl: 'https://www.walmart.com',
      ),
      tagline: 'Everyday Low Prices & Savings',
    ),
    TrendingBannerItemData(
      brand: BrandModel(
        name: 'Best Buy',
        logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/f/f5/Best_Buy_Logo.svg',
        bannerUrl: 'https://images.unsplash.com/photo-1550009158-9ebf69173e03?w=800&auto=format&fit=crop&q=80',
        cashbackPercentage: 'Up to 6% Rewards',
        category: 'Global',
        offerText: 'Tech Outlet Sale',
        websiteUrl: 'https://www.bestbuy.com',
      ),
      tagline: 'Expert Electronics & Gadgets',
    ),
    TrendingBannerItemData(
      brand: BrandModel(
        name: 'Target',
        logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/c/c5/Target_Corporation_logo_vector.svg',
        bannerUrl: 'https://images.unsplash.com/photo-1472851294608-062f824d29cc?w=800&auto=format&fit=crop&q=80',
        cashbackPercentage: 'Up to 5% Rewards',
        category: 'Global',
        offerText: 'Target Circle Deals',
        websiteUrl: 'https://www.target.com',
      ),
      tagline: 'Style, Home & Daily Essentials',
    ),
  ];

  static const List<BrandModel> beautyBrandsCatalog = [
    BrandModel(
      name: 'Nykaa',
      logoUrl: 'assets/logos/nykaa.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Up to 8% Cashback',
      category: 'Beauty',
      offerText: 'Up to 50% Off',
      websiteUrl: 'https://www.nykaa.com',
    ),
    BrandModel(
      name: 'Sephora',
      logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/2/21/Sephora_logo.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat 10% Cashback',
      category: 'Beauty',
      offerText: 'Up to 40% Off',
      websiteUrl: 'https://sephora.in',
    ),
    BrandModel(
      name: 'Mamaearth',
      logoUrl: 'assets/logos/mamaearth.svg',
      bannerUrl: 'assets/logos/mamaearth.svg',
      cashbackPercentage: 'Flat 12% Cashback',
      category: 'Beauty',
      offerText: 'Buy 1 Get 1 Free',
      websiteUrl: 'https://mamaearth.in',
    ),
    BrandModel(
      name: 'Plum Goodness',
      logoUrl: 'assets/logos/plum.svg',
      bannerUrl: 'assets/logos/plum.svg',
      cashbackPercentage: 'Up to 15% Cashback',
      category: 'Beauty',
      offerText: 'Flat 30% Off',
      websiteUrl: 'https://plumgoodness.com',
    ),
    BrandModel(
      name: 'Minimalist',
      logoUrl: 'assets/logos/minimalist.svg',
      bannerUrl: 'assets/logos/minimalist.svg',
      cashbackPercentage: 'Flat 10% Cashback',
      category: 'Beauty',
      offerText: 'Flat ₹100 Off',
      websiteUrl: 'https://beminimalist.co',
    ),
    BrandModel(
      name: 'Sugar Cosmetics',
      logoUrl: 'assets/logos/sugarcosmetics.svg',
      bannerUrl: 'assets/logos/sugarcosmetics.svg',
      cashbackPercentage: 'Up to 12% Cashback',
      category: 'Beauty',
      offerText: 'Up to 45% Off',
      websiteUrl: 'https://sugarcosmetics.com',
    ),
  ];

  static const List<BrandModel> lifetimeFreeCardsCatalog = [
    BrandModel(
      name: 'HDFC Freedom',
      logoUrl: 'assets/logos/hdfc_cashback.svg',
      bannerUrl: 'assets/logos/hdfc_cashback.svg',
      cashbackPercentage: 'Flat ₹1,500 Bonus',
      category: 'Cards',
      offerText: 'Lifetime Free Card',
      websiteUrl: 'https://www.hdfcbank.com',
    ),
    BrandModel(
      name: 'SBI SimplyCLICK',
      logoUrl: 'assets/logos/sbi_simplyclick.svg',
      bannerUrl: 'assets/logos/sbi_simplyclick.svg',
      cashbackPercentage: 'Flat ₹1,200 Cashback',
      category: 'Cards',
      offerText: 'Zero Annual Fee',
      websiteUrl: 'https://www.sbicard.com',
    ),
    BrandModel(
      name: 'Axis MyZone',
      logoUrl: 'assets/logos/axis_myzone.svg',
      bannerUrl: 'assets/logos/axis_myzone.svg',
      cashbackPercentage: 'Flat ₹1,500 Cashback',
      category: 'Cards',
      offerText: 'Lifetime Free Card',
      websiteUrl: 'https://www.axisbank.com',
    ),
    BrandModel(
      name: 'ICICI Amazon Pay',
      logoUrl: 'assets/logos/icici_amazonpay.svg',
      bannerUrl: 'assets/logos/icici_amazonpay.svg',
      cashbackPercentage: 'Flat ₹1,000 Rewards',
      category: 'Cards',
      offerText: 'Zero Joining Fee',
      websiteUrl: 'https://www.icicibank.com',
    ),
    BrandModel(
      name: 'IDFC Millennia',
      logoUrl: 'assets/logos/idfc_millennia.svg',
      bannerUrl: 'assets/logos/idfc_millennia.svg',
      cashbackPercentage: 'Flat ₹1,000 Bonus',
      category: 'Cards',
      offerText: 'Lifetime Free Card',
      websiteUrl: 'https://www.idfcfirstbank.com',
    ),
    BrandModel(
      name: 'OneCard Credit',
      logoUrl: 'assets/logos/onecard.svg',
      bannerUrl: 'assets/logos/onecard.svg',
      cashbackPercentage: 'Flat ₹800 Cashback',
      category: 'Cards',
      offerText: 'Metal Card Free',
      websiteUrl: 'https://getonecard.app',
    ),
  ];

  static const List<BrandModel> electronicsBrandsCatalog = [
    BrandModel(
      name: 'Amazon',
      logoUrl: 'assets/logos/amazon.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Up to 6% Cashback',
      category: 'Electronics',
      offerText: 'Up to 65% Off',
      websiteUrl: 'https://www.amazon.in',
    ),
    BrandModel(
      name: 'Flipkart',
      logoUrl: 'assets/logos/flipkart.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Up to 7% Cashback',
      category: 'Electronics',
      offerText: 'Up to 70% Off',
      websiteUrl: 'https://www.flipkart.com',
    ),
    BrandModel(
      name: 'Croma',
      logoUrl: 'assets/logos/croma.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1526738549149-8e07eca6c147?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat 6% Cashback',
      category: 'Electronics',
      offerText: 'Up to 50% Off',
      websiteUrl: 'https://www.croma.com',
    ),
    BrandModel(
      name: 'Apple Store',
      logoUrl: 'assets/logos/apple.svg',
      bannerUrl: 'assets/logos/apple.svg',
      cashbackPercentage: 'Up to 4% Cashback',
      category: 'Electronics',
      offerText: 'Save up to ₹10,000',
      websiteUrl: 'https://www.apple.com/in',
    ),
    BrandModel(
      name: 'Samsung',
      logoUrl: 'assets/logos/samsung.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Up to 8% Cashback',
      category: 'Electronics',
      offerText: 'Up to 55% Off',
      websiteUrl: 'https://www.samsung.com/in',
    ),
    BrandModel(
      name: 'Reliance Digital',
      logoUrl: 'assets/logos/reliancedigital.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1550009158-9ebf69173e03?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Up to 5% Cashback',
      category: 'Electronics',
      offerText: 'Up to 45% Off',
      websiteUrl: 'https://www.reliancedigital.in',
    ),
  ];

  static const List<BrandModel> shoppingCardsCatalog = [
    BrandModel(
      name: 'HDFC Millennia',
      logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/2/28/HDFC_Bank_Logo.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1559526324-4b87b5e36e44?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat ₹1,500 Bonus',
      category: 'Shopping Cards',
      offerText: '5% Online Cashback',
      websiteUrl: 'https://www.hdfcbank.com',
    ),
    BrandModel(
      name: 'SBI CashCard',
      logoUrl: 'assets/logos/sbi_cashcard.svg',
      bannerUrl: 'assets/logos/sbi_cashcard.svg',
      cashbackPercentage: 'Flat ₹1,200 Cashback',
      category: 'Shopping Cards',
      offerText: '5% Unlimited Online',
      websiteUrl: 'https://www.sbicard.com',
    ),
    BrandModel(
      name: 'Axis Flipkart Card',
      logoUrl: 'assets/logos/axis_flipkart.svg',
      bannerUrl: 'assets/logos/axis_flipkart.svg',
      cashbackPercentage: 'Flat ₹1,500 Cashback',
      category: 'Shopping Cards',
      offerText: '5% Flipkart Cashback',
      websiteUrl: 'https://www.axisbank.com',
    ),
    BrandModel(
      name: 'ICICI Amazon Pay',
      logoUrl: 'assets/logos/icici_amazonpay.svg',
      bannerUrl: 'assets/logos/icici_amazonpay.svg',
      cashbackPercentage: 'Flat ₹1,000 Rewards',
      category: 'Shopping Cards',
      offerText: '5% Amazon Cashback',
      websiteUrl: 'https://www.icicibank.com',
    ),
    BrandModel(
      name: 'HDFC Cashback',
      logoUrl: 'assets/logos/hdfc_cashback.svg',
      bannerUrl: 'assets/logos/hdfc_cashback.svg',
      cashbackPercentage: 'Flat ₹1,200 Bonus',
      category: 'Shopping Cards',
      offerText: '10% Dining Cashback',
      websiteUrl: 'https://www.hdfcbank.com',
    ),
    BrandModel(
      name: 'StanChart Smart',
      logoUrl: 'assets/logos/stanchart_smart.svg',
      bannerUrl: 'assets/logos/stanchart_smart.svg',
      cashbackPercentage: 'Flat ₹1,000 Bonus',
      category: 'Shopping Cards',
      offerText: '2% Online Cashback',
      websiteUrl: 'https://www.sc.com/in',
    ),
  ];

  static const List<BrandModel> medicineBrandsCatalog = [
    BrandModel(
      name: 'Tata 1mg',
      logoUrl: 'assets/logos/tata1mg.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat 12% Cashback',
      category: 'Medicines',
      offerText: 'Up to 25% Off',
      websiteUrl: 'https://www.1mg.com',
    ),
    BrandModel(
      name: 'PharmEasy',
      logoUrl: 'assets/logos/pharmeasy.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1471864190281-a93a3070b6de?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Up to 15% Cashback',
      category: 'Medicines',
      offerText: 'Up to 30% Off',
      websiteUrl: 'https://www.pharmeasy.in',
    ),
    BrandModel(
      name: 'Netmeds',
      logoUrl: 'assets/logos/tata1mg.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1587854692152-cbe660dbde88?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat 10% Cashback',
      category: 'Medicines',
      offerText: 'Flat 20% Off',
      websiteUrl: 'https://www.netmeds.com',
    ),
    BrandModel(
      name: 'Apollo Pharmacy',
      logoUrl: 'assets/logos/apollopharmacy.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1579722821273-0f6c7d44362f?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Up to 8% Cashback',
      category: 'Medicines',
      offerText: 'Up to 15% Off',
      websiteUrl: 'https://www.apollopharmacy.in',
    ),
    BrandModel(
      name: 'HealthKart',
      logoUrl: 'assets/logos/tata1mg.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1517838277536-f5f99be501cd?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Up to 10% Cashback',
      category: 'Medicines',
      offerText: 'Up to 40% Off',
      websiteUrl: 'https://www.healthkart.com',
    ),
    BrandModel(
      name: 'PharmEasy Lab',
      logoUrl: 'assets/logos/pharmeasy.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1579154204601-01588f351e67?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat ₹500 Cashback',
      category: 'Medicines',
      offerText: 'Flat 70% Off Labs',
      websiteUrl: 'https://www.pharmeasy.in',
    ),
  ];

  static const List<BrandModel> cardsAndLoansCatalog = [
    BrandModel(
      name: 'MoneyTap Line',
      logoUrl: 'assets/logos/moneytap.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1563013544-824ae1b704d3?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat ₹1,000 Bonus',
      category: 'Cards & Loans',
      offerText: 'Credit Line ₹5 Lakhs',
      websiteUrl: 'https://www.moneytap.com',
    ),
    BrandModel(
      name: 'Navi Financial',
      logoUrl: 'assets/logos/navi.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1579621970563-ebec7560ff3e?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat ₹1,200 Cashback',
      category: 'Cards & Loans',
      offerText: 'Instant Cash Loans',
      websiteUrl: 'https://navi.com',
    ),
    BrandModel(
      name: 'KreditBee',
      logoUrl: 'assets/logos/moneytap.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1601597111158-2fceff292cdc?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat ₹800 Cashback',
      category: 'Cards & Loans',
      offerText: 'Personal Credit Line',
      websiteUrl: 'https://www.kreditbee.in',
    ),
    BrandModel(
      name: 'Bajaj Finserv',
      logoUrl: 'assets/logos/bajajfinserv.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1559526324-4b87b5e36e44?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat ₹1,500 Bonus',
      category: 'Cards & Loans',
      offerText: 'Insta EMI Card Free',
      websiteUrl: 'https://www.bajajfinserv.in',
    ),
    BrandModel(
      name: 'Tata Capital',
      logoUrl: 'assets/logos/tatacapital.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1554224155-8d04cb21cd6c?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat ₹1,200 Rewards',
      category: 'Cards & Loans',
      offerText: 'Quick Loan Approval',
      websiteUrl: 'https://www.tatacapital.com',
    ),
    BrandModel(
      name: 'CASHe Credit',
      logoUrl: 'assets/logos/navi.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1556742049-0a67dd385203?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat ₹1,000 Cashback',
      category: 'Cards & Loans',
      offerText: 'Instant Credit Line',
      websiteUrl: 'https://www.cashe.co.in',
    ),
  ];

  static const List<BrandModel> hotelBookingCatalog = [
    BrandModel(
      name: 'MakeMyTrip',
      logoUrl: 'assets/logos/makemytrip.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1436491865332-7a61a109cc05?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat 8% Cashback',
      category: 'Travel',
      offerText: 'Up to 35% Off',
      websiteUrl: 'https://www.makemytrip.com',
    ),
    BrandModel(
      name: 'Booking.com',
      logoUrl: 'assets/logos/booking.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Up to 9% Cashback',
      category: 'Travel',
      offerText: 'Up to 40% Off',
      websiteUrl: 'https://www.booking.com',
    ),
    BrandModel(
      name: 'Agoda',
      logoUrl: 'assets/logos/agoda.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat 10% Cashback',
      category: 'Travel',
      offerText: 'Up to 50% Off',
      websiteUrl: 'https://www.agoda.com',
    ),
    BrandModel(
      name: 'Goibibo',
      logoUrl: 'assets/logos/goibibo.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat 9% Cashback',
      category: 'Travel',
      offerText: 'Flat ₹500 Off',
      websiteUrl: 'https://www.goibibo.com',
    ),
    BrandModel(
      name: 'EaseMyTrip',
      logoUrl: 'assets/logos/easemytrip.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat 8% Cashback',
      category: 'Travel',
      offerText: 'Zero Convenience Fee',
      websiteUrl: 'https://www.easemytrip.com',
    ),
    BrandModel(
      name: 'Expedia',
      logoUrl: 'assets/logos/expedia.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1488646953014-85cb44e25828?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat 7% Cashback',
      category: 'Travel',
      offerText: 'Up to 30% Off',
      websiteUrl: 'https://www.expedia.com',
    ),
  ];

  static const List<BrandModel> personalLoansCatalog = [
    BrandModel(
      name: 'Navi Loans',
      logoUrl: 'assets/logos/navi.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1579621970563-ebec7560ff3e?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat ₹1,200 Cashback',
      category: 'Personal Loans',
      offerText: 'Loans up to ₹20 Lakhs',
      websiteUrl: 'https://navi.com',
    ),
    BrandModel(
      name: 'MoneyTap',
      logoUrl: 'assets/logos/moneytap.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1563013544-824ae1b704d3?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat ₹1,000 Bonus',
      category: 'Personal Loans',
      offerText: 'Instant Credit Line',
      websiteUrl: 'https://www.moneytap.com',
    ),
    BrandModel(
      name: 'Tata Capital',
      logoUrl: 'assets/logos/tatacapital.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1559526324-4b87b5e36e44?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat ₹1,500 Bonus',
      category: 'Personal Loans',
      offerText: 'Low Interest Rates',
      websiteUrl: 'https://www.tatacapital.com',
    ),
    BrandModel(
      name: 'Paysense',
      logoUrl: 'assets/logos/moneytap.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1554224155-8d04cb21cd6c?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat ₹800 Cashback',
      category: 'Personal Loans',
      offerText: 'Quick Disbursal',
      websiteUrl: 'https://www.gopaysense.com',
    ),
    BrandModel(
      name: 'CASHe',
      logoUrl: 'assets/logos/navi.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1556742049-0a67dd385203?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat ₹700 Cashback',
      category: 'Personal Loans',
      offerText: 'Instant Salary Loan',
      websiteUrl: 'https://www.cashe.co.in',
    ),
    BrandModel(
      name: 'mPokket',
      logoUrl: 'assets/logos/moneytap.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1523240795612-9a054b0db644?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat ₹500 Cashback',
      category: 'Personal Loans',
      offerText: 'Student & Youth Loan',
      websiteUrl: 'https://mpokket.in',
    ),
  ];

  static const List<BrandModel> luxuryBrandsCatalog = [
    BrandModel(
      name: 'Michael Kors',
      logoUrl: 'assets/logos/michaelkors.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat 8% Cashback',
      category: 'Luxury Fashion',
      offerText: 'Up to 50% Off Designer Handbags',
      websiteUrl: 'https://www.michaelkors.global/in',
    ),
    BrandModel(
      name: 'Coach',
      logoUrl: 'assets/logos/coach.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Up to 9% Cashback',
      category: 'Luxury Fashion',
      offerText: 'Up to 45% Off Leather Bags',
      websiteUrl: 'https://india.coach.com',
    ),
    BrandModel(
      name: 'Calvin Klein',
      logoUrl: 'assets/logos/calvinklein.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1509631179647-0177331693ae?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat 7.5% Cashback',
      category: 'Luxury Fashion',
      offerText: 'Up to 40% Off Designer Wear',
      websiteUrl: 'https://www.calvinklein.in',
    ),
    BrandModel(
      name: 'Tommy Hilfiger',
      logoUrl: 'assets/logos/tommyhilfiger.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1490481651871-ab68de25d43d?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat 8% Cashback',
      category: 'Luxury Fashion',
      offerText: 'Up to 50% Off Classic Styles',
      websiteUrl: 'https://tommyhilfiger.nnnow.com',
    ),
    BrandModel(
      name: 'Ralph Lauren',
      logoUrl: 'assets/logos/ralphlauren.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1507679799987-c73779587ccf?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat 6% Cashback',
      category: 'Luxury Fashion',
      offerText: 'Polo Luxury Essentials',
      websiteUrl: 'https://www.ralphlauren.asia/in',
    ),
    BrandModel(
      name: 'Hugo Boss',
      logoUrl: 'assets/logos/hugoboss.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1594938298603-c8148c4dae35?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat 7% Cashback',
      category: 'Luxury Fashion',
      offerText: 'Up to 35% Off Tailored Suits',
      websiteUrl: 'https://www.hugoboss.com/in',
    ),
    BrandModel(
      name: 'Armani',
      logoUrl: 'assets/logos/armani.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat 6.5% Cashback',
      category: 'Luxury Fashion',
      offerText: 'Emporio Armani Couture',
      websiteUrl: 'https://www.armani.com/in',
    ),
    BrandModel(
      name: 'Versace',
      logoUrl: 'assets/logos/versace.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat 8% Cashback',
      category: 'Luxury Fashion',
      offerText: 'Designer Perfumes & Accs',
      websiteUrl: 'https://www.versace.com/international/en',
    ),
    BrandModel(
      name: 'Swarovski',
      logoUrl: 'assets/logos/swarovski.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1599643478518-a784e5dc4c8f?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat 10% Cashback',
      category: 'Luxury Accessories',
      offerText: 'Crystal Jewelry & Watches',
      websiteUrl: 'https://www.swarovski.com/en-IN',
    ),
    BrandModel(
      name: 'Ray-Ban',
      logoUrl: 'assets/logos/rayban.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1511499767150-a48a237f0083?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat 8% Cashback',
      category: 'Luxury Eyewear',
      offerText: 'Aviator & Wayfarer Deals',
      websiteUrl: 'https://india.ray-ban.com',
    ),
    BrandModel(
      name: 'Ted Baker',
      logoUrl: 'assets/logos/tedbaker.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1496747611176-843222e1e57c?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Up to 9% Cashback',
      category: 'Luxury Fashion',
      offerText: 'British Designer Elegance',
      websiteUrl: 'https://www.tedbaker.com',
    ),
    BrandModel(
      name: 'Steve Madden',
      logoUrl: 'assets/logos/stevemadden.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1543163521-1bf539c55dd2?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat 7% Cashback',
      category: 'Luxury Footwear',
      offerText: 'Up to 40% Off Designer Shoes',
      websiteUrl: 'https://www.stevemadden.in',
    ),
  ];

  static const List<AmazonDealItemData> amazonDealsCatalog = [
    AmazonDealItemData(
      brandName: 'Samsung',
      productName: 'Samsung Galaxy S24 Ultra 5G (256GB)',
      imageUrl: 'https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?w=800&auto=format&fit=crop&q=80',
      actualPrice: 129999,
      rewardPercentage: 5.0,
      productUrl: 'https://www.amazon.in',
    ),
    AmazonDealItemData(
      brandName: 'Apple',
      productName: 'Apple MacBook Air M3 (15-inch, 16GB)',
      imageUrl: 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=800&auto=format&fit=crop&q=80',
      actualPrice: 134900,
      rewardPercentage: 4.0,
      productUrl: 'https://www.amazon.in',
    ),
    AmazonDealItemData(
      brandName: 'Sony',
      productName: 'Sony WH-1000XM5 Wireless Headphones',
      imageUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=800&auto=format&fit=crop&q=80',
      actualPrice: 29990,
      rewardPercentage: 6.0,
      productUrl: 'https://www.amazon.in',
    ),
    AmazonDealItemData(
      brandName: 'Nike',
      productName: "Nike Air Force 1 '07 Sneakers",
      imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800&auto=format&fit=crop&q=80',
      actualPrice: 8695,
      rewardPercentage: 8.0,
      productUrl: 'https://www.amazon.in',
    ),
    AmazonDealItemData(
      brandName: 'Logitech',
      productName: 'Logitech MX Master 3S Mouse',
      imageUrl: 'https://images.unsplash.com/photo-1615663245857-ac93bb7c39e7?w=800&auto=format&fit=crop&q=80',
      actualPrice: 10995,
      rewardPercentage: 5.0,
      productUrl: 'https://www.amazon.in',
    ),
    AmazonDealItemData(
      brandName: 'Bose',
      productName: 'Bose QuietComfort Ultra Earbuds',
      imageUrl: 'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?w=800&auto=format&fit=crop&q=80',
      actualPrice: 25900,
      rewardPercentage: 7.0,
      productUrl: 'https://www.amazon.in',
    ),
    AmazonDealItemData(
      brandName: 'Dyson',
      productName: 'Dyson V15 Detect Vacuum Cleaner',
      imageUrl: 'https://images.unsplash.com/photo-1558317374-067fb5f30001?w=800&auto=format&fit=crop&q=80',
      actualPrice: 65900,
      rewardPercentage: 5.0,
      productUrl: 'https://www.amazon.in',
    ),
    AmazonDealItemData(
      brandName: 'Asus',
      productName: 'Asus ROG Zephyrus G16 Gaming Laptop',
      imageUrl: 'https://images.unsplash.com/photo-1603302576837-37561b2e2302?w=800&auto=format&fit=crop&q=80',
      actualPrice: 189990,
      rewardPercentage: 5.0,
      productUrl: 'https://www.amazon.in',
    ),
  ];

  static const List<OfferSectionItem> flipkartOffers = [
    OfferSectionItem(
      id: 101,
      title: 'Samsung Galaxy S23 FE 5G',
      description: '8GB RAM, 128GB Storage, Flagship Camera',
      priceOrRate: '₹33,999',
      cashbackTag: 'FLAT 10% CASHBACK',
      imageUrl:
          'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=800&auto=format&fit=crop&q=80',
      storeName: 'Flipkart',
    ),
    OfferSectionItem(
      id: 102,
      title: 'Apple iPhone 15 (128GB)',
      description: 'Dynamic Island, 48MP Main Camera, A16 Bionic',
      priceOrRate: '₹65,999',
      cashbackTag: 'FLAT 6% CASHBACK',
      imageUrl:
          'https://images.unsplash.com/photo-1510557880182-3d4d3cba35a5?w=800&auto=format&fit=crop&q=80',
      storeName: 'Flipkart',
    ),
    OfferSectionItem(
      id: 103,
      title: 'boAt Airdopes 141 ANC',
      description: 'Active Noise Cancellation, 42H Battery Playtime',
      priceOrRate: '₹1,299',
      cashbackTag: 'FLAT 18% CASHBACK',
      imageUrl:
          'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?w=800&auto=format&fit=crop&q=80',
      storeName: 'Flipkart',
    ),
    OfferSectionItem(
      id: 104,
      title: 'ASUS TUF Gaming F15',
      description: 'Intel Core i5 11th Gen, 16GB RAM, RTX 3050',
      priceOrRate: '₹52,990',
      cashbackTag: 'FLAT 8% CASHBACK',
      imageUrl:
          'https://images.unsplash.com/photo-1588872657578-7efd1f1555ed?w=800&auto=format&fit=crop&q=80',
      storeName: 'Flipkart',
    ),
    OfferSectionItem(
      id: 105,
      title: 'Noise ColorFit Pro 5',
      description: '1.85" AMOLED Display, Bluetooth Calling, 7-Day Battery',
      priceOrRate: '₹2,499',
      cashbackTag: 'FLAT 20% CASHBACK',
      imageUrl:
          'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=800&auto=format&fit=crop&q=80',
      storeName: 'Flipkart',
    ),
    OfferSectionItem(
      id: 106,
      title: 'Sony Bravia 4K Ultra HD TV',
      description: '43 Inch Google TV with Dolby Atmos & HDR10',
      priceOrRate: '₹42,990',
      cashbackTag: 'FLAT 7% CASHBACK',
      imageUrl:
          'https://images.unsplash.com/photo-1593359677879-a4bb92f829d1?w=800&auto=format&fit=crop&q=80',
      storeName: 'Flipkart',
    ),
    OfferSectionItem(
      id: 107,
      title: 'Puma Velocity Nitro Shoes',
      description: 'High-Performance Lightweight Breathable Running Shoes',
      priceOrRate: '₹3,499',
      cashbackTag: 'FLAT 15% CASHBACK',
      imageUrl:
          'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800&auto=format&fit=crop&q=80',
      storeName: 'Flipkart',
    ),
    OfferSectionItem(
      id: 108,
      title: 'Dyson Cordless Vacuum',
      description: 'Powerful Suction, HEPA Filtration Deep Clean',
      priceOrRate: '₹29,900',
      cashbackTag: 'FLAT 9% CASHBACK',
      imageUrl:
          'https://images.unsplash.com/photo-1558089687-f282ffcbc126?w=800&auto=format&fit=crop&q=80',
      storeName: 'Flipkart',
    ),
  ];

  static const List<OfferSectionItem> meeshoOffers = [
    OfferSectionItem(
      id: 201,
      title: 'Banarasi Art Silk Saree',
      description: 'Traditional Embroidered Zari Border Saree',
      priceOrRate: '₹699',
      cashbackTag: 'UP TO 25% CASHBACK',
      imageUrl:
          'https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=800&auto=format&fit=crop&q=80',
      storeName: 'Meesho',
    ),
    OfferSectionItem(
      id: 202,
      title: 'Men Slim Fit Cotton Shirt',
      description: '100% Pure Breathable Cotton Regular Fit',
      priceOrRate: '₹399',
      cashbackTag: 'UP TO 30% CASHBACK',
      imageUrl:
          'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=800&auto=format&fit=crop&q=80',
      storeName: 'Meesho',
    ),
    OfferSectionItem(
      id: 203,
      title: 'Matte Liquid Lipstick Set',
      description: 'Long Lasting 16H Waterproof Smudge-Proof',
      priceOrRate: '₹249',
      cashbackTag: 'UP TO 20% CASHBACK',
      imageUrl:
          'https://images.unsplash.com/photo-1586495777744-4413f21062fa?w=800&auto=format&fit=crop&q=80',
      storeName: 'Meesho',
    ),
    OfferSectionItem(
      id: 204,
      title: 'Running Mesh Sports Shoes',
      description: 'Ultra Lightweight Anti-Slip Athletic Sneakers',
      priceOrRate: '₹499',
      cashbackTag: 'UP TO 22% CASHBACK',
      imageUrl:
          'https://images.unsplash.com/photo-1560769629-975ec94e6a86?w=800&auto=format&fit=crop&q=80',
      storeName: 'Meesho',
    ),
    OfferSectionItem(
      id: 205,
      title: 'Airtight Spice Container Set',
      description: '12 Pcs BPA-Free Modular Kitchen Jar Organizer',
      priceOrRate: '₹349',
      cashbackTag: 'UP TO 25% CASHBACK',
      imageUrl:
          'https://images.unsplash.com/photo-1584992236310-6edddc08acff?w=800&auto=format&fit=crop&q=80',
      storeName: 'Meesho',
    ),
    OfferSectionItem(
      id: 206,
      title: 'Floral Print Anarkali Kurti',
      description: 'Rayon Gold Foil Printed Festive Party Wear',
      priceOrRate: '₹549',
      cashbackTag: 'UP TO 28% CASHBACK',
      imageUrl:
          'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=800&auto=format&fit=crop&q=80',
      storeName: 'Meesho',
    ),
    OfferSectionItem(
      id: 207,
      title: 'Insulated Water Bottle (1L)',
      description: 'Stainless Steel Double Wall Hot & Cold Flask',
      priceOrRate: '₹299',
      cashbackTag: 'UP TO 15% CASHBACK',
      imageUrl:
          'https://images.unsplash.com/photo-1602143407151-7111542de6e8?w=800&auto=format&fit=crop&q=80',
      storeName: 'Meesho',
    ),
    OfferSectionItem(
      id: 208,
      title: 'Wireless Neckband Earphones',
      description: '30 Hours Playtime Deep Bass Bluetooth v5.3',
      priceOrRate: '₹399',
      cashbackTag: 'UP TO 30% CASHBACK',
      imageUrl:
          'https://images.unsplash.com/photo-1546435770-a3e426bf472b?w=800&auto=format&fit=crop&q=80',
      storeName: 'Meesho',
    ),
  ];

  static const List<OfferSectionItem> loanOffers = [
    OfferSectionItem(
      id: 301,
      title: 'Instant Personal Loan',
      description: 'Quick Approval in 10 Mins',
      priceOrRate: '10.49% p.a.',
      cashbackTag: 'FLAT \$50 REWARD',
      imageUrl:
          'https://cdn.dummyjson.com/products/images/groceries/Apple/1.png',
      storeName: 'Loans',
    ),
    OfferSectionItem(
      id: 302,
      title: 'Pre-Approved Home Loan',
      description: 'Lowest Interest Rates & 0 Processing Fee',
      priceOrRate: '8.40% p.a.',
      cashbackTag: 'FLAT \$100 REWARD',
      imageUrl:
          'https://cdn.dummyjson.com/products/images/groceries/Honey%20Jar/1.png',
      storeName: 'Loans',
    ),
    OfferSectionItem(
      id: 303,
      title: 'Business Expansion Loan',
      description: 'Unsecured Collateral-Free Business Loan',
      priceOrRate: '11.99% p.a.',
      cashbackTag: 'FLAT \$75 REWARD',
      imageUrl:
          'https://cdn.dummyjson.com/products/images/groceries/Kiwi/1.png',
      storeName: 'Loans',
    ),
    OfferSectionItem(
      id: 304,
      title: 'Instant Credit Card Loan',
      description: 'Zero Interest for 45 Days',
      priceOrRate: '0% Interest',
      cashbackTag: 'FLAT \$30 REWARD',
      imageUrl:
          'https://cdn.dummyjson.com/products/images/groceries/Lemon/1.png',
      storeName: 'Loans',
    ),
    OfferSectionItem(
      id: 305,
      title: 'Higher Education Loan',
      description: 'Coverage for Tuition & Living Expenses',
      priceOrRate: '9.50% p.a.',
      cashbackTag: 'FLAT \$60 REWARD',
      imageUrl:
          'https://cdn.dummyjson.com/products/images/groceries/Milk/1.png',
      storeName: 'Loans',
    ),
  ];

  // =========================================================================
  // CATEGORY-SPECIFIC BRAND CATALOGS
  // =========================================================================

  static const List<BrandModel> mobilesBrandsCatalog = [
    BrandModel(
      name: 'Apple',
      logoUrl: 'assets/logos/apple.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1695048133142-1a20484d2569?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Up to 5% Cashback',
      category: 'Mobiles',
      offerText: 'iPhone 15 & 16 Series',
      websiteUrl: 'https://www.apple.com/in',
    ),
    BrandModel(
      name: 'Samsung',
      logoUrl: 'assets/logos/samsung.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Up to 8% Cashback',
      category: 'Mobiles',
      offerText: 'Galaxy S24 & Z Fold',
      websiteUrl: 'https://www.samsung.com/in',
    ),
    BrandModel(
      name: 'OnePlus',
      logoUrl: 'assets/logos/oneplus.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1598327105666-5b89351aff97?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat 6% Cashback',
      category: 'Mobiles',
      offerText: 'OnePlus 12 & Nord',
      websiteUrl: 'https://www.oneplus.in',
    ),
    BrandModel(
      name: 'Xiaomi / Redmi',
      logoUrl: 'assets/logos/xiaomi.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Up to 7% Cashback',
      category: 'Mobiles',
      offerText: 'Redmi Note Series',
      websiteUrl: 'https://www.mi.com/in',
    ),
    BrandModel(
      name: 'Realme',
      logoUrl: 'assets/logos/realme.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1580910051074-3eb694886505?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat 6.5% Cashback',
      category: 'Mobiles',
      offerText: 'Realme GT Series',
      websiteUrl: 'https://www.realme.com/in',
    ),
    BrandModel(
      name: 'OPPO',
      logoUrl: 'assets/logos/oppo.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1565849904461-04a58ad377e0?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Up to 6% Cashback',
      category: 'Mobiles',
      offerText: 'Reno & Find Series',
      websiteUrl: 'https://www.oppo.com/in',
    ),
    BrandModel(
      name: 'Vivo',
      logoUrl: 'assets/logos/vivo.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1574944985070-8f3ebc6b79d2?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Up to 6% Cashback',
      category: 'Mobiles',
      offerText: 'V & X Series Camera Phones',
      websiteUrl: 'https://www.vivo.com/in',
    ),
    BrandModel(
      name: 'Motorola',
      logoUrl: 'assets/logos/motorola.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1546868871-7041f2a55e12?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat 5% Cashback',
      category: 'Mobiles',
      offerText: 'Moto Edge & Razr Flip',
      websiteUrl: 'https://www.motorola.in',
    ),
    BrandModel(
      name: 'Nothing',
      logoUrl: 'assets/logos/nothing.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat 7% Cashback',
      category: 'Mobiles',
      offerText: 'Phone (2) & Glyph Tech',
      websiteUrl: 'https://in.nothing.tech',
    ),
    BrandModel(
      name: 'iQOO',
      logoUrl: 'assets/logos/iqoo.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1585060544812-6b45742d762f?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat 6% Cashback',
      category: 'Mobiles',
      offerText: 'iQOO 12 Flagship Gaming',
      websiteUrl: 'https://www.iqoo.com/in',
    ),
  ];

  static const List<BrandModel> pharmacyBrandsCatalog = [
    BrandModel(
      name: 'Tata 1mg',
      logoUrl: 'assets/logos/tata1mg.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat 12% Cashback',
      category: 'Pharmacy',
      offerText: 'Up to 25% Off Medicines',
      websiteUrl: 'https://www.1mg.com',
    ),
    BrandModel(
      name: 'PharmEasy',
      logoUrl: 'assets/logos/pharmeasy.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1471864190281-a93a3070b6de?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Up to 15% Cashback',
      category: 'Pharmacy',
      offerText: 'Up to 30% Off Healthcare',
      websiteUrl: 'https://www.pharmeasy.in',
    ),
    BrandModel(
      name: 'Netmeds',
      logoUrl: 'assets/logos/netmeds.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1587854692152-cbe660dbde88?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat 10% Cashback',
      category: 'Pharmacy',
      offerText: 'Flat 20% Off Orders',
      websiteUrl: 'https://www.netmeds.com',
    ),
    BrandModel(
      name: 'Apollo Pharmacy',
      logoUrl: 'assets/logos/apollopharmacy.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1579722821273-0f6c7d44362f?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Up to 8% Cashback',
      category: 'Pharmacy',
      offerText: 'Up to 15% Off Prescriptions',
      websiteUrl: 'https://www.apollopharmacy.in',
    ),
    BrandModel(
      name: 'MedPlus',
      logoUrl: 'assets/logos/medplus.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1586015555751-63bb77f4322a?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat 10% Cashback',
      category: 'Pharmacy',
      offerText: 'Up to 20% Savings',
      websiteUrl: 'https://www.medplusmart.com',
    ),
    BrandModel(
      name: 'Practo',
      logoUrl: 'assets/logos/practo.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1505751172876-fa1923c5c528?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat ₹150 Cashback',
      category: 'Pharmacy',
      offerText: 'Doctor Consultations & Tests',
      websiteUrl: 'https://www.practo.com',
    ),
  ];

  static const List<BrandModel> healthWellnessCatalog = [
    BrandModel(
      name: 'HealthKart',
      logoUrl: 'assets/logos/healthkart.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1517838277536-f5f99be501cd?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Up to 10% Cashback',
      category: 'Health & Wellness',
      offerText: 'Proteins & Multivitamins',
      websiteUrl: 'https://www.healthkart.com',
    ),
    BrandModel(
      name: 'Cult.fit',
      logoUrl: 'assets/logos/cultfit.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat ₹500 Cashback',
      category: 'Health & Wellness',
      offerText: 'Gym & Fitness Passes',
      websiteUrl: 'https://www.cult.fit',
    ),
    BrandModel(
      name: 'MuscleBlaze',
      logoUrl: 'assets/logos/muscleblaze.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1584735935682-2f2b69dff9d2?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat 8% Cashback',
      category: 'Health & Wellness',
      offerText: 'Biozyme Whey & Creatine',
      websiteUrl: 'https://www.muscleblaze.com',
    ),
    BrandModel(
      name: 'Fast&Up',
      logoUrl: 'assets/logos/fastandup.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1579722820308-d74e571900a9?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat 12% Cashback',
      category: 'Health & Wellness',
      offerText: 'Effervescent Nutrition',
      websiteUrl: 'https://www.fastandup.in',
    ),
    BrandModel(
      name: 'Kapiva Ayurveda',
      logoUrl: 'assets/logos/kapiva.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1617897903246-719242758050?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat 15% Cashback',
      category: 'Health & Wellness',
      offerText: 'Pure Shilajit & Juices',
      websiteUrl: 'https://www.kapiva.in',
    ),
    BrandModel(
      name: 'OZiva',
      logoUrl: 'assets/logos/oziva.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Up to 14% Cashback',
      category: 'Health & Wellness',
      offerText: 'Clean Plant Nutrition',
      websiteUrl: 'https://www.oziva.in',
    ),
  ];

  static const List<BrandModel> loansCategoryCatalog = [
    BrandModel(
      name: 'Bajaj Finserv',
      logoUrl: 'assets/logos/bajajfinserv.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1559526324-4b87b5e36e44?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat ₹1,500 Bonus',
      category: 'Loans',
      offerText: 'Instant Personal Loan',
      websiteUrl: 'https://www.bajajfinserv.in',
    ),
    BrandModel(
      name: 'Moneyview',
      logoUrl: 'assets/logos/moneyview.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1554224155-8d04cb21cd6c?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat ₹1,200 Cashback',
      category: 'Loans',
      offerText: 'Quick Loans in 2 Hours',
      websiteUrl: 'https://moneyview.in',
    ),
    BrandModel(
      name: 'KreditBee',
      logoUrl: 'assets/logos/kreditbee.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1601597111158-2fceff292cdc?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat ₹800 Cashback',
      category: 'Loans',
      offerText: 'Personal Credit Line',
      websiteUrl: 'https://www.kreditbee.in',
    ),
    BrandModel(
      name: 'Navi',
      logoUrl: 'assets/logos/navi.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1579621970563-ebec7560ff3e?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat ₹1,200 Cashback',
      category: 'Loans',
      offerText: 'Cash Loans up to ₹20L',
      websiteUrl: 'https://navi.com',
    ),
    BrandModel(
      name: 'CASHe',
      logoUrl: 'assets/logos/cashe.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1556742049-0a67dd385203?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat ₹700 Cashback',
      category: 'Loans',
      offerText: 'Instant Salary Loan',
      websiteUrl: 'https://www.cashe.co.in',
    ),
    BrandModel(
      name: 'PaySense',
      logoUrl: 'assets/logos/paysense.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1563013544-824ae1b704d3?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat ₹800 Cashback',
      category: 'Loans',
      offerText: 'Zero Paperwork Loan',
      websiteUrl: 'https://www.gopaysense.com',
    ),
    BrandModel(
      name: 'Tata Capital',
      logoUrl: 'assets/logos/tatacapital.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1559526324-4b87b5e36e44?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat ₹1,500 Bonus',
      category: 'Loans',
      offerText: 'Low Interest Rates',
      websiteUrl: 'https://www.tatacapital.com',
    ),
  ];

  static const List<BrandModel> departmentalCatalog = [
    BrandModel(
      name: 'DMart',
      logoUrl: 'assets/logos/dmart.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1578916171728-46686eac8d58?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat 5% Cashback',
      category: 'Departmental',
      offerText: 'Daily Grocery & Home Savings',
      websiteUrl: 'https://www.dmart.in',
    ),
    BrandModel(
      name: 'Reliance Smart',
      logoUrl: 'assets/logos/reliancesmart.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Up to 6% Cashback',
      category: 'Departmental',
      offerText: 'Fresh Produce & Superstore Deals',
      websiteUrl: 'https://www.reliancesmart.in',
    ),
    BrandModel(
      name: 'Spencer\'s',
      logoUrl: 'assets/logos/spencers.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1583258292688-d0213dc5a3a8?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat 8% Cashback',
      category: 'Departmental',
      offerText: 'Gourmet & Household Essentials',
      websiteUrl: 'https://www.spencers.in',
    ),
    BrandModel(
      name: 'BigBasket',
      logoUrl: 'assets/logos/bigbasket.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1534723452862-4c874018d66d?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Up to 7% Cashback',
      category: 'Departmental',
      offerText: '15-Min Delivery & Supermarket',
      websiteUrl: 'https://www.bigbasket.com',
    ),
  ];

  static const List<BrandModel> foodGroceryCatalog = [
    BrandModel(
      name: 'Swiggy',
      logoUrl: 'assets/logos/swiggy.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1578916171728-46686eac8d58?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat 10% Cashback',
      category: 'Food & Grocery',
      offerText: 'Flat 50% Off Food Delivery',
      websiteUrl: 'https://www.swiggy.com',
    ),
    BrandModel(
      name: 'Zomato',
      logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/b/bd/Zomato_Logo.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat 8% Cashback',
      category: 'Food & Grocery',
      offerText: 'Up to 60% Off Trending Dishes',
      websiteUrl: 'https://www.zomato.com',
    ),
    BrandModel(
      name: 'Blinkit',
      logoUrl: 'https://blinkit.com/images/header/blinkit_logo.png',
      bannerUrl: 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Up to 8% Cashback',
      category: 'Food & Grocery',
      offerText: '10-Minute Grocery Delivery',
      websiteUrl: 'https://www.blinkit.com',
    ),
    BrandModel(
      name: 'BigBasket',
      logoUrl: 'assets/logos/bigbasket.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1534723452862-4c874018d66d?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Up to 7% Cashback',
      category: 'Food & Grocery',
      offerText: 'Supermarket Grocery Online',
      websiteUrl: 'https://www.bigbasket.com',
    ),
  ];

  static const List<BrandModel> educationCatalog = [
    BrandModel(
      name: 'Udemy',
      logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/e/e3/Udemy_logo.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat 15% Cashback',
      category: 'Education',
      offerText: 'Courses from ₹499',
      websiteUrl: 'https://www.udemy.com',
    ),
    BrandModel(
      name: 'Coursera',
      logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/9/97/Coursera-Logo_600x600.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1501504905252-473c47e087f8?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat 12% Cashback',
      category: 'Education',
      offerText: 'Certificates & Degrees',
      websiteUrl: 'https://www.coursera.org',
    ),
    BrandModel(
      name: 'Unacademy',
      logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/e/e0/Unacademy_Logo.png',
      bannerUrl: 'https://images.unsplash.com/photo-1434030216411-0b793f4b4173?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat 10% Cashback',
      category: 'Education',
      offerText: 'Competitive Exam Prep',
      websiteUrl: 'https://www.unacademy.com',
    ),
  ];

  // =========================================================================
  // TOP CATEGORIES
  // =========================================================================

  static const List<TopCategoryItemData> topCategories = [
    TopCategoryItemData(
      title: 'Most Popular',
      icon: Icons.local_fire_department_rounded,
      slug: 'smartphones',
    ),
    TopCategoryItemData(
      title: 'Fashion',
      icon: Icons.checkroom_rounded,
      slug: 'mens-shirts',
    ),
    TopCategoryItemData(
      title: 'Credit Cards',
      icon: Icons.credit_card_rounded,
      slug: 'groceries',
    ),
    TopCategoryItemData(
      title: 'Beauty & Grooming',
      icon: Icons.face_retouching_natural_rounded,
      slug: 'beauty',
    ),
    TopCategoryItemData(
      title: 'Home & Kitchen',
      icon: Icons.home_rounded,
      slug: 'home-decoration',
    ),
    TopCategoryItemData(
      title: 'Electronics',
      icon: Icons.devices_rounded,
      slug: 'laptops',
    ),
    TopCategoryItemData(
      title: 'Food & Grocery',
      icon: Icons.shopping_bag_rounded,
      slug: 'groceries',
    ),
    TopCategoryItemData(
      title: 'Mobiles',
      icon: Icons.smartphone_rounded,
      slug: 'smartphones',
    ),
    TopCategoryItemData(
      title: 'Pharmacy',
      icon: Icons.medical_services_rounded,
      slug: 'skin-care',
    ),
    TopCategoryItemData(
      title: 'Health & Wellness',
      icon: Icons.health_and_safety_rounded,
      slug: 'skin-care',
    ),
    TopCategoryItemData(
      title: 'Loans',
      icon: Icons.account_balance_wallet_rounded,
      slug: 'groceries',
    ),
    TopCategoryItemData(
      title: 'Departmental',
      icon: Icons.storefront_rounded,
      slug: 'groceries',
    ),
    TopCategoryItemData(
      title: 'Flights & Hotels',
      icon: Icons.flight_takeoff_rounded,
      slug: 'smartphones',
    ),
    TopCategoryItemData(
      title: 'Education',
      icon: Icons.school_rounded,
      slug: 'laptops',
    ),
  ];

  static List<BrandModel> getBrandsForTopCategory(String title) {
    switch (title) {
      case 'Most Popular':
        return popularBrandsCatalog;

      case 'Fashion':
        return fashionBrandsCatalog;

      case 'Credit Cards':
        return lifetimeFreeCardsCatalog;

      case 'Beauty & Grooming':
        return beautyBrandsCatalog;

      case 'Home & Kitchen':
        return const [
          BrandModel(
            name: 'Pepperfry',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/e/e0/Pepperfry_logo.png',
            bannerUrl: 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Flat 9% Cashback',
            category: 'Home & Kitchen',
            offerText: 'Up to 60% Off',
            websiteUrl: 'https://www.pepperfry.com',
          ),
          BrandModel(
            name: 'Urban Ladder',
            logoUrl: 'https://www.urbanladder.com/assets/logo.png',
            bannerUrl: 'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Up to 8% Cashback',
            category: 'Home & Kitchen',
            offerText: 'Up to 50% Off',
            websiteUrl: 'https://www.urbanladder.com',
          ),
          BrandModel(
            name: 'IKEA India',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/c/c5/Ikea_logo.svg',
            bannerUrl: 'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Up to 5% Cashback',
            category: 'Home & Kitchen',
            offerText: 'Up to 40% Off',
            websiteUrl: 'https://www.ikea.com/in',
          ),
        ];

      case 'Electronics':
        return electronicsBrandsCatalog;

      case 'Food & Grocery':
        return foodGroceryCatalog;

      case 'Mobiles':
        return mobilesBrandsCatalog;

      case 'Pharmacy':
        return pharmacyBrandsCatalog;

      case 'Health & Wellness':
        return healthWellnessCatalog;

      case 'Loans':
        return loansCategoryCatalog;

      case 'Departmental':
        return departmentalCatalog;

      case 'Flights & Hotels':
        return hotelBookingCatalog;

      case 'Education':
        return educationCatalog;

      case 'Luxury':
      case 'Luxury Fashion':
        return luxuryBrandsCatalog;

      default:
        return popularBrandsCatalog;
    }
  }

  // =========================================================================
  // REUSABLE DISCOVERY SECTIONS LIST
  // =========================================================================

  static const List<DiscoverySectionModel> discoverySections = [
    DiscoverySectionModel(
      id: 'fashion',
      title: 'Get Cashback on Fashion Buys',
      lightGradientColors: [Color(0xFFFFF0F5), Colors.white],
      darkGradientColors: [Color(0xFF1E1016), Color(0xFF0D0D0D)],
      brands: fashionBrandsCatalog,
      bannerData: fashionBanner,
      initialCount: 3,
    ),
    DiscoverySectionModel(
      id: 'beauty',
      title: 'Get Cashback on Beauty Brands',
      lightGradientColors: [Color(0xFFFFF5EE), Colors.white],
      darkGradientColors: [Color(0xFF1E1410), Color(0xFF0D0D0D)],
      brands: beautyBrandsCatalog,
      bannerData: beautyBanner,
      initialCount: 6,
    ),
    DiscoverySectionModel(
      id: 'lifetime_cards',
      title: 'Rewards on Lifetime Free Cards',
      lightGradientColors: [Color(0xFFFFFDF0), Colors.white],
      darkGradientColors: [Color(0xFF1C1A10), Color(0xFF0D0D0D)],
      brands: lifetimeFreeCardsCatalog,
      bannerData: lifetimeCardsBanner,
      initialCount: 6,
    ),
    DiscoverySectionModel(
      id: 'electronics',
      title: 'Get Cashback on Electronics',
      lightGradientColors: [Color(0xFFF0FAF7), Colors.white],
      darkGradientColors: [Color(0xFF101E1A), Color(0xFF0D0D0D)],
      brands: electronicsBrandsCatalog,
      bannerData: electronicsBanner,
      initialCount: 6,
    ),
    DiscoverySectionModel(
      id: 'shopping_cards',
      title: 'Best Cards for Shopping',
      lightGradientColors: [Color(0xFFFFF8F0), Colors.white],
      darkGradientColors: [Color(0xFF1E1610), Color(0xFF0D0D0D)],
      brands: shoppingCardsCatalog,
      bannerData: shoppingCardsBanner,
      initialCount: 6,
    ),
    DiscoverySectionModel(
      id: 'medicines',
      title: 'Get Cashback on Medicines',
      lightGradientColors: [Color(0xFFF0FFF4), Colors.white],
      darkGradientColors: [Color(0xFF101F14), Color(0xFF0D0D0D)],
      brands: medicineBrandsCatalog,
      bannerData: medicineBanner,
      initialCount: 6,
    ),
    DiscoverySectionModel(
      id: 'cards_loans',
      title: 'Get Rewards on Cards and Loans',
      lightGradientColors: [Color(0xFFFFFBF0), Colors.white],
      darkGradientColors: [Color(0xFF1D1B10), Color(0xFF0D0D0D)],
      brands: cardsAndLoansCatalog,
      bannerData: cardsLoansBanner,
      initialCount: 6,
    ),
    DiscoverySectionModel(
      id: 'hotel_booking',
      title: 'Get Cashback on Hotel Booking',
      lightGradientColors: [Color(0xFFF0F9FF), Colors.white],
      darkGradientColors: [Color(0xFF101B24), Color(0xFF0D0D0D)],
      brands: hotelBookingCatalog,
      bannerData: hotelBookingBanner,
      initialCount: 6,
    ),
    DiscoverySectionModel(
      id: 'personal_loans',
      title: 'Get Rewards on Personal Loans',
      lightGradientColors: [Color(0xFFF3F0FF), Colors.white],
      darkGradientColors: [Color(0xFF141022), Color(0xFF0D0D0D)],
      brands: personalLoansCatalog,
      bannerData: personalLoansBanner,
      initialCount: 6,
    ),
    DiscoverySectionModel(
      id: 'luxury',
      title: 'Luxury Made Affordable',
      lightGradientColors: [
        Color(0xFFF3E8FF),
        Color(0xFFFBF7FF),
        Color(0xFFFFFFFF),
      ],
      darkGradientColors: [
        Color(0xFF201332),
        Color(0xFF160D23),
        Color(0xFF0D0D0D),
      ],
      brands: luxuryBrandsCatalog,
      bannerData: luxuryBanner,
      initialCount: 6,
    ),
  ];
}
