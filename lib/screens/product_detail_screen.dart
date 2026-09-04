import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/amazon_deal_model.dart';
import '../models/brand_model.dart';
import '../models/product.dart';
import '../screens/offer_section_screen.dart';
import '../services/url_launcher_service.dart';
import '../theme/app_theme.dart';
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
      customWebsiteUrl: resolveStoreUrl(item.storeName),
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

  /// Factory for BrandModel
  factory ProductDetailScreen.fromBrand(
    BrandModel brand, {
    Key? key,
  }) {
    return ProductDetailScreen(
      key: key,
      brand: brand,
      customTitle: '${brand.name} Cashback & Offers',
      customBrandName: brand.name,
      customCategory: brand.category,
      customDiscountTag: brand.offerText,
      customCashbackTag: brand.cashbackPercentage,
      customDescription:
          'Shop online at ${brand.name} to earn up to ${brand.cashbackPercentage} cashback on your purchase. All transactions are securely tracked.',
      customImageUrl: brand.bannerUrl.isNotEmpty ? brand.bannerUrl : brand.logoUrl,
      customWebsiteUrl: (brand.websiteUrl.isNotEmpty && !brand.websiteUrl.contains('cashkaro.com'))
          ? brand.websiteUrl
          : resolveStoreUrl(brand.name),
    );
  }

  static String _formatCurrency(num amount) {
    final str = amount.round().toString();
    final reg = RegExp(r'(\d+?)(?=(\d{3})+(?!\d))');
    return str.replaceAllMapped(reg, (Match m) => '${m[1]},');
  }

  static String resolveStoreUrl(String storeOrBrand) {
    final target = storeOrBrand.toLowerCase();

    // Banks & Financial Institutions (Credit Cards & Loans)
    if (target.contains('sbi')) return 'https://www.sbicard.com';
    if (target.contains('hdfc')) return 'https://www.hdfcbank.com';
    if (target.contains('axis')) return 'https://www.axisbank.com';
    if (target.contains('icici')) return 'https://www.icicibank.com';
    if (target.contains('hsbc')) return 'https://www.hsbc.co.in';
    if (target.contains('kotak')) return 'https://www.kotak.com';
    if (target.contains('idfc')) return 'https://www.idfcfirstbank.com';
    if (target.contains('bobcard') || target.contains('baroda')) return 'https://www.bobcard.co.in';
    if (target.contains('yes bank') || target.contains('yes')) return 'https://www.yesbank.in';
    if (target.contains('indusind')) return 'https://www.indusind.com';
    if (target.contains('rbl')) return 'https://www.rblbank.com';
    if (target.contains('scapia')) return 'https://www.scapia.cards';
    if (target.contains('uni')) return 'https://www.uni.cards';
    if (target.contains('tata neu')) return 'https://www.tataneu.com';
    if (target.contains('tata capital') || target.contains('tata')) return 'https://www.tatacapital.com';
    if (target.contains('bajaj')) return 'https://www.bajajfinserv.in';
    if (target.contains('poonawalla')) return 'https://www.poonawallafincorp.com';
    if (target.contains('money view') || target.contains('moneyview')) return 'https://moneyview.in';
    if (target.contains('fibe')) return 'https://www.fibe.in';
    if (target.contains('kiwi')) return 'https://gokiwi.in';
    if (target.contains('salaryse')) return 'https://salaryse.com';
    if (target.contains('ram fincorp')) return 'https://ramfincorp.com';
    if (target.contains('zapcash')) return 'https://zapcash.in';
    if (target.contains('prefr')) return 'https://prefr.com';
    if (target.contains('olyv') || target.contains('smartcoin')) return 'https://olyv.com';
    if (target.contains('mpokket')) return 'https://mpokket.in';
    if (target.contains('zype')) return 'https://getzype.com';
    if (target.contains('creditsea')) return 'https://creditsea.com';
    if (target.contains('bankkaro')) return 'https://bankkaro.com';

    // Top E-commerce & Shopping Brands
    if (target.contains('flipkart')) return 'https://www.flipkart.com';
    if (target.contains('meesho')) return 'https://www.meesho.com';
    if (target.contains('amazon')) return 'https://www.amazon.in';
    if (target.contains('myntra')) return 'https://www.myntra.com';
    if (target.contains('nykaa')) return 'https://www.nykaa.com';
    if (target.contains('ajio')) return 'https://www.ajio.com';
    if (target.contains('croma')) return 'https://www.croma.com';
    if (target.contains('reliance')) return 'https://www.reliancedigital.in';
    if (target.contains('jiomart')) return 'https://www.jiomart.com';
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
    if (target.contains('realme')) return 'https://www.realme.com/in';
    if (target.contains('swiggy')) return 'https://www.swiggy.com';
    if (target.contains('zomato')) return 'https://www.zomato.com';
    if (target.contains('blinkit')) return 'https://blinkit.com';
    if (target.contains('zepto')) return 'https://www.zeptonow.com';
    if (target.contains('makemytrip')) return 'https://www.makemytrip.com';
    if (target.contains('goibibo')) return 'https://www.goibibo.com';
    if (target.contains('cleartrip')) return 'https://www.cleartrip.com';
    if (target.contains('1mg')) return 'https://www.1mg.com';
    if (target.contains('pharmeasy')) return 'https://pharmeasy.in';
    if (target.contains('netmeds')) return 'https://www.netmeds.com';
    if (target.contains('apollo')) return 'https://www.apollopharmacy.in';

    return 'https://www.google.com/search?q=${Uri.encodeComponent(storeOrBrand)}';
  }

  static String _extractBankName(String name) {
    if (name.contains('SBI')) return 'SBI';
    if (name.contains('HDFC')) return 'HDFC Bank';
    if (name.contains('Axis')) return 'Axis Bank';
    if (name.contains('ICICI')) return 'ICICI Bank';
    if (name.contains('HSBC')) return 'HSBC';
    if (name.contains('Kotak')) return 'Kotak';
    if (name.contains('IDFC')) return 'IDFC FIRST';
    if (name.contains('BOBCARD') || name.contains('Bank of Baroda')) return 'BOBCARD';
    if (name.contains('Yes Bank') || name.contains('YES BANK')) return 'Yes Bank';
    if (name.contains('IndusInd') || name.contains('Indusind')) return 'IndusInd';
    if (name.contains('RBL')) return 'RBL Bank';
    if (name.contains('Federal') || name.contains('Scapia')) return 'Scapia';
    if (name.contains('Uni')) return 'Uni';
    if (name.contains('Tata Neu')) return 'Tata Neu';
    if (name.contains('Tata Capital') || name.contains('Tata')) return 'Tata';
    if (name.contains('Bajaj')) return 'Bajaj Finserv';
    if (name.contains('Poonawalla')) return 'Poonawalla';
    if (name.contains('Money View') || name.contains('MoneyView')) return 'Money View';
    if (name.contains('Fibe')) return 'Fibe';
    if (name.contains('KIWI') || name.contains('Kiwi')) return 'Kiwi';
    if (name.contains('SalarySe')) return 'SalarySe';
    if (name.contains('Ram Fincorp')) return 'Ram Fincorp';
    if (name.contains('ZapCash')) return 'ZapCash';
    if (name.contains('Prefr')) return 'Prefr';
    if (name.contains('Olyv') || name.contains('SmartCoin')) return 'Olyv';
    if (name.contains('Mpokket') || name.contains('mPokket')) return 'mPokket';
    if (name.contains('Zype')) return 'Zype';
    if (name.contains('CreditSea')) return 'CreditSea';
    if (name.contains('BankKaro')) return 'BankKaro';

    final words = name.split(RegExp(r'\s+'));
    return words.length > 2 ? '${words[0]} ${words[1]}' : name;
  }

  static bool isCreditCard(String name, String category) {
    final lowerName = name.toLowerCase();
    final lowerCat = category.toLowerCase();
    return lowerCat.contains('card') ||
        lowerName.contains('card') ||
        lowerName.contains('credit');
  }

  static bool isLoan(String name, String category) {
    final lowerName = name.toLowerCase();
    final lowerCat = category.toLowerCase();
    return lowerCat.contains('loan') || lowerName.contains('loan');
  }

  static String getButtonLabel(String brandOrStoreName, String category) {
    if (isCreditCard(brandOrStoreName, category)) {
      final bank = _extractBankName(brandOrStoreName);
      return 'Visit $bank Card';
    }

    if (isLoan(brandOrStoreName, category)) {
      final bank = _extractBankName(brandOrStoreName);
      return 'Visit $bank Loan';
    }

    return 'Shop Now on ${brandOrStoreName.toUpperCase()}';
  }

  static IconData getButtonIcon(String brandOrStoreName, String category) {
    if (isCreditCard(brandOrStoreName, category)) {
      return Icons.credit_card_rounded;
    }
    if (isLoan(brandOrStoreName, category)) {
      return Icons.account_balance_wallet_rounded;
    }
    return Icons.shopping_bag_outlined;
  }

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _currentImageIndex = 0;

  Future<void> _handleShopNow(String targetUrl, String storeName) async {
    var urlToOpen = targetUrl.trim();
    if (urlToOpen.isEmpty || urlToOpen.contains('cashkaro.com')) {
      urlToOpen = ProductDetailScreen.resolveStoreUrl(storeName);
    }

    var success = await UrlLauncherService.openUrl(urlToOpen);

    // If primary URL fails (e.g., tracking redirect block), fallback directly to official store website
    if (!success) {
      final fallbackUrl = ProductDetailScreen.resolveStoreUrl(storeName);
      if (fallbackUrl != urlToOpen) {
        success = await UrlLauncherService.openUrl(fallbackUrl);
      }
    }

    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not open $storeName website. Please check your internet connection.'),
          backgroundColor: AppColors.error,
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

    final finalPrice = widget.customFinalPrice ??
        (product != null
            ? '₹${ProductDetailScreen._formatCurrency((product.finalPrice * 83 * 0.9).round())}'
            : (amazonDeal != null
                ? '₹${ProductDetailScreen._formatCurrency(amazonDeal.finalPrice * (1 - (amazonDeal.rewardPercentage / 100)))}'
                : null));

    final rawUrl = widget.customWebsiteUrl ??
        (brand != null && brand.websiteUrl.isNotEmpty
            ? brand.websiteUrl
            : (amazonDeal != null && amazonDeal.productUrl.isNotEmpty
                ? amazonDeal.productUrl
                : ''));

    final websiteUrl = (rawUrl.isNotEmpty && !rawUrl.contains('cashkaro.com'))
        ? rawUrl
        : ProductDetailScreen.resolveStoreUrl(
            brandName.isNotEmpty ? brandName : (category.isNotEmpty ? category : title));

    final displayStoreName = brandName.isNotEmpty
        ? brandName
        : (category.isNotEmpty ? category : 'Store');

    final isCard = ProductDetailScreen.isCreditCard(displayStoreName, category);
    final isLoan = ProductDetailScreen.isLoan(displayStoreName, category);
    final buttonLabel = ProductDetailScreen.getButtonLabel(displayStoreName, category);
    final buttonIcon = ProductDetailScreen.getButtonIcon(displayStoreName, category);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.mainBackground,
      appBar: AppBar(
        title: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.screenHeading(
            color: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
          ).copyWith(fontSize: 18),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isDark ? AppColors.darkTextPrimary : AppColors.primaryBrown,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: isDark ? AppColors.darkCard : AppColors.mainBackground,
        foregroundColor: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
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
                    color: isDark ? AppColors.darkCard : AppColors.cardBackground,
                    child: imageList.isEmpty
                        ? Container(
                            color: isDark ? AppColors.darkSurface : AppColors.beigeSurface,
                            child: Center(
                              child: Icon(
                                Icons.storefront_rounded,
                                size: 80,
                                color: isDark ? AppColors.darkPrimary : AppColors.primaryBrown,
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
                                                  ? AppColors.darkSurface
                                                  : AppColors.beigeSurface,
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
                                              ? (isDark ? AppColors.darkTextPrimary : AppColors.deepBrown)
                                              : (isDark ? AppColors.darkBorder : AppColors.border),
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
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkCard : AppColors.cardBackground,
                      border: Border.all(
                        color: isDark ? AppColors.darkBorder : AppColors.border,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // BRAND & CATEGORY & RATING CHIPS
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            if (brandName.isNotEmpty)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? AppColors.primaryBrown.withValues(alpha: 0.25)
                                      : AppColors.beigeSurface,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  brandName.toUpperCase(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.fraunces(
                                    color: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            if (category.isNotEmpty)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? AppColors.darkSurface
                                      : AppColors.beigeSurface.withValues(alpha: 0.5),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  category,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.caption(
                                    color: isDark
                                        ? AppColors.darkTextSecondary
                                        : AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            if (rating != null)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.pending,
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

                        // PRODUCT TITLE (Fraunces Typography)
                        Text(
                          title,
                          style: GoogleFonts.fraunces(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            height: 1.3,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
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
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkCard : AppColors.cardBackground,
                      border: Border.all(
                        color: isDark ? AppColors.darkBorder : AppColors.border,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pricing & Offer Details',
                          style: AppTextStyles.sectionHeading(
                            color: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
                          ).copyWith(fontSize: 14),
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
                                    style: AppTextStyles.caption(
                                      color: isDark
                                          ? AppColors.darkTextSecondary
                                          : AppColors.textSecondary,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    discountedPrice,
                                    style: GoogleFonts.fraunces(
                                      fontSize: 26,
                                      fontWeight: FontWeight.w700,
                                      color: isDark
                                          ? AppColors.darkTextPrimary
                                          : AppColors.deepBrown,
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
                                    style: AppTextStyles.caption(
                                      color: isDark
                                          ? AppColors.darkTextSecondary
                                          : AppColors.textMuted,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    originalPrice,
                                    style: TextStyle(
                                      fontSize: 16,
                                      decoration: TextDecoration.lineThrough,
                                      color: isDark
                                          ? AppColors.darkTextSecondary
                                          : AppColors.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            const Spacer(),
                            if (discountTag != null && discountTag.isNotEmpty)
                              Flexible(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.successBackground,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
                                  ),
                                  child: Text(
                                    discountTag,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.end,
                                    style: AppTextStyles.smallLabel(
                                      color: AppColors.success,
                                    ).copyWith(fontSize: 12),
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
                            color: isDark
                                ? AppColors.primaryBrown.withValues(alpha: 0.2)
                                : AppColors.beigeSurface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isDark
                                  ? AppColors.darkBorder
                                  : AppColors.border,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: const BoxDecoration(
                                  color: AppColors.primaryBrown,
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
                                      style: GoogleFonts.fraunces(
                                        color: isDark
                                            ? AppColors.darkTextPrimary
                                            : AppColors.deepBrown,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      isCard
                                          ? 'Rewards track automatically on card application'
                                          : (isLoan
                                              ? 'Rewards track automatically on loan disbursal'
                                              : 'Cashback tracks automatically on ${displayStoreName.toUpperCase()}'),
                                      style: AppTextStyles.caption(
                                        color: isDark
                                            ? AppColors.darkTextSecondary
                                            : AppColors.textSecondary,
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
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                'Effective Price after Cashback: ',
                                style: AppTextStyles.caption(
                                  color: isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.textSecondary,
                                ).copyWith(fontWeight: FontWeight.w600),
                              ),
                              Text(
                                finalPrice,
                                style: GoogleFonts.fraunces(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? AppColors.darkTextPrimary : AppColors.primaryBrown,
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
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkCard : AppColors.cardBackground,
                      border: Border.all(
                        color: isDark ? AppColors.darkBorder : AppColors.border,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Product Overview & Details',
                          style: AppTextStyles.sectionHeading(
                            color: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
                          ).copyWith(fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          description,
                          style: AppTextStyles.body(
                            color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                          ),
                        ),
                        if (stock != null) ...[
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Icon(
                                Icons.inventory_2_outlined,
                                size: 16,
                                color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Availability: ',
                                style: AppTextStyles.caption(
                                  color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                                ),
                              ),
                              Text(
                                '$stock units in stock',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.bold,
                                  color: stock < 10
                                      ? AppColors.pending
                                      : (isDark ? AppColors.darkTextPrimary : AppColors.textPrimary),
                                ),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 16),
                        Divider(color: isDark ? AppColors.darkBorder : AppColors.border),
                        const SizedBox(height: 10),

                        // How Cashback Works 3 Steps
                        Text(
                          'How to Earn Cashback:',
                          style: AppTextStyles.sectionHeading(
                            color: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
                          ).copyWith(fontSize: 13.5),
                        ),
                        const SizedBox(height: 8),
                        _buildCashbackStep(
                          '1',
                          isCard
                              ? 'Tap "$buttonLabel" below to visit & apply for your card'
                              : (isLoan
                                  ? 'Tap "$buttonLabel" below to check eligibility & apply'
                                  : 'Tap "Shop Now" below to visit $displayStoreName'),
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
              color: isDark ? AppColors.darkCard : AppColors.cardBackground,
              border: Border(
                top: BorderSide(
                  color: isDark ? AppColors.darkBorder : AppColors.border,
                  width: 1,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              child: ElevatedButton(
                onPressed: () => _handleShopNow(websiteUrl, displayStoreName),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBrown,
                  foregroundColor: AppColors.cardBackground,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
                  ),
                  elevation: 2,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(buttonIcon, size: 20),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        buttonLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.buttonText(color: AppColors.cardBackground).copyWith(fontSize: 14.5),
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
            color: AppColors.primaryBrown,
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
            style: AppTextStyles.caption(
              color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
