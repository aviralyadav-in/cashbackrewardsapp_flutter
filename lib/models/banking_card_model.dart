import 'brand_model.dart';

class BankingCardModel {
  final String id;
  final String slug;
  final String name;
  final String tag;
  final String rewardAmount;
  final String rewardType;
  final String cashbackText;
  final String shortDescription;
  final List<String> perks;
  final String remoteImageUrl;
  final String localAssetPath;
  final String applyUrl;

  const BankingCardModel({
    required this.id,
    required this.slug,
    required this.name,
    required this.tag,
    required this.rewardAmount,
    required this.rewardType,
    required this.cashbackText,
    required this.shortDescription,
    required this.perks,
    required this.remoteImageUrl,
    required this.localAssetPath,
    required this.applyUrl,
  });

  factory BankingCardModel.fromJson(Map<String, dynamic> json) {
    return BankingCardModel(
      id: json['id'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      name: json['name'] as String? ?? '',
      tag: json['tag'] as String? ?? '',
      rewardAmount: json['rewardAmount'] as String? ?? '',
      rewardType: json['rewardType'] as String? ?? 'Rewards',
      cashbackText: json['cashbackText'] as String? ?? '',
      shortDescription: json['shortDescription'] as String? ?? '',
      perks: (json['perks'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      remoteImageUrl: json['remoteImageUrl'] as String? ?? '',
      localAssetPath: json['localAssetPath'] as String? ?? '',
      applyUrl: json['applyUrl'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'slug': slug,
      'name': name,
      'tag': tag,
      'rewardAmount': rewardAmount,
      'rewardType': rewardType,
      'cashbackText': cashbackText,
      'shortDescription': shortDescription,
      'perks': perks,
      'remoteImageUrl': remoteImageUrl,
      'localAssetPath': localAssetPath,
      'applyUrl': applyUrl,
    };
  }

  /// Converts this banking card to a [BrandModel] so it can be rendered
  /// seamlessly by existing brand widgets (e.g. GridBrandCard).
  BrandModel toBrandModel() {
    return BrandModel(
      name: name,
      logoUrl: localAssetPath.isNotEmpty ? localAssetPath : remoteImageUrl,
      bannerUrl: remoteImageUrl,
      cashbackPercentage: cashbackText.isNotEmpty ? cashbackText : rewardAmount,
      category: 'Banking & Finance',
      offerText: perks.isNotEmpty ? perks.first : shortDescription,
      websiteUrl: applyUrl,
    );
  }
}
