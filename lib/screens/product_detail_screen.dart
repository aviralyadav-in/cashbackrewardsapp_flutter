import 'package:flutter/material.dart';

import '../models/amazon_deal_model.dart';
import '../models/brand_model.dart';
import '../models/product.dart';
import '../screens/offer_section_screen.dart';
import '../services/url_launcher_service.dart';
import '../widgets/network_image_with_skeleton.dart';

class ProductDetailScreen extends StatefulWidget {
  static const String routeName = '/product-detail';

  final Product? product;
  final BrandModel? brand;
  final AmazonDealItemData? amazonDeal;
  final OfferSectionItem? offerItem;

  // Custom generic attributes for maximum flexibility
  final String? customTitle;
  final String? customBrandName;
  final String? customCategory;
  final String? customOriginalPrice;
  final String? customDiscountedPrice;
  final String? customDiscountTag;
  final String? customCashbackTag;
  final String? customFinalPrice;
  final String? customDescription;
  final String? customImageUrl;
  final List<String>? customImages;
  final String? customWebsiteUrl;
  final double? customRating;
  final int? customStock;

  const ProductDetailScreen({
    super.key,
    this.product,
    this.brand,
    this.amazonDeal,
    this.offerItem,
    this.customTitle,
    this.customBrandName,
    this.customCategory,
    this.customOriginalPrice,
    this.customDiscountedPrice,
    this.customDiscountTag,
    this.customCashbackTag,
    this.customFinalPrice,
    this.customDescription,
    this.customImageUrl,
    this.customImages,
    this.customWebsiteUrl,
    this.customRating,
    this.customStock,
  });

  /// Factory for OfferSectionItem (Flipkart, Meesho, etc.)
  factory ProductDetailScreen.fromOfferItem(
    OfferSectionItem item, {
    Key? key,
  }) {
    return ProductDetailScreen(
      key: key,
      offerItem: item,
      customTitle: item.title,
      customBrandName: item.storeName,
      customCategory: item.storeName,
      customDiscountedPrice: item.priceOrRate,
      customCashbackTag: item.cashbackTag,
      customDescription: item.description,
      customImageUrl: item.imageUrl,
      customWebsiteUrl: _resolveStoreUrl(item.storeName),
    );
  }

  /// Factory for AmazonDealItemData
  factory ProductDetailScreen.fromAmazonDeal(
    AmazonDealItemData deal, {
    Key? key,
  }) {
    final originalPriceStr = '₹${_formatCurrency(deal.actualPrice.round())}';
    final discountedPriceStr = '₹${_formatCurrency(deal.finalPrice)}';
    final rewardTag = 'Flat ${deal.rewardPercentage.toInt()}% Reward';
    final finalPriceStr = '₹${_formatCurrency(deal.finalPrice)}';

    return ProductDetailScreen(
      key: key,
      amazonDeal: deal,
      customTitle: deal.productName,
      customBrandName: deal.brandName.isNotEmpty ? deal.brandName : 'Amazon',
      customCategory: 'Amazon Top Deals',
      customOriginalPrice: originalPriceStr,
      customDiscountedPrice: discountedPriceStr,
      customDiscountTag: '${deal.rewardPercentage.toStringAsFixed(0)}% OFF',
      customCashbackTag: rewardTag,
      customFinalPrice: finalPriceStr,
      customDescription:
          'Special promotional pricing on Amazon with extra cashback rewards automatically credited to your CashKaro wallet after delivery.',
      customImageUrl: deal.imageUrl,
      customWebsiteUrl: deal.productUrl.isNotEmpty
          ? deal.productUrl
          : 'https://www.amazon.in',
    );
  }

