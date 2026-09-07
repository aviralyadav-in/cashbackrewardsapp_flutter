class FlashDeal {
  final String brandName;
  final String category;
  final String logo;
  final String? productImage;
  final String offer;
  final String saving;
  final String cashback;
  final String minimumOrder;
  final String urgency;
  final String cta;
  final String websiteUrl;
  final int? remainingSeconds;

  const FlashDeal({
    required this.brandName,
    required this.category,
    required this.logo,
    this.productImage,
    required this.offer,
    required this.saving,
    required this.cashback,
    required this.minimumOrder,
    required this.urgency,
    required this.cta,
    required this.websiteUrl,
    this.remainingSeconds,
  });
}
