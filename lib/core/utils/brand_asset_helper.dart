/// BrandAssetHelper provides robust, offline-first resolution for brand logos,
/// store cards, category banners, and product imagery from the local asset catalog in
/// `assets/cards/`, `assets/logos/`, and `assets/banners/`.
class BrandAssetHelper {
  static const String defaultCard = 'assets/cards/col_default.jpg';

  // Exact mapping of brand / store keys to verified local asset paths
  static const Map<String, String> _logoMap = {
    // E-Commerce & Retail
    'amazon': 'assets/cards/amazon.jpg',
    'amazon.in': 'assets/cards/amazon.jpg',
    'amazon india': 'assets/cards/amazon.jpg',
    'flipkart': 'assets/cards/flipkart-electronics.png',
    'myntra': 'assets/cards/myntra.jpg',
    'ajio': 'assets/cards/ajio-coupons.jpg',
    'nykaa': 'assets/cards/nykaa.jpg',
    'shopsy': 'assets/cards/shopsy-coupons.png',
    'tatacliq': 'assets/cards/tatacliq-coupons.png',
    'tata cliq': 'assets/cards/tatacliq-coupons.png',
    'meesho': 'assets/logos/meesho.svg',
    'croma': 'assets/logos/croma.svg',
    'reliance digital': 'assets/logos/reliancedigital.svg',
    'reliancedigital': 'assets/logos/reliancedigital.svg',
    'jiomart': 'assets/cards/jiomart-electronics.png',
    'snapdeal': 'assets/logos/snapdeal.svg',
    'walmart': 'assets/cards/col_shopsy.jpg',
    'best buy': 'assets/cards/col_electronics.jpg',
    'target': 'assets/cards/col_shopsy.jpg',
    'etsy': 'assets/logos/etsy.svg',
    'ebay': 'assets/logos/ebay.svg',

    // Fashion & Lifestyle
    'uniqlo': 'assets/cards/uniqlo-coupons.jpg',
    'zara': 'assets/cards/col_zara.jpg',
    'hummel': 'assets/cards/hummel-coupons.png',
    'xyxx': 'assets/cards/xyxx-discount-code.jpg',
    'xyxx crew': 'assets/cards/xyxx-discount-code.jpg',
    'libas': 'assets/cards/libas-coupons.jpg',
    'shyaway': 'assets/cards/shyaway-coupons.jpg',
    'lavie': 'assets/cards/lavie-coupons.png',
    'strch': 'assets/cards/strch-coupons.jpg',
    'house of koala': 'assets/cards/house-of-koala-offers.png',
    'lucira': 'assets/cards/lucira-jewelry-coupons.png',
    'tiaraa': 'assets/cards/tiaraa-coupons.jpg',
    'uppercase': 'assets/cards/uppercase.png',
    'outzidr': 'assets/cards/outzidr-coupons.png',
    'cahoot': 'assets/cards/cahoot-coupons.png',
    'the luxury closet': 'assets/cards/the-luxury-closet-coupons.jpg',
    'nike': 'assets/logos/nike.svg',
    'adidas': 'assets/logos/adidas.svg',
    'puma': 'assets/cards/hummel-coupons.png',
    'hm': 'assets/logos/hm.svg',
    'h&m': 'assets/logos/hm.svg',
    'levis': 'assets/cards/col_myntra.jpg',
    "levi's": 'assets/cards/col_myntra.jpg',
    'roadster': 'assets/cards/col_ajio.jpg',
    'tommy hilfiger': 'assets/logos/tommyhilfiger.svg',
    'calvin klein': 'assets/logos/calvinklein.svg',
    'ralph lauren': 'assets/logos/ralphlauren.svg',
    'armani': 'assets/logos/armani.svg',
    'versace': 'assets/logos/versace.svg',

    // Electronics & Tech
    'boat': 'assets/cards/boat-coupon.jpg',
    'boAt': 'assets/cards/boat-coupon.jpg',
    'noise': 'assets/cards/gonoise-coupons.jpg',
    'gonoise': 'assets/cards/gonoise-coupons.jpg',
    'go noise': 'assets/cards/gonoise-coupons.jpg',
    'dell': 'assets/cards/dell.jpg',
    'hp': 'assets/cards/hp-coupon-codes.png',
    'asus': 'assets/cards/asus-coupons.png',
    'oppo': 'assets/cards/oppo-coupons.png',
    'realme': 'assets/cards/realme-offers.jpg',
    'apple': 'assets/logos/apple.svg',
    'samsung': 'assets/logos/samsung.svg',
    'mivi': 'assets/cards/mivi-coupons.png',
    'controlz': 'assets/cards/controlz-coupon-codes.png',
    'daily objects': 'assets/cards/daily-objects-coupons.jpg',
    'dailyobjects': 'assets/cards/daily-objects-coupons.jpg',
    'havells': 'assets/cards/havells-coupons.png',
    'elver': 'assets/cards/elver-coupons.png',
    'moglix': 'assets/cards/moglix-coupons.png',
    'dyson': 'assets/cards/dyson-discount-codes.jpg',
    'whirlpool': 'assets/cards/whirlpool-coupons.png',
    'element14': 'assets/cards/element14-coupons-cb.jpg',
    'oneplus': 'assets/logos/oneplus.svg',
    'vivo': 'assets/logos/vivo.svg',
    'xiaomi': 'assets/logos/xiaomi.svg',
    'iqoo': 'assets/logos/iqoo.svg',
    'motorola': 'assets/logos/motorola.svg',
    'nothing': 'assets/logos/nothing.svg',

    // Home, Kitchen & Utilities
    'wonderchef': 'assets/cards/wonderchef-coupons.png',
    'milton': 'assets/cards/milton-coupons.png',
    'lifelong': 'assets/cards/lifelong-coupons.png',
    'ruhe': 'assets/cards/ruhe-coupons.png',
    'kohler': 'assets/cards/kohler-coupons.png',
    'beco': 'assets/cards/beco-coupons.png',
    'r for rabbit': 'assets/cards/r-for-rabbit-coupons.png',
    'loophoop': 'assets/cards/loophoop-coupons.png',
    'art of puja': 'assets/cards/art-of-puja-coupons.png',

    // Beauty, Care & Cosmetics
    'foxtale': 'assets/cards/foxtale-coupons.jpg',
    'the derma co': 'assets/cards/thedermaco-coupons.jpg',
    'thedermaco': 'assets/cards/thedermaco-coupons.jpg',
    'derma co': 'assets/cards/thedermaco-coupons.jpg',
    'dot & key': 'assets/cards/dotandkey-coupons.png',
    'dotandkey': 'assets/cards/dotandkey-coupons.png',
    'aqualogica': 'assets/cards/aqualogica-coupons.png',
    'mcaffeine': 'assets/cards/mcaffeine-coupons.jpg',
    'dr. sheth\'s': 'assets/cards/dr-sheths-coupons.png',
    'drsheths': 'assets/cards/dr-sheths-coupons.png',
    'swiss beauty': 'assets/cards/swiss-beauty-coupons.jpg',
    'the man company': 'assets/cards/themancompany-coupons.jpg',
    'forest essentials': 'assets/cards/forestessentialsindia-coupons.jpg',
    'wow': 'assets/cards/buywow-coupons.png',
    'buywow': 'assets/cards/buywow-coupons.png',
    'hyphen': 'assets/cards/hyphen-coupon-codes.png',
    'mamaearth': 'assets/logos/mamaearth.svg',
    'nature 4 nature': 'assets/cards/nature4nature-coupons.png',
    'nature4nature': 'assets/cards/nature4nature-coupons.png',
    'tm perfumes': 'assets/cards/tm-perfumes-coupons.png',
    'yaan man': 'assets/cards/yaan-man-mens-makeup.png',
    'plum': 'assets/logos/plum.svg',
    'sephora': 'assets/logos/sephora.svg',
    'minimalist': 'assets/logos/minimalist.svg',
    'sugar cosmetics': 'assets/logos/sugarcosmetics.svg',
    'world of asaya': 'assets/cards/world-of-asaya-coupons.png',

    // Travel & Hotels
    'makemytrip': 'assets/cards/makemytrip-hotels.png',
    'cleartrip': 'assets/cards/cleartrip.png',
    'agoda': 'assets/cards/agoda.png',
    'booking': 'assets/cards/booking.jpg',
    'booking.com': 'assets/cards/booking.jpg',
    'goibibo': 'assets/cards/goibibo-hotels.png',
    'air india': 'assets/cards/air-india-coupons.png',
    'air india express': 'assets/cards/air-india-express-coupons.png',
    'etihad': 'assets/cards/etihad-airways-coupons.jpg',
    'etihad airways': 'assets/cards/etihad-airways-coupons.jpg',
    'qatar airways': 'assets/cards/qatar-airways-coupons.jpg',
    'skyscanner': 'assets/cards/skyscanner-hotels-promo-code.png',
    'expedia': 'assets/cards/expedia-flightbookings.jpg',
    'accor': 'assets/cards/accor-coupons-cb.jpg',
    'ihg': 'assets/cards/ihg-coupons.jpg',
    'hotels.com': 'assets/cards/hotels-com.png',
    'radisson': 'assets/cards/radisson-hotel-benefits.png',
    'kayak': 'assets/cards/kayak-flights-coupons-cb.png',
    'getyourguide': 'assets/cards/getyourguide-coupons-cb.png',
    'university living': 'assets/cards/university-living-coupons.jpg',
    'easemytrip': 'assets/logos/easemytrip.svg',

    // Food, Dining & Grocery
    'zomato': 'assets/logos/zomato.svg',
    'swiggy': 'assets/logos/swiggy.svg',
    'haldiram': 'assets/cards/haldiram-coupons.png',
    'haldiram\'s': 'assets/cards/haldiram-coupons.png',
    'bigbasket': 'assets/logos/bigbasket.svg',
    'blinkit': 'assets/logos/blinkit.svg',
    'dmart': 'assets/logos/dmart.svg',
    'rage coffee': 'assets/cards/rage-coffee-coupons.png',
    'zoff': 'assets/cards/zoff-coupons.png',
    'zop': 'assets/cards/zop-coupons.png',
    'true elements': 'assets/cards/true-elements-coupons.jpg',
    'city gold tea': 'assets/cards/citygoldtea-coupons.png',
    'nutslane': 'assets/cards/nutslane-coupons.png',
    'krafted millets': 'assets/cards/krafted-millets-coupons.png',
    'spencers': 'assets/logos/spencers.svg',
    'reliance smart': 'assets/logos/reliancesmart.svg',

    // Pharmacy & Health
    'truemeds': 'assets/cards/truemeds-coupon-code.jpg',
    'netmeds': 'assets/cards/netmeds-coupons.jpg',
    'pharmeasy': 'assets/cards/pharmeasy-diagnostics.png',
    'medibuddy': 'assets/cards/medibuddy-labs-coupons.jpg',
    'tata 1mg': 'assets/logos/tata1mg.svg',
    'tata1mg': 'assets/logos/tata1mg.svg',
    'apollo pharmacy': 'assets/logos/apollopharmacy.svg',
    'healthkart': 'assets/cards/healthkart.jpg',
    'muscleblaze': 'assets/cards/muscleblaze-coupon-codes.jpg',
    'muscletech': 'assets/cards/muscletech-coupon.jpg',
    'hk vitals': 'assets/cards/hk-vitals-coupons.jpg',
    'sirona': 'assets/cards/sirona-coupons.png',
    'kapiva': 'assets/cards/kapiva-coupons.jpg',
    'zandu': 'assets/cards/zanducare-coupons.jpg',
    'zanducare': 'assets/cards/zanducare-coupons.jpg',
    'rasayanam': 'assets/cards/rasayanam-coupons.png',
    'kerala ayurveda': 'assets/cards/kerala-ayurveda-coupons.png',
    'kama ayurveda': 'assets/cards/kama-ayurveda-coupons.png',
    'durex': 'assets/cards/durex-india-offers.png',
    'ageasy': 'assets/cards/ageasy-coupons.png',
    'hyugalife': 'assets/cards/hyugalife-coupons.jpg',
    'fuel:one': 'assets/cards/fuel-one-coupons.png',
    'fuel one': 'assets/cards/fuel-one-coupons.png',
    'truebasics': 'assets/cards/truebasics-coupons.jpg',
    'nveda': 'assets/cards/nveda-coupons.png',
    'nua': 'assets/cards/nua-coupon.png',
    'nutriburst': 'assets/cards/nutriburst-india-coupons.png',
    'neurogum': 'assets/cards/neurogum-coupons.png',
    'ounce organics': 'assets/cards/ounce-organics.png',
    'ounce products': 'assets/cards/ounce-products.png',
    'oziva': 'assets/cards/oziva-coupons.png',

    // Credit Cards & Banking
    'sbi': 'assets/cards/sbi-cashback-card.png',
    'sbi card': 'assets/cards/sbi-cashback-card.png',
    'sbicard': 'assets/cards/sbi-cashback-card.png',
    'sbi cashback': 'assets/cards/sbi-cashback-card.png',
    'simplyclick': 'assets/cards/simply-click-sbi-card.png',
    'flipkart sbi': 'assets/cards/flipkart-sbi-credit-card.png',
    'axis': 'assets/cards/axis-neo-rupay-credit-card.jpg',
    'axis bank': 'assets/cards/axis-neo-rupay-credit-card.jpg',
    'axis neo': 'assets/cards/axis-neo-rupay-credit-card.jpg',
    'bank karo axis': 'assets/cards/bank-karo-axis-flipkart.png',
    'axis flipkart': 'assets/cards/bank-karo-axis-flipkart.png',
    'axis my zone': 'assets/cards/bank-karo-axis-my-zone.png',
    'hdfc': 'assets/cards/hdfcbank-personal-loan.png',
    'hdfc bank': 'assets/cards/hdfcbank-personal-loan.png',
    'hdfc loan': 'assets/cards/hdfc-loan-on-credit-card.png',
    'hdfc emi': 'assets/cards/hdfc-smart-emi.png',
    'idfc': 'assets/cards/idfc-first-credit-card.png',
    'idfc first': 'assets/cards/idfc-first-credit-card.png',
    'bobcard': 'assets/cards/bobcard-eterna-credit-card.png',
    'uni': 'assets/cards/uni-goldx-credit-card.png',
    'scapia': 'assets/cards/federal-bank-scapia-credit-card-offer.png',
    'federal bank': 'assets/cards/federal-bank-scapia-credit-card-offer.png',
    'kotak': 'assets/cards/kotak-league-platinum-credit-card.png',
    'kotak league': 'assets/cards/kotak-league-platinum-credit-card.png',
    'hsbc': 'assets/cards/hsbc-platinum-credit-card.png',
    'hsbc platinum': 'assets/cards/hsbc-platinum-credit-card.png',
    'hsbc live plus': 'assets/cards/hsbc-live-plus-credit-card.png',
    'indusind': 'assets/cards/indusind-tiger-credit.png',
    'rbl': 'assets/cards/rbl-bank-shoprite-credit.png',
    'salaryse': 'assets/cards/cub-salaryse-level-up-credit-card.png',
    'yes bank': 'assets/cards/yes-bank-popclub-credit-card.png',
    'kiwi': 'assets/cards/kiwi-credit-card-offers.png',
    'onecard': 'assets/logos/onecard.svg',
    'tata neu sbi': 'assets/cards/tata-neu-infinity-sbi-credit-card.png',

    // Loans & Finance
    'bajaj finserv': 'assets/cards/bajajfinserv-personal-loan.png',
    'bajajfinserv': 'assets/cards/bajajfinserv-personal-loan.png',
    'money view': 'assets/cards/money-view-personal-loan.png',
    'moneyview': 'assets/cards/money-view-personal-loan.png',
    'fibe': 'assets/cards/fibe-personal-loan-coupons.png',
    'zapcash': 'assets/cards/zapcash-personal-loan.png',
    'ram fincorp': 'assets/cards/ram-fincorp-personal-loan.png',
    'tataneu': 'assets/cards/tataneu-personal-loan.png',
    'tata neu': 'assets/cards/tataneu-personal-loan.png',
    'times prime': 'assets/cards/times-prime-coupons.jpg',
    'timesprime': 'assets/cards/times-prime-coupons.jpg',
    'emergent': 'assets/cards/emergent-coupons.png',
    'creditsea': 'assets/cards/creditsea-personal-loan.png',
    'mpokket': 'assets/cards/mpokket-coupons.png',
    'prefr': 'assets/cards/prefr-coupons.png',
    'smartcoin': 'assets/cards/smartcoin-coupons.png',
    'zype': 'assets/cards/zype-coupons.png',
    'poonawalla': 'assets/cards/poonawala-instant-loan.png',
    'kreditbee': 'assets/logos/kreditbee.svg',
    'cashe': 'assets/logos/cashe.svg',
    'navi': 'assets/logos/navi.svg',
    'paysense': 'assets/logos/paysense.svg',
    'bankkaro': 'assets/cards/bankkaro-loan.png',

    // Education
    'udemy': 'assets/cards/col_electronics.jpg',
    'coursera': 'assets/cards/col_electronics.jpg',
    'unacademy': 'assets/cards/col_electronics.jpg',
  };

