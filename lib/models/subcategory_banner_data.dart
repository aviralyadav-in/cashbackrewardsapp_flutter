import 'package:flutter/material.dart';

class SubcategoryBannerData {
  final String brandName;
  final String headline;
  final String subText;
  final String offerTag;
  final String buttonText;
  final Color themeColor;
  final Color lightColor;
  final IconData logoIcon;

  const SubcategoryBannerData({
    required this.brandName,
    required this.headline,
    required this.subText,
    required this.offerTag,
    required this.buttonText,
    required this.themeColor,
    required this.lightColor,
    required this.logoIcon,
  });
}