  /// Factory for BrandModel (Popular Brands, Fashion, Beauty, Electronics, etc.)
  factory ProductDetailScreen.fromBrand(
    BrandModel brand, {
    Key? key,
  }) {
    final imgUrl = brand.bannerUrl.isNotEmpty
        ? brand.bannerUrl
        : (brand.logoUrl.isNotEmpty ? brand.logoUrl : '');

    return ProductDetailScreen(
      key: key,
      brand: brand,
      customTitle: brand.name,
      customBrandName: brand.name,
      customCategory: brand.category.isNotEmpty ? brand.category : 'Featured Partner',
      customDiscountTag: brand.offerText,
      customCashbackTag: brand.cashbackPercentage,
      customDescription:
          'Shop online at ${brand.name} through CashKaro to enjoy exclusive voucher discounts and guaranteed cashback rewards on your orders.',
      customImageUrl: imgUrl,
      customImages: [
        if (brand.bannerUrl.isNotEmpty) brand.bannerUrl,
        if (brand.logoUrl.isNotEmpty && brand.logoUrl != brand.bannerUrl) brand.logoUrl,
      ],
      customWebsiteUrl: brand.websiteUrl.isNotEmpty
          ? brand.websiteUrl
          : _resolveStoreUrl(brand.name),
    );
  }

  static String _formatCurrency(num amount) {
    final str = amount.round().toString();
    final reg = RegExp(r'(\d+?)(?=(\d{3})+(?!\d))');
    return str.replaceAllMapped(reg, (Match m) => '${m[1]},');
  }

  static String _resolveStoreUrl(String storeOrBrand) {
    final target = storeOrBrand.toLowerCase();
    if (target.contains('flipkart')) return 'https://www.flipkart.com';
    if (target.contains('meesho')) return 'https://www.meesho.com';
    if (target.contains('amazon')) return 'https://www.amazon.in';
    if (target.contains('myntra')) return 'https://www.myntra.com';
    if (target.contains('nykaa')) return 'https://www.nykaa.com';
    if (target.contains('ajio')) return 'https://www.ajio.com';
    if (target.contains('croma')) return 'https://www.croma.com';
    if (target.contains('reliance')) return 'https://www.reliancedigital.in';
    if (target.contains('zara')) return 'https://www.zara.com/in';
    if (target.contains('h&m') || target.contains('hm')) return 'https://www2.hm.com/en_in';
    if (target.contains('nike')) return 'https://www.nike.com/in';
    if (target.contains('adidas')) return 'https://www.adidas.co.in';
    if (target.contains('puma')) return 'https://in.puma.com';
    if (target.contains('samsung')) return 'https://www.samsung.com/in';
    if (target.contains('apple')) return 'https://www.apple.com/in';
    if (target.contains('sony')) return 'https://www.sony.co.in';
    if (target.contains('boat')) return 'https://www.boat-lifestyle.com';
    if (target.contains('noise')) return 'https://www.gonoise.com';
    if (target.contains('dyson')) return 'https://www.dyson.in';
    return 'https://www.google.com/search?q=${Uri.encodeComponent(storeOrBrand)}';
  }

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _currentImageIndex = 0;

