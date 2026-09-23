import 'package:flutter/foundation.dart';
import '../models/home_discovery_models.dart';
import '../services/home_service.dart';

enum HomeStatus { initial, loading, loaded, error }

class HomeProvider extends ChangeNotifier {
  final HomeService _homeService;

  HomeDataModel? _homeData;
  HomeStatus _status = HomeStatus.initial;
  String _errorMessage = '';

  HomeProvider({HomeService? homeService})
      : _homeService = homeService ?? HomeService() {
    fetchHomeData();
  }

  HomeDataModel? get homeData => _homeData;
  HomeStatus get status => _status;
  bool get isLoading => _status == HomeStatus.loading;
  String get errorMessage => _errorMessage;

  CashbackSummaryModel? get cashbackSummary => _homeData?.cashbackSummary;
  List<BestDealModel> get bestDeals => _homeData?.bestDeals ?? [];
  List<HomeOfferModel> get offers => _homeData?.offers ?? [];
  List<HomeCouponModel> get coupons => _homeData?.coupons ?? [];
  List<SmartSavingsModel> get smartSavings => _homeData?.smartSavings ?? [];
  List<FeaturedStoreModel> get featuredStores => _homeData?.featuredStores ?? [];
  List<TrendingDealModel> get trendingDeals => _homeData?.trendingDeals ?? [];
  List<PriceDropModel> get priceDrops => _homeData?.priceDrops ?? [];
  List<CashbackIncreaseModel> get cashbackIncreases =>
      _homeData?.cashbackIncreases ?? [];

  /// Fetches structured home discovery feed
  Future<void> fetchHomeData() async {
    _status = HomeStatus.loading;
    _errorMessage = '';
    notifyListeners();

    try {
      _homeData = await _homeService.fetchHomeData();
      _status = HomeStatus.loaded;
    } catch (e) {
      debugPrint('Error loading home data: $e');
      _errorMessage = 'Couldn\'t load deals. Please tap to retry.';
      // Fallback safely to offline data so screen is never empty
      _homeData = HomeService.getFallbackHomeData();
      _status = HomeStatus.loaded;
    }

    notifyListeners();
  }
}
