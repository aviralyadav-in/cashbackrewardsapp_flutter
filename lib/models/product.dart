class Product {
  final int id;
  final String title;
  final String description;
  final double price;
  final double discountPercentage;
  final String thumbnail;
  final String? brand;
  final String? category;
  final double? rating;
  final int? stock;
  final String? sku;
  final List<String>? images;
  final String? originalUrl;
  final String? affiliateUrl;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.discountPercentage,
    required this.thumbnail,
    this.brand,
    this.category,
    this.rating,
    this.stock,
    this.sku,
    this.images,
    this.originalUrl,
    this.affiliateUrl,
  });

  double get finalPrice => price;

  double get originalPrice {
    if (discountPercentage <= 0) return price;
    return price / (1 - (discountPercentage / 100));
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: (json['title'] ?? json['name']) as String? ?? '',
      description: json['description'] as String? ?? '',
      price: (json['price'] as num? ?? 0).toDouble(),
      discountPercentage: (json['discountPercentage'] as num? ?? 0).toDouble(),
      thumbnail: json['thumbnail'] as String? ?? '',
      brand: json['brand'] as String?,
      category: json['category'] as String?,
      rating: json['rating'] != null ? (json['rating'] as num).toDouble() : null,
      stock: json['stock'] as int?,
      sku: json['sku'] as String?,
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      originalUrl: json['originalUrl'] as String? ??
          json['original_url'] as String? ??
          json['url'] as String?,
      affiliateUrl: json['affiliateUrl'] as String? ??
          json['affiliate_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'discountPercentage': discountPercentage,
      'thumbnail': thumbnail,
      if (brand != null) 'brand': brand,
      if (category != null) 'category': category,
      if (rating != null) 'rating': rating,
      if (stock != null) 'stock': stock,
      if (sku != null) 'sku': sku,
      if (images != null) 'images': images,
      if (originalUrl != null) 'originalUrl': originalUrl,
      if (affiliateUrl != null) 'affiliateUrl': affiliateUrl,
    };
  }
}
