class AmazonDealItemData {
  final String brandName;
  final String productName;
  final String imageUrl;
  final double actualPrice;
  final double rewardPercentage;
  final String productUrl;

  const AmazonDealItemData({
    required this.brandName,
    required this.productName,
    required this.imageUrl,
    required this.actualPrice,
    required this.rewardPercentage,
    this.productUrl = 'https://www.amazon.in',
  });

  int get finalPrice => (actualPrice * (1.0 - (rewardPercentage / 100.0))).round();
}