  /// Resolves the local asset logo or card for a given brand or store name.
  /// If [urlOrName] already starts with 'assets/', it is returned directly.
  static String getBrandLogo(String? urlOrName, {String? fallback}) {
    if (urlOrName == null) return fallback ?? defaultCard;
    final trimmed = urlOrName.trim();
    if (trimmed.isEmpty) return fallback ?? defaultCard;

    if (trimmed.startsWith('assets/')) {
      return trimmed;
    }

    final localFromUrl = findLocalAssetForUrl(trimmed);
    if (localFromUrl != null) {
      return localFromUrl;
    }

    final clean = trimmed.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');

    for (final entry in _logoMap.entries) {
      final keyClean = entry.key.replaceAll(RegExp(r'[^a-z0-9]'), '');
      if (clean.contains(keyClean) || keyClean.contains(clean)) {
        return entry.value;
      }
    }

    return fallback ?? defaultCard;
  }

  /// Finds a local asset match for any URL string (e.g. from CKAssets, CDN, or web URL)
  static String? findLocalAssetForUrl(String url) {
    final lower = url.toLowerCase();
    if (lower.startsWith('assets/')) return url;

    for (final entry in _logoMap.entries) {
      final keyClean = entry.key.replaceAll(RegExp(r'[^a-z0-9]'), '');
      if (keyClean.length >= 3 && lower.contains(keyClean)) {
        return entry.value;
      }
    }
    return null;
  }

