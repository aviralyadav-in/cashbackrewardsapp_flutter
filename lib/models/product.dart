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
  });

  double get finalPrice => price;

  double get originalPrice {
    if (discountPercentage <= 0) return price;
    return price / (1 - (discountPercentage / 100));
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
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
    );
  }
}
