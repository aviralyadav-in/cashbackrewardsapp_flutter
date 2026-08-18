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
    return BrandModel(
      name: json['name'] as String? ?? '',
      logoUrl: json['logoUrl'] as String? ?? '',
      bannerUrl: json['bannerUrl'] as String? ?? '',
      cashbackPercentage: json['cashbackPercentage'] as String? ?? '',
      category: json['category'] as String? ?? '',
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
