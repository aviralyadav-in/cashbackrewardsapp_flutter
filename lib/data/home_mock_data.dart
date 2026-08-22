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

  static const SubcategoryBannerData amazonDealsBanner = SubcategoryBannerData(
    brandName: 'Amazon Deals',
    headline: 'AMAZON SUPER CASHBACK DEALS',
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
      logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/a/a9/Amazon_logo.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Up to 8% Rewards',
      category: 'Popular',
      offerText: 'Up to 80% Off',
      websiteUrl: 'https://www.amazon.in',
    ),
    BrandModel(
      name: 'Flipkart',
      logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/7/7a/Flipkart_logo.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Up to 7% Rewards',
      category: 'Popular',
      offerText: 'Up to 75% Off',
      websiteUrl: 'https://www.flipkart.com',
    ),
    BrandModel(
      name: 'Myntra',
      logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/b/bc/Myntra_Logo.png',
      bannerUrl: 'https://images.unsplash.com/photo-1483985988355-763728e1935b?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat 7.5% Rewards',
      category: 'Popular',
      offerText: 'Up to 60% Off',
      websiteUrl: 'https://www.myntra.com',
    ),
    BrandModel(
      name: 'AJIO',
      logoUrl: 'https://assets.ajio.com/static/img/Ajio-Logo.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1445205170230-053b83016050?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat 10% Rewards',
      category: 'Popular',
      offerText: 'Flat 50% Off',
      websiteUrl: 'https://www.ajio.com',
    ),
    BrandModel(
      name: 'MakeMyTrip',
      logoUrl: 'https://imgak.mmtcdn.com/pwa_v3/pwa_commons_assets/desktop/logo.png',
      bannerUrl: 'https://images.unsplash.com/photo-1436491865332-7a61a109cc05?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat 8% Rewards',
      category: 'Popular',
      offerText: 'Up to 35% Off',
      websiteUrl: 'https://www.makemytrip.com',
    ),
    BrandModel(
      name: 'Samsung',
      logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/2/24/Samsung_Logo.svg',
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
      logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/b/bc/Myntra_Logo.png',
      bannerUrl: 'https://images.unsplash.com/photo-1483985988355-763728e1935b?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat 7.5% Cashback',
      category: 'Fashion',
      offerText: 'Up to 70% Off',
      websiteUrl: 'https://www.myntra.com',
    ),
    BrandModel(
      name: 'AJIO',
      logoUrl: 'https://assets.ajio.com/static/img/Ajio-Logo.svg',
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
        logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/a/a9/Amazon_logo.svg',
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
        logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/7/7a/Flipkart_logo.svg',
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
        logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/b/bc/Myntra_Logo.png',
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
        logoUrl: 'https://assets.ajio.com/static/img/Ajio-Logo.svg',
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
        logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/7/7a/Flipkart_logo.svg',
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
        logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/b/bc/Myntra_Logo.png',
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
        logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/0/00/Nykaa_New_Logo.svg',
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
        logoUrl: 'https://media.croma.com/image/upload/v1637759004/Croma%20Assets/CMS/Category%20Icon/Croma_Logo.png',
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
        logoUrl: 'https://www.reliancedigital.in/build/client/images/rel_stat_svg.svg',
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
        logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/7/7a/Flipkart_logo.svg',
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
      logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/0/00/Nykaa_New_Logo.svg',
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
      logoUrl: 'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=400&auto=format&fit=crop&q=80',
      bannerUrl: 'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat 12% Cashback',
      category: 'Beauty',
      offerText: 'Buy 1 Get 1 Free',
      websiteUrl: 'https://mamaearth.in',
    ),
    BrandModel(
      name: 'Plum Goodness',
      logoUrl: 'https://images.unsplash.com/photo-1598440947619-2c35fc9aa908?w=400&auto=format&fit=crop&q=80',
      bannerUrl: 'https://images.unsplash.com/photo-1598440947619-2c35fc9aa908?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Up to 15% Cashback',
      category: 'Beauty',
      offerText: 'Flat 30% Off',
      websiteUrl: 'https://plumgoodness.com',
    ),
    BrandModel(
      name: 'Minimalist',
      logoUrl: 'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=400&auto=format&fit=crop&q=80',
      bannerUrl: 'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat 10% Cashback',
      category: 'Beauty',
      offerText: 'Flat ₹100 Off',
      websiteUrl: 'https://beminimalist.co',
    ),
    BrandModel(
      name: 'Sugar Cosmetics',
      logoUrl: 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?w=400&auto=format&fit=crop&q=80',
      bannerUrl: 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Up to 12% Cashback',
      category: 'Beauty',
      offerText: 'Up to 45% Off',
      websiteUrl: 'https://sugarcosmetics.com',
    ),
  ];

  static const List<BrandModel> lifetimeFreeCardsCatalog = [
    BrandModel(
      name: 'HDFC Freedom',
      logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/2/28/HDFC_Bank_Logo.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1559526324-4b87b5e36e44?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat ₹1,500 Bonus',
      category: 'Cards',
      offerText: 'Lifetime Free Card',
      websiteUrl: 'https://www.hdfcbank.com',
    ),
    BrandModel(
      name: 'SBI SimplyCLICK',
      logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/c/cc/SBI-Logo.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1563013544-824ae1b704d3?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat ₹1,200 Cashback',
      category: 'Cards',
      offerText: 'Zero Annual Fee',
      websiteUrl: 'https://www.sbicard.com',
    ),
    BrandModel(
      name: 'Axis MyZone',
      logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/1/1a/Axis_Bank_logo.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1601597111158-2fceff292cdc?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat ₹1,500 Cashback',
      category: 'Cards',
      offerText: 'Lifetime Free Card',
      websiteUrl: 'https://www.axisbank.com',
    ),
    BrandModel(
      name: 'ICICI Amazon Pay',
      logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/1/12/ICICI_Bank_Logo.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1556742049-0a67dd385203?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat ₹1,000 Rewards',
      category: 'Cards',
      offerText: 'Zero Joining Fee',
      websiteUrl: 'https://www.icicibank.com',
    ),
    BrandModel(
      name: 'IDFC Millennia',
      logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/a/a2/IDFC_First_Bank_logo.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1559526324-4b87b5e36e44?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat ₹1,000 Bonus',
      category: 'Cards',
      offerText: 'Lifetime Free Card',
      websiteUrl: 'https://www.idfcfirstbank.com',
    ),
    BrandModel(
      name: 'OneCard Credit',
      logoUrl: 'https://images.unsplash.com/photo-1563013544-824ae1b704d3?w=400&auto=format&fit=crop&q=80',
      bannerUrl: 'https://images.unsplash.com/photo-1563013544-824ae1b704d3?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat ₹800 Cashback',
      category: 'Cards',
      offerText: 'Metal Card Free',
      websiteUrl: 'https://getonecard.app',
    ),
  ];

  static const List<BrandModel> electronicsBrandsCatalog = [
    BrandModel(
      name: 'Amazon',
      logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/a/a9/Amazon_logo.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Up to 6% Cashback',
      category: 'Electronics',
      offerText: 'Up to 65% Off',
      websiteUrl: 'https://www.amazon.in',
    ),
    BrandModel(
      name: 'Flipkart',
      logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/7/7a/Flipkart_logo.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Up to 7% Cashback',
      category: 'Electronics',
      offerText: 'Up to 70% Off',
      websiteUrl: 'https://www.flipkart.com',
    ),
    BrandModel(
      name: 'Croma',
      logoUrl: 'https://media.croma.com/image/upload/v1637759004/Croma%20Assets/CMS/Category%20Icon/Croma_Logo.png',
      bannerUrl: 'https://images.unsplash.com/photo-1526738549149-8e07eca6c147?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat 6% Cashback',
      category: 'Electronics',
      offerText: 'Up to 50% Off',
      websiteUrl: 'https://www.croma.com',
    ),
    BrandModel(
      name: 'Apple Store',
      logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/f/fa/Apple_logo_black.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Up to 4% Cashback',
      category: 'Electronics',
      offerText: 'Save up to ₹10,000',
      websiteUrl: 'https://www.apple.com/in',
    ),
    BrandModel(
      name: 'Samsung',
      logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/2/24/Samsung_Logo.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Up to 8% Cashback',
      category: 'Electronics',
      offerText: 'Up to 55% Off',
      websiteUrl: 'https://www.samsung.com/in',
    ),
    BrandModel(
      name: 'Reliance Digital',
      logoUrl: 'https://www.reliancedigital.in/build/client/images/rel_stat_svg.svg',
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
      logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/c/cc/SBI-Logo.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1563013544-824ae1b704d3?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat ₹1,200 Cashback',
      category: 'Shopping Cards',
      offerText: '5% Unlimited Online',
      websiteUrl: 'https://www.sbicard.com',
    ),
    BrandModel(
      name: 'Axis Flipkart Card',
      logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/1/1a/Axis_Bank_logo.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1601597111158-2fceff292cdc?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat ₹1,500 Cashback',
      category: 'Shopping Cards',
      offerText: '5% Flipkart Cashback',
      websiteUrl: 'https://www.axisbank.com',
    ),
    BrandModel(
      name: 'ICICI Amazon Pay',
      logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/1/12/ICICI_Bank_Logo.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1556742049-0a67dd385203?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat ₹1,000 Rewards',
      category: 'Shopping Cards',
      offerText: '5% Amazon Cashback',
      websiteUrl: 'https://www.icicibank.com',
    ),
    BrandModel(
      name: 'HSBC Cashback',
      logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/1/12/ICICI_Bank_Logo.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1559526324-4b87b5e36e44?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat ₹1,200 Bonus',
      category: 'Shopping Cards',
      offerText: '10% Dining Cashback',
      websiteUrl: 'https://www.hsbc.co.in',
    ),
    BrandModel(
      name: 'StanChart Smart',
      logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/1/1a/Axis_Bank_logo.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1563013544-824ae1b704d3?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat ₹1,000 Bonus',
      category: 'Shopping Cards',
      offerText: '2% Online Cashback',
      websiteUrl: 'https://www.sc.com/in',
    ),
  ];

  static const List<BrandModel> medicineBrandsCatalog = [
    BrandModel(
      name: 'Tata 1mg',
      logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/6/6f/1mg_Logo.png',
      bannerUrl: 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat 12% Cashback',
      category: 'Medicines',
      offerText: 'Up to 25% Off',
      websiteUrl: 'https://www.1mg.com',
    ),
    BrandModel(
      name: 'PharmEasy',
      logoUrl: 'https://pharmeasy.in/assets/src/images/logo.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1471864190281-a93a3070b6de?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Up to 15% Cashback',
      category: 'Medicines',
      offerText: 'Up to 30% Off',
      websiteUrl: 'https://www.pharmeasy.in',
    ),
    BrandModel(
      name: 'Netmeds',
      logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/6/6f/1mg_Logo.png',
      bannerUrl: 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat 10% Cashback',
      category: 'Medicines',
      offerText: 'Flat 20% Off',
      websiteUrl: 'https://www.netmeds.com',
    ),
    BrandModel(
      name: 'Apollo Pharmacy',
      logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/6/6f/1mg_Logo.png',
      bannerUrl: 'https://images.unsplash.com/photo-1471864190281-a93a3070b6de?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Up to 8% Cashback',
      category: 'Medicines',
      offerText: 'Up to 15% Off',
      websiteUrl: 'https://www.apollopharmacy.in',
    ),
    BrandModel(
      name: 'HealthKart',
      logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/d/d7/HealthKart_Logo.png',
      bannerUrl: 'https://images.unsplash.com/photo-1579722821273-0f6c7d44362f?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Up to 10% Cashback',
      category: 'Medicines',
      offerText: 'Up to 40% Off',
      websiteUrl: 'https://www.healthkart.com',
    ),
    BrandModel(
      name: 'PharmEasy Lab',
      logoUrl: 'https://pharmeasy.in/assets/src/images/logo.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat ₹500 Cashback',
      category: 'Medicines',
      offerText: 'Flat 70% Off Labs',
      websiteUrl: 'https://www.pharmeasy.in',
    ),
  ];

  static const List<BrandModel> cardsAndLoansCatalog = [
    BrandModel(
      name: 'MoneyTap Line',
      logoUrl: 'https://www.moneytap.com/images/logo.png',
      bannerUrl: 'https://images.unsplash.com/photo-1554224155-8d04cb21cd6c?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat ₹1,000 Bonus',
      category: 'Cards & Loans',
      offerText: 'Credit Line ₹5 Lakhs',
      websiteUrl: 'https://www.moneytap.com',
    ),
    BrandModel(
      name: 'Navi Financial',
      logoUrl: 'https://navi.com/assets/images/navi_logo.png',
      bannerUrl: 'https://images.unsplash.com/photo-1579621970563-ebec7560ff3e?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat ₹1,200 Cashback',
      category: 'Cards & Loans',
      offerText: 'Instant Cash Loans',
      websiteUrl: 'https://navi.com',
    ),
    BrandModel(
      name: 'KreditBee',
      logoUrl: 'https://www.moneytap.com/images/logo.png',
      bannerUrl: 'https://images.unsplash.com/photo-1554224155-8d04cb21cd6c?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat ₹800 Cashback',
      category: 'Cards & Loans',
      offerText: 'Personal Credit Line',
      websiteUrl: 'https://www.kreditbee.in',
    ),
    BrandModel(
      name: 'Bajaj Finserv',
      logoUrl: 'https://navi.com/assets/images/navi_logo.png',
      bannerUrl: 'https://images.unsplash.com/photo-1579621970563-ebec7560ff3e?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat ₹1,500 Bonus',
      category: 'Cards & Loans',
      offerText: 'Insta EMI Card Free',
      websiteUrl: 'https://www.bajajfinserv.in',
    ),
    BrandModel(
      name: 'IndusInd Card',
      logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/1/12/ICICI_Bank_Logo.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1559526324-4b87b5e36e44?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat ₹1,200 Rewards',
      category: 'Cards & Loans',
      offerText: 'Lifetime Free Card',
      websiteUrl: 'https://www.indusind.com',
    ),
    BrandModel(
      name: 'BoB Credit Card',
      logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/1/1a/Axis_Bank_logo.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1563013544-824ae1b704d3?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat ₹1,000 Cashback',
      category: 'Cards & Loans',
      offerText: 'Zero Annual Fee',
      websiteUrl: 'https://www.bobfinancial.com',
    ),
  ];

  static const List<BrandModel> hotelBookingCatalog = [
    BrandModel(
      name: 'MakeMyTrip',
      logoUrl: 'https://imgak.mmtcdn.com/pwa_v3/pwa_commons_assets/desktop/logo.png',
      bannerUrl: 'https://images.unsplash.com/photo-1436491865332-7a61a109cc05?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat 8% Cashback',
      category: 'Travel',
      offerText: 'Up to 35% Off',
      websiteUrl: 'https://www.makemytrip.com',
    ),
    BrandModel(
      name: 'Booking.com',
      logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/b/be/Booking.com_logo.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Up to 9% Cashback',
      category: 'Travel',
      offerText: 'Up to 40% Off',
      websiteUrl: 'https://www.booking.com',
    ),
    BrandModel(
      name: 'Agoda',
      logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/c/ce/Agoda_logo.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1488646953014-85cb44e25828?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat 10% Cashback',
      category: 'Travel',
      offerText: 'Up to 50% Off',
      websiteUrl: 'https://www.agoda.com',
    ),
    BrandModel(
      name: 'Expedia',
      logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/c/ce/Agoda_logo.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1488646953014-85cb44e25828?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat 7% Cashback',
      category: 'Travel',
      offerText: 'Up to 30% Off',
      websiteUrl: 'https://www.expedia.com',
    ),
    BrandModel(
      name: 'Air India',
      logoUrl: 'https://imgak.mmtcdn.com/pwa_v3/pwa_commons_assets/desktop/logo.png',
      bannerUrl: 'https://images.unsplash.com/photo-1436491865332-7a61a109cc05?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat 6% Cashback',
      category: 'Travel',
      offerText: 'Flight Deals',
      websiteUrl: 'https://www.airindia.com',
    ),
    BrandModel(
      name: 'Qatar Airways',
      logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/b/be/Booking.com_logo.svg',
      bannerUrl: 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat 8% Cashback',
      category: 'Travel',
      offerText: 'Global Flights',
      websiteUrl: 'https://www.qatarairways.com',
    ),
  ];

  static const List<BrandModel> personalLoansCatalog = [
    BrandModel(
      name: 'Navi Loans',
      logoUrl: 'https://navi.com/assets/images/navi_logo.png',
      bannerUrl: 'https://images.unsplash.com/photo-1579621970563-ebec7560ff3e?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat ₹1,200 Cashback',
      category: 'Personal Loans',
      offerText: 'Loans up to ₹20 Lakhs',
      websiteUrl: 'https://navi.com',
    ),
    BrandModel(
      name: 'MoneyTap',
      logoUrl: 'https://www.moneytap.com/images/logo.png',
      bannerUrl: 'https://images.unsplash.com/photo-1554224155-8d04cb21cd6c?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat ₹1,000 Bonus',
      category: 'Personal Loans',
      offerText: 'Instant Credit Line',
      websiteUrl: 'https://www.moneytap.com',
    ),
    BrandModel(
      name: 'Tata Capital',
      logoUrl: 'https://navi.com/assets/images/navi_logo.png',
      bannerUrl: 'https://images.unsplash.com/photo-1579621970563-ebec7560ff3e?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat ₹1,500 Bonus',
      category: 'Personal Loans',
      offerText: 'Low Interest Rates',
      websiteUrl: 'https://www.tatacapital.com',
    ),
    BrandModel(
      name: 'Paysense',
      logoUrl: 'https://www.moneytap.com/images/logo.png',
      bannerUrl: 'https://images.unsplash.com/photo-1554224155-8d04cb21cd6c?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat ₹800 Cashback',
      category: 'Personal Loans',
      offerText: 'Quick Disbursal',
      websiteUrl: 'https://www.gopaysense.com',
    ),
    BrandModel(
      name: 'CASHe',
      logoUrl: 'https://navi.com/assets/images/navi_logo.png',
      bannerUrl: 'https://images.unsplash.com/photo-1579621970563-ebec7560ff3e?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat ₹700 Cashback',
      category: 'Personal Loans',
      offerText: 'Instant Salary Loan',
      websiteUrl: 'https://www.cashe.co.in',
    ),
    BrandModel(
      name: 'mPokket',
      logoUrl: 'https://www.moneytap.com/images/logo.png',
      bannerUrl: 'https://images.unsplash.com/photo-1554224155-8d04cb21cd6c?w=800&auto=format&fit=crop&q=80',
      cashbackPercentage: 'Flat ₹500 Cashback',
      category: 'Personal Loans',
      offerText: 'Student & Youth Loan',
      websiteUrl: 'https://mpokket.in',
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
      title: 'Samsung Galaxy M34 5G',
      description: '6GB RAM, 128GB Storage, 50MP Camera',
      priceOrRate: '\$199',
      cashbackTag: 'FLAT 15% CASHBACK',
      imageUrl:
          'https://cdn.dummyjson.com/products/images/smartphones/iPhone%205s/1.png',
      storeName: 'Flipkart',
    ),
    OfferSectionItem(
      id: 102,
      title: 'Realme Buds Air 5',
      description: 'Active Noise Cancellation, 38H Playtime',
      priceOrRate: '\$39',
      cashbackTag: 'FLAT 20% CASHBACK',
      imageUrl:
          'https://cdn.dummyjson.com/products/images/mobile-accessories/Apple%20AirPods%20Max/1.png',
      storeName: 'Flipkart',
    ),
    OfferSectionItem(
      id: 103,
      title: 'ASUS Vivobook 15',
      description: 'Intel Core i5 12th Gen, 16GB RAM',
      priceOrRate: '\$499',
      cashbackTag: 'FLAT 10% CASHBACK',
      imageUrl:
          'https://cdn.dummyjson.com/products/images/laptops/Apple%20MacBook%20Pro%2014%20Inch%20Space%20Grey/1.png',
      storeName: 'Flipkart',
    ),
    OfferSectionItem(
      id: 104,
      title: 'Boult Drift Smartwatch',
      description: '1.85" HD Display, Bluetooth Calling',
      priceOrRate: '\$25',
      cashbackTag: 'FLAT 25% CASHBACK',
      imageUrl:
          'https://cdn.dummyjson.com/products/images/womens-watches/IWC%20Ingenieur%20Automatic/1.png',
      storeName: 'Flipkart',
    ),
    OfferSectionItem(
      id: 105,
      title: 'Sony Bravia 4K Smart TV',
      description: '55 Inch Google TV, Dolby Atmos',
      priceOrRate: '\$599',
      cashbackTag: 'FLAT 12% CASHBACK',
      imageUrl:
          'https://cdn.dummyjson.com/products/images/mobile-accessories/Amazon%20Echo%20Dot%203rd%20Gen/1.png',
      storeName: 'Flipkart',
    ),
  ];

  static const List<OfferSectionItem> meeshoOffers = [
    OfferSectionItem(
      id: 201,
      title: 'Designer Silk Saree',
      description: 'Traditional Embroidered Saree',
      priceOrRate: '\$29',
      cashbackTag: 'UP TO 25% CASHBACK',
      imageUrl:
          'https://cdn.dummyjson.com/products/images/womens-dresses/Corset%20Mini%20Dress/1.png',
      storeName: 'Meesho',
    ),
    OfferSectionItem(
      id: 202,
      title: 'Men Casual Printed Shirt',
      description: '100% Breathable Cotton Fit',
      priceOrRate: '\$15',
      cashbackTag: 'UP TO 30% CASHBACK',
      imageUrl:
          'https://cdn.dummyjson.com/products/images/mens-shirts/Man%20Shirt/1.png',
      storeName: 'Meesho',
    ),
    OfferSectionItem(
      id: 203,
      title: 'Matte Lipstick Combo',
      description: 'Long Lasting 12H Stay Lipstick',
      priceOrRate: '\$12',
      cashbackTag: 'UP TO 20% CASHBACK',
      imageUrl:
          'https://cdn.dummyjson.com/products/images/beauty/Essence%20Mascara%20Lash%20Princess/1.png',
      storeName: 'Meesho',
    ),
    OfferSectionItem(
      id: 204,
      title: 'Running Sports Shoes',
      description: 'Lightweight Mesh Comfort Shoes',
      priceOrRate: '\$22',
      cashbackTag: 'UP TO 18% CASHBACK',
      imageUrl:
          'https://cdn.dummyjson.com/products/images/mens-shoes/Sports%20Sneakers/1.png',
      storeName: 'Meesho',
    ),
    OfferSectionItem(
      id: 205,
      title: 'Kitchen Storage Container',
      description: 'Set of 12 Airtight Jar Set',
      priceOrRate: '\$18',
      cashbackTag: 'UP TO 22% CASHBACK',
      imageUrl:
          'https://cdn.dummyjson.com/products/images/kitchen-accessories/Bamboo%20Spatula/1.png',
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
        return const [
          BrandModel(
            name: 'Amazon.in',
            logoUrl: 'https://www.freepnglogos.com/uploads/amazon-png-logo-vector/woodland-gardening-amazon-png-logo-vector-8.png',
            bannerUrl: 'https://www.freepnglogos.com/uploads/amazon-png-logo-vector/woodland-gardening-amazon-png-logo-vector-8.png',
            cashbackPercentage: 'Up to 8% Rewards',
            category: 'Most Popular',
            offerText: 'Up to 8000000% Off',
            websiteUrl: 'https://www.amazon.in',
          ),
          BrandModel(
            name: 'Flipkart',
            logoUrl: 'https://www.freepnglogos.com/uploads/flipkart-logo-png/flipkart-logo-transparent-vector-3.png',
            bannerUrl: 'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Up to 7% Rewards',
            category: 'Most Popular',
            offerText: 'Up to 75% Off',
            websiteUrl: 'https://www.flipkart.com',
          ),
          BrandModel(
            name: 'Myntra',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/b/bc/Myntra_Logo.png',
            bannerUrl: 'https://images.unsplash.com/photo-1483985988355-763728e1935b?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Flat 7.5% Rewards',
            category: 'Most Popular',
            offerText: 'Up to 60% Off',
            websiteUrl: 'https://www.myntra.com',
          ),
          BrandModel(
            name: 'AJIO',
            logoUrl: 'https://assets.ajio.com/static/img/Ajio-Logo.svg',
            bannerUrl: 'https://images.unsplash.com/photo-1445205170230-053b83016050?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Flat 10% Rewards',
            category: 'Most Popular',
            offerText: 'Flat 50% Off',
            websiteUrl: 'https://www.ajio.com',
          ),
          BrandModel(
            name: 'MakeMyTrip',
            logoUrl: 'https://imgak.mmtcdn.com/pwa_v3/pwa_commons_assets/desktop/logo.png',
            bannerUrl: 'https://images.unsplash.com/photo-1436491865332-7a61a109cc05?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Flat 8% Rewards',
            category: 'Most Popular',
            offerText: 'Up to 35% Off',
            websiteUrl: 'https://www.makemytrip.com',
          ),
          BrandModel(
            name: 'Samsung',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/2/24/Samsung_Logo.svg',
            bannerUrl: 'https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Up to 9% Rewards',
            category: 'Most Popular',
            offerText: 'Up to 50% Off',
            websiteUrl: 'https://www.samsung.com/in',
          ),
        ];

      case 'Fashion':
        return const [
          BrandModel(
            name: 'Myntra',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/b/bc/Myntra_Logo.png',
            bannerUrl: 'https://images.unsplash.com/photo-1483985988355-763728e1935b?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Flat 7.5% Cashback',
            category: 'Fashion',
            offerText: 'Up to 70% Off',
            websiteUrl: 'https://www.myntra.com',
          ),
          BrandModel(
            name: 'AJIO',
            logoUrl: 'https://assets.ajio.com/static/img/Ajio-Logo.svg',
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

      case 'Credit Cards':
        return const [
          BrandModel(
            name: 'SBI Card',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/c/cc/SBI-Logo.svg',
            bannerUrl: 'https://images.unsplash.com/photo-1563013544-824ae1b704d3?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Flat ₹1,200 Cashback',
            category: 'Credit Cards',
            offerText: 'Instant ₹500 Gift Card',
            websiteUrl: 'https://www.sbicard.com',
          ),
          BrandModel(
            name: 'HDFC Bank',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/2/28/HDFC_Bank_Logo.svg',
            bannerUrl: 'https://images.unsplash.com/photo-1559526324-4b87b5e36e44?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Flat ₹1,500 Bonus',
            category: 'Credit Cards',
            offerText: 'Lifetime Free Card',
            websiteUrl: 'https://www.hdfcbank.com',
          ),
          BrandModel(
            name: 'ICICI Bank',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/1/12/ICICI_Bank_Logo.svg',
            bannerUrl: 'https://images.unsplash.com/photo-1556742049-0a67dd385203?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Flat ₹1,000 Rewards',
            category: 'Credit Cards',
            offerText: 'Zero Joining Fee',
            websiteUrl: 'https://www.icicibank.com',
          ),
          BrandModel(
            name: 'Axis Bank',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/1/1a/Axis_Bank_logo.svg',
            bannerUrl: 'https://images.unsplash.com/photo-1601597111158-2fceff292cdc?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Flat ₹1,500 Cashback',
            category: 'Credit Cards',
            offerText: '5% Unlimited Cashback',
            websiteUrl: 'https://www.axisbank.com',
          ),
        ];

      case 'Beauty & Grooming':
        return const [
          BrandModel(
            name: 'Nykaa',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/0/00/Nykaa_New_Logo.svg',
            bannerUrl: 'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Up to 8% Cashback',
            category: 'Beauty & Grooming',
            offerText: 'Up to 50% Off',
            websiteUrl: 'https://www.nykaa.com',
          ),
          BrandModel(
            name: 'Sephora',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/2/21/Sephora_logo.svg',
            bannerUrl: 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Flat 10% Cashback',
            category: 'Beauty & Grooming',
            offerText: 'Up to 40% Off',
            websiteUrl: 'https://sephora.in',
          ),
          BrandModel(
            name: 'Mamaearth',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/0/00/Nykaa_New_Logo.svg',
            bannerUrl: 'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Flat 12% Cashback',
            category: 'Beauty & Grooming',
            offerText: 'Buy 1 Get 1 Free',
            websiteUrl: 'https://mamaearth.in',
          ),
        ];

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
        return const [
          BrandModel(
            name: 'Amazon',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/a/a9/Amazon_logo.svg',
            bannerUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Up to 6% Cashback',
            category: 'Electronics',
            offerText: 'Up to 65% Off',
            websiteUrl: 'https://www.amazon.in',
          ),
          BrandModel(
            name: 'Flipkart',
            logoUrl: 'https://www.freepnglogos.com/uploads/flipkart-logo-png/flipkart-logo-transparent-vector-3.png',
            bannerUrl: 'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Up to 7% Cashback',
            category: 'Electronics',
            offerText: 'Up to 70% Off',
            websiteUrl: 'https://www.flipkart.com',
          ),
          BrandModel(
            name: 'Croma',
            logoUrl: 'https://media.croma.com/image/upload/v1637759004/Croma%20Assets/CMS/Category%20Icon/Croma_Logo.png',
            bannerUrl: 'https://images.unsplash.com/photo-1526738549149-8e07eca6c147?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Flat 6% Cashback',
            category: 'Electronics',
            offerText: 'Up to 50% Off',
            websiteUrl: 'https://www.croma.com',
          ),
          BrandModel(
            name: 'Apple Store',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/f/fa/Apple_logo_black.svg',
            bannerUrl: 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Up to 4% Cashback',
            category: 'Electronics',
            offerText: 'Save up to ₹10,000',
            websiteUrl: 'https://www.apple.com/in',
          ),
          BrandModel(
            name: 'Samsung',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/2/24/Samsung_Logo.svg',
            bannerUrl: 'https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Up to 8% Cashback',
            category: 'Electronics',
            offerText: 'Up to 55% Off',
            websiteUrl: 'https://www.samsung.com/in',
          ),
          BrandModel(
            name: 'Reliance Digital',
            logoUrl: 'https://www.reliancedigital.in/build/client/images/rel_stat_svg.svg',
            bannerUrl: 'https://images.unsplash.com/photo-1550009158-9ebf69173e03?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Up to 5% Cashback',
            category: 'Electronics',
            offerText: 'Up to 45% Off',
            websiteUrl: 'https://www.reliancedigital.in',
          ),
        ];

      case 'Food & Grocery':
        return const [
          BrandModel(
            name: 'Swiggy',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/1/13/Swiggy_logo.svg',
            bannerUrl: 'https://images.unsplash.com/photo-1578916171728-46686eac8d58?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Flat 10% Cashback',
            category: 'Food & Grocery',
            offerText: 'Flat 50% Off',
            websiteUrl: 'https://www.swiggy.com',
          ),
          BrandModel(
            name: 'Zomato',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/b/bd/Zomato_Logo.svg',
            bannerUrl: 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Flat 8% Cashback',
            category: 'Food & Grocery',
            offerText: 'Up to 60% Off',
            websiteUrl: 'https://www.zomato.com',
          ),
          BrandModel(
            name: 'Blinkit',
            logoUrl: 'https://blinkit.com/images/header/blinkit_logo.png',
            bannerUrl: 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Up to 8% Cashback',
            category: 'Food & Grocery',
            offerText: 'Flat ₹100 Off',
            websiteUrl: 'https://www.blinkit.com',
          ),
        ];

      case 'Flights & Hotels':
        return const [
          BrandModel(
            name: 'MakeMyTrip',
            logoUrl: 'https://imgak.mmtcdn.com/pwa_v3/pwa_commons_assets/desktop/logo.png',
            bannerUrl: 'https://images.unsplash.com/photo-1436491865332-7a61a109cc05?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Flat 8% Cashback',
            category: 'Flights & Hotels',
            offerText: 'Up to 35% Off',
            websiteUrl: 'https://www.makemytrip.com',
          ),
          BrandModel(
            name: 'Booking.com',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/b/be/Booking.com_logo.svg',
            bannerUrl: 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Up to 9% Cashback',
            category: 'Flights & Hotels',
            offerText: 'Up to 40% Off',
            websiteUrl: 'https://www.booking.com',
          ),
          BrandModel(
            name: 'Agoda',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/c/ce/Agoda_logo.svg',
            bannerUrl: 'https://images.unsplash.com/photo-1488646953014-85cb44e25828?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Flat 10% Cashback',
            category: 'Flights & Hotels',
            offerText: 'Up to 50% Off',
            websiteUrl: 'https://www.agoda.com',
          ),
          BrandModel(
            name: 'Expedia',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/c/ce/Agoda_logo.svg',
            bannerUrl: 'https://images.unsplash.com/photo-1488646953014-85cb44e25828?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Flat 7% Cashback',
            category: 'Flights & Hotels',
            offerText: 'Up to 30% Off',
            websiteUrl: 'https://www.expedia.com',
          ),
        ];

      default:
        return const [
          BrandModel(
            name: 'Amazon.in',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/a/a9/Amazon_logo.svg',
            bannerUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=800&auto=format&fit=crop&q=80',
            cashbackPercentage: 'Up to 8% Cashback',
            category: 'E-Commerce',
            offerText: 'Up to 80% Off',
            websiteUrl: 'https://www.amazon.in',
          ),
        ];
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
  ];
}
