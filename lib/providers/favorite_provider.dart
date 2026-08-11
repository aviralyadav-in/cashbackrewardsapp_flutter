import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../models/product.dart';
import '../services/favorite_service.dart';
import '../services/product_detail_service.dart';
import '../services/storage_service.dart';

class FavoriteProvider extends ChangeNotifier {
  final FavoriteService _favoriteService;
  final AppStorageService _storageService;
  final ProductDetailService _productDetailService;
  late final StreamSubscription<User?> _authSubscription;

  final Set<int> _favoriteProductIds = {};
  final Map<int, Product> _favoriteProductsMap = {};
  // Track order in which items were favorited
  final List<int> _favoriteOrder = [];

  FavoriteProvider({
    FavoriteService? favoriteService,
    AppStorageService? storageService,
    ProductDetailService? productDetailService,
  })  : _favoriteService = favoriteService ?? FavoriteService(),
        _storageService = storageService ?? AppStorageService(),
        _productDetailService = productDetailService ?? ProductDetailService() {
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen((_) {
      Future.microtask(() => initialize());
    });
  }

  Set<int> get favoriteProductIds => Set.unmodifiable(_favoriteProductIds);

  /// Returns favorite products in a stable, deterministic order (order of favoriting)
  List<Product> get favoriteProducts {
    final list = <Product>[];
    for (final id in _favoriteOrder) {
      final product = _favoriteProductsMap[id];
      if (product != null) {
        list.add(product);
      }
    }
    return list;
  }

  // Load favorites for the current state (Firestore if logged in, user-scoped local SharedPreferences otherwise)
  Future<void> initialize() async {
    try {
      final userId = _favoriteService.currentUserId;
      _favoriteProductIds.clear();
      _favoriteProductsMap.clear();
      _favoriteOrder.clear();

      Set<int> loadedIds = {};

      if (userId != null) {
        // Logged-in user: Load from Firestore
        loadedIds = await _favoriteService.getFavoriteProductIds();

        // Check user-scoped local storage if Firestore is empty/offline
        if (loadedIds.isEmpty) {
          final localIds = await _storageService.getFavoriteProductIds(userId);
          loadedIds.addAll(localIds);
        } else {
          // Sync Firestore IDs to user-scoped local storage
          await _storageService.saveFavoriteProductIds(loadedIds, userId);
        }
      } else {
        // Guest user: Load from guest-scoped local storage ONLY
        final guestIds = await _storageService.getFavoriteProductIds(null);
        loadedIds.addAll(guestIds);
      }

      _favoriteProductIds.addAll(loadedIds);
      _favoriteOrder.addAll(loadedIds);

      notifyListeners();

      // Fetch missing details for favorited products asynchronously in background
      _fetchMissingProductDetails();
    } catch (e) {
      debugPrint('Error initializing favorites: $e');
    }
  }

  Future<void> _fetchMissingProductDetails() async {
    final missingIds = _favoriteProductIds
        .where((id) => !_favoriteProductsMap.containsKey(id))
        .toList();

    for (final id in missingIds) {
      try {
        final detail = await _productDetailService.fetchProductDetail(id);
        _favoriteProductsMap[id] = detail.toProduct();
        notifyListeners();
      } catch (e) {
        debugPrint('Error fetching product detail for favorite ID $id: $e');
      }
    }
  }

  bool isFavorite(int productId) {
    return _favoriteProductIds.contains(productId);
  }

  /// Add/remove favorite with OPTIMISTIC UI update (immediately notifies listeners)
  Future<void> toggleFavorite(Product product) async {
    final productId = product.id;

    if (_favoriteProductIds.contains(productId)) {
      _favoriteProductIds.remove(productId);
      _favoriteProductsMap.remove(productId);
      _favoriteOrder.remove(productId);
    } else {
      _favoriteProductIds.add(productId);
      _favoriteProductsMap[productId] = product;
      if (!_favoriteOrder.contains(productId)) {
        _favoriteOrder.add(productId);
      }
    }

    // 1. OPTIMISTIC UPDATE: notify UI instantly so heart fills/unfills immediately
    notifyListeners();

    // 2. PERSISTENCE IN BACKGROUND
    _persistFavoriteState(productId);
  }

  Future<void> toggleFavoriteProductId(int productId, {Product? product}) async {
    if (product != null) {
      await toggleFavorite(product);
      return;
    }

    final isFav = _favoriteProductIds.contains(productId);
    if (isFav) {
      _favoriteProductIds.remove(productId);
      _favoriteProductsMap.remove(productId);
      _favoriteOrder.remove(productId);
    } else {
      _favoriteProductIds.add(productId);
      if (!_favoriteOrder.contains(productId)) {
        _favoriteOrder.add(productId);
      }
    }

    // 1. OPTIMISTIC UPDATE
    notifyListeners();

    // 2. PERSISTENCE IN BACKGROUND
    _persistFavoriteState(productId);

    // Fetch product details if adding and missing
    if (!isFav && !_favoriteProductsMap.containsKey(productId)) {
      try {
        final detail = await _productDetailService.fetchProductDetail(productId);
        _favoriteProductsMap[productId] = detail.toProduct();
        notifyListeners();
      } catch (e) {
        debugPrint('Error loading product detail after toggle: $e');
      }
    }
  }

  Future<void> removeProductFavorite(int productId) async {
    if (_favoriteProductIds.contains(productId)) {
      _favoriteProductIds.remove(productId);
      _favoriteProductsMap.remove(productId);
      _favoriteOrder.remove(productId);
      notifyListeners();

      _persistFavoriteState(productId);
    }
  }

  void _persistFavoriteState(int productId) {
    final isFav = _favoriteProductIds.contains(productId);
    final userId = _favoriteService.currentUserId;

    // Save locally under current user ID (or guest) key
    _storageService
        .saveFavoriteProductIds(_favoriteProductIds, userId)
        .catchError((e) {
      debugPrint('Error saving favorites locally: $e');
    });

    // Save to Firestore if user is logged in
    if (userId != null) {
      if (isFav) {
        _favoriteService.addFavorite(productId);
      } else {
        _favoriteService.removeFavorite(productId);
      }
    }
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }
}