  /// Resolves a local promotional collection banner for any store or brand.
  static String getBrandBanner(String brandName, {String? category, String? fallback}) {
    final b = brandName.toLowerCase();
    final c = (category ?? '').toLowerCase();

    if (b.contains('amazon')) return 'assets/cards/col_amazon.jpg';
    if (b.contains('flipkart')) return 'assets/cards/col_flipkart.jpg';
    if (b.contains('myntra')) return 'assets/cards/col_myntra.jpg';
    if (b.contains('ajio')) return 'assets/cards/col_ajio.jpg';
    if (b.contains('nykaa')) return 'assets/cards/col_nykaa.jpg';
    if (b.contains('derma')) return 'assets/cards/col_derma.jpg';
    if (b.contains('dot & key') || b.contains('dotkey')) return 'assets/cards/col_dotkey.jpg';
    if (b.contains('aqualogica')) return 'assets/cards/col_aqualogica.jpg';
    if (b.contains('mcaffeine')) return 'assets/cards/col_mcaffeine.jpg';
    if (b.contains('zara')) return 'assets/cards/col_zara.jpg';
    if (b.contains('boat') || b.contains('noise') || b.contains('mivi') || b.contains('audio') || b.contains('headphone')) {
      return 'assets/banners/headphone_banner_16_9.jpg';
    }
    if (b.contains('realme') || b.contains('oppo') || b.contains('vivo') || b.contains('samsung') || b.contains('apple') || b.contains('phone') || b.contains('mobile')) {
      return 'assets/banners/phone_banner_16_9.jpg';
    }
    if (b.contains('sneaker') || b.contains('shoe') || b.contains('nike') || b.contains('adidas') || b.contains('puma') || b.contains('hummel')) {
      return 'assets/banners/sneaker_banner_16_9.jpg';
    }
    if (b.contains('watch')) return 'assets/banners/watch_banner_16_9.jpg';
    if (b.contains('reliance')) return 'assets/banners/reliance_banner_16_9.jpg';
    if (b.contains('muscle') || b.contains('supplements') || b.contains('kapiva') || b.contains('oziva') || b.contains('hyuga') || b.contains('nut')) {
      return 'assets/banners/supplements_banner_16_9.jpg';
    }
    if (b.contains('shopsy') || b.contains('meesho')) return 'assets/cards/col_shopsy.jpg';

    // Category fallbacks
    if (c.contains('fashion') || c.contains('cloth') || c.contains('apparel') || c.contains('luxury')) {
      return 'assets/cards/col_myntra.jpg';
    }
    if (c.contains('elect') || c.contains('tech') || c.contains('gadget') || c.contains('appliance')) {
      return 'assets/cards/col_electronics.jpg';
    }
    if (c.contains('beauty') || c.contains('glow') || c.contains('skin') || c.contains('cosmetic') || c.contains('personal care')) {
      return 'assets/cards/col_derma.jpg';
    }
    if (c.contains('travel') || c.contains('hotel') || c.contains('flight') || c.contains('stay')) {
      return 'assets/cards/col_travel.jpg';
    }
    if (c.contains('card') || c.contains('loan') || c.contains('bank') || c.contains('credit') || c.contains('finance')) {
      return 'assets/cards/col_cards.jpg';
    }
    if (c.contains('med') || c.contains('health') || c.contains('pharm')) {
      return 'assets/cards/col_pharmacy.jpg';
    }
    if (c.contains('food') || c.contains('dine') || c.contains('grocery') || c.contains('supermarket')) {
      return 'assets/cards/col_food.jpg';
    }

    return fallback ?? 'assets/cards/col_electronics.jpg';
  }