  Future<void> _handleShopNow(String targetUrl, String storeName) async {
    final success = await UrlLauncherService.openUrl(targetUrl);
    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not open $storeName website. Please try again.'),
          backgroundColor: const Color(0xFF1E90FF),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Resolve details dynamically from Product object, route arguments, or custom attributes
    final routeArgs = ModalRoute.of(context)?.settings.arguments;
    Product? product = widget.product;
    BrandModel? brand = widget.brand;
    AmazonDealItemData? amazonDeal = widget.amazonDeal;
    OfferSectionItem? offerItem = widget.offerItem;

    if (routeArgs != null) {
      if (routeArgs is Product) {
        product = routeArgs;
      } else if (routeArgs is BrandModel) {
        brand = routeArgs;
      } else if (routeArgs is AmazonDealItemData) {
        amazonDeal = routeArgs;
      } else if (routeArgs is OfferSectionItem) {
        offerItem = routeArgs;
      }
    }

    final title = widget.customTitle ??
        product?.title ??
        brand?.name ??
        amazonDeal?.productName ??
        offerItem?.title ??
        'Product Details';

    final brandName = widget.customBrandName ??
        product?.brand ??
        brand?.name ??
        amazonDeal?.brandName ??
        offerItem?.storeName ??
        '';

    final category = widget.customCategory ??
        product?.category ??
        brand?.category ??
        (amazonDeal != null ? 'Amazon Top Deals' : (offerItem?.storeName ?? ''));

    final rating = widget.customRating ?? product?.rating;
    final stock = widget.customStock ?? product?.stock;
    final description = widget.customDescription ??
        product?.description ??
        (brand != null
            ? 'Shop online at ${brand.name} through CashKaro to enjoy exclusive voucher discounts and guaranteed cashback rewards on your orders.'
            : (amazonDeal != null
                ? 'Special promotional pricing on Amazon with extra cashback rewards automatically credited to your CashKaro wallet after delivery.'
                : (offerItem?.description ??
                    'Shop this deal via CashKaro to earn guaranteed cashback rewards credited to your account.')));

    // Image list resolution
    List<String> imageList = [];
    if (widget.customImages != null && widget.customImages!.isNotEmpty) {
      imageList = List.from(widget.customImages!);
    } else if (widget.customImageUrl != null && widget.customImageUrl!.isNotEmpty) {
      imageList = [widget.customImageUrl!];
    } else if (product != null) {
      if (product.images != null && product.images!.isNotEmpty) {
        imageList = List.from(product.images!);
      } else if (product.thumbnail.isNotEmpty) {
        imageList = [product.thumbnail];
      }
    } else if (brand != null) {
      if (brand.bannerUrl.isNotEmpty) imageList.add(brand.bannerUrl);
      if (brand.logoUrl.isNotEmpty && brand.logoUrl != brand.bannerUrl) {
        imageList.add(brand.logoUrl);
      }
    } else if (amazonDeal != null && amazonDeal.imageUrl.isNotEmpty) {
      imageList = [amazonDeal.imageUrl];
    } else if (offerItem != null && offerItem.imageUrl.isNotEmpty) {
      imageList = [offerItem.imageUrl];
    }

    // Pricing resolution
    final discountedPrice = widget.customDiscountedPrice ??
        (product != null
            ? '₹${ProductDetailScreen._formatCurrency((product.finalPrice * 83).round())}'
            : (amazonDeal != null
                ? '₹${ProductDetailScreen._formatCurrency(amazonDeal.finalPrice)}'
                : offerItem?.priceOrRate));

    final originalPrice = widget.customOriginalPrice ??
        (product != null && product.discountPercentage > 0
            ? '₹${ProductDetailScreen._formatCurrency((product.originalPrice * 83).round())}'
            : (amazonDeal != null
                ? '₹${ProductDetailScreen._formatCurrency(amazonDeal.actualPrice.round())}'
                : null));

    final discountTag = widget.customDiscountTag ??
        (product != null && product.discountPercentage > 0
            ? '${product.discountPercentage.toStringAsFixed(0)}% OFF'
            : (brand?.offerText ??
                (amazonDeal != null
                    ? '${amazonDeal.rewardPercentage.toStringAsFixed(0)}% OFF'
                    : null)));

    final cashbackTag = widget.customCashbackTag ??
        (product != null
            ? 'FLAT ${(product.discountPercentage > 0 ? product.discountPercentage : 10).toStringAsFixed(0)}% CASHBACK'
            : (brand?.cashbackPercentage ??
                (amazonDeal != null
                    ? 'Flat ${amazonDeal.rewardPercentage.toInt()}% Reward'
                    : (offerItem?.cashbackTag ?? 'EARN EXTRA CASHBACK'))));

    final finalPrice = widget.customFinalPrice ?? discountedPrice;

    // Target Website URL resolution
    final websiteUrl = widget.customWebsiteUrl ??
        (brand?.websiteUrl.isNotEmpty == true
            ? brand!.websiteUrl
            : (amazonDeal?.productUrl.isNotEmpty == true
                ? amazonDeal!.productUrl
                : ProductDetailScreen._resolveStoreUrl(
                    brandName.isNotEmpty ? brandName : (category.isNotEmpty ? category : title))));

    final displayStoreName = brandName.isNotEmpty
        ? brandName
        : (category.isNotEmpty ? category : 'Store');

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0D0D0D) : const Color(0xFFF6F7F9),
      appBar: AppBar(
        title: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isDark ? Colors.white : Colors.black87,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: isDark ? const Color(0xFF161618) : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black87,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. PRODUCT / BRAND IMAGE SECTION
                  Container(
                    width: double.infinity,
                    height: 280,
                    color: isDark ? const Color(0xFF161618) : Colors.white,
                    child: imageList.isEmpty
                        ? Container(
                            color: isDark ? const Color(0xFF242426) : Colors.grey.shade100,
                            child: const Center(
                              child: Icon(
                                Icons.storefront_rounded,
                                size: 80,
                                color: Color(0xFF1E90FF),
                              ),
                            ),
                          )
                        : Stack(
                            children: [
                              PageView.builder(
                                itemCount: imageList.length,
                                onPageChanged: (index) {
                                  setState(() {
                                    _currentImageIndex = index;
                                  });
                                },
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Center(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: NetworkImageWithSkeleton(
                                          imageUrl: imageList[index],
                                          fit: BoxFit.contain,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Container(
                                              color: isDark
                                                  ? const Color(0xFF242426)
                                                  : Colors.grey.shade200,
                                              child: const Center(
                                                child: Icon(
                                                  Icons.image_not_supported_outlined,
                                                  size: 64,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              if (imageList.length > 1)
                                Positioned(
                                  bottom: 12,
                                  left: 0,
                                  right: 0,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(
                                      imageList.length,
                                      (index) => AnimatedContainer(
                                        duration: const Duration(milliseconds: 200),
                                        margin: const EdgeInsets.symmetric(horizontal: 3),
                                        width: _currentImageIndex == index ? 20 : 7,
                                        height: 7,
                                        decoration: BoxDecoration(
                                          color: _currentImageIndex == index
                                              ? const Color(0xFF1E90FF)
                                              : (isDark ? Colors.white38 : Colors.black26),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                  ),

                  const SizedBox(height: 10),

                  // 2. MAIN PRODUCT HEADER CARD
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    color: isDark ? const Color(0xFF161618) : Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // BRAND & CATEGORY & RATING CHIPS
                        Row(
                          children: [
                            if (brandName.isNotEmpty)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1E90FF).withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  brandName.toUpperCase(),
                                  style: const TextStyle(
                                    color: Color(0xFF1E90FF),
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            if (brandName.isNotEmpty && category.isNotEmpty)
                              const SizedBox(width: 8),
                            if (category.isNotEmpty)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? const Color(0xFF28282A)
                                      : const Color(0xFFF0F2F5),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  category,
                                  style: TextStyle(
                                    color: isDark
                                        ? Colors.grey.shade300
                                        : Colors.grey.shade700,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            const Spacer(),
                            if (rating != null)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.amber.shade700,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      size: 14,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      rating.toStringAsFixed(1),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // PRODUCT TITLE
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            height: 1.3,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // 3. PRICING & CASHBACK DETAILS CARD
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    color: isDark ? const Color(0xFF161618) : Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pricing & Offer Details',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (discountedPrice != null)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Deal Price',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isDark
                                          ? Colors.grey.shade400
                                          : Colors.grey.shade600,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    discountedPrice,
                                    style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.w900,
                                      color: isDark
                                          ? const Color(0xFF1E90FF)
                                          : const Color(0xFF0066CC),
                                    ),
                                  ),
                                ],
                              ),
                            if (originalPrice != null) ...[
                              const SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Original Price',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isDark
                                          ? Colors.grey.shade500
                                          : Colors.grey.shade600,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    originalPrice,
                                    style: TextStyle(
                                      fontSize: 16,
                                      decoration: TextDecoration.lineThrough,
                                      color: isDark
                                          ? Colors.grey.shade500
                                          : Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            const Spacer(),
                            if (discountTag != null && discountTag.isNotEmpty)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade50,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.green.shade300),
                                ),
                                child: Text(
                                  discountTag,
                                  style: TextStyle(
                                    color: Colors.green.shade800,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                          ],
                        ),

                        // CASHBACK HIGHLIGHT BANNER
                        const SizedBox(height: 14),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isDark
                                  ? [
                                      const Color(0xFF0D3E24),
                                      const Color(0xFF161618),
                                    ]
                                  : [
                                      const Color(0xFFE8F5E9),
                                      const Color(0xFFF1F8E9),
                                    ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isDark
                                  ? Colors.green.shade800
                                  : Colors.green.shade300,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: Colors.green.shade700,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.account_balance_wallet_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      cashbackTag,
                                      style: TextStyle(
                                        color: isDark
                                            ? Colors.green.shade300
                                            : Colors.green.shade900,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Cashback tracks automatically on ${displayStoreName.toUpperCase()}',
                                      style: TextStyle(
                                        color: isDark
                                            ? Colors.grey.shade400
                                            : Colors.grey.shade700,
                                        fontSize: 11.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        if (finalPrice != null) ...[
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                'Effective Price after Cashback: ',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? Colors.grey.shade300
                                      : Colors.grey.shade700,
                                ),
                              ),
                              Text(
                                finalPrice,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF1E90FF),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // 4. DESCRIPTION & GUARANTEES CARD
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    color: isDark ? const Color(0xFF161618) : Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Product Overview & Details',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          description,
                          style: TextStyle(
                            height: 1.5,
                            fontSize: 13.5,
                            color: isDark ? Colors.grey.shade300 : Colors.grey.shade800,
                          ),
                        ),
                        if (stock != null) ...[
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Icon(
                                Icons.inventory_2_outlined,
                                size: 16,
                                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Availability: ',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                                ),
                              ),
                              Text(
                                '$stock units in stock',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.bold,
                                  color: stock < 10
                                      ? Colors.orange
                                      : (isDark ? Colors.white : Colors.black87),
                                ),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 16),
                        const Divider(),
                        const SizedBox(height: 10),

                        // How Cashback Works 3 Steps
                        Text(
                          'How to Earn Cashback:',
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildCashbackStep(
                          '1',
                          'Tap "Shop Now" below to visit $displayStoreName',
                          isDark,
                        ),
                        const SizedBox(height: 6),
                        _buildCashbackStep(
                          '2',
                          'Place your order normally on the website/app',
                          isDark,
                        ),
                        const SizedBox(height: 6),
                        _buildCashbackStep(
                          '3',
                          'Cashback is tracked within 24-48 hrs & ready to withdraw',
                          isDark,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // 5. PROMINENT BOTTOM "SHOP NOW" BAR
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF161618) : Colors.white,
              border: Border(
                top: BorderSide(
                  color: isDark ? const Color(0xFF28282A) : const Color(0xFFE5E5EA),
                  width: 1,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.08),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              child: ElevatedButton(
                onPressed: () => _handleShopNow(websiteUrl, displayStoreName),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E90FF),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 2,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.shopping_bag_outlined, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Shop Now on ${displayStoreName.toUpperCase()}',
                      style: const TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.arrow_forward_rounded, size: 18),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCashbackStep(String step, String text, bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: const BoxDecoration(
            color: Color(0xFF1E90FF),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              step,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
            ),
          ),
        ),
      ],
    );
  }
}
