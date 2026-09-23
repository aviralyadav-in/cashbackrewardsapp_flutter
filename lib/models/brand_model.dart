import '../core/utils/brand_asset_helper.dart';

class BrandModel {
  final String name;
  final String logoUrl;
  final String bannerUrl;
  final String cashbackPercentage;
  final String category;
  final String offerText;
  final String websiteUrl;

  const BrandModel({
    required this.name,
    required this.logoUrl,
    required this.bannerUrl,
    required this.cashbackPercentage,
    required this.category,
    required this.offerText,
    required this.websiteUrl,
  });

  factory BrandModel.fromJson(Map<String, dynamic> json) {
    final name = json['name'] as String? ?? '';
    final category = json['category'] as String? ?? '';
    var logo = json['logoUrl'] as String? ?? '';
    var banner = json['bannerUrl'] as String? ?? '';

    if (!logo.startsWith('assets/')) {
      logo = BrandAssetHelper.getBrandLogo(name, fallback: logo);
    }
    if (!banner.startsWith('assets/')) {
      banner = BrandAssetHelper.getBrandBanner(name, category: category, fallback: banner);
    }

    return BrandModel(
      name: name,
      logoUrl: logo,
      bannerUrl: banner,
      cashbackPercentage: json['cashbackPercentage'] as String? ?? '',
      category: category,
      offerText: json['offerText'] as String? ?? '',
      websiteUrl: json['websiteUrl'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'logoUrl': logoUrl,
      'bannerUrl': bannerUrl,
      'cashbackPercentage': cashbackPercentage,
      'category': category,
      'offerText': offerText,
      'websiteUrl': websiteUrl,
    };
  }
}
