import 'package:flutter/foundation.dart';

import '../models/product_detail.dart';
import '../services/product_detail_service.dart';

enum ProductDetailStatus { initial, loading, loaded, error }

class ProductDetailProvider extends ChangeNotifier {
  final ProductDetailService _service;

  ProductDetail? productDetail;
  ProductDetailStatus status = ProductDetailStatus.initial;
  String errorMessage = '';

  ProductDetailProvider({ProductDetailService? service})
    : _service = service ?? ProductDetailService();

  Future<void> fetchProductDetail(int id) async {
    status = ProductDetailStatus.loading;
    errorMessage = '';
    notifyListeners();

    try {
      productDetail = await _service.fetchProductDetail(id);
      status = ProductDetailStatus.loaded;
    } catch (e, stackTrace) {
  debugPrint("ERROR: $e");
  debugPrintStack(stackTrace: stackTrace);

  status = ProductDetailStatus.error;
  errorMessage = e.toString();
}

    notifyListeners();
  }
}
