import 'package:flutter/material.dart';
import 'brand_model.dart';
import 'subcategory_banner_data.dart';

class DiscoverySectionModel {
  final String id;
  final String title;
  final List<Color> lightGradientColors;
  final List<Color> darkGradientColors;
  final List<BrandModel> brands;
  final SubcategoryBannerData bannerData;
  final int initialCount;

  const DiscoverySectionModel({
    required this.id,
    required this.title,
    required this.lightGradientColors,
    required this.darkGradientColors,
    required this.brands,
    required this.bannerData,
    this.initialCount = 6,
  });
}