  /// Resolves category-specific collection cards
  static String getCategoryCard(String categoryName) {
    final cat = categoryName.trim().toLowerCase();
    if (cat.contains('fashion') || cat.contains('cloth') || cat.contains('wear')) {
      return 'assets/cards/col_myntra.jpg';
    }
    if (cat.contains('elect') || cat.contains('gadget') || cat.contains('phone') || cat.contains('tech')) {
      return 'assets/cards/col_electronics.jpg';
    }
    if (cat.contains('travel') || cat.contains('flight') || cat.contains('hotel')) {
      return 'assets/cards/col_travel.jpg';
    }
    if (cat.contains('food') || cat.contains('dine') || cat.contains('meal')) {
      return 'assets/cards/col_food.jpg';
    }
    if (cat.contains('beauty') || cat.contains('skin') || cat.contains('cosmetic')) {
      return 'assets/cards/col_nykaa.jpg';
    }
    if (cat.contains('pharm') || cat.contains('health') || cat.contains('med')) {
      return 'assets/cards/col_pharmacy.jpg';
    }
    if (cat.contains('card') || cat.contains('bank') || cat.contains('loan') || cat.contains('credit')) {
      return 'assets/cards/col_cards.jpg';
    }
    if (cat.contains('groc') || cat.contains('daily') || cat.contains('basket') || cat.contains('departmental')) {
      return 'assets/cards/col_shopsy.jpg';
    }

    return defaultCard;
  }

  /// Resolves high-resolution product imagery from local assets
  static String getProductImage(String productName, {String? category, String? fallback}) {
    final name = productName.toLowerCase();

    if (name.contains('iphone') || name.contains('galaxy') || name.contains('smartphone') || name.contains('phone') || name.contains('s24')) {
      return 'assets/banners/phone_banner_16_9.jpg';
    }
    if (name.contains('headphone') || name.contains('airdopes') || name.contains('earbud') || name.contains('audio') || name.contains('wh-1000') || name.contains('quietcomfort')) {
      return 'assets/banners/headphone_banner_16_9.jpg';
    }
    if (name.contains('sneaker') || name.contains('jordan') || name.contains('shoe') || name.contains('footwear') || name.contains('air force')) {
      return 'assets/banners/sneaker_banner_16_9.jpg';
    }
    if (name.contains('watch') || name.contains('colorfit') || name.contains('smartwatch')) {
      return 'assets/banners/watch_banner_16_9.jpg';
    }
    if (name.contains('macbook') || name.contains('laptop') || name.contains('notebook') || name.contains('zephyrus') || name.contains('asus') || name.contains('dell')) {
      return 'assets/cards/dell.jpg';
    }
    if (name.contains('mouse') || name.contains('mx master') || name.contains('logitech')) {
      return 'assets/cards/col_electronics.jpg';
    }
    if (name.contains('aqualogica') || name.contains('dew drops')) {
      return 'assets/banners/aqualogica_banner_16_9.jpg';
    }
    if (name.contains('dot & key') || name.contains('dotkey') || name.contains('vitamin c') || name.contains('ceramide')) {
      return 'assets/banners/dotkey_banner_16_9.jpg';
    }
    if (name.contains('mcaffeine') || name.contains('coffee face') || name.contains('caffeine')) {
      return 'assets/banners/mcaffeine_banner_16_9.jpg';
    }
    if (name.contains('derma') || name.contains('salicylic') || name.contains('niacinamide')) {
      return 'assets/cards/col_derma.jpg';
    }
    if (name.contains('shirt') || name.contains('denim') || name.contains('jeans') || name.contains('t-shirt') || name.contains('jacket')) {
      return 'assets/cards/col_myntra.jpg';
    }
    if (name.contains('vacuum') || name.contains('dyson') || name.contains('appliance')) {
      return 'assets/cards/dyson-discount-codes.jpg';
    }
    if (name.contains('flight') || name.contains('hotel') || name.contains('resort') || name.contains('stay')) {
      return 'assets/cards/col_travel.jpg';
    }
    if (name.contains('credit card') || name.contains('rupay') || name.contains('voucher')) {
      return 'assets/cards/col_cards.jpg';
    }
    if (name.contains('grocery') || name.contains('bundle') || name.contains('tea') || name.contains('nuts')) {
      return 'assets/cards/col_shopsy.jpg';
    }

    if (category != null) {
      return getCategoryCard(category);
    }

    return fallback ?? defaultCard;
  }
}
